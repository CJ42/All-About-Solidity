# Solidity Tutorial : all about Constructors


Constructors run only once, when the contract is deployed. However, the code deployed on the network does not include the constructor code.

---

## How to define a constructor ?

Constructors can be either public or internal.

However, constructors in Solidity are optional. If no constructor is defined within the contract, the contract will assume the default constructor equivalent to constructor() public {}.

> **Be aware that prior to compiler version 0.4.22, constructors were defined as functions with the same name as the contract. This syntax is now deprecated and not allowed anymore in version 0.5.0 and above.**
 
---

## Pass Arguments to Constructors

You can pass arguments to a `constructor`.

If the base constructor have arguments, derived contract need to specify all of them. This can be done in two ways.

- Directly in the inheritance list.
- Through a modifier of the derived contract.

---

## What you can't and shouldn't do with Constructors !

- **You should not access functions externally in the constructor because the function does not exist yet.**
- Constructors can not be declared in an interface.