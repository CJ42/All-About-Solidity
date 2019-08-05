# Solidity Tutorial : all about Strings

As a general rule, you should use stringfor arbitrary-length string (UTF-8) data.
Strings heavily involve the use of bytes in Solidity

## Strings as Arrays
In Solidity, string are actually a special type of arrays (Like abytes is similar to byte[] ).

String are actually equal to bytes but does not allow length or index access.

---

## String Literals
In Solidity, strings can be written with either double or single-quotes ("foo" or 'bar').

---

## Escape characters in String Literals

String literals support the following escape characters:

_picture here_

\xNN takes a hex value and inserts the appropriate byte, while \uNNNN takes a Unicode codepoint and inserts an UTF-8 sequence.

The string in the following example has a length of ten bytes. It starts with a newline byte, followed by a double quote, a single quote a backslash character and then (without separator) the character sequence abcdef.

```
"\n\"\'\\abc\
def"
```
Any unicode line terminator which is not a newline (i.e. LF, VF, FF, CR, NEL, LS, PS) is considered to terminate the string literal. Newline only terminates the string literal if it is not preceded by a \.

---

## Compare two strings.

You can compare two strings by their keccak256-hash using :
```
keccak256(abi.encodePacked(s1)) == keccak256(abi.encodePacked(s2)) .
````

---

## Concatenate two strings.
You can concatenate two strings using abi.encodePacked() method. Here is an example below.

```
string s1 = "Hello ";
string s2 = "World";

function concatenateStrings(string s1, string s2) internal pure returns (bytes) {
    return abi.encodePacked(s1, s2);
}
````

We could also do it differently. We would first need to convert the two values pass as parameters into `bytes`.

In other programming languages like PHP, you can reference the individual values of a string. In fact, a string is an array of integers cast to their ASCII character values.

---

## Data Location with Strings
Let's see how you can create a new string character by character. This will introduce us to one peculiarity of Solidity programming: data location.

---

## Additional notes on Strings
If you want to access the byte-representation of a string s, use bytes(s).length / bytes(s)[7] = 'x';. Keep in mind that you are accessing the low-level bytes of the UTF-8 representation, and not the individual characters.

String literals can be implicitly converted to fixed-size byte arrays, if their number of characters matches the size of the bytes type:

```
bytes2 b = "xy"; // fine
bytes2 e = "x"; // not allowed
bytes2 f = "xyz"; // not allowed
````

---

## What you can't do with Strings in Solidity ?

- Solidity does not have string manipulation functions, but there are third-party string libraries.