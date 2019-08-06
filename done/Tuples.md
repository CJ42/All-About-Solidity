
# Solidity Tutorial: all about Tuples

  

## What is a Tuple ?

Tuple are an existing concept in Programming.

According to the Solidity Documentation:

> A tuple is a list of objects of potentially different types whose number is a constant at compile-time

  

## Tuples in Solidity

Solidity are not a proper types in Solidity. There is no `tuple` keyword is Solidity. Therefore, you can’t assign a **tuple** as a type to a variable.

However, the official documentation states that Solidity internally allows tuple types and can only be used to form syntactic group of expressions.

  

## Tuples as return value type

Tuples can be used to return multiple value at the same time. These can then either be assigned to newly declared variables or to pre-existing variables (or LValues in general)