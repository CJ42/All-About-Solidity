# All About Calldata

## Constructing calldata to be sent via `.call()`

When making external low level call via `address(target_contract).call(calldataPayload)`, there are multiple ways to the build the calldata that will be passed in the tx/msg call.

Below is a summary of all the possible ways to build a calldata payload in Solidity, so it can be sent via a low-level `.call(...)`.

To illustrate with an example, we will imagine the scenario of a `CallerContract` interacting with a `DeployedContract` defined in the snippet below. The `CallerContract` aims to call the `add(uint256)` function in the `DeployedContract`.

```solidity
contract DeployedContract {
    uint public result = 0;

    function add(uint256 input) public {
        result = result + input;
    }
}

contract CallerContract {    
    DeployedContract deployed_contract;

    constructor(DeployedContract deployedContract_) {
        deployed_contract = deployedContract_;
    }

    // see examples below of different types
    // of low level call

}
```

### Calldata as literal string

```solidity
function callWithLiteralString() public {
    bytes memory calldataPayload = "0x1003e2d20000000000000000000000000000000000000000000000000000000000000005";
    (bool success, ) = address(deployed_contract).call(calldataPayload);
}
```

### Calldata as literal hex string

Subtle difference with previous example.

```solidity
function callWithLiteralHexString() public {
    bytes memory calldataPayload = hex"1003e2d20000000000000000000000000000000000000000000000000000000000000005";
    (bool success, ) = address(deployed_contract).call(calldataPayload);
}
```

### Calldata by creating the bytes4 selector manually (= first 4 bytes of the keccak256 hash of function signature)

```solidity
function callWithFunctionSignatureFromHash(uint256 input) public {
    bytes memory calldataPayload = bytes.concat(
        bytes4(keccak256("add(uint256)")),
        abi.encodePacked(input)
    );

    (bool success, ) = address(deployed_contract).call(calldataPayload);
}
```

### Calldata using `abi.encodeWithSignature`

```solidity
function callWithEncodeWithSignature(uint256 input) public {
    bytes memory calldataPayload = abi.encodeWithSignature("add(uint256)", input);
    (bool success, ) = address(deployed_contract).call(calldataPayload);
}
```

### Calldata using `abi.encodeWithSelector`, using a `bytes4` value

```solidity
function callWithEncodeWithSelectorAsLiteral(uint256 input) public {
    bytes memory calldataPayload = abi.encodeWithSelector(0x1003e2d2, input);
    (bool success, ) = address(deployed_contract).call(calldataPayload);
}
```

### Calldata using `abi.encodeWithSelector`, extracting function selector via `functionName.selector`

```solidity
function callWithEncodeWithSelectorAsReference(uint256 input) public {
    bytes memory calldataPayload = abi.encodeWithSelector(deployed_contract.add.selector, input);
    (bool success, ) = address(deployed_contract).call(calldataPayload);
}
```

### Calldata using `abi.encodeCall` using a function pointer (since solc 0.8.11)

```solidity
function callWithABIEncodeCall(uint input) public { 

    function (uint256) external functionToCall = deployed_contract.add;

    bytes memory calldataPayload = abi.encodeCall(functionToCall, input);
    (bool success, ) = address(deployed_contract).call(calldataPayload);
}
```

### Summary of all possible calldata construction

```solidity
// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract DeployedContract {
    uint public result = 0;

    function add(uint256 input) public {
        result = result + input;
    }
}


contract CallerContract {    
    DeployedContract deployed_contract;

    constructor(DeployedContract deployedContract_) {
        deployed_contract = deployedContract_;
    }

    // calldata as a literal string
    function callWithLiteralString() public {
        bytes memory calldataPayload = "0x1003e2d20000000000000000000000000000000000000000000000000000000000000005";
        (bool success, ) = address(deployed_contract).call(calldataPayload);
    }

    // calldata as a literal string (with hex"")
    function callWithLiteralHexString() public {
        bytes memory calldataPayload = hex"1003e2d20000000000000000000000000000000000000000000000000000000000000005";
        (bool success, ) = address(deployed_contract).call(calldataPayload);
    }

    // calldata with bytes.concat() -> keccak256 hash of the function signature + bytes data
    function callWithFunctionSignatureFromHash(uint256 input) public {
        bytes memory calldataPayload = bytes.concat(
            bytes4(keccak256("add(uint256)")),
            abi.encodePacked(input)
        );

        (bool success, ) = address(deployed_contract).call(calldataPayload);
    }

    // calldata with abi.encodeWithSignature
    function callWithEncodeWithSignature(uint256 input) public {
        bytes memory calldataPayload = abi.encodeWithSignature("add(uint256)", input);
        (bool success, ) = address(deployed_contract).call(calldataPayload);
    }

    // calldata with abi.encodeWithSelector -> selector as a literal
    function callWithEncodeWithSelectorAsLiteral(uint256 input) public {
        bytes memory calldataPayload = abi.encodeWithSelector(0x1003e2d2, input);
        (bool success, ) = address(deployed_contract).call(calldataPayload);
    }

    // calldata with abi.encodeWithSelector -> selector as reference via Contract.function.selector
    function callWithEncodeWithSelectorAsReference(uint256 input) public {
        bytes memory calldataPayload = abi.encodeWithSelector(deployed_contract.add.selector, input);
        (bool success, ) = address(deployed_contract).call(calldataPayload);
    }

    // calldata with abi.encodeCall (since solc 0.8.11)
    function callWithABIEncodeCall(uint input) public { 

        function (uint256) external functionToCall = deployed_contract.add;

        bytes memory calldataPayload = abi.encodeCall(functionToCall, input);
        (bool success, ) = address(deployed_contract).call(calldataPayload);
    }

}
```

## Extracting calldata slices.

We have seen that the calldata is a continuous string of `bytes`. One of the main recent feature of Solidity available sine 0.8.6 is **bytes slices**. 

Bytes slices are only available in calldata as per the current Solidity version. They enable to grab sections of the calldata, by returning any number of bytes. The slice returned is of type `bytes`. 

Calldata bytes slices works by specifying:

- the offset to **start** slicing from.
- the offset where the slicing should **end**.

Both **start** and **end** are separated by a colon symbol `:`. You can also emit the **start** or the **end**. Omitting the start will default to starting slicing at offset 0. Omitting the end default to slicing up to the last byte in the calldata.

There are two cases where slicing can be used and useful.

1. slicing directly from the whole calldata - `msg.data`.

```solidity
msg.data[start:end]
```

2. slice a `bytes` with the data location calldata.


```solidity
function example(bytes calldata input) public {
    bytes calldata secondThirdBytes = input[1:3];
}
```

### Examples

Let's illustrate with some examples. 

**Extract the function selector**

The signature of the function can be extracted by slicing the first 4 bytes of the calldata. This is equivqlent to `msg.sig` (except `msg.sig` will cast to the first 4 bytes automatically. Below, we cast via explicit conversion).

```solidity
bytes4 selector = bytesmsg.data[:4];
```

**Extract bytes slices**

Consider as an example the `bytes` data `0xcafecafebeefbeeff00df00d`.

You can extract different part of the calldata using the **start** and **end** as follow:

```solidity
function example(bytes calldata input) public {
    bytes calldata cafe = input[:4];
    bytes calldata beef = input[4:8];
    bytes calldata food = input[8:];
}

```

## Upcoming content

- [] Explain why you can’t use calldata inside internal functions. For instance if you constructed something in memory (e.g: a struct), and try to pass it to an internal function that specify calldata in a parameter. it will not compile. Explain why (good example).
- [] Explain what is happening under the hood for the following examples.
- Function takes calldata parameter. A variable inside is defined as calldata. What are the opcodes and what happen under the hood?
- Function takes calldata parameter. A variable inside defined as memory. What are the opcodes, what is happening under the hood?
- [] Explain why it is cheaper to use calldata instead of memory (in a function arguments, different number of opcodes + differences).
- [] Calldata is not a special place in memory. It’s its own location. Explain this and make it clear.
## References

- [Solidity `msg.sender`](https://medium.com/@devrann.simsek/solidity-msg-sender-9072c1561966)
