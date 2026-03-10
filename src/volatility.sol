// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import {measure} from "./measure.sol";

// uint48 t_0, uint48 t_1, 
// uint160 int_{t_0}^{t_1} f(position.price) dt

// type volatility is measure;

type volatility is uint256;

// uint48 t_0, uint48 t_1, 
// uint160 int_{t_0}^{t_1} priceReturn_t dt

// type realizedVolatility is volatility;
type realizedVolatility is uint256;

// uint48 t_0, uint48 t_1, 
// uint160 int_{t_0}^{t_1} opportunityCost_t dt

// type differentialVolatility is volatility;

type differentialVolatility is uint256;
//Double integral over a collection of option prices AND the time

// type impliedVolatility is measure;

type impliedVolatility is uint256;


