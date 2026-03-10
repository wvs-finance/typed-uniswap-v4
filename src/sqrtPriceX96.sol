// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;


import {timestamp} from "./timestamp.sol";
import {percentage} from "./percentage.sol";

// uint160 sqrtPriceX96 (value) , uint48 timeStamp, 
// uint8 source
// enum source{
// POOL
// EXTERNAL
//} = uint216

enum source{
    POOL,
    ORACLE
}

type sqrtPriceX96 is uint216;


// NOTE: This is a price which time stamp is in the future and does not have source 
type sqrtStrikeX96 is uint208;

function toStrike(sqrtPriceX96) returns(sqrtStrikeX96){}


type sqrtOptionPriceX96 is uint160;

// TODO: Missing realized folatility
function calculateSqrtOPtionPriceX96(sqrtPriceX96 underlying,timestamp maturity,sqrtStrikeX96 strike,percentage riskFreeRate)  returns(sqrtOptionPriceX96){}