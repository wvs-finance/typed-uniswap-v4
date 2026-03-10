// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

struct Matrix{
    uint256 nRows;
    uint256 nColumns;
    uint256[] row;
    uint256[] column;
}

library MatrixOperations{
    
    error TypeError(string);
    
    function add(Matrix memory m1,Matrix memory m2) internal returns(Matrix memory){
        if (m1.nRows != m2.nRows || m1.nColumns != m2.nColumns) revert TypeError("trying to add matrices of different size");

    }

    function transpose(Matrix memory m) internal returns(Matrix memory mT){

        {
            // transpose
            mT = m;
        }
        if (!(mT.nColumns == m.nRows && mT.nRows != m.nColumns)) revert();
    }
}

enum ATMState{
    READY,
    CARD
}