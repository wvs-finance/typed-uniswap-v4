// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {EnumerableSetLib} from "solady/utils/EnumerableSetLib.sol";
import {TickRange, fromTicksPacked} from "./TickRangeMod.sol";
import {SwapCount} from "./SwapCountMod.sol";
import {BlockCount} from "./BlockCountMod.sol";

// V2: register/deregister accept only TickRange (packed encoding).
// Tick bounds are recovered via lowerTick()/upperTick() — no redundant int24 params.
// Requires callers to build TickRange with fromTicksPacked(), not fromTicks().

struct TickRangeRegistryV2 {
    // TickRange => set of position keys in that range
    mapping(bytes32 => EnumerableSetLib.Bytes32Set) positionsByRange;
    // positionKey => its TickRange (reverse lookup for deregister)
    mapping(bytes32 => TickRange) rangeKeyOf;
    // TickRange => cumulative swap count for this range
    mapping(bytes32 => SwapCount) rangeSwapCount;
    // positionKey => snapshot of rangeSwapCount at add time
    mapping(bytes32 => SwapCount) baselineSwapCount;
    // All range keys with >= 1 position (for afterSwap iteration)
    EnumerableSetLib.Bytes32Set activeRanges;
    // TickRange => sum of liquidity across all positions in range (for x_k weighting)
    mapping(bytes32 => uint128) totalRangeLiquidity;
    // positionKey => block.number at registration (for block-based lifetime)
    mapping(bytes32 => uint256) positionAddBlock;
}

using TickRangeRegistryV2Lib for TickRangeRegistryV2 global;

library TickRangeRegistryV2Lib {
    using EnumerableSetLib for EnumerableSetLib.Bytes32Set;

    // ── Mutators ──

    function register(
        TickRangeRegistryV2 storage self,
        TickRange rk,
        bytes32 positionKey,
        uint128 posLiquidity
    ) internal {
        bytes32 rkRaw = TickRange.unwrap(rk);
        self.positionsByRange[rkRaw].add(positionKey);
        self.rangeKeyOf[positionKey] = rk;
        self.baselineSwapCount[positionKey] = self.rangeSwapCount[rkRaw];
        self.totalRangeLiquidity[rkRaw] += posLiquidity;
        self.positionAddBlock[positionKey] = block.number;

        // First position in this range: track for afterSwap iteration
        if (self.positionsByRange[rkRaw].length() == 1) {
            self.activeRanges.add(rkRaw);
        }
    }

    function deregister(
        TickRangeRegistryV2 storage self,
        bytes32 positionKey,
        uint128 /* posLiquidity */
    ) internal returns (TickRange rk, SwapCount swapLifetime, BlockCount blockLifetime, uint128 totalLiquidityBefore) {
        rk = self.rangeKeyOf[positionKey];
        bytes32 rkRaw = TickRange.unwrap(rk);

        // Swap lifetime (for zero-check)
        SwapCount current = self.rangeSwapCount[rkRaw];
        SwapCount baseline = self.baselineSwapCount[positionKey];
        swapLifetime = SwapCount.wrap(current.unwrap() - baseline.unwrap());

        // Block lifetime (for HHI divisor)
        blockLifetime = BlockCount.wrap(block.number - self.positionAddBlock[positionKey]);

        // Read total liquidity (used for x_k computation denominator).
        totalLiquidityBefore = self.totalRangeLiquidity[rkRaw];

        self.positionsByRange[rkRaw].remove(positionKey);
        self.rangeKeyOf[positionKey] = TickRange.wrap(bytes32(0));
        self.baselineSwapCount[positionKey] = SwapCount.wrap(0);
        delete self.positionAddBlock[positionKey];

        // Last position removed: clean up range tracking (INV-005)
        if (self.positionsByRange[rkRaw].length() == 0) {
            self.activeRanges.remove(rkRaw);
            self.rangeSwapCount[rkRaw] = SwapCount.wrap(0);
            self.totalRangeLiquidity[rkRaw] = 0;
        }
    }

    function incrementRangeSwapCount(
        TickRangeRegistryV2 storage self,
        TickRange rk
    ) internal {
        bytes32 rkRaw = TickRange.unwrap(rk);
        self.rangeSwapCount[rkRaw] = self.rangeSwapCount[rkRaw].increment();
    }

    // ── Views ──

    function positionsInRange(
        TickRangeRegistryV2 storage self,
        TickRange rk
    ) internal view returns (bytes32[] memory) {
        return self.positionsByRange[TickRange.unwrap(rk)].values();
    }

    function rangeLength(
        TickRangeRegistryV2 storage self,
        TickRange rk
    ) internal view returns (uint256) {
        return self.positionsByRange[TickRange.unwrap(rk)].length();
    }

    function contains(
        TickRangeRegistryV2 storage self,
        TickRange rk,
        bytes32 positionKey
    ) internal view returns (bool) {
        return self.positionsByRange[TickRange.unwrap(rk)].contains(positionKey);
    }

    function getLifetime(
        TickRangeRegistryV2 storage self,
        bytes32 positionKey
    ) internal view returns (SwapCount) {
        TickRange rk = self.rangeKeyOf[positionKey];
        SwapCount current = self.rangeSwapCount[TickRange.unwrap(rk)];
        SwapCount baseline = self.baselineSwapCount[positionKey];
        return SwapCount.wrap(current.unwrap() - baseline.unwrap());
    }

    function activeRangeCount(
        TickRangeRegistryV2 storage self
    ) internal view returns (uint256) {
        return self.activeRanges.length();
    }

    function activeRangeAt(
        TickRangeRegistryV2 storage self,
        uint256 index
    ) internal view returns (bytes32) {
        return self.activeRanges.at(index);
    }
}
