// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {IPoolManager} from "v4-core/interfaces/IPoolManager.sol";
import {PoolId} from "v4-core/types/PoolId.sol";
import {StateLibrary} from "v4-core/libraries/StateLibrary.sol";

/// @dev Read current tick from PoolManager state.
function getCurrentTick(
    IPoolManager manager,
    PoolId poolId
) view returns (int24 tick) {
    (, int24 currentTick,,) = StateLibrary.getSlot0(manager, poolId);
    return currentTick;
}

/// @dev Read a position's last fee growth and liquidity from PoolManager.
function getPositionFeeGrowthInsideLast0(
    IPoolManager manager,
    PoolId poolId,
    bytes32 positionKey
) view returns (uint128 liquidity, uint256 feeGrowthInside0LastX128) {
    // TODO: implement via StateLibrary or direct slot reads
    return (0, 0);
}

/// @dev Compute feeGrowthInside0 for a tick range from PoolManager state.
function getFeeGrowthInside0(
    IPoolManager manager,
    PoolId poolId,
    int24 currentTick,
    int24 tickLower,
    int24 tickUpper
) view returns (uint256 feeGrowthInside0X128) {
    // TODO: implement via StateLibrary or direct slot reads
    return 0;
}
