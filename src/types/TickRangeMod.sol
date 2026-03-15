// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

// TickRange identifies a unique (tickLower, tickUpper) pair via keccak256 hash.
// Used as storage key for per-range swap counters and position sets.
// tickSpacing is a pool-level property — not encoded in the range key.

type TickRange is bytes32;

function fromTicks(int24 tickLower, int24 tickUpper) pure returns (TickRange) {
    return TickRange.wrap(keccak256(abi.encode(tickLower, tickUpper)));
}

function unwrap(TickRange rk) pure returns (bytes32) {
    return TickRange.unwrap(rk);
}

function eq(TickRange a, TickRange b) pure returns (bool) {
    return TickRange.unwrap(a) == TickRange.unwrap(b);
}

function isZero(TickRange rk) pure returns (bool) {
    return TickRange.unwrap(rk) == bytes32(0);
}

// O(1) overlap test on two half-open tick ranges [lA, uA) and [lB, uB).
// Returns true iff the ranges share at least one tick.
function intersects(
    int24 lowerA, int24 upperA,
    int24 lowerB, int24 upperB
) pure returns (bool) {
    return lowerA < upperB && lowerB < upperA;
}

// ── Packed encoding (V2): ticks recoverable from TickRange ──
// Packs int24 tickLower in bits [47:24] and int24 tickUpper in bits [23:0].
// Unlike fromTicks (keccak256), this is reversible.

function fromTicksPacked(int24 tickLower, int24 tickUpper) pure returns (TickRange) {
    return TickRange.wrap(bytes32(
        (uint256(uint24(tickLower)) << 24) | uint256(uint24(tickUpper))
    ));
}

function lowerTick(TickRange rk) pure returns (int24) {
    return int24(uint24(uint256(TickRange.unwrap(rk)) >> 24));
}

function upperTick(TickRange rk) pure returns (int24) {
    return int24(uint24(uint256(TickRange.unwrap(rk))));
}

using {unwrap, eq, isZero, lowerTick, upperTick} for TickRange global;
