program.intention ----type.checks---> type
     2             
  -----------
 |   program |      ------1-------
 |   design  |---> |     type    |
 ------------      --------------
          <        | - define    |
             ---   | -refine     |
                   --------------
- fit values (holes) on types
- types ARE a means of classifying values

### Roles
- Machine: describe bit patterns in memory
- Compiler: bit pattern semantics
- Programmer: organize conceps, aidiong documentation


1. T = (t1, t2, ..., tn)
2. ti --> O(ti) ->     o:ti x ti --> ti
                 \-->  o:ti --> ti
3. F = (f1,   ... , fm)
          fi: tj --> tk


- Simple Type:
    bytes[]  
- Generic Types:
    uint256[]
    ------
      |
       \--> type variable := uint256 
- Dependant Types:
    uint256[3]
                 Tk(Ti)
- Type variables
    - parameters on generic types
## Pure functional langauage


### function pure

- DO NOT have side effects
    - DO NOT modify state
    - DO NOT throw errors

    - DO NOT emit events
    => univalent relation on (I x O)
        referential transparency
            O= f(I) => f(O) = O

### function total
- guaranteed to produce a result
    - DOES NOT throw exeptions
    - DOES NOT run infinite loops

### function partial

- might not return a result for some inputs
    - CAN throw exeptions
    - CAN run infinite loops

## Patterns

---------------------------------------------
|- type                                      |
|               ----------   ------------    |
|              |  valid  |  | Operations |   |
|              |         |  |    set     |   |
|              |  states |  |            |   |
|              -----------   -----------     |
-------------------------------------------|      
                                    

## Language Constructs:

### first class:
- treated as value:
    - used in calldata
    - used in returndata

PG 23
