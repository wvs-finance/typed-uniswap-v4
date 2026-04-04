// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import {PoolKey} from "@uniswap/v4-core/src/types/PoolKey.sol";
import {PoolId, PoolIdLibrary} from "@uniswap/v4-core/src/types/PoolId.sol";
import {Position} from "@uniswap/v4-core/src/libraries/Position.sol";
import {ModifyLiquidityParams} from "@uniswap/v4-core/src/types/PoolOperation.sol";

using PoolIdLibrary for PoolKey;

/// @notice Derives (PoolId, positionKey) from hook callback parameters in one call.
/// @dev Avoids repeating key.toId() + Position.calculatePositionKey() in every hook.
function poolAndPositionKey(
    PoolKey calldata key,
    address sender,
    ModifyLiquidityParams calldata params
) pure returns (PoolId id, bytes32 positionKey) {
    id = key.toId();
    positionKey = Position.calculatePositionKey(sender, params.tickLower, params.tickUpper, params.salt);
}
