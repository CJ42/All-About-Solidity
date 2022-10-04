# All About Code

## Introduction

Code as a data location refers the contract bytecode. Once a contract has been deployed, its code cannot be changed. Therefore, data and variables stored into code are read only and not editable.

The code is made of bytes (unlike storage that is made of “slots”).

## How to store variables in the contract's code?

You can define variables to be stored inside the contract bytecode using either the keyword `constant` or `immutable`. 

More details below.

## Immutable

Variables defined as `immutable` can be defined only during deployment via the constructor.

Only variables of direct type can go into code as immutable. Meaning variables like `uintN`, `bytesN` or `address`.

Variables of types array cannot be defined as `immutable` at the moment. It is currently not supported.

It is impossible to predict where immutable variables will be placed in the code (= comtract’s code/bytecode). (Hypothesis: this might especially be the case if the optimizer is on, and depending on its settings).

An important thing to note is that immutable variables will not appear in the code if they are never read from (in the contract logic / execution or functions). So they will not appear anywhere in the code if they are simply defined in the contract, but not used anywhere in the contract.
Immutables are simply inline into the code wherever they are read from. Therefore if the constant is never read from, it’s value isn’t stored anywhere in the code.


## Layout of code

The code has no notion of “slots”; the variables are simply placed wherever the compiler places them, among the code.

Immutables in code are padded, but they have unusual padding.

> Prior to Solidity 0.8.9, padding worked a bit differently in code; in code, all types were zero-padded, even if they would ordinarily be sign-padded. This did not affect which side they are padded on.

## Finding variables inside the contract bytecode

You can use the Solidity compiler’s `immutableReferences` output to determine this information. To understand the Data layout of code, and how to access the variables defined inside it, we rely on the compiler output.

# References

- https://ethereum.stackexchange.com/questions/107894/storing-immutable-state-in-contract-data

