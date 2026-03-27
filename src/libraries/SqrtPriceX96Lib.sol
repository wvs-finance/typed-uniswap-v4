// SPDX-License-Identifier: UNLICENSED
pragma solidity =0.8.26;


import {FixedPointMathLib} from "solmate/src/utils/FixedPointMathLib.sol";

uint160 constant Q96 = 2 ** 96;
uint256 constant Q192 = 2 ** 192;

function sortSqrtPriceX96Range(
			       uint160 lowSqrtPriceX96,
			       uint160 upSqrtPriceX96
) pure returns (uint160, uint160){
        (uint160 _lowSqrtPriceX96, uint160 _upSqrtPriceX96) = lowSqrtPriceX96 <= upSqrtPriceX96
        ? (lowSqrtPriceX96, upSqrtPriceX96)
        : (upSqrtPriceX96, lowSqrtPriceX96);
	return (_lowSqrtPriceX96, _upSqrtPriceX96);
}

function inRange(
		 uint160 sqrtPriceX96,
		 uint160 lowSqrtPriceX96,
		 uint160 upSqrtPriceX96
) pure returns(bool){
    (uint160 _lowSqrtPriceX96, uint160 _upSqrtPriceX96) = sortSqrtPriceX96Range(
										lowSqrtPriceX96,
										upSqrtPriceX96
    );
    return (sqrtPriceX96 >= _lowSqrtPriceX96 && sqrtPriceX96 < _upSqrtPriceX96);
}

function fractionToSqrtPriceX96(
      uint256 numerator,
      uint256 denominator
) pure returns (uint160 sqrtPriceX96) {
        // sqrtPriceX96 = sqrt(numerator / denominator) * Q96)
        // sqrtPriceX96 = sqrt(numerator) * 2^96 / sqrt(denominator)
        return
            uint160(FixedPointMathLib.sqrt(numerator) * Q96 / FixedPointMathLib.sqrt(denominator));
}

function fromWadToSqrtPriceX96(
        uint256 exchangeRateWad
 ) pure returns (uint160 sqrtPriceX96) {
        sqrtPriceX96 =  fractionToSqrtPriceX96(1e18, exchangeRateWad);
}

function fromRayToSqrtPriceX96(uint256 exchangeRateRay) pure returns (uint160 sqrtPriceX96) {
    sqrtPriceX96 = fractionToSqrtPriceX96(1e27, exchangeRateRay);
}

   function absDifferenceX96(
        uint160 sqrtPriceAX96,
        uint160 sqrtPriceBX96
    ) pure returns (uint160) {
        return sqrtPriceAX96 < sqrtPriceBX96
            ? (sqrtPriceBX96 - sqrtPriceAX96)
            : (sqrtPriceAX96 - sqrtPriceBX96);
    }


// divX96: (numeratorX96 * Q96) / denominatorX96, overflow-safe via mulDivDown
function divX96(uint160 numeratorX96, uint160 denominatorX96) pure returns (uint256) {
    return FixedPointMathLib.mulDivDown(uint256(numeratorX96), uint256(Q96), uint256(denominatorX96));
}

function absPercentageDifferenceWad(
    uint160 sqrtPriceX96,
    uint160 denominatorX96
) pure returns (uint256) {
    uint256 _divX96 = divX96(sqrtPriceX96, denominatorX96);

    // (_divX96^2 * 1e18) / Q192, overflow-safe via mulDivDown
    uint256 _squaredX192 = FixedPointMathLib.mulDivDown(_divX96, _divX96, Q192);
    uint256 _percentageDiffWad = _squaredX192 * 1e18;
    return (1e18 < _percentageDiffWad) ? _percentageDiffWad - 1e18 : 1e18 - _percentageDiffWad;
}


