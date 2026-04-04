// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import {PoolKey} from "v4-core/types/PoolKey.sol";
import {PoolId, PoolIdLibrary} from "v4-core/types/PoolId.sol";
import {Position} from "v4-core/libraries/Position.sol";
import {ModifyLiquidityParams} from "v4-core/types/PoolOperation.sol";

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
