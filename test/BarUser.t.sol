// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import {Test, console2} from "forge-std/Test.sol";
import "../src/structFunctions.sol";

contract BarTest is Test{
    
    BarUser barUser;
    address any_caller = makeAddr("anyCaller");

    function setUp() public {
        barUser = new BarUser();
    }

    function test__fuzz__writeBar(Bar memory _bar) public {
        // console2.log(_bar.boo);        
        console2.log("Bar User Address:", address(barUser));
        console2.log(abi.encode(_bar).length);
        vm.prank(any_caller);
        // if (msg.sender != abi.decode(abi.encode(_bar), (address))){
        //     vm.expectRevert();
        // }
        console2.log("Caller:", msg.sender);
        
        console2.logBytes(abi.encode(_bar));
        barUser.writeBar(_bar);
        // assertEq(abi.decode(abi.encode(_bar), (address)),any_caller);
    }
}