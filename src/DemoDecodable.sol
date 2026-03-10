// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

type foo is bytes32;

contract Bar{
    function (foo) internal view returns(foo) boo;
    function getBoo() external view returns(bytes32 res){
    
        assembly{
            res := sload(0x00)
        }   
    }
}