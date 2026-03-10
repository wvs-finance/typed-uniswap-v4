// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

type foo is bytes32;

/**
 * @title Function Types and Visibility in Solidity Explanation
 * @dev This contract demonstrates the concepts mentioned in the notes
 */
contract FunctionTypesExplanation {
    
    // Function type variable - stored in contract storage
    // This acts as a function pointer slot
    function (foo) external returns(foo) public externalFunctionPointer;
    function (foo) internal returns(foo) internalFunctionPointer;
    
    // Example of an internal function that can be assigned to internalFunctionPointer
    function internalExample(foo input) internal returns(foo) {
        return input;
    }
    
    function initialize() external {
        // Assigning the internal function to the function pointer
        internalFunctionPointer = internalExample;
        
        // Using external function pointers requires assigning from another contract
        // externalFunctionPointer = AddressOfAnotherContract.someFunction;
    }
    
    /**
     * @notice Demonstrates why private functions have limitations
     * @dev Private functions can't be referenced externally and have limited use as function pointers
     */
    function demonstratePrivateFunctionLimitation() external view returns (bool) {
        // Private functions are not accessible to other contracts
        // and thus cannot be assigned to external function type variables
        return true;
    }
    
    /**
     * @notice Example of function that accepts function type as parameter
     * @dev This function can only have internal/private visibility because 
     * it takes a function type parameter, which isn't ABI-compatible for external visibility
     */
    function functionAsParameter(
        function (foo) returns(uint) func  // Function type parameter
    ) private pure returns(uint) {
        // This function can accept another function as parameter
        // but can only be private/internal due to ABI compatibility issues
        foo dummyInput = foo.wrap(bytes32(0));
        // Cannot actually call 'func' here since we don't know its implementation
        return 0;
    }
    
    /**
     * @notice Example showing why function types can't be external parameters
     * @dev This would cause a compilation error:
     * "Internal type is not allowed for public or external functions."
     */
    // function functionAsExternalParameter(
    //     function (foo) returns(uint) func  // <-- This causes compilation error
    // ) public returns(uint) {
    //     return 0;
    // }
}

/**
 * @title Nominal Type Demonstration
 * @dev Showing how contracts are nominal types
 */
contract NominalTypeExample {
    // Contract itself is a nominal type
    // Two contracts with identical structure are still different types
    
    // Variables of these types would have different types even with identical structure
    FunctionTypesExplanation public example1;
    AnotherContractWithSameStructure public example2;
    
    // Despite having the same structure, Example1 and Example2 are different nominal types
    // This demonstrates the nominal vs structural typing concept
}

contract AnotherContractWithSameStructure {
    // Same structure as FunctionTypesExplanation but different nominal type
    function (foo) external returns(foo) public externalFunctionPointer;
    function (foo) internal returns(foo) internalFunctionPointer;
}

/**
 * @title Storage Layout Example
 * @dev Shows how function pointers occupy storage slots
 */
contract StorageLayoutExample {
    // Each function type variable gets a dedicated storage slot
    function (uint256) external returns(bool) funcPtr1;  // Slot 0
    function (string memory) external returns(bytes memory) funcPtr2;  // Slot 1
    uint256 dummyData;  // Slot 2 (after function pointers)
    
    function demonstrateStorageSlots() external {
        // The function pointer variables are stored in specific storage slots
        // and can be assigned different functions during runtime
    }
}