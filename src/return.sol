// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import {percentage} from "./percentage.sol";

// type priceReturn is percentage;

type priceReturn is uint24;
// requires same position BUT different prices

// ∆LP = V'(P) = ∂V(P)/∂P
// Price sensitivity: rate of change of position value with respect to price
type delta is int256;  // or could be a signed percentage type
// requires same position at a specific price
// Measures how much position value changes per unit price change
// Can be positive or negative

// ΓLP = V''(P) = ∂²V(P)/∂P²  
// Convexity: rate of change of delta with respect to price
type gamma is int256;  // or could be a signed percentage type
// requires same position at a specific price
// Measures how much delta changes per unit price change
// Typically negative for LP positions (concave payoff)
