# Solidity Tutorial : all about Bytes (edit)


# Table of Content :


1) What are bytes in Solidity exactly ?
2) How to declare a byte variable in Solidity
3) Bitwise operations in Solidity
4) An array of bytes : a little difference
5) Storage, Memory and Stack related to Bytes
6) Bytes as function argument
7) Advanced operations with Bytes
8) Some Warnings !

---

Bytes are easy to work with in Solidity because they are treated a lot like an array. You can just decode the bytes in the frontend and less data is stored on the blockchain.

---

## 1) What are bytes in Solidity exactly ?

### Definition
Define first what is a byte in general


### Bytes and Endianness

In computing, the term endianness corresponds to how bytes are ordered (and stored) in a computer or any machine. Therefore, it defines the internal ordering of the memory.

We refer to multi-byte data types as type of data (uint, float, string, etc…). There are two ways for ordering multi-byte data types in computer: in little-endian or big-endian format (where format = order). The differences are :

- With Big-Endian, the first byte of binary representation of the multibyte data-type is stored first.
- With Little-Endian, the last byte of binary representation of the multibyte data-type is stored first. (Intel x86 machines)

This is how a variable y with a value of 0x01234567 (hexa-decimal representation) would be stored in both formats

_picture here_

---

### Bytes & Endianness in Ethereum
Ethereum uses the two endianness format depending on the variable type, as follow :
- Big endian format : strings and bytes
- Little endian format : other types (numbers, addresses, etc…).

As an example, this is how we would store the string "abcd" in one full word (32 bytes):
```
0x6162636400000000000000000000000000000000000000000000000000000000
```
This is how the number 0x61626364 would be stored:
```
0x0000000000000000000000000000000000000000000000000000000061626364
```


> This is not the case in solidity if I return
> Find a way to show that on Remix !!!

In Solidity, the data type `byte` represent a sequence of bytes.

A byte is different than a number type of the same bit-size (like for instance uint8), because their internal representations are different:

```
// 0x00000000…01
Uint8 u8 = 1;
// 0x01000000….
Byte b = 1;
```

---

## 2) How to declare a byte variable in Solidity ?
Solidity presents two type of bytes types :
- Fixed-sized byte arrays
- Dynamically-sized byte arrays.

### Fixed-size byte arrays
You can define a variables by using the keyword bytesX where X represents the sequence of bytes. X can be from 1 up to 32

> byte is an alias for bytes1 and therefore stores a single byte.




_If you can limit the length to a certain number of bytes, always use one of bytes1 to bytes32 because they are much cheaper._




Bytes with a fixed-size variable can be passed between contracts.

### Dynamically-size byte arrays
These are a really specific types. Basically, bytes and string are special array (see Solidity doc)

### Bytes
> use bytes for arbitrary-length raw byte data
The term bytes in Solidity represents a dynamic array of bytes. It's a shorthand for `byte[]`.

Because bytes are treated as array is Solidity code, it can have a length of zero and you can do things like append a byte to the end.

However, bytes is not a value type !
You can push, pop and length

### String

> use string for arbitrary-length string (UTF-8) data

```
bytes32 samevar = "stringliteral";
```

This string literal is interpreted in its raw byte form when assigned to a bytes32 type.

However, strings can't be passed between contracts because they are not fixed size variables.

Solidity does not have string manipulation functions, but there are third-party string libraries.


---

## 3) Bitwise operations in Solidity

> Most of this section is based on articles written by Maksym, which also provides great articles on zk-SNARKS. Thanks Chronicled Staff !!

Solidity supports basic bitwise operations (though some of them are missing, like left of right shift). Luckily there's arithmetic equivalents. The following section will give you some basic primitives for bit manipulations.

### Comparison operator
The following comparison operators applied to bytes evaluate to a bool value true or false .
<=, <, ==, !=, >=, >

```
// Some examples needed
```

---

### Bit operator
The following Bit operators are available in Solidity : & (AND), | (OR), ^ (XOR) and ~ (NEGATION).
For simplicity, we are going to use bytes1 data type ( equal tobyte ) for two variables : a and b. We will initialize them in Solidity by using their hex representation.

```
bytes1 a = 0xb5; //  [10110101]
bytes1 b = 0x56; //  [01010110]
````

The following table display their representation in binary format.

_picture here_

NB: inputs have white background, results will be highlighted in yellowLet's have a look :
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
- `&` (**AND**) : both bits must be 1s (white rows) to result in true (1 => yellow rows).

_picture here_

```
a & b; // Result: 0x14  [00010100]
```
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
- `|` (**OR**) : at least one of the bits have to be 1 (white rows), to result in true (1 => yellow rows)

_picture here_

```
a | b; // Result: 0xf7  [11110111]
```
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
- `^` (**XOR**) : bitwise exclusive OR

This is the difference between two inputs. One of the inputs have to be 1 and the other one must be 0 to result in true. Simply a[i] != b[i].
* If both inputs have the same value (1 and 1, or 0 and 0), this results in false (0).
* If both inputs have different value (1 and 0, or 0 and 1), this results in true (1)

_picture here_

```
a ^ b; // Result: 0xe3  [11100011]
```
> XOR operation often applied in cryptographic algorithms.

An interesting property is that if you want to know what was the value of original b, just XOR result with a. In one sense a is the key to unlock b.

```
0xe3 ^ a; // Result: 0x56 == b  [01010110]
```
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
- `~` (**Negation**) : bitwise negation

This is also called an inversion operation. With this operation, 0 becomes and 1 and 1 becomes 0.

_picture here_

```
a ^ 0xff; // Result: 0x4a  [01001010]
````

> **NB:** Negation is the same as to XOR input with all 1s.
 
```
function negate(bytes1 a) returns (bytes1) {
    return a ^ allOnes();
}
// Sets all bits to 1
function allOnes() returns (bytes1) {

    
    // 0 - 1, since data type is unsigned, this results in all 1s.
    
    return bytes1(-1);
}
```
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 


---

### Shift Operator

// explain like the article it is based on that shift is like 2 ^ x, where x is the number of positions we want to shift our bits.

> **From the Solidity Doc :** The shifting operator works with any integer type as right operand (but returns the type of the left operand), which denotes the number of bits to shift by. Shifting by a negative amount causes a runtime exception.

Let's have a look :

- - - 

- `<< x` (**left shift of x bits**) : shift a number 3 bits left.

_picture here_

```
function leftShiftBinary(
    bytes32 a, 
    uint n
) public pure returns (bytes32) {
    return bytes32(uint(a) * 2 ** n);
}

// This function does the same than above using the << operators
function leftShiftBinary2(
    bytes32 a, 
    uint n
) public pure returns (bytes32) {
    return a << n;
}

// Normally, we should do the following according to the article,
// but explicit conversion is not allowed for bytes to uint
var n = 3; 
var aInt = uint8(a); // Converting bytes1 into 8 bit integer
var shifted = aInt * 2 ** n;
bytes1(shifted);     // Back to bytes. Result: 0xa8  [10101000]
```

- `>> x` (**right shift of x bits**) : shift a number 3 bits left.

```
function rightShiftBinary(
    bytes32 a, 
    uint n
) public pure returns (bytes32) {
    return bytes32(uint(a) / 2 ** n);
}

// This function does the same than above using the >> operators
function rightShiftBinary2(
    bytes32 a, 
    uint n
) public pure returns (bytes32) {
    return a >> n;
}

// Normally, we should do the following according to the article,
// but explicit conversion is not allowed for bytes to uint
var n = 2; 
var aInt = uint8(a); // Converting bytes1 into 8 bit integer
var shifted = aInt / 2 ** n;
bytes1(shifted);     // Back to bytes. Result: 0x2d  [00101101]
```

---

### Index Access (read-only)

> if `x` is of type bytesI (where I represents an integer), then `x[k]` for 0 <= k < I returns the `k`th byte.

Accessing individual bytes by index is possible for all bytesN types. The highest order byte is found at index 0. Let's see with an example.

```
function accessByte(
     bytes32 _number_in_hex, 
     uint8 _index
) public pure returns (byte) {
     byte value = _arg[_index];
     return value;
}
```

_image from Remix here_
This is the result you should obtain in Remix

If we pass the arguments `_number_in_hex = 0x61626364` and `_index = 2`, the function will return 0x63 as you can see from the screenshot.


_Don't remember this_

```
Var numLit_0 = numLit[0];      // 0
Var numLit_31 = numLit[31]     // 0x04
Var strLit_0 = strLit[0];      // 0x30
Var strLit_31 = strLit[31];    // 0
```



### Members of Bytes
- `.length` (read-only). : yields the fixed length of the byte array




---

## 4) An array of bytes : a little difference.
According to the Solidity documentation,

> The type byte[] is an array of bytes, but due to padding rules, it wastes 31 bytes of space for each element (except in storage). It is better to use the bytes type instead.


---

## 5) Storage, Memory and Stack related to Bytes




---

## 6) Bytes as function argument
The fixed length bytes32 can be used in function arguments to pass data in or return data out of a contract.

The variable length bytes can be used in function arguments also, but only for internal use (inside the same contract), because the interface (ABI) does not support variable length type.


---

## 7) Working with addresses and bytes.
As we know, an address in Ethereum is a 20 bytes value. Here is an example : `0xa59b89aee4f944a04d8fc075967d616b937dd4a7.` Because of this, it is possible to do several conversions in both ways. let's see some examples below.

## bytes to address
You can easily convert a value of `bytes20` type into an address via explicit conversion. That means you simply wrap your bytes20 value between parentheses () and prefix it with the type address , as shown below :

_image needed here_

```
// This function is really expensive the 1st time 
    // it's called (21 000 gas). Why ?
    function bytesToAddress(bytes20 input) public pure returns (address) {
        return address(input);
    }
```

Try to run this function by entering the following address in Remix : `0xa1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1`

If we look at the result in Remix after running this function, we can see that the explicit conversion from bytes20 to address ran successfully. 

Even more, the Solidity compiler converted it into an address with a valid checksum ! Note the different uppercase and lowercase letters in the input.

```
{
	"0": "address: 0xA1A1a1a1A1A1A1A1A1a1a1a1a1a1A1A1a1A1a1a1"
}
```




For more infos on checksum, read our article "All about addresses" or see EIP55 proposed by Vitalik Buterin.




### address to bytes
What about the other way around ? What if we would like to convert an address into the bytes20 type and maybe do some computation on it like the one we have seen above ? Let's see with an example.




---

## 8) Advanced Operations with Bytes


### Get First N Bits

In this scenario, we need a 2 step process :

1. Create a mask of needed number N of 1s in order to filter the part in a that we are looking to retrieve.
2. Apply an AND operation between a and the mask, so : a & mask.

_image needed here_

```
function getFirstNBytes(
    bytes1 _x,
    uint8 _n
) public pure returns (bytes1) {
    require(2 ** _n < 255, "Overflow encountered ! ");
    bytes1 nOnes = bytes1(2 ** _n - 1);
    bytes1 mask = nOnes >> (8 - _n); // Total 8 bits
    return _x & mask;
}
```

### Get Last N Bits

There's arithmetic way to get last N bits. We can achieve that using modulo. For example if want to get last 2 digits from 10345, we can easily do it by dividing by 100 (¹⁰²) and getting remainder.

```
10345 % 10 ** 2 = 45
````

Same with binary, though this time we're getting modulo of multiples of 2. For example to get last 5 bits:

```
// `var` is deprecated
var n = 5;
var lastBits = uint8(a) % 2 ** n;
bytes1(lastBits); // Result: 0x15  [00010101]


// This would do the same, but doesn't return byte
function test2(uint a) public pure returns (uint) {
        uint n = 5;
        uint lastBits = uint(a) % 2 ** n;
        return lastBits; // Result: 21 -> 0x15  [00010101]
    }
```

Here is the implementation in Solidity.

```
function getLastNBytes(
    byte _A, 
    uint8 _N
) public pure returns (bytes1) {
    require(2 ** _N < 255, "Overflow encountered ! ");
    uint8 lastN = uint8(_A) % (2 ** _N);
    return byte(lastN);
}
````

### Data Packing Use Case
Imagine that you have two values 4-bit (= 2 values of 2 bytes each) : **`c`** and **`d`**.

You want to pack these two value into one 8-bit (= 4 bytes) value.

_picture here_
c takes first 4 bits, and d takes the remaining 4 bits (can be the other way around)

> **Note :** the function below works in Remix, but is restrictive.
It is based on the example above and works only to concatenate two value of both 2 bytes into a final value of 4 bytes. For more modularity, you might need something else, like an array of bytes that you shrink and specify the number of bytes only (difficult)

```
/// @dev 798 gas cost :)
function concatBytes(
    bytes2 _c, 
    bytes2 _d
) public pure returns (bytes4) {
    return (_c << 4) | _d;
}
```

---

## 8) Some Warnings !
Some possibly disorienting situations are possible if bytes is used as a function argument and the contract successfully compiles. Always use fixed length types for any function that will called from outside.


# References
- Little Endian vs Big Endian
A question very frequently asked in interviews.thebittheories.com

- Endianness - Wikipedia
Historically, various methods of endianness have been used in computing, including exotic forms such as…en.wikipedia.org

- Bitwise Operations and Bit Manipulation in Solidity, Ethereum
Yes, Ethereum is the world's computer, though probably the most expensive one. Since storage is the largest…medium.com