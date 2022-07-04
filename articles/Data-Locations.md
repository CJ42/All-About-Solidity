# Solidity Tutorial : all about Storage, Memory and CallData

You will find this topic probably as the most challenging. The table below is an overview of each data location available, with mention if read and write to it is allowed. For more details on each data location, read the section for each data location below.

| Data Location  | :mag: Read  | :pencil2: Write  |
|---|---|---|
| Storage  | :white_check_mark:  | :white_check_mark:  |
| Memory  | :white_check_mark:   | :white_check_mark:  |
| Calldata  | :white_check_mark:  | :x:  |
| Stack  | :white_check_mark:  | :white_check_mark:  |
| Code  | :white_check_mark:  | :x:  |

---

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

| Function visibility  | Data location for function parameter can be  |
|---|---|
| `external`  | `storage` = :x: **not allowed** <br> `memory` = :white_check_mark: (since 0.6.9) <br> `calldata` = :white_check_mark:  |
| `public`  | `storage` = :x: **not allowed** <br> `memory` = :white_check_mark: <br> `calldata` = :white_check_mark: (since 0.6.9)  |
| `internal`  | `storage` = :white_check_mark: <br> `memory` = :white_check_mark: <br> `calldata` = :white_check_mark: (since 0.6.9)  |
| `private` | `storage` = :white_check_mark: <br> `memory` = :white_check_mark: <br> `calldata` = :white_check_mark: (since 0.6.9)  |


## Data Location in Function Body

Inside functions, all three data locations can be specified, no matter the function visibility. However, some specific rules exist for assignment between references, or to the data at the data location directly. The tables below summarize them.

**For `storage`**:

| `storage` references can be assigned a: | |
|---|:---:|
| state variable directly  | ✅  |
| state variable via `storage` reference | ✅  |
| `memory` reference  | ❌  |
| calldata value directly  | ❌  |
| calldata value via `calldata` reference   | ❌  |

**For `memory`**:

| `memory` references can be assigned a: | |
|---|:---:|
| state variable directly  | ✅  |
| state variable via `storage` reference | ✅  |
| `memory` reference  | ✅  |
| calldata value directly  | ✅  |
| calldata value via `calldata` reference   | ✅  |

**For `calldata`**:

| `calldata` references can be assigned a: | |
|---|:---:|
| state variable directly  | ❌  |
| state variable via `storage` reference | ❌  |
| `memory` reference  | ❌  |
| calldata value directly  | ✅  |
| calldata value via `calldata` reference   | ✅  |

## When to use the keywords Storage, Memory and CallData ?

Any variable of complex type like array, struct, mapping or enum must specify a data location.


# References

- [Hackernoon - Getting Deep into Ethereum: how data is stored ?](https://hackernoon.com/getting-deep-into-ethereum-how-data-is-stored-in-ethereum-e3f669d96033)
