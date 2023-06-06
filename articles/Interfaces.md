# Solidity Tutorial: all about interfaces

--- 

## What is an interface in Solidity ?

### What is an interface ?

_Explain first what is an interface in simple terms (analogy with car and country)_

### Interface in Solidity

The Solidity documentation states the following:
> Interfaces are similar to abstract contracts, but they cannot have any functions implemented.

---

## How to declare an interface ?

You can declare an interface by simply using the keyword interface . Let's look at an example.

```solidity
interface Country {
    
    // Define interface methods here

}
```

---

## How to use an interface in Solidity

Smart Contracts can implement interfaces using the same syntax for inheritance.


---

## More about interfaces

### From the Solidity doc

Interfaces are basically limited to what the Contract ABI can represent, and the conversion between the ABI and an interface should be possible without any information loss.

Types defined inside interfaces and other contract-like structures can be accessed from other contracts: Token.TokenType or Token.Coin.

Note that prior to Solidity 0.6.0 (up to 0.5.17), interface contracts could be defined as shown below.

```solidity
pragma solidity 0.5.17;

// This is the syntax prior to 0.6.0
// These abstract contracts are only provided to make the
// interface known to the compiler. Note the function
// without body. If a contract does not implement all
// functions it can only be used as an interface.
contract Config {
    function lookup(uint id) public returns (address adr);
}
```

Since Solidity 0.6.0 and up to the latest version, such contracts must be marked as `abstract`.

```solidity
pragma solidity 0.6.0;

abstract contract Config {
    function lookup(uint id) public virtual returns (address adr);
}
```

### Inheritance Notes

> Currently it is undefined whether a contract with a function having no NatSpec will inherit the NatSpec of a parent contract/interface for that same function. (Solidity doc).

I have tested and No, contracts do not inherit NatSpec and Doxygen tags from the interfaces they implement. You have to override them.

However, this might be a handy feature, especially for the @notice comment if they include dynamic expressions.

---

## What you can't do with an interface ?

Interfaces have several restrictions, including the following:

- Variables (including constants) can't be defined in interfaces
- They can't inherit.
- They can't have a constructor.
- You can't instantiate an interface.
- Their functions can't have an implementation
- Their functions can't be declared as private or internal. All their functions - must be declared external, although

> Up to version 0.4.26 (before version 0.5.0), you could declare a function as public in your interface instead of external. The Solidity compiler will give you a simple warning but will allow you to compile. 
> Since version 0.5.0, declaring functions as public within interfaces raises a TypeError and does not allow to compile.

---

# References

- [Solidity get interface id and ERC165](https://nhancv.medium.com/solidity-get-interface-id-and-erc165-190f0e2e3a9)

- Contracts - Solidity 0.5.10 documentation
Contracts in Solidity are similar to classes in object-oriented languages. They contain persistent data in state…solidity.readthedocs.io

- Interfaces make your Solidity contracts upgradeable
This blog post talks about two problems common to all Ethereum smart contracts - upgradeability and block gas limit…medium.com

- Interface Function
I understand that the following function is used to link the ico contract to the token. Appreciate if someone could…ethereum.stackexchange.com

- Ethereum Development: Interfaces and Function Modifiers
In my last article, we got started with Ethereum development by using Truffle and the Ganache command line. In this…dev.to
