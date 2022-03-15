# Solidity Tutorial: all about booleans

**Table of Content**
- [Solidity Tutorial: all about booleans](#solidity-tutorial-all-aboutbooleans)
  - [How to define a boolean variable in Solidity?](#how-to-define-a-boolean-variable-in-solidity)
  - [Operators related to booleans](#operators-related-tobooleans)
  - [Comparisons operators and booleans](#comparisons-operators-andbooleans)
- [References](#references)

## How to define a boolean variable in Solidity?

Variable of boolean type are defined by the keyword `bool` . They can contain a constant value of either `true` or `false`;



## Operators related to booleans

- `!` (logical negation)
- `&&` (logical conjunction, "and")
- `||` (logical disjunction, "or")
- `==` (equality)
- `!=` (inequality)

The operators `||` and `&&` apply the common short-circuiting rules. This means that in the expression `f(x) || g(y)`, if `f(x)` evaluates to `true`, `g(y)` will not be evaluated even if it may have side-effects.



## Comparisons operators and booleans

The following comparison operators `<=` (less than or equal), `<` (less than), `==`, `!=`, `>=`, `>` evaluate to a boolean value.


# References

- https://solidity.readthedocs.io/en/v0.5.7/types.html