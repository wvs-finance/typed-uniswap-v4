// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

contract File{
    uint256 public v1 = 1;
    uint256 public v2 = 2;

}

contract FileReader{
    
    event Result(uint256);
    function sumFromFile(address _file) public returns(uint256 res){
        (,bytes memory res1) = _file.staticcall(abi.encodeWithSignature("v1()"));
        (,bytes memory res2) = _file.staticcall(abi.encodeWithSignature("v2()"));
        res = abi.decode(res1, (uint256)) + abi.decode(res2, (uint256));
        emit Result(res);
    }
}





// How does the compiler knows statically is non-zero

// https://www.youtube.com/watch?v=_lZu1c7tZ-3:29


// compiler error
type NonZeroAddress is address;
error TypeError(string reason);

abstract contract TypeChecker{
    modifier verifyTypes(bytes memory types){
        _;
    }
}

contract UseNonZeroAddress is TypeChecker{
    event Used(NonZeroAddress);


    function use(NonZeroAddress nonZeroAddress) external{
        emit Used(nonZeroAddress);
    }

    function use(NonZeroAddress nonZeroAddress) external verifyTypes(abi.encode(nonZeroAddress)){
        emit Used(nonZeroAddress);
    }



//     function use(NonZeroAddress)
// //     function use(address value, function(address) returns(address)) external{}
}




