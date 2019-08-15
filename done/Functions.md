# Solidity Tutorial: all about Functions

# Function Visibility
There are 4 main visibilities that can be assigned to functions in Solidity
* `Public` > The function is visible everywhere (within the contract itself and other contracts or addresses).
* `Private` > The function is visible only by the contract it is defined in, not derived contracts.
* `Internal` > The function is visible by the contract itself and contracts derived from it.
* `External` > The function is visible only by external contracts / addresses. It can't be called by a function within the contract.

# View vs Pure ?
Functions can also accept different keywords. These messages are mentioned by the Solidity compiler. Here are some explanations about these two keywords.
* View functions can read contract's storage, but can't modify the contract storage. Therefore, they are ideal as getters.

View functions do not require any gas in order to be executed. However, there are some important things to keep in mind.

If a view function is called externally, it will not require any gas to run.

If a view function is called internally (within the same contract) from another function which is not a view function, it will still cost gas. This is because this other function creates a transaction on the Ethereum blockchain, and will need to be verified by every node on the network.

* Pure functions can neither read, nor modify the contract's storage. They are used mostly for pure computation, like functions that perform mathematic or cryptographic operations.

#The "payable" keyword
When the keyword payable is appended to a function, the function can send or receive Ethers.
If Ethers are sent to a function that is not mentioned as payable, the function will automatically reject the ethers sent to it.

# Fallbacks functions
A fallback function has 2 main purposes on Ethereum:

1. Coin management = accept and allocate coins in a meaningful manner.

2. Error-handling = if a user calls a function in a contract that does not exists. Therefore, the fallback function can implement some code to gracefully handle the situation.

A default fallback function can be declared as shown below. Here, the keywords public and payable mean that the contract can then accept ether by default. As explained by Antonopoulos and Wood (2018), " if we make a transaction that sends ether to the contract address, as if it were a wallet, this function will handle it ".
```
function() public payable {}
```
Show some code about how to define some code in a fallback function.

# Variables as function type

https://solidity.readthedocs.io/en/v0.5.11/types.html#function-types

---

# Understanding Function Signatures

To understand what is a function signature, we need to go a bit more into the details of the Solidity compiler and the EVM. But first, let's define a function signature in Solidity.

## What is a function signature ?



# Recursive Functions : How to prevent Re-Entrancy Attacks ?
A recursive function is a function that can reference itself and re-call itself several times. They occur in scenario where you have a base case (if) and an induction case (else). 
Recursive functions are dangerous in Solidity, because they are the gateway for re-entrancy attacks (See the case of the DAO hack for more details). The danger most of the time lies in the induction case. If the base case is reached, the function stops. However, if the induction case is not reached, the function can re-execute again.
Note that in a re-entrancy attack, the remaining gas of the transaction is transferred to the fallback function of the attacker's contract. The solution here is to restrict the gas transferred to another contract when it is invoked. The best way to do this is to use either the built-in methods in Solidity transfer() or send(), which only transfer 23k of gas. So not enough for calling recursively. These 2 methods would then stop a potential attack. 
The steps to prevent re-entrancy attacks in functions that send or accept ethers are:

1. Check: verify that the pre-condition is valid (eg: does the user has a sufficient balance ?).
2. Effect: update the internal state (eg: remove the amount to withdraw to the the user's balance, so pretend the transfer has already happened).
3. Interact: make the interaction with other contracts or addresses and revert in case of failure (eg: transfer the coins).
