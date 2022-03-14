# Solidity Tutorial : all about Literal Numbers

## Integers numbers
Integers in Solidity can be **signed** or **unsigned**. 

An int8 will accept values positive and negative values ranging from -128 to 128. 

An uint8 will accept values only positive values ranging from 0 to 256
By default, the type int and uint assigns 256 bytes. However, you can specify the number of bytes by range of 8, ranging from 8 to 256. 

Because the idea behind these articles is "all about", we must describe everything ! ^^ The table below summaries all the minimum and maximum values for every single possible type of int and uint.

_picture here_
Assign precisely the number of bytes to an integer can enable to use less gas and takes up less storage space on the EVM.

---

## Fixed point numbers
Use the keyword fixed or ufixed.


## Arithmetic Overflow and Underflow
As we have seen, integers are a fixed-size data type and an integer variable has a certain range of numbers it can represents.

If you try to add a number over the range of your integer (eg: 256 for an uint8 that can hold a value up to 255), the result will be overflowed. In this scenario, the value of the variable will be simply 0.


[Show an example here with Remix code]

## Warning about numbers

Never use a floating point number in a Financial System because of potentially unexpected behaviour.