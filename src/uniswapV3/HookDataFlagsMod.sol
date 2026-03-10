// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/// @dev Check whether hookData encodes a V3-reactive callback.
/// Convention: first 32 bytes of hookData contain a flags word;
/// bit 0 set means the call originates from V3 reactive path.
function isUniswapV3Reactive(bytes calldata hookData) pure returns (bool) {
    if (hookData.length < 32) return false;
    uint256 flags = abi.decode(hookData[:32], (uint256));
    return (flags & 1) != 0;
}
