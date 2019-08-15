# Solidity Tutorial : all about Control Flow

## Available control structures in Solidity

Most of the control structures known from curly-braces languages are available in Solidity:

`if`, `else`, `for`, `while`, `do`, `break`, `continue`, `return`, with the usual semantics known from C or JavaScript.

Parentheses can not be omitted for conditionals, but curly braces can be omitted around single-statement bodies.

Note that there is no type conversion from non-boolean to boolean types as there is in C and JavaScript, so `if (1) { ... }` is not valid Solidity

### If … Else Statements

As a shorthand, you can write a single `if` statement without curly braces `{}`. Here are two examples derived from the [Gnosis MultiSigWallet contract](https://github.com/gnosis/MultiSigWallet/blob/master/contracts/MultiSigWallet.sol).

Method 1 : on the same line.

```solidity
/// @dev Fallback function allows to deposit ether.
function() external payable {
    if (msg.value > 0) emit Deposit(msg.sender, msg.value);
}
```

Method 2 : on a different line.
```solidity
/// @dev Fallback function allows to deposit ether.
function() external payable {
    if (msg.value > 0)
        emit Deposit(msg.sender, msg.value);
}
```

---

### For Loops
Let's say we want to calculate the total value of all addresses, having an array of addresses can really be helpful.

```solidity
mapping (address => uint) public mappedUsers;
address[] public addressIndices;

// start adding address in array
addressIndices.push(newAddress);

// define mappedUsers as well
mappedUsers[newAddress] = someValue;

...

// We know the length of the array
uint arrayLength = addressIndices.length;

// totalValue auto init to 0
uint totalValue;

for (uint i=0; i<arrayLength; i++) {
  totalValue += mappedUsers[addressIndices[i]];
}
```

What if we want to delete the array efficiently? We have to move the array's last position to the deleted position.

```solidity
uint indexToBeDeleted;
mapping (address => uint) public mappedUsers;
address[] public addressIndices;
uint arrayLength = addressIndices.length;

for (uint i=0; i<arrayLength; i++) {
  if (addressIndices[i] == addressToBeDeleted) {
    indexToBeDeleted = i;
    break;
  }
}

// if index to be deleted is not the last index, swap position.
if (indexToBeDeleted < arrayLength-1) {
  mappedUsers[indexToBeDeleted] = mappedUsers[arrayLength-1];
}

// we can now reduce the array length by 1
addressIndices--;
```
---

### While Loops
You might need to execute a code segment repeatedly based on a condition. Solidity provides `while` loops precisely for this purpose. The general form of the while loop is as follows:

```solidity
// Declare and initialize a counter
while (check the value of counter using an expression or condition) {
  // Execute the instructions here
  // Increment the value of counter
}
```

`while` is a keyword in Solidity and it informs the compiler that it contains a decision control instruction. If this expression evaluates to true then the code instructions that follow in the pair of double-brackets `{` and `}` should be executed. The `while` loop keeps executing until the condition turns false.

Here is an example of a `while` loop.

```solidity
while (input1 >= 0) { 
    if(input1 == 5) 
        continue; 
    input1 = input1–1; 
    a++; 
}
```

---

### Do … While Loop

```solidity
do { 
  a - ; 
} (while a>0);
```

---

# References

- Learn Solidity: Control Structure (if-else, for, while, Do-While)
In this post, we will understand the Control Structure (if-else, for, while, Do-While) in Solidity Language. ...www.toshblocks.com

- Control Structures in Ethereum
Listen, I love Ethereum, I think it's cool as hell, I even wrote a book about it, what I really don't like is the…medium.com
