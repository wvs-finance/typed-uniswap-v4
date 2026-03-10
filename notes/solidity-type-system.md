# Understanding Type System: Why Function Types Cannot Appear at the Top Level
## Solidity

### Contract
- contract{} IS semantically a nominal-type
- contract{} IS syntactically a top-level-declaration grammar

```solidity
contract Bar{
    function (foo) external boo;
    function (foo) internal booInternal;
}
```
- Why private functions are not accepted ? -> A private function is an implementation detail, not a callable entity.

- contract{} CAN store function pointer slots
    => solc INSTRUCTS to store (function (foo) external boo) 
        => if internal := JUMPDEST on storage slot to the EVM
                ----------------
                | PUSH JUMPDEST |
                | PUSH 0x00     |
                | SSTORE        |
                ----------------
        => if external : = (selector, address)
                ----------------
                | PUSH SELECTOR |
                | PUSH ADDRESS  |
                | PACK          |
                | SSTORE        |
                ----------------
- contract{} 
### Functions
- (function (foo) returns(uint)) IS semantically a function-type
- (function (foo) returns(uint)) IS syntactically an expression type
- (function (foo) returns(uint)) IS NOT syntactically top-level declaration grammar

=> one CAN use (function (foo) returns(uint)) as a function type
=> one CAN NOT declare (function (foo) returns(uint)) as top-level function typed value
```solidity
interface IContractServices{
    function service(calldata) external{}
}

function free-function(calldata) returns(returndata){}

contract Contract is IContractServices{
    context;
    
    function service(calldata) external{}
    function context-transformation(calldata) internal{}
}
```
### Struct
- struct{} IS semantically composite value-type
- struct{} IS syntactically a top-level-declaration grammar


### Library

- library{} IS syntactically a top-level-declaration grammar
    
Level 1 — Syntax vs Semantics
Level 2 — Declaration Grammar vs Expression Grammar
Level 3 — Type Theory: Where Function Types Live
### Level 4 — Compiler Design: IR (Intermediate Representation)

    | Top-level Item | Compiler IR Mapping          |
    | -------------- | ---------------------------- |
    | contract X     | object layout + codegen unit |
    | type T is U    | typedef node                 |
    | function f()   | codegen unit                 |
    | library L      | namespace + codegen          |

Level 5 — ABI & Runtime Constraints
Level 6 — Language Comparisons
Level 7 — Category Theory & Lambda Calculus Foundations

## Level 8 — The Mental Model You Need
The difference between:

- Deﬁnition vs declaration
    - Type-level constructs vs module-level constructs

- Grammar categories:

    - Declarative

    -Statement

    -expression

    - type

ML/Haskell (separation of types and values)
