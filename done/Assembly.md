
----------

# Solidity Tutorial : all about Assembly

![](https://cdn-images-1.medium.com/max/2600/1*OCoLQtXw8KFQ1eHf_jiBYQ.jpeg)

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