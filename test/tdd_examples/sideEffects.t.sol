// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;


import {Test, console2} from "forge-std/Test.sol";
import "../../src/tdd_examples/sideEffects1.sol";

contract sideEffectsTest is Test{
    File file;
    FileReader fileReader;
    UseNonZeroAddress useNonZeroAddress;

    function setUp() public{
        useNonZeroAddress = new UseNonZeroAddress();
    }

    function test__unit__useNonZeroAddress() public {
        useNonZeroAddress.use(NonZeroAddress.wrap(address(0x00)));
    }

    function test__imperative__readFile() public {
        uint256 res = fileReader.sumFromFile(address(file));
        
    }
}