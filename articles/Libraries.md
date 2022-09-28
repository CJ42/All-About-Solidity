
----------

# Solidity Tutorial: all about Libraries (edit)

![](https://cdn-images-1.medium.com/max/2600/1*vO-s4EkCLU7apasYDSLUaA.jpeg)

## Table of Contents

1.  **What is a Library in Solidity ?**
2.  **How to create a library in Solidity ?**
3.  **How to deploy a Library in Solidity ?**
4.  **How to use a Library in a smart contract ?**
5.  **How to interact with a library in Solidity ?**
6.  **Understanding functions in libraries.**
7.  **Events and Libraries**
8.  **Mappings in Library = more functionalities !**
9.  **Linking libraries with other libraries**
10.  **Use modifier in libraries**
11.  **What you can’t do with library in Solidity ?**
12.  **Some already available libraries**

**What I do not understand about libraries in Solidity**

**References**

### 1. What is a Library in Solidity ?

> [Libraries can be seen as implicit base contracts of the contracts that use them (Solidity doc)](https://solidity.readthedocs.io/en/v0.5.9/contracts.html#libraries)

A `library` in Solidity is a different type of smart contract that contains reusable code. Once deployed on the blockchain (only once), it is assigned a specific address and its properties / methods can be reused many times by other contracts in the Ethereum network.

They enable to develop in a more modular way. Sometimes, it is helpful to think of a library as a **singleton** in the EVM, a piece of code that can be called from any contract without the need to deploy it again.

  

### Benefits

However, libraries in Solidity are not only limited to reusability. Here are some of their advantages :

-   **Usability :** Functions in a library can be used by many contracts. If you have many contracts that have some common code, then you can deploy that common code as a library.
-   **Economical :** Deploying common code as library will save gas as gas depends on the size of the contract too. Using a base contract instead of a library to split the common code won’t save gas because in Solidity, inheritance works by copying code.
-   **Good add-ons :** Solidity libraries can be used to add member functions to data types. For instance, think of libraries like the _standard libraries_ or _packages_ that you can use in other programming languages to perform complex math operations on numbers.

  

### Limitations

Libraries in Solidity are considered **stateless,** and hence have the following restrictions

-   They do not have any storage (so can’t have non-constant state variables)
-   They can’t hold ethers (so can’t have a **fallback** function)
-   Doesn’t allow payable functions (since they can’t hold ethers)
-   Cannot inherit nor be inherited
-   Can’t be destroyed (no `selfdestruct()` function since version 0.4.20)

![](https://cdn-images-1.medium.com/max/1600/1*lvh4MsCrW0FzonkShQs0iA.png)

> “Ideally, libraries are not meant to change state of contract, it should only be used to perform simple operations based on input and returns result”

However, libraries have the benefits to save substantial amount of gas (and therefore, not contaminating the blockchain with repetitive code), since the same code doesn’t have to be deployed over and over. Different contract on Ethereum can just rely on the same already deployed library.

The fact that multiple contracts depend on the exact piece of code, can make for a more secure environment. Imagine not only having well audited code for common endeavours (like the tremendous job the guys at [Zeppelin](https://github.com/OpenZeppelin/zeppelin-solidity) are doing), but relying on the same deployed library code that other contracts are already using. It would certainly have helped in this [case](https://github.com/ether-camp/virtual-accelerator/issues/8), where all balances of an ERC20 token (nothing too fancy), that was intended to raise a [maximum of $50M](https://www.reddit.com/r/ethereum/comments/56lrpa/ethercamp_just_set_a_cap_on_their_crowdsale_of/), were **whipped out**.

----------

## 2. How to create a library in Solidity ?

### Define a library and variables allowed

You define a library contract with the keyword `library` instead of the traditional `contract` keyword used for standard smart contracts. Just declare `libary` under the `pragma solidity` statement (compiler version). See our code example below.

```solidity
pragma solidity ^0.5.0;

library libraryName {

	// struct, enum or constant variable declaration
	// function definition with body  
	
}
```

As we have seen, libraries contracts do not have storage. Therefore, they can’t hold state variables (state variables that are non-constant). However, libraries can still implement some data type :

-   `struct` and `enum` : these are user-defined variables.
-   `Any other constant` variable (immutable) : constant variables are stored in the stack in Ethereum, not in its storage.

Let’s start with a simple example : a library for mathematical operation. The SafeMath library described below contains basic arithmetic operation which takes 2 unsigned integer as input and returns the arithmetic operation result.

```solidity
pragma solidity ^0.5.0;

library MathLib {  
      
    struct MathConstant {  
        uint Pi;             // π (Pi) ≈ 3.1415926535...  
        uint Phi;            // Golden ratio ≈ 1.6180339887...  
        uint Tau;            // Tau (2pi) ≈ 6.283185...  
        uint Omega;          // Ω (Omega) ≈ 0.5671432904...  
        uint ImaginaryUnit;  // i (Imaginary Unit) = √–1  
        uint EulerNb;        // Euler number ≈ 2.7182818284590452...  
        uint PythagoraConst; // Pythagora constant (√2) ≈ 1.41421...   
        uint TheodorusConst; // Theodorus constant (√3) ≈ 1.73205...   
    }  
      
}
```

> [SafeMath](https://docs.openzeppelin.org/docs/math_safemath) library available in [open zeppelin smart contracts collection](https://openzeppelin.org/) is a popular solidity library that is used to protect from [overflow](https://ethereumdev.io/safemath-protect-overflows/).

----------

## 3. How to deploy a Library in Solidity ?

Library deployment is a bit different from regular smart contract deployment. Here are two scenarios :

1.  **Embedded Library:** If a smart contract is consuming a library which have only **internal functions,** then the EVM simply embeds library into the contract. Instead of using delegate call to call a function, it simply uses JUMP statement(normal method call). There is no need to separately deploy library in this scenario.
2.  **Linked Library :** On the flip side, if a library contain **public or external functions** then library needs to be deployed. The deployment of library will generate a unique address in the blockchain. This address needs to be linked with calling contract.

----------

## 4. How to use a Library in a smart contract ?

### Step 1 : Importing the library

Under the `pragma` , just specify the following statement :

```solidity
import LibraryName from “./library-file.sol”;
```

Your file could also contain multiple libraries. Using curly braces `{}` in the import statement, you can specify which library you would like to import. Imagine you have a file `my-lib.sol` like this :

```solidity
pragma solidity >0.5.0;

library Library1 {  
 // Code from library 1  
}

library Library2 {  
 // Code from library 2  
}

library Library3 {  
 // Code fom library 3  
}
```

You can specify which library you want to use in your main contract as follow :

```solidity
pragma solidity ^0.5.0;

// We choose to use only Library 1 and 3 here, and exclude Library 2  
import {Library1, Library3} from "./library-file.sol";

contract MyContract {  
      
    // Your contract code here

}
```
### Step 2 : Using the Library

To use a library within a smart contract, we use the syntax `**using** LibraryName **for** Type` . This directive can be use to attach library functions (from the library `LibraryName`) to any type (`Type`).

-   **LibraryName** = the name of the library we want to import.
-   **Type** = the variable type we intend to use the library for. (We can also use the wildcard operator `*` to attach functions from the library to all types).

```solidity
// Use the library for unsigned integers  
**using** MathLib **for** uint;

// Use the library for any data type  
**using** MathLib **for** *;
```
> In both previous situations, _all_ functions from the library are attached to the contract, including those where the type of the first parameter does not match the type of the object. The type is checked at the point the function is called and **function overload resolution is performed.**

By including a library, its data types including library functions are available without having to add further code. When you call a library function, these functions will receive the object they are called on as their first parameter, much like the variable `self` in Python

```solidity
import {MathLib} from  './lib-file.sol';

using MathLib for uint;

uint a = 10;  
uint b= 10;

uint c = a.subUint(b);
```

We could still do `uint c = a - b;` It will return the same result which is `0`. However our library has some added properties to protect from overflow for example; `assert(a >= b);` which checks to make sure the first operand `a`is greater than or equal to the second operand `b` so that the subtraction operation doesn’t result to a negative value.

> **I don’t understand :** The `_using A for B;_` directive is active only within the current contract, including within all of its functions, and has no effect outside of the contract in which it is used. The directive may only be used inside a contract, not inside any of its functions.

  

— — — — — — — — — — — — — — — — — — — — — — — — — — — — — — —

Another good syntax that makes our code easily understandable is to use the keyword `using` with a library function as a method of its first parameter. With our **MathConstant** example, it would be :

```solidity
using MathLib for MathLib.MathConstant
```

The `using` keyword allows for calling functions in MathLib **for all functions that take a MathConstant as a first argument, as if they were a method of the struct.**

> This construct is pretty similar of how you can execute methods on Go structs, without them being fully-fledged objects.

----------

## 5. How to interact with a library in Solidity ?

### Introduction : a bit of theory

> If library functions are called, their code is executed in the context of the calling contract

Let’s dive a bit deeper into the Solidity documentation. The doc states the following : _“Libraries can be seen as implicit base contracts of the contracts that use them” :_

-   They will not be explicitly visible in the inheritance hierarchy…
-   …but calls to library functions look just like calls to functions of explicit base contracts (`L.f()` if `L` is the name of the library).

Calling a function from a library will use a special instruction in the EVM: the `[DELEGATECALL](https://ethervm.io/#F4)` [opcode](https://ethervm.io/#F4) (`CALLCODE` until Homestead, version 0.4.20). This will cause the calling context to be passed to the library, **like if it was some code running in the contract itself**. Let’s look at a code example :

```solidity
pragma solidity ^0.5.0;

library MathLib {  
      
    function mult(uint a, uint b) public view returns (uint, address) {  
        return (a * b, address(this));  
    }  
}

contract Example {  
      
    using MathLib for uint;

address owner = address(this);  
      
    function multEx(uint _a, uint _b) public view returns (uint, address) {  
        return _a.mult(_b);  
    }

}
```

![](https://cdn-images-1.medium.com/max/1600/1*d6kEYDCSHPpsu8MFodjYEA.png)

If we call `add()` function of the `Math` library from our contract, **the address of** `**MyContract**` **will be returned** and not the library address. The `add()` function is compiled as an external call ( `DELEGATECALL` ) but if we check the address from the `address(this)` (the contract address), we will see our contract address (not the library contract’s address). The same applies for all other `msg` properties ( `msg.value`, `msg.data` and `msg.gas`).

> **Warning :** prior to Homestead , `_msg.sender_` and `_msg.value_` changed ! (because of the use of `_CALLCODE_`)

> **Exception :** Library functions can only be called directly (without the use of `_DELEGATECALL_`) if they do not modify the state (`_view_` or `_pure_` functions)

![](https://cdn-images-1.medium.com/max/1600/1*GLNCjkSdUGkjXFmO90ZQLA.png)

Furthermore, `internal`functions of libraries are visible in all contracts, just as if the library were a base contract. **What ???** Yes that sounds strange. Let’s unpack the process of calling an internal library function, to understand what happen exactly is the following :

-   Contract A calls internal function B from library L.
-   At compile time, the EVM **pulls** internal function B into contract A. It would be like if function B was hardcoded in contract A.
-   A regular `JUMP` call will be used instead of a `DELEGATECALL`.

Calls to internal functions use the same internal calling convention :

-   all internal types can be passed.
-   types [stored in memory](https://solidity.readthedocs.io/en/v0.5.9/types.html#data-location) will be passed by reference and not copied.

— — — — — — — — — — — — — — — — — — — — — — — — — — — — — — 

Despite the fact libraries do not have storage, they can modify their linked contract’s storage, by passing a `storage` argument to their function parameters. Hence any modification made by the library does via its function will be saved in the contract’s own storage.

Therefore, the keyword `this` will point to the calling contract, and **refers to the storage of the calling contract** to be precise.

Since a library is an isolated piece of code, it can only access state variables of from the storage of the calling contract if they are explicitly supplied. In fact, it would have no way to name them, otherwise. Let’s have a look at a simple example.

```
// Some code here
```

### We want to use our library functions !

Ok enough theory, let’s look at some practical examples ! :)

To use a library function, we select the variable we want to apply the library function to and add a `.` followed by the library function name we want to use. `Type variable = variable.libraryFunction(Type argument)`.

Here is an example below.

```solidity
pragma solidity ^0.5.0;

contract MyContract {  
      
    using MathLib for uint;  
      
    uint256 a = 10;  
    uint256 b= 10;

uint256 c = a.add(b);  
      
}

library MathLib {  
      
    function add(uint256 a, uint256 b) external pure returns (uint256) {  
        uint256 c = a + b;  
        assert(c >= a);  
        return c;  
    }  
      
}
```
----------

## 6. Understanding functions in libraries

A library can have functions which are not implemented (like in interfaces). As a result, these type of functions have to be declared as public or external. They can’t be internal or external.

![](https://cdn-images-1.medium.com/max/1600/1*bTFYv6DlXoNDs06Gt6AIeQ.png)

A picture is worth a thousand words !

Here is our internal function implemented in our `testConnection()` function :

```solidity
function testConnection(address _from, address _to) internal returns(bool) {  
     if (true) {  
         emit testConnection(_from, _to, connection_success_message);  
         return true;  
     }  
 }
```

An example of not implemented functions in our situation would be callback functions on connect and disconnect. You would implement your own custom code in the function body. _(I am not sure about that, since it’s the role of interfaces)_

```solidity
function onConnect() public;  
function onDisconnect() public;
```
----------

## 7. Events and Libraries

In the same way that libraries don’t have storage, they don’t have an event log. However, libraries can dispatch events.

Any event created by the library will be saved in the event log of the contract that calls the event emitting function in the library.

> Only problem is, as of right now, the contract ABI does not reflect the events that the libraries it uses may emit. This confuses clients such as web3, that won’t be able to decode what event was called or figure out how to decode its arguments.

We could do a quick hack by defining the event both in the contract and the library ([As shown by this article from Gnosis about the DelegateProxy contract)](https://blog.gnosis.pm/solidity-delegateproxy-contracts-e09957d0f201). This will trick clients into thinking that it was actually the main contract who sent the event and not the library.

This is our library :

```solidity
library KombuchaLib {  
    event FilledKombucha(uint amountAdded, uint newFillAmount);  
    event DrankKombucha(uint amountDrank, uint newFillAmount);

// ... other library structs, enums and functions  
}
```

This is our contract :

```solidity
contract Kombucha {  
    using KombuchaLib for KombuchaLib.KombuchaStorage;

// we have to repeat the event declarations in the contract  
    // in order for some client-side frameworks to detect them  
    // (otherwise they won't show up in the contract ABI)  
    event FilledKombucha(uint amountAdded, uint newFillAmount);  
    event DrankKombucha(uint amountDrank, uint newFillAmount);

KombuchaLib.KombuchaStorage private self;  
      
    // ... etc ...  
}
```

_// Need some code here_

----------

## 8. Mappings in Library = more functionalities !

Using the `mapping` type inside libraries differ compared to its usage in traditional Solidity smart contracts. Here we will discuss about using it as a parameter type inside a function

**Extended functionality :**

-   You can use a **mapping** as a parameter for any function visibility : **public, private, external and internal.**

In comparison, mappings can only be passed as a parameter for internal or private functions inside contracts.

> **Warning :** The data location **can only be storage** if a mapping is passed as function parameters

Since we are using a mapping inside a library, we can’t instantiate it inside the library (remember, libraries can’t hold state variables). Let’s look at a _“possible”_ an example of what it could look like:

```solidity
pragma solidity ^0.5.0;

library Messenger {

event LogFunctionWithMappingAsInput(address from, address to,       string message);

function sendMessage(address to, mapping (string => string) storage aMapping) public {  
        emit LogFunctionWithMappingAsInput(msg.sender, to, aMapping[“test1”]);  
    }  
}
```
----------

## 9. Use Structs in Libraries

```solidity
library Library3 {  
   
    struct hold{  
        uint a;  
    }  
   
    function subUint(hold storage s, uint b) public view returns(uint){  
   
        // Make sure it doesn’t return a negative value.          
        require(s.a >= b);   
        return s.a — b;  
   
     }  
}
```

> **_Notice_** _how the function_ `_subUint_` _receives a struct as argument. In Solidity v0.4.24, this is not possible in contracts, but possible in Solidity libraries_

----------

## 9. Linking libraries with other libraries

Libraries can be linked with other libraries and use them in the same way a contract would. This come however with the natural limitations of libraries.

_// Deep dive here_

It is then possible to include libraries inside other libraries, as explained here :

[https://ethereum.stackexchange.com/questions/45032/is-it-possible-to-use-a-solidity-library-inside-another](https://ethereum.stackexchange.com/questions/45032/is-it-possible-to-use-a-solidity-library-inside-another)

----------

## 10. Use modifiers in libraries

It is possible to use modifiers in libraries. However, we can’t export them in our contract, because modifiers are compile-time features (a sort of macros).

See this : [https://ethereum.stackexchange.com/questions/68529/solidity-modifiers-in-library](https://ethereum.stackexchange.com/questions/68529/solidity-modifiers-in-library)

Therefore, modifiers only apply to the functions of the library itself, and cannot be used by an external contract of the library.

----------

## 11. What you can’t do with library in Solidity ?

-   Libraries can’t hold mutable variables. If you try to add a variable that can be modified, you will get the following error in Remix : `TypeError: library can't have non-constant state variable`
-   Libraries do not have event logs
-   It is not possible to destroy a library.
-   Library can’t inherit.

----------

## 12. Some already available libraries

Here is a curated list of some already libraries written in Solidity and their authors :

-   [**Modular network**](https://github.com/modular-network/ethereum-libraries) **:** include several modular library utilities to use, such as [**ArrayUtils**](https://github.com/modular-network/ethereum-libraries/blob/master/ArrayUtilsLib/Array256Lib.sol)**,** [**BasicMath**](https://github.com/modular-network/ethereum-libraries/blob/master/BasicMathLib/BasicMathLib.sol)**,** [**CrowdSale**](https://github.com/modular-network/ethereum-libraries/blob/master/CrowdsaleLib/CrowdsaleLib.sol)**,** [**LinkedList**](https://github.com/modular-network/ethereum-libraries/blob/master/LinkedListLib/LinkedListLib.sol)**,** [**StringUtils**](https://github.com/modular-network/ethereum-libraries/blob/master/StringUtilsLib/StringUtilsLib.sol)**,** [**Token**](https://github.com/modular-network/ethereum-libraries/blob/master/TokenLib/TokenLib.sol)**,** [**Vesting**](https://github.com/modular-network/ethereum-libraries/blob/master/VestingLib/VestingLib.sol)  and [**Wallet**](https://github.com/modular-network/ethereum-libraries/tree/master/WalletLib)
-   **OpenZeppelin :** other libraries such as [**Roles**](https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/access/Roles.sol)**,** [**ECDSA**](https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/cryptography/ECDSA.sol)**,** [**MerkleProof**](https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/cryptography/MerkleProof.sol)**,** [**SafeERC20**](https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/token/ERC20/SafeERC20.sol)**,** [**ERC165Checker**](https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/introspection/ERC165Checker.sol)**,** [**Math**](https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/math/Math.sol)**,** [**SafeMath**](https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/math/SafeMath.sol)  (to protect from overflow)**,** [**Address**](https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/utils/Address.sol)**,** [**Arrays**](https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/utils/Arrays.sol)**,**
-   **Dapp-bin** by Ethereum : include interesting libraries like [**IterableMapping**](https://github.com/ethereum/dapp-bin/blob/master/library/iterable_mapping.sol)**,** [**DoublyLinkedList**](https://github.com/ethereum/dapp-bin/blob/master/library/linkedList.sol)**,** and another  [**StringUtils**](https://github.com/ethereum/dapp-bin/blob/master/library/stringUtils.sol)

----------

## What I do not understand about libraries in Solidity

For library `view` functions `DELEGATECALL` is used, because there is no combined `DELEGATECALL` and `STATICCALL`. This means library `view` functions do not have run-time checks that prevent state modifications. This should not impact security negatively because library code is usually known at compile-time and the static checker performs compile-time checks. ([Solidity docs](https://solidity.readthedocs.io/en/v0.5.9/contracts.html))

> “One condition which should be taken care is, library functions will receive the object they are called on as their first parameter (like the `_self_` variable in Python).”

Note that all library calls are actual EVM function calls. This means that if you pass memory or value types, a copy will be performed, even of the `self` variable. The only situation where no copy will be performed is when storage reference variables are used.

# References

- [**All you should know about libraries in solidity**  
_It’s very important to know about the libraries in solidity while writing Dapps. In simple words, a library is the…_medium.com](https://medium.com/coinmonks/all-you-should-know-about-libraries-in-solidity-dd8bc953eae7 "https://medium.com/coinmonks/all-you-should-know-about-libraries-in-solidity-dd8bc953eae7")[](https://medium.com/coinmonks/all-you-should-know-about-libraries-in-solidity-dd8bc953eae7)

- [**Library Driven Development in Solidity**  
_A comprehensive review on how to develop more modular, reusable and elegant smart contract systems on top of the…_blog.aragon.org](https://blog.aragon.org/library-driven-development-in-solidity-2bebcaf88736/ "https://blog.aragon.org/library-driven-development-in-solidity-2bebcaf88736/")[](https://blog.aragon.org/library-driven-development-in-solidity-2bebcaf88736/)

- [**Solidity libraries**  
_Reference: http://solidity.readthedocs.io/en/v0.4.21/contracts.html_medium.com](https://medium.com/@yangnana11/solidity-libraries-1f04a177803f "https://medium.com/@yangnana11/solidity-libraries-1f04a177803f")[](https://medium.com/@yangnana11/solidity-libraries-1f04a177803f)

- [**Contracts — Solidity 0.5.6 documentation**  
_Contracts in Solidity are similar to classes in object-oriented languages. They contain persistent data in state…_solidity.readthedocs.io](https://solidity.readthedocs.io/en/v0.5.9/contracts.html#libraries "https://solidity.readthedocs.io/en/v0.5.9/contracts.html#libraries")[](https://solidity.readthedocs.io/en/v0.5.9/contracts.html#libraries)

- [Solidity gotchas Part 3 - Compile size limitations and librairies](https://medium.com/@simon.palmer_42769/solidity-gotchas-part-3-compile-size-limitations-and-libraries-ab01035a1eef)