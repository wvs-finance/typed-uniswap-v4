// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

// TickRange: minimal reversible encoding of (tickLower, tickUpper).
// Two int24 = 48 bits = bytes6. No hash, no wasted storage.
//
// Layout (big-endian within bytes6):
//   bits [47:24] = uint24(tickLower)
//   bits [23:0]  = uint24(tickUpper)
//
// DOD rationale:
//   - Reversible: lowerTick/upperTick are O(1) bitshifts, no storage lookups
//   - Packable:   6 bytes leaves 26 bytes in a slot for co-located hot data
//   - Mapping-safe: Solidity hashes mapping keys anyway; pre-hashing is double-work
//   - Equality:   native == on bytes6, no wrapper needed

type TickRange is bytes6;

// ── Construction ──

function wrap(int24 tickLower, int24 tickUpper) pure returns (TickRange) {
    return TickRange.wrap(bytes6(uint48(
        (uint48(uint24(tickLower)) << 24) | uint48(uint24(tickUpper))
    )));
}

// ── Projection ──

function lowerTick(TickRange r) pure returns (int24) {
    return int24(uint24(uint48(TickRange.unwrap(r)) >> 24));
}

function upperTick(TickRange r) pure returns (int24) {
    return int24(uint24(uint48(TickRange.unwrap(r))));
}

// ── Predicates ──

function isZero(TickRange r) pure returns (bool) {
    return TickRange.unwrap(r) == bytes6(0);
}

// O(1) overlap: [lA, uA) and [lB, uB) share at least one tick?
function intersects(TickRange a, TickRange b) pure returns (bool) {
    return a.lowerTick() < b.upperTick() && b.lowerTick() < a.upperTick();
}

// Width in ticks (unsigned). Caller is responsible for tickLower < tickUpper.
function width(TickRange r) pure returns (uint24) {
    return uint24(r.upperTick() - r.lowerTick());
}

// ── Bytes32 bridge (for EnumerableSetLib.Bytes32Set) ──

function toBytes32(TickRange r) pure returns (bytes32) {
    return bytes32(TickRange.unwrap(r));
}

function fromBytes32(bytes32 b) pure returns (TickRange) {
    return TickRange.wrap(bytes6(b));
}

// ── Bind as member functions ──

using {lowerTick, upperTick, isZero, intersects, width, toBytes32} for TickRange global;
