// SPDX-License-Identifier: UNLICENSED
pragma solidity =0.8.26;

enum PRECISION_FLAG {
    RAY,  
    WAD  
}

function toBool(PRECISION_FLAG precisionFlag) pure returns (bool result) {
    assembly ("memory-safe") {
        result := precisionFlag
    }
}
