# Solidity Tutorial : all about Storage, Memory and CallData

You will find this topic probably as the most challenging.

---

## Storage

Storage refers to the contract's storage.

You can pass the keyword storage to a value you don't want to be cloned.

Storage is long-term but expensive !

---

## Memory

In Ethereum, the memory holds temporary values (said not persisting), like function parameters.

Relative to the execution of the transaction of the transaction of the constructor.

Variables with the keyword memory assigned to them are therefore not persisting and temporary.

Moreover, memory variables are erased between external function calls.

Memory is short and cheap !

---

## CallData or the Stack

The Stack referred by the keyword calldata in Solidity hold small local variables. However, it can hold only a limited number of values. The Stack in Ethereum has maximum size of 1024 elements.

Finishes once a function finishes its execution.

CallData is almost free but has a limited size !

---

## When to use the keywords Storage, Memory and CallData ?

Any variable of complex type like array, struct, mapping or enum must specify a data location.

---

## Data Location Rules for Function parameters

The table below give the possible data locations for function parameters, depending on the function visibility.

| Function visibility  | Data location for function parameter can be  |
|---|---|
| `external`  | `storage` = :x: **not allowed** <br> `memory` = :white_check_mark: (since 0.6.9) <br> `calldata` = :white_check_mark:  |
| `public`  | `storage` = :x: **not allowed** <br> `memory` = :white_check_mark: <br> `calldata` = :white_check_mark: (since 0.6.9)  |
| `internal`  | `storage` = :white_check_mark: <br> `memory` = :white_check_mark: <br> `calldata` = :white_check_mark: (since 0.6.9)  |
| `private` | `storage` = :white_check_mark: <br> `memory` = :white_check_mark: <br> `calldata` = :white_check_mark: (since 0.6.9)  |

# References

- [Hackernoon - Getting Deep into Ethereum: how data is stored ?](https://hackernoon.com/getting-deep-into-ethereum-how-data-is-stored-in-ethereum-e3f669d96033)
