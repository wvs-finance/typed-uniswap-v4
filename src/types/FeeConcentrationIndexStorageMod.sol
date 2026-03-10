// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {PoolId} from "v4-core/types/PoolId.sol";
import {TickRange} from "./TickRangeMod.sol";
import {SwapCount} from "./SwapCountMod.sol";
import {BlockCount} from "./BlockCountMod.sol";

/// @dev Central storage layout for the Fee Concentration Index.
struct FeeConcentrationIndexStorage {
    /// pool → position count
    mapping(PoolId => uint256) posCount;
    /// pool → tick → overlapping range count
    mapping(PoolId => mapping(int24 => uint256)) overlappingRanges;
    /// pool → positionKey → TickRange
    mapping(PoolId => mapping(bytes32 => TickRange)) positions;
    /// pool → positionKey → liquidity
    mapping(PoolId => mapping(bytes32 => uint128)) posLiquidity;
    /// pool → positionKey → fee growth baseline
    mapping(PoolId => mapping(bytes32 => uint256)) feeGrowthBaseline;
    /// pool → accumulated state term (Σ x² · Δblocks)
    mapping(PoolId => uint256) accumulatedStateTerm;
    /// transient: cached tick
    int24 _cachedTick;
    /// transient: cached removal data
    uint256 _cachedFeeLast0;
    uint128 _cachedPosLiquidity;
    uint256 _cachedRangeFeeGrowth0;
}

// ─── Storage slots ──────────────────────────────────────────────────

bytes32 constant FCI_STORAGE_SLOT = keccak256("fee-concentration-index.storage");
bytes32 constant REACTIVE_FCI_STORAGE_SLOT = keccak256("fee-concentration-index.reactive.storage");

function fciStorage() pure returns (FeeConcentrationIndexStorage storage $) {
    bytes32 slot = FCI_STORAGE_SLOT;
    assembly { $.slot := slot }
}

function reactiveFciStorage() pure returns (FeeConcentrationIndexStorage storage $) {
    bytes32 slot = REACTIVE_FCI_STORAGE_SLOT;
    assembly { $.slot := slot }
}

// ─── Position lifecycle ─────────────────────────────────────────────

function registerPosition(
    FeeConcentrationIndexStorage storage $,
    PoolId poolId,
    TickRange rk,
    bytes32 positionKey,
    int24 tickLower,
    int24 tickUpper,
    uint128 liquidity
) {
    $.positions[poolId][positionKey] = rk;
    $.posLiquidity[poolId][positionKey] = liquidity;
}

function deregisterPosition(
    FeeConcentrationIndexStorage storage $,
    PoolId poolId,
    bytes32 positionKey,
    uint128 posLiquidity
) returns (TickRange rk, SwapCount swapLifetime, BlockCount blockLifetime, uint128 totalRangeLiq) {
    rk = $.positions[poolId][positionKey];
    $.positions[poolId][positionKey] = TickRange.wrap(bytes32(0));
    delete $.posLiquidity[poolId][positionKey];
    return (rk, SwapCount.wrap(0), BlockCount.wrap(0), posLiquidity);
}

// ─── Counters ───────────────────────────────────────────────────────

function incrementPosCount(FeeConcentrationIndexStorage storage $, PoolId poolId) {
    $.posCount[poolId]++;
}

function decrementPosCount(FeeConcentrationIndexStorage storage $, PoolId poolId) {
    $.posCount[poolId]--;
}

function incrementOverlappingRanges(
    FeeConcentrationIndexStorage storage $,
    PoolId poolId,
    int24 tickMin,
    int24 tickMax
) {
    for (int24 t = tickMin; t <= tickMax; t++) {
        $.overlappingRanges[poolId][t]++;
    }
}

// ─── State accumulation ─────────────────────────────────────────────

function addStateTerm(
    FeeConcentrationIndexStorage storage $,
    PoolId poolId,
    BlockCount blockLifetime,
    uint256 xSquaredQ128
) {
    $.accumulatedStateTerm[poolId] += xSquaredQ128 * uint64(BlockCount.unwrap(blockLifetime));
}

// ─── Fee growth baseline ────────────────────────────────────────────

function setFeeGrowthBaseline(
    FeeConcentrationIndexStorage storage $,
    PoolId poolId,
    bytes32 positionKey,
    uint256 feeGrowth0X128
) {
    $.feeGrowthBaseline[poolId][positionKey] = feeGrowth0X128;
}

function getFeeGrowthBaseline(
    FeeConcentrationIndexStorage storage $,
    PoolId poolId,
    bytes32 positionKey
) view returns (uint256) {
    return $.feeGrowthBaseline[poolId][positionKey];
}

function deleteFeeGrowthBaseline(
    FeeConcentrationIndexStorage storage $,
    PoolId poolId,
    bytes32 positionKey
) {
    delete $.feeGrowthBaseline[poolId][positionKey];
}

// ─── Transient cache ────────────────────────────────────────────────

function t_storeTick(int24 tick) {
    FeeConcentrationIndexStorage storage $ = fciStorage();
    $._cachedTick = tick;
}

function t_readTick() returns (int24 tick) {
    FeeConcentrationIndexStorage storage $ = fciStorage();
    tick = $._cachedTick;
    $._cachedTick = 0;
}

function t_cacheRemovalData(uint256 feeLast0, uint128 posLiquidity, uint256 rangeFeeGrowth0) {
    FeeConcentrationIndexStorage storage $ = fciStorage();
    $._cachedFeeLast0 = feeLast0;
    $._cachedPosLiquidity = posLiquidity;
    $._cachedRangeFeeGrowth0 = rangeFeeGrowth0;
}

function t_readRemovalData() returns (uint256 feeLast0, uint128 posLiquidity, uint256 rangeFeeGrowth0) {
    FeeConcentrationIndexStorage storage $ = fciStorage();
    feeLast0 = $._cachedFeeLast0;
    posLiquidity = $._cachedPosLiquidity;
    rangeFeeGrowth0 = $._cachedRangeFeeGrowth0;
    $._cachedFeeLast0 = 0;
    $._cachedPosLiquidity = 0;
    $._cachedRangeFeeGrowth0 = 0;
}
