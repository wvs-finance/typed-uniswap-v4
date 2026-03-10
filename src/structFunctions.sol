// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import {console2} from "forge-std/console2.sol";

struct Bar{
    function (bytes32) external boo;
}
// (bytes4, address)--
//                   |
//           write(      )

// clients can call this functions (equivalent to diamond ?)

library BarLib{
    function foo(Bar memory _bar) internal{
        _bar.boo(keccak256(bytes("0x00")));
    }
}
contract Caller{
    uint256 count;

    function foo(bytes32 _val) internal{}

    fallback() external{
        assembly{
            let x:= sload(0x00)
            let ptr := mload(0x40)
            mstore(ptr,add(x,0x01))
            
        }
    }

}

contract BarUser{
    Bar bar;
    
    constructor() payable {}


    function boo() private{
        BarLib.foo(bar);
    }


    function writeBar(Bar memory _bar) external{
        console2.logBytes(abi.encode(_bar));
        assembly{
            let _size := calldatasize()
            log1(0x00,0x20, _size)
        }
//         
//assembly{
//             let _caller := shr(0x60, calldataload(0x04))
//             if iszero(eq(_caller, caller())) {
//                 revert(0x00,0x00)
//             }

// // 1           log1(0x00, calldatasize(),_caller)
//         }
        // bar = _bar;
    }

}
