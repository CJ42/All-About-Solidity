# Solidity Tutorial : all about Addresses (edit)

Table of Content
Introduction
1. What is an Ethereum Address ? (Technically)
2. Address payable
3. Available methods with addresses (Solidity)
4. Check if an address exists
5. Zero addresses
6. Addresses related to Web3.js
7. Advanced Topics
   References

---

## Introduction

Addresses in Ethereum are unique identifiers, since they are derived from either a public key or contracts.

In the payment portion of an Ethereum transaction, the intended recipient is represented by an Ethereum address. This is the same as the beneficiary account in a bank transfer (Wood and Antonopoulos, 2018).

There are two types of addresses in Ethereum :

- Externally Owned Accounts (EOA) : these accounts are controlled by their private key.

The private key enable private control over access to any ether in the account and over any authentication the account needs when using smart contracts. They are the unique piece of information needed to create digital signatures, required to sign transactions to spend any funds in the account.

- Contracts Accounts (Smart Contracts) : these accounts are controlled by their code.

Unlike EOAs, there are no keys associated with an account created for a new Smart Contracts. Therefore, smart contracts are not backed by a private key (which in fact, does not exist for smart contracts ! ). we can say that _"smart contracts own themselves"_.

Each contract's address is derived from the contract creation transaction, as a function of the originating account and nonce. The Ethereum address of a contract can be used in a transaction as the recipient, sending funds to the contract or calling one of the contract's functions.

---

## What is an Ethereum Address (Technically)

Hash functions are the key to transform Ethereum public keys (or contracts) into addresses. Ethereum uses the keccak-256 hash function to generate addresses in the following way.

_yellow paper image_
**Source:** Ethereum Yellow Paper (Byzantium Version, 2019–06–13, p24, point 284).

In Ethereum and Solidity, an `address` is of 20 byte value size (160 bits or 40 hex characters). It corresponds to the last 20 bytes of the Keccak-256 hash of the public key.

An address is always pre-fixed with 0x as it is represented in hexadecimal format (base 16 notation) (defined explicitly). (NB: it's total length therefore is actually 42 characters long, not 40 ;) ).

This article from Vincent Kobel gives you a good indication step-by-step of how address are created.

1. Start with the public key (128 characters / 64 bytes)

```
pubKey = 6e145ccef1033dea239875dd00dfb4fee6e3348b84985c92f103444683bae07b83b5c38e5e...
```

2. Apply the Keccak-256 hash to the public key. You should obtain a string that is 64 characters / 32 bytes long.

```
Keccak256(pubKey) = 2a5bc342ed616b5ba5732269001d3f1ef827552ae1114027bd3ecf1f086ba0f9
```

3. Take the last 40 characters / 20 bytes (least significant bytes) of the resulting hash. Or, in other words, drop the first 24 characters / 12 bytes. These 40 characters / 20 bytes are the address (they are in bold below).

`2a5bc342ed616b5ba5732269`**`001d3f1ef827552ae1114027bd3ecf1f086ba0f9`**

```
Address = 0x001d3f1ef827552ae1114027bd3ecf1f086ba0f9
```

When prefixed with 0x, the address actually becomes 42 characters long. Ethereum address are represented in raw hexadecimals numbers. Moreover it is important to note that they are case-insensitive. All wallets are supposed to accept Ethereum addresses expressed in capital or lowercase characters, without any difference in interpretation. (Since EIP-55, UpperCase addresses are used to validate a checksum)

```
0x001d3f1ef827552ae1114027bd3ecf1f086ba0f9 or
0X001D3F1EF827552AE1114027BD3ECF1F086BA0F9
```

_How is the address of an Ethereum contract computed ?_

---

## How to define an address variable ?

In Solidity, you define a variable as an address type by simply specifying the keyword `address` in front of the variable name.

```solidity
address user = msg.sender
```

Here we use the Solidity built-in function msg.sender to retrieve the address of the account that interacted with the smart contract.

## Address literals

Address literals are the hexadecimal representation of an Ethereum address (prefixed with 0x) that pass the checksum test. (Apparently their size range from 39 to 41 digits). You can declare address literals in Solidity as follow :

```solidity
address owner = 0xc0ffee254729296a45a3885639ac7e10F9d54979
```

In the example above, you should obtain the following warning message :

```
This looks like an address but has an invalid checksum. Correct checksummed address: "0xc0ffee254729296a45a3885639AC7E10F9d54979". If this is not used as an address, please prepend '00'. For more information please see https://solidity.readthedocs.io/en/develop/types.html#address-literals
```

To silence the error, copy and paste the address provided with the valid checksum :

```solidity
address owner = 0xc0ffee254729296a45a3885639AC7E10F9d54979
```

Address literals that do not pass the checksum test bring up an error message. (Additionally, they are treated as a regular rational number intervals).

> The mixed-case address checksum format is defined in EIP-55.

**Address literals** (hexadecimal representation of an address) are by default set as `address payable`.

## address vs address payable ?

The distinction between `address` and `address payable` was introduced with version 0.5.0 of Solidity.

The idea behind this distinction is that `address payable` is an address you can send Ether to, while a simple (plain) `address` cannot be sent Ether.

When assigning the keyword payable to an address variable in Solidity, the address (variable) can send and receive Ethers. As a result, all the other methods (transfer, send, call, delegatecall and staticcall) become available for this variable.

## Type conversion between address and address payable

- Implicit conversions from address payable to address are allowed

_Give an example of user list._

- Implicit conversions from address to address payable are not possible (except for address payable).

> _NB: the only way to convert from address to address payable is by using an intermediate conversion to uint160 (160 bits = 20 bytes, the size of an Ethereum address)._

- Explicit conversion from and to address are allowed for : integers, integer literals, bytes20 and contract type.

- Explicit conversion in the form address payable(x) (where x = integers, integer literal, bytes or contract type).

- The result of a conversion in the form address(x) has the type address payable, if x is of integer or fixed bytes type, a literal or a contract with a payable fallback function.

---

## Contracts as address

Before version 0.5.0, contracts directly derived from the address type (since there was no distinction between address and address payable ).

Starting from version 0.5.0 of Solidity, **contracts do not derive from the address type anymore.** However, they can still be explicitly converted to and from address and address payable, if they have a payable fallback function.

Let's assume the following code :

```solidity
contract NotPayable {

    // No payable function here

}

contract Payable {

    // Payable function
    function() payable {

        // do something with payable function

    }

}


contract HelloWorld {

    address x = address(NotPayable);
    address y = address(Payable);

    function hello_world() public pure returns (string memory) {
        return "hello world";
    }

}
```

Let's look at our Hello World contract to understand :

- NotPayable is a contract without a payable fallback function. The the variable x which is assigned the value address(NotPayable) will be of type address.

- Payable is a contract with a payable fallback function. The the variable y which is assigned the value address(Payable) will be of type address payable.

> **NB :** The conversion is still performed using address(variable) and not using address payable(variable).

- An external function signatures address is used for both the address and the address payable type.

---

## Address conversion using operators

The following operators are available with addresses : <=, <, ==, !=, >= and > .

## Check if an address exists

You can if an address exists for instance using the following statement :

```solidity
modifier addressExist(address _address) {
    require(_address != address(0));
    _;
}
```

This method simply use type casting. The number `0` is casted into an address type, so it generates a 20 bytes value as follow : `0x0000000000000000000000000000000000000000`

---

## Transactions Methods available with Addresses

As you can imagine, address enable to send funds (Ethers) to other addresses. This sections cover the different methods available.

> **NB:** the \_amount specified as functions parameters always represents an Ether amount expressed in Wei (18 zeros):

> 1 Ether = 1¹⁸ Wei = 1,000,000,000,000,000,000 wei

_picture here_
(legend: Members functions available for addresses in Solidity)- - - -

---

`address.transfer()`

- Transfer the amount of ether (in wei) to the specified account.
- Reverts on failure and throw an exception on any error.
- Forwards 2,300 gas stipend, not adjustable.

- - - - 
`address.send()`

_picture here_

- Similar to address.transfer()
- Returns false on failure (Warning : always check the return value of send !)
- Forwards 2,300 gas stipend, not adjustable.

- - - - 
`address.balance`

- Returns the account balance in Wei .

There is two methods to look at an Ethereum address / Contract address balance. (NB: the address below is a vanity address).

```solidity
address public _account = msg.sender;

// look-up balance from sender (Method 1)
uint public sender_balance = _account.balance;

// look-up balance from _account (Method 2)
uint public sender_balance = address(_account).balance;

// look-up balance from the current contract (Method 2)
uint public contract_balance = address(this).balance;
```

- - - -

`address.call(bytes memory) returns (bool, bytes memory)`

> **WARNING : UNSAFE !**
> The recipient can (accidentally or maliciously) use up all your gas, causing your contract to halt with an OOG exception; always check the return value of call.

_picture here_

- Creates an arbitrary message call (low-level CALL , see Opcode OxF1) given the memory (data payload) passed as an argument.
- Returns a tuple with :

1. a boolean for the call result (true on success, false on failure or error).
2. The data in bytes format.

- Forward all available gas, adjustable.

- - - - 
`_address.delegatecall(bytes memory) returns (bool, bytes memory)`

> **WARNING : Advanced Use Only !**

- Low-level DELEGATECALL , see Opcode OxF4) (with the full msg context seen by the current contract) given the memory (data payload) passed as an argument.
- Returns a tuple with :

1. a boolean for the delegatecall result (true on success, false on failure or error).
2. The data in bytes format.

- Forward all available gas, adjustable

- - - - 
`address.staticcall(bytes memory) returns (bool, bytes memory)`

- Low-level STATICCALL , see Opcode OxF4) (with the full msg context seen by the current contract) given the memory (data payload) passed as an argument.
- Returns a tuple with :

1. a boolean for the staticcall result (true on success, false on failure or error).
2. The data in bytes format.

- Forward all available gas, adjustable

- - - - 
`address.callcode(__payload__) (deprecated)`

- Low-level CALLCODE function, like address(this).call(…) but with this contract's code replaced with that of address. Returns false on error. WARNING: advanced use only!

_photo here_

---

## Related Methods that return an address

`msg.sender()`
Function : msg.sender() -> Returns : address payable

Pretty easy, the `msg.sender` function returns the address that initiated this contract call. However, it is important to mention the following :

> `msg.sender` returns the current call. It does not necessarily return the originating EOA that sent the transaction.

- If our contract A was called directly by an EOA transaction, then msg.sender would return the EOA's address.
- If our contract A was called by another contract B, where B was called by an EOA transaction, then msg.sender would return contract B's address.

`tx.origin` **(WARNING -> UNSAFE !!!!)**
Function : tx.origin() -> Returns : address payable
tx.origin returns the address of the originating EOA for this transaction.
tx.origin returns the full call chain !

`block.coinbase()`
Function : block.coinbase() -> Returns : address payable

`block.coinbase(_address payable)`

The current block miner's address. (Recipient of the current block's fees and block reward).

`ecrecover()`

_photo here_

---

## Zero Addresses

> Registering a contract on Ethereum involves creating a special transaction whose destination is the address 0x0000000000000000000000000000000000000000, also known as the zero address. (Antonopoulos and Wood, 2018, p29).

_photo yellow paper here_

The section related to zero-addresses from the yellow paper.

Once a smart contract is compiled, it is deployed on the Ethereum platform using a special contract creation transaction. However, a transaction might reach a specific address. So which address should be specificied for a contract creation ?

The EVM understand that a transaction intends to create a new contract when it specifies a specific address in the recipient field of the transaction. This address is known as a zero-address.

A zero address in Ethereum is also 20 bytes long but contains only empty bytes. That explain why it is named zero-address, because it contains only 0x0 values.

---

## Addresses related to web3.js

Web3.js and console functions accept addresses with or without this prefix but for transparency we encourage their use. Since each byte of the address is represented by 2 hex characters, a prefixed address is 42 characters long.

---

## Advanced Topics

Several apps and APIs are also meant to implement the new checksum-enabled address scheme introduced in the Mist Ethereum wallet as of version 0.5.0. - Homestead Docs

Ethereum Improvement Proposal 55 (EIP-55) : standard to propose backward compatible checksum for Ethereum addresses, by modifying the capitalization of the hexadecimal address.

---

## References

- How is the address of an Ethereum contract computed?
  Ethereum Stack Exchange is a question and answer site for users of Ethereum, the decentralized application platform and…ethereum.stackexchange.com

- How are ethereum addresses generated?
  Recently this article came to my attention that is way more in depth and technical than my more accessible version…ethereum.stackexchange.com
  Create full Ethereum wallet, keypair and address

This article is a guide on how to generate an ECDSA private key and derive its Ethereum address. Using OpenSSL and…kobl.one

- What is an 'EOA' account?
  Thanks for contributing an answer to Ethereum Stack Exchange! Please be sure to answer the question. Provide details…ethereum.stackexchange.com

- Difference between CALL, CALLCODE and DELEGATECALL
  DELEGATECALL basically says that I'm a contract and I'm allowing (delegating) you to do whatever you want to my…ethereum.stackexchange.com

```solidity
<address>.balance(uint256)
```

```solidity
<address payable>.transfer(uint256 _amount)
```

```solidity
<address payable>.send(uint256 _amount) returns (bool)
```

```solidity
<address payable>.call(bytes memory) returns (bool, bytes memory)
```

```solidity
<address payable>.delegatecall(bytes memory) returns (bool, bytes memory)
```

```solidity
<address payable>.staticcall(bytes memory) returns (bool, bytes memory)
```
