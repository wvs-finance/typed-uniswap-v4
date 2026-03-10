// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import {PositionInfo} from "@uniswap/v4-periphery/src/libraries/PositionInfoLibrary.sol";
import {Reserves} from "./Reserves.sol";
import {sqrtPriceX96} from "./sqrtPriceX96.sol";

// 128 position value  + 1 byte for type = uint136

enum positionType{
    LP,
    HODL
}

type positionValue is uint128;

struct position{
    PositionInfo range;
    Reserves reserves;
    sqrtPriceX96 price;
    positionType _type;
}

function calculatePosition(PositionInfo,Reserves memory,sqrtPriceX96) pure returns(position memory){}

struct LP{
    PositionInfo range;
    Reserves reserves;
    sqrtPriceX96 price;
    positionType _type;

}

function LPPosition(PositionInfo,Reserves memory,sqrtPriceX96) returns(LP memory){
    // require(LP._type == positionType.LP);
}


struct hodl{
    PositionInfo range;
    Reserves reserves;
    sqrtPriceX96 price;
    positionType _type;

}

function hodlPosition(PositionInfo,Reserves memory,sqrtPriceX96) returns(hodl memory){
    // require(hodl._type == positionType.HODL);
}





