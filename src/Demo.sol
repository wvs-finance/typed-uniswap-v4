// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

// TODO: Answer this questions from a compiler design type driven developement, why certain things are not allowed
// the design midnset behind it 

// Unveiling semantics from syntax
//                                  .sol    =   ?                 
// 
//                            modules === > name_space
//                      ------------------------------------------------
//                                     TOP LEVEL ITEMS
//                     | import                                        |
//                     | types := T                                    |
//                     | global functions --> No contract state access |
//                     | contracts : C                                 |
//                     | interface : I                                 |
//                     | library: L                                    |
//                      ------------------------------------------------       
//                   
// ==> contract {}    =   ?           nominal type + runtime deployment template 
// |                    TDD                      |               OOD                   |      Compiler         |
// |---------------------------------------------|----------------------------------------------------------
// | - nominal type declaration that produces a  | - A class (nominal, not structural) | - A container of functions + storage + metadata                             |
// |   runtime instance                          | - [Runtime] A deployed object with  |                                   | - 
// |                                             | an address                          |                              
// | - type with known interface & storage layout|                                     |


type foo is bytes32;

// IS:
// ✔ A newtype wrapper (Haskell)
// ✔ A strong typedef (Rust: struct Foo(pub u32);)
// ✔ A nominal alias over a primitive

// INTRODUCE:
// 
// new static type
// identical runtime representation
// no runtime wrapper
// compile-time checking only

// But wrapping functions on structs and contracts is correct
//         - sintax: Yes
//         - semantic : ?

// implications and meaning of this ?  
struct bar{
    function (foo) external returns(foo) boo;
    function (foo) internal returns(bytes32) booInternal;
}

contract Bar{
    // external OR  internal 
    // Why ?: --> Error (6012): Invalid visibility, can only be "external" or "internal".
        // function (foo) returns(foo) boo; 
    // But inside the contract is valid:
    // b.f: foo --> foo
    function (foo) external view returns(foo) boo;
    
    // c.b: foo x uint ---> foo
    // Why ?: Error (4103): Internal type is not allowed for public or external functions.
        // function bar(
        //     function (foo) returns(uint)
        // ) public returns(foo){}
    // Allowed only for internal, private
    // bar: whatever x whatever --> barOutput
    function bar(
        // f: whatever ---> whatever
        // a.k.a: Arbitrary calls 
        function (bytes calldata) returns(bytes memory)
    ) private pure returns(barOutput){}

    // function barExternal(
    //     function ex(bytes calldata) returns(bytes memory)
    // ) external{}
    // Is there a semantic dirfference if I define the type outside of the contract than inside   ?
    type barOutput is bytes32;

    // Can we define nested types ?
        // sintax: No --> Error (2314): Expected identifier but got ';'
         //semantically : ?
    // function (function (bytes calldata)) external returns(barOutput); 

    // Functions whit no return types what class of types
    // f: bytes (Statefull to be meaningfull)
    function (bytes calldata) hello;

    // Can we define types where the data is coming from memory ?
        // syntax: Yes
        // semantic: ?
    function (bytes memory) ge;

}