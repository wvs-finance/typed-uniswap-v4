// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

type type1 is bytes32;
type type2 is bytes32;
type type3 is bytes32;

type intermediateType is bytes32;

library Functions{
    function f(type1) internal returns(type2){}
    // f: A x B -> C
    // g: A--> B  h: B --> C
    // (f o g): A --> B
    // (f o h): A --> C
    // function typeChecker(
    //     function (input) returns(intermediateType)
    // ) internal returns(function(bytes32) returns(output)){}

}