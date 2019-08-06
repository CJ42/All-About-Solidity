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