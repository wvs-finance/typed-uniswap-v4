// SPDX-License-Identifier: UNLICENSED
pragma solidity =0.8.26;

import {TickRange} from "../types/TickRangeV2Mod.sol";
import {TickMath} from "@uniswap/v4-core/src/libraries/TickMath.sol";

function fromTickRangeToSqrtPriceX96Range(TickRange tickRange) pure returns (uint160, uint160) {
    return (
        TickMath.getSqrtPriceAtTick(tickRange.lowerTick()),
        TickMath.getSqrtPriceAtTick(tickRange.upperTick())
    );
}
