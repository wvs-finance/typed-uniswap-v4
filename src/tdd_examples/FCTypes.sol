// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;


struct Type{
    bytes value;
}

contract FCTypes{
    
    function stringOrInt(
        bool cond
    ) internal returns(Type memory _type){
       _type =
       Type(cond ? bytes(string(_type.value)):abi.encode(abi.decode(_type.value, (int256))));
    
    }
    // function getStringOrInt(bool x) internal returns(function(bool) returns(Type memory _type)){
    //     x ? stringOrInt(x).value :int256(94);
    // }

    // function toString(bool x) private returns(string memory){
        
    //     return x ? string(Type.value);
    // }

    // function toInt256(bool x) private returns(int256){

    // }
    
}