// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;


type char is bytes1;

// page 21
contract Holes{
    function (char) internal returns(string memory) convert;
}