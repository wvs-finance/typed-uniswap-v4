// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import {percentage} from "./percentage.sol";
import {position, LP, hodl} from "./position.sol";

// AT the same price
// | (position1 - position2)/position1|

// type opportunityCost is percentage;
type opportunityCost is uint24;

function calculateOpportunityCost(position memory p1,position memory p2) returns(opportunityCost){
    // require(p1._type != p2._type && p1.price != p2.price);
}

// function foo(position memory,position memory) internal returns(percentage) opportunityCost_;

contract Foo{
    function foo(uint x) internal returns(uint) {
        return 1;
    }

    function (address,address) internal returns(bool) ze;
    function (opportunityCost) external returns(percentage) si;


    function bar() public returns(uint){
        function(uint) internal returns(uint) f = foo;
        return f(5); 
    }

}



// type impermanentLoss is opportunityCost;

type impermanentLoss is uint24;

function calculateImpermanentLoss(LP memory _lp,hodl memory _hodl) returns(impermanentLoss){}
