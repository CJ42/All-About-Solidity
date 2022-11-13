
----------

# Solidity Tutorial : all about Assembly

![](https://cdn-images-1.medium.com/max/2600/1*OCoLQtXw8KFQ1eHf_jiBYQ.jpeg)

**Table of content**
- What is Assembly
- Why use Assembly in Solidity?
  - Understand the EVM and the Stack first
  - Assembly and the EVM
- Gas cost reduction with Assembly
- Two types of Assembly in Solidity
- Visualise the assembly code of your Solidity contract.
  - Installing the solc compiler
  - Creating our project structure.
  - Creating and compiling a sample contract
- Diving into our contract in Assembly
- Basics of Assembly syntax in Solidity
- How to use inline Assembly in Solidity ?

## What is Assembly ?

Assembly language is a low-level language used to communicate directly with the processor. A high level language such as C, Go, or Java is compiled down to assembly before execution.

An interesting feature of Solidity is its support for inline assembly. Assembly is used to interact directly with the EVM using opcodes.

## Why use Assembly in Solidity ?

### Understand the EVM and the Stack first

The Ethereum Virtual Machine (EVM) is a stack machine. A stack is a type data structure where you can only PUSH values on the stack and POP them from on it. The item most recently pushed onto the stack is the first that gets popped off. So :

-   You always add an item on the top of the stack (PUSH)
-   You can only remove the item (POP) from the top of the stack.

This is what we call a LIFO order (Last in, First out). In order to be useful, a stack-machine need to implement additional instructions, like ADD, SUBSTRACT, etc… Instructions usually pop one or more values from the stack, do some computation, and push the result. This order is called **Reverse Polish Notation.**

```solidity
a + b      // Standard Notation (Infix)  
a b add    // Reverse Polish Notation
```

> If you don’t know what a stack machine is, [here](https://igor.io/2013/08/28/stack-machines-fundamentals.html) is an amazing series of posts detailing stack machines.

A stack machine is also a type of processor in which **all operands are stored on a stack.** It still has memory and registers for the PC (program counter) and SP (stack pointer), but everything is stored on the stack, only operands are.

----------

### Assembly and the EVM

It is often hard to address the correct stack slot and provide arguments to opcodes at the correct point on the stack. Assembly language (especially inline-assembly) helps us to do that (and with other issues that arise when writing manual assembly).

Assembly gives you much more control, enabling you to execute logic that may not be possible with just Solidity. Therefore, you can obtain a more fine-grained control over a smart contract’s source code. This is especially useful when we need to enhance the language by writing existing libraries.

----------

### Gas cost reduction with Assembly

**Let’s compare the gas cost between Solidity and Assembly** by creating a function that do 1) a simple addition of two numbers (`x + y`) and 2) return the result. We are going to create two versions of this function : one using pure Solidity, one using inline Assembly.

give a simple example of gas cost between two functions that just do a simple addition of `x` and `y`.

```solidity
function addAssembly(uint x, uint y) public pure returns (uint) {  
     assembly {  
         // Add some code here  
         let result := add(x, y)  
         mstore(0x0, result)  
         return(0x0, 32)  
     }  
 }  
   
 function addSolidity(uint x, uint y) public pure returns (uint) {  
     return x + y;  
 }
```
![](https://cdn-images-1.medium.com/max/2400/1*d9qMI-RDUsr9aIxlSpDYlg.jpeg)

As you can see from the example above, we save 86 gas by using inline Assembly in our Solidity contract.

## Two types of Assembly in Solidity

The assembly language is relatively close to the one of the EVM.

Solidity defines two type of implementation of the Assembly language :

-   **Inline Assembly :** can use inside Solidity source code.
-   **Standalone Assembly :** can use without solidity.

> **!!!!! WARNING !!!!!**

> Inline assembly is a way to access the Ethereum Virtual Machine at a low level. This bypasses several important safety features and checks of Solidity. You should only use it for tasks that need it, and only if you are confident with using it.

----------

## Visualise the assembly code of your Solidity contract.

Before to dive into the assembly code, let's have a look of the EVM assembly code of a Solidity contract. 

### Installing the solc compiler

We are going to use the the solidity compiler `solc` via the CLI. You can install it globally on your local machine using the following npm command :

```
npm install -g solc
```

### Creating our project structure.

Go into your Desktop, create a directory and go into it.

```
mkdir All-About-Solidity
cd All-About-Solidity
```

You can now create a new contract file.

```
// If you use visual studio code, this will open the file automatically
code assembly.sol

// Other, use the `touch` UNIX command
touch assembly.sol
```

### Creating and compiling a sample contract

Copy and paste the following code in the file `assembly.sol`


```solidity
pragma solidity ^0.5.0;

contract Assembly {

    uint my_score = 5;
    
    constructor() public {
        my_score = 10;
    }
}
```

This contract doesn't do anything special. It just contains a state variable `my_score` of type `uint256` (remember that `int` and `uint` refer by default to 256 bits signed or unsigned integers). When the contract is instantiated (or deployed in Ethereum jargon), it assigns a value of 10 to our `my_score` variable.

Because we are not using **Remix** here, we are not warned by any errors while we code. So let's first try to compile our contract to make sure it does not contain any errors. You can compile a Solidity contract using the following command in the CLI.

```
solc assembly.sol

// Output expected
Compiler run successful, no output requested.
```

The `solc` CLI tool contains really powerful features. Let's have a look to it. Like any CLI tool, you can see the options and flags available using the `--help` flag. Try it on your terminal : 

```
solc --help

solc, the Solidity commandline compiler.
[...]     // Description

Allowed options :
[...]     // options available

Output Components
[...]                // We are interested in the following output options

--asm                EVM assembly of the contracts.
--asm-json           EVM assembly of the contracts in JSON format.
--opcodes            Opcodes of the contracts.
--bin                Binary of the contracts in hex.

[...]
```

The solc compiler gives you the option to display the assembly, opcode or binary version of your contract after compilation. We can have a try to see exactly what does it looks like. Type the following :

```
solc assembly.sol --asm
```
 
 The following should be displayed in the CLI. 
 
 ```
======= assembly.sol:Assembly =======
EVM assembly:
    /* "assembly.sol":25:131  contract Assembly {... */
  mstore(0x40, 0x80)
    /* "assembly.sol":66:67  5 */
  0x05
    /* "assembly.sol":50:67  uint my_score = 5 */
  0x00
  sstore
    /* "assembly.sol":78:129  constructor() public {... */
  callvalue
    /* "--CODEGEN--":8:17   */
  dup1
    /* "--CODEGEN--":5:7   */
  iszero
  tag_1
  jumpi
    /* "--CODEGEN--":30:31   */
  0x00
    /* "--CODEGEN--":27:28   */
  dup1
    /* "--CODEGEN--":20:32   */
  revert
    /* "--CODEGEN--":5:7   */
tag_1:
    /* "assembly.sol":78:129  constructor() public {... */
  pop
    /* "assembly.sol":120:122  10 */
  0x0a
    /* "assembly.sol":109:117  my_score */
  0x00
    /* "assembly.sol":109:122  my_score = 10 */
  dup2
  swap1
  sstore
  pop
    /* "assembly.sol":25:131  contract Assembly {... */
  dataSize(sub_0)
  dup1
  dataOffset(sub_0)
  0x00
  codecopy
  0x00
  return
stop

sub_0: assembly {
        /* "assembly.sol":25:131  contract Assembly {... */
      mstore(0x40, 0x80)
      0x00
      dup1
      revert

    auxdata: 0xa265627a7a72305820538db90c853f78eff41184acc184f577d7e1784e8f306928874755530dd8b0ed64736f6c63430005090032
}
```

We can also see our Assembly code in JSON format for a more detailed and structured view. Try it and type the following CLI command :

```
solc assembly.sol --asm-json
```

The following should appear :

```
======= assembly.sol:Assembly =======
EVM assembly:
{
  ".code" : 
  [
    {
      "begin" : 25,
      "end" : 131,
      "name" : "PUSH",
      "value" : "80"
    },
    {
      "begin" : 25,
      "end" : 131,
      "name" : "PUSH",
      "value" : "40"
    },
    {
      "begin" : 25,
      "end" : 131,
      "name" : "MSTORE"
    },
    {
      "begin" : 66,
      "end" : 67,
      "name" : "PUSH",
      "value" : "5"
    },
    {
      "begin" : 50,
      "end" : 67,
      "name" : "PUSH",
      "value" : "0"
    },
    {
      "begin" : 50,
      "end" : 67,
      "name" : "SSTORE"
    },
    {
      "begin" : 78,
      "end" : 129,
      "name" : "CALLVALUE"
    },
    
    ...        // More code below, we stop here for brievity
    
```

### Diving into our contract in Assembly

Let's try to break down part by part the assembly code. The output has the format described below. Each line corresponds to an EVM opcode associated with a comment (written above the opcode) that specifies where does it relate to in our Solidity contract.

```
   /* Solidity code with source file */
   opcode
```

As such, we can track easily which low-level instruction with high-level code (Solidity). Let's try to understand the following lines.

```
    /* "assembly.sol":66:67  5 */
  0x05
    /* "assembly.sol":50:67  uint my_score = 5 */
  0x00
  sstore
```

What happen in brief is that we allocate a slot in storage for our state variable `my_score`. In the EVM, the storage is simply a list of key-value pair (like an array), where the key corresponds to an index in our storage, and the value is the value associated with this key.

1. 5 (0x05) is pushed onto the stack. This is the value of our `my_score` variable.
2. 0 (0x00) is pushed onto the stack. The is going to be the index in our storage where we will store our variable `my_score`.
3. [`sstore`](https://ethervm.io/#55) takes the two parameters in 1. and 2. from our stack to create our storage slot.

**Let's now look at our constructor function**




## Basics of Assembly syntax in Solidity

Assembly parses comments, literals and identifiers in the same way as Solidity does. Therefore, you can use the usual `//` and `/* */` inside your assembly code.

## How to use inline Assembly in Solidity ?

You can mix assembly code with Solidity statements by using the keyword `assembly` followed by a pair of curly braces `{}`. See the following syntax :

```solidity
assembly {  
    // some assembly code here  
}
```

Here is a simple example of inline assembly in Solidity

```solidity
function addition() public pure returns (uint) {  
     assembly {  
          // Add some code here  
          let x := 5  
          let y := 23  
          let result := add(x, y)  
          mstore(0x0, result)  
          return(0x0, 32)  
      }  
 }
```

> **Important !**

> At the end of the `assembly { ... }` block, the stack must be balanced, unless you require it otherwise. If it is not balanced, the compiler generates a warning.

  

-   **Literals :** `0x123`, `42` or `"abc"` (for strings, up to 32 characters)
-   **EVM opcodes** in functional style. _Example:_

```
add(1, mload(0))
mul(1, add(2, 3))
```

-   **Variable declarations.** _Example :_

```
let x := 7
```

-   **Identifiers** (assembly-local variables and externals if used as inline assembly). _Example :_

add(3, x)  
sstore(x_slot, 2)

-   **Assignments.** _Example :_

```
x := add(y, 3)
```

-   **Blocks** where local variables are scoped inside. _Example :_

```
{ let x := 3 { let y := add(x, 1) } }
```
  

### Inline assembly has also the additional following features :

  

**assembly-local variables:**

```
let x := add(2, 3)  let y := mload(0x40)  x := add(x, y)
```

**access to external variables:**

```
function f(uint x) public pure {  
    assembly {  
        x := sub(x, 1)  
    }  
}
```

**loops: (this does not compile)**

```
for { let i := 0 } lt(i, x) { i := add(i, 1) } { y := mul(2, y) }
```

**if statements:**

```
if slt(x, 0) { x := sub(0, x) }
```

**switch statements: (this does not compile)**

```
switch x case 0 { y := mul(x, 2) } default { y := 0 }
```

**function calls:**

```
function f(x) -> y { switch x case 0 { y := 1 } default { y := mul(x, f(sub(x, 1))) }   }
```

  

## How to use standalone Assembly in Solidity ?

> Standalone assembly is supported for backwards compatibility but is not documented in the Solidity documentation anymore.

The following features are only available in standalone assembly.

-   **direct stack control** : `dup1`, `swap1`, …
-   **direct stack assignments** (in “instruction style”) : `3 =: x`
-   **labels** : `name:`
-   **jump opcodes**

  

## How to use opcodes in Assembly with Solidity

[The Solidity documentation provides a good list of opcodes as a reference for inline assembly.](https://solidity.readthedocs.io/en/v0.5.9/assembly.html#opcodes) A bit more details about this table :

-   Opcodes take arguments **always** **from the top of the stack.** The arguments are given in parentheses.
-   Opcodes marked with a `-` (second column) do not push items onto the stack.
-   Opcodes marked with a `*` (second column) are special opcodes (so here `swap1` to `swap16`).
-   All other opcodes push items onto the stack (their _“return”_ value).
-   Opcodes marked with `F`, `H`, `B` and `C` are present since Frontier, Homestead, Byzantium and Constantinople version of Ethereum.
-   `mem[a...b)` signifies the bytes of memory starting at position `a` up to (but not including position `b`.
-   `storage[p]` signifies the storage contents at position `p`.

The opcodes `pushi` and `jumpdest` cannot be used directly. Instead, you can use **integers** constants by typing them in **decimal** or **hexadecimal** notation. As a result, an appropriate `PUSHi` instruction will automatically be generated.

----------

## Functional-Style Assembly in Solidity

For a sequence of opcodes, it can be hard to see what the actual arguments for certain opcodes are. Let’s take an example of an instruction in both style : **non-functional** and **functional style :**

```solidity
// Non-Functional style  
3 0x80 mload add 0x80 mstore

// Functional style  
mstore(0x80, add(mload(0x80), 3))
```

This sequence of opcodes ([taken from the Solidity doc](https://solidity.readthedocs.io/en/v0.5.9/assembly.html#functional-style)) add 3 to the content located in memory at position `0x80`.

```
// Draw a picture of the steps in the stack for this example.
```

If we analyze carefully, the functional style is simply the reverse notation of the non-functional style. If you read the code from right to left, you end up with exactly the same sequence of constants and opcodes, but it is much clearer where the values end up. If you care about the exact stack layout, then note that **the first argument of an opcode function in functional style is always put at the top of the stack !**

```
  stack    PUSH 3  PUSH 0x80   MLOAD      ADD    PUSH 0x80   MSTORE

                    |_0x80| > |__5__|             |_0x80|  
|_____| > |__3__| > |__3__| > |__3__| > |__8__| > |__8__| > |_____|
```
  
```
// Draw a picture on Photoshop with the arrows
```

## Security considerations with assembly

Assembly is ok to use but you have to know what is bypassed when using it.

## References

- [Yul vs Solidity contract comparison](https://medium.com/@jtriley15/yul-vs-solidity-contract-comparison-2b6d9e9dc833)
