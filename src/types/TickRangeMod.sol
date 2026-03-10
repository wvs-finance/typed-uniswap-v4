// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/// @dev Encoded tick range key: keccak256(abi.encode(tickLower, tickUpper)).
type TickRange is bytes32;
