# Solidity Tutorial : all about Data Locations

You will find this topic probably as the most challenging. The table below is an overview of each data location available, with mention if read and write to it is allowed. For more details on each data location, read the section for each data location below.

| Data Location | :mag: Read         | :pencil2: Write    |
| ------------- | ------------------ | ------------------ |
| Storage       | :white_check_mark: | :white_check_mark: |
| Memory        | :white_check_mark: | :white_check_mark: |
| Calldata      | :white_check_mark: | :x:                |
| Stack         | :white_check_mark: | :white_check_mark: |
| Code          | :white_check_mark: | :x:                |

---

**When to use the keywords `storage`, `memory` and `calldata`?**

Any variable of complex type like array, struct, mapping or enum must specify a data location.

### Storage

Storage refers to the contract's storage.

You can pass the keyword storage to a value you don't want to be cloned.

Storage is long-term but expensive !

---

### Memory

In Ethereum, the memory holds temporary values (said not persisting), like function parameters.

Relative to the execution of the transaction of the transaction of the constructor.

Variables with the keyword memory assigned to them are therefore not persisting and temporary.

Moreover, memory variables are erased between external function calls.

Memory is short and cheap !

---

### CallData

CallData is almost free but has a limited size !

### Stack

The Stack hold small local variables. However, it can hold only a limited number of values. The Stack in Ethereum has maximum size of 1024 elements.

Finishes once a function finishes its execution.

---

## Data Location Rules for Function parameters

The table below give the possible data locations for function parameters, depending on the function visibility.

| Function visibility | Data location for function parameter can be                                                                           |
| ------------------- | --------------------------------------------------------------------------------------------------------------------- |
| `external`          | `storage` = :x: **not allowed** <br> `memory` = :white_check_mark: (since 0.6.9) <br> `calldata` = :white_check_mark: |
| `public`            | `storage` = :x: **not allowed** <br> `memory` = :white_check_mark: <br> `calldata` = :white_check_mark: (since 0.6.9) |
| `internal`          | `storage` = :white_check_mark: <br> `memory` = :white_check_mark: <br> `calldata` = :white_check_mark: (since 0.6.9)  |
| `private`           | `storage` = :white_check_mark: <br> `memory` = :white_check_mark: <br> `calldata` = :white_check_mark: (since 0.6.9)  |

## Data Location in Function Body

Inside functions, all three data locations can be specified, no matter the function visibility. However, some specific rules exist for assignment between references, or to the data at the data location directly. The tables below summarize them.

**For `storage`**:

| `storage` references can be assigned a: |     |
| --------------------------------------- | :-: |
| state variable directly                 | ✅  |
| state variable via `storage` reference  | ✅  |
| `memory` reference                      | ❌  |
| calldata value directly                 | ❌  |
| calldata value via `calldata` reference | ❌  |

**For `memory`**:

| `memory` references can be assigned a:  |     |
| --------------------------------------- | :-: |
| state variable directly                 | ✅  |
| state variable via `storage` reference  | ✅  |
| `memory` reference                      | ✅  |
| calldata value directly                 | ✅  |
| calldata value via `calldata` reference | ✅  |

**For `calldata`**:

| `calldata` references can be assigned a: |     |
| ---------------------------------------- | :-: |
| state variable directly                  | ❌  |
| state variable via `storage` reference   | ❌  |
| `memory` reference                       | ❌  |
| calldata value directly                  | ✅  |
| calldata value via `calldata` reference  | ✅  |

# Data Locations - Behaviours

There are two main things to consider when specifying the data location inside the function body: the **effect**, and the **gas usage**.

Let's use a simple contract as an example to better understand. The contract holds a mapping of struct items in storage. To compare the behaviour of each data location, we will use different functions that use different data location keywords.

- a getter using `storage`.
- a getter using `memory`.
- a setter using `storage`.
- a setter using `memory`.

```solidity
// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.0;

contract Garage {
    struct Item {
        uint256 units;
    }
    mapping(uint256 => Item) items;

    // gas (view) 24025
    function getItemUnitsStorage(uint _itemIndex) public view returns(uint) {
        Item storage item = items[_itemIndex];
        return item.units;
    }

    // gas (view) 24055
    function getItemUnitsMemory(uint _itemIndex) public view returns (uint) {
        Item memory item = items[_itemIndex];
        return item.units;
    }
}
```


## Getter with storage vs memory

Let's debug the opcodes.

```asm
; getItemUnitsStorage = 30 instructions
PUSH1 00   ; 1) manipulate + prepare the stack
DUP1
PUSH1 00
DUP1
DUP5
DUP2
MSTORE     ; 2.1) prepare the memory for hashing (1)
PUSH1 20
ADD
SWAP1
DUP2
MSTORE     ; 2.2) prepare the memory for hashing (2)
PUSH1 20
ADD
PUSH1 00
SHA3       ; 3) compute the storage number to load via hashing
SWAP1
POP
DUP1
PUSH1 00
ADD
SLOAD      ; 4) load mapping value from storage
SWAP2
POP
POP
SWAP2
SWAP1
POP
JUMP
JUMPDEST

; getItemUnitsMemory = 47 instructions
PUSH1 00
DUP1
PUSH1 00
DUP1
DUP5
DUP2
MSTORE
PUSH1 20
ADD
SWAP1
DUP2
MSTORE
PUSH1 20
ADD
PUSH1 00
SHA3
PUSH1 40  ; <------ additional opcodes start here
MLOAD     ; 1) load the free memory pointer
DUP1      ; 2) reserve the free memory pointer by duplicating it
PUSH1 20
ADD       ; 3) compute the new free memory pointer
PUSH1 40
MSTORE    ; 4) store the new free memory pointer
SWAP1
DUP2
PUSH1 00
DUP3
ADD
SLOAD     ; 5) load mapping value from storage
DUP2
MSTORE    ; 6) store mapping value retrieved from storage in memory
POP
POP ; <------------ additonal opcodes end here
SWAP1
POP
DUP1
PUSH1 00
ADD
MLOAD
SWAP2
POP
POP
SWAP2
SWAP1
POP
```

# References

- [About the EVM (https://www.evm.codes)](https://www.evm.codes/about?fork=grayGlacier)

- [Hackernoon - Getting Deep into Ethereum: how data is stored ?](https://hackernoon.com/getting-deep-into-ethereum-how-data-is-stored-in-ethereum-e3f669d96033)

- [Solidity gotchas Part 2 - Storage, Memory and Calldata](https://medium.com/@simon.palmer_42769/solidity-gotchas-part-2-storage-memory-and-calldata-ca697e49d2a7)

- [Under the hood with Solidity reference types](https://medium.com/coinmonks/under-the-hood-with-solidity-reference-types-16b3e4e3559f)

- [Do you know the reference type in Solidity?](https://medium.com/coinmonks/do-you-know-the-reference-types-in-solidity-7a4821ed7937)

