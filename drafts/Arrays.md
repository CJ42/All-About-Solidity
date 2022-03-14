# Solidity Tutorial: all about Array

In Solidity, Arrays are ordered list of items indexed numerically starting at 0.


## Array types
Below, T is the element type and k is the array length / size. If k is equal to 5, then the array can hold a maximum of 5 values.

- Fixed Size: T[k]
- Dynamic Size: []
- Multi-dimensional: T[][k]

Example: uint[][5] represents an array that include 5 other arrays of dynamic size uint.

(Draw an example of code here).

> **Note that in Solidity, the notation of multidimensional array is reversed compared to other programming languages.**
 
---

## How to define arrays ?
example: uint[][5] x
Where x is the variable name.

---

## Access elements within Fixed and Dynamic size arrays.

Like many other programming languages, you must specify the index between the square brackets.

---

## Access elements within multi-dimensional arrays.

As said before, the notation is reversed, so you must access the element in the opposite direction of the declaration. Here is an example:

```
y = x[2][1]
```

Here, y represents the value of the 2nd uint  inside the 3rd dynamic array located in the array x.

---

## Arrays literals (inline arrays)
Arrays literals are arrays written like an expression. They do not get assigned to a variable right away.

```
// Base type (common types of the given elements)
// Here the type would be uint8[3]
function func1() public pure {

    // Conversion of the 1st element to uint (uin256) is necessary because
    // the type of every constant memory is uint8 by default.
    
    func2([uint(1), 2, 3]);
}

// memory type array that has a fixed size (uint3)
function func2(uint[3] _data) {
    // Some code here
}
```

---

## Allocate memory Arrays
Use the **new** keyword.

```
function _memory_array(uint len) public {
    
    uint[] memory x = new uint[](7);
    bytes[] memory y = new bytes(len):;
    
    // Here we have x.length == 7 and y.length == len
    x[6] = 8;

}
```
Note that you can't change the size of memory arrays by assigning values to the member .length

You can't assign fix size memory arrays to dynamic size memory array !

(copy code from note book here)

---

## Reference type members of Arrays
It exists to main members functions that you can perform on arrays in Solidity. These are also common to other programming languages that use arrays.

- .length > return the number of elements the array holds.

Note that dynamic sized arrays may be resized in storage, not in memory, by modifying the length member.

- .push(new_element) > append a new element at the end of the array. Returns the new length.

This member function is only available for **dynamic sized arrays** and **bytes**, not strings (not sure if you can't push an element in a fixed sized array).


## What you can't do in Arrays with Solidity ?

It is not possible to use arrays of arrays within external functions.