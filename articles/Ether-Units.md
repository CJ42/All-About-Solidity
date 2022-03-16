# all about Ether Units

## How to assign an ether unit to a variable?

ether units can be assigned to any number in Solidity, but this number MUST be a **literal number**. 

The following sub-demonimation of ether are available in Solidity, from the smallest to the largest: `wei`, `finney`, `szabo` and `ether`.

You can assign these keywords as suffix to a literal number in Solidity. Like for instance

```solidity
500000 wei

3000 szabo

50 finney

3 ethers
```

## Available ether units.

As mentioned in the previous section, these ether units are available in Solidity. The only effect of the sub-denomination suffix is a multiplication by a power of ten, 

- 1 `wei` = 1 * 10 ** 18 = 1_0
- 1 `szabo` = 1 * 10 ** 6
- 1 `finney` = 1 * 10 ** 3

By default, ether numbers / currencies (like `msg.value`) without a postfix are assumed to be `wei`.

> These are the names of famous cryptographers who inspired or were involved in the early days of Bitcoin


## Conversion table

- 1 ether = 1,000,000,000,000,000,000 **wei**
- 1 ether = 1,000,000 **szabo**
- 1 ether = 1,000 **finney**


|            |`wei`                     |`szabo`          |`finney`         |`ether`              |
|------------|--------------------------|-----------------|-----------------|---------------------|
|**`wei`**   |1                         |0.000000000001   |0.000000000000001|0.000000000000000001 |
|**`szabo`** |1,000,000,000,000         |1                |0.001            |0.000001             |
|**`finney`**|1,000,000,000,000,000     |1,000            |1                |0.001                |
|**`ether`** |1,000,000,000,000,000,000 |1,000,000        |1,000            |1                    |



> **Quick tip for converting in your mind**
> 
> This table and units might sound complex and confusing. Here is a simple way to remember:
> •	Always start by counting in wei. 
> •	Remember the number of trailing zeros.
> 1 finney = 1e12 wei = 12 zeros
> 1 szabo = 1e15 wei = 15 zeros
> 1 ether = 1e18 wei = 18 zeros
> NB: You can also use etherconverter.online for quick conversion. It displays other units (like Kwei, Mwei (Shannon), Kether, etc…), but these units are not available in Solidity.



## Working with variables and Ether Units

The code below is a really simple example of what a variable holding an ether value would look like.

```solidity
uint256 price = 0.06 ether;
require(msg.value == price);
````

This other example below will assume that the message value represents 0.06 % of an Ether.

```solidity
uint256 percentage = 6;
require(msg.value == 1 ether * percentage / 100);
```



## Assertions and Comparisons with Ether units

2 ether == 2000 finney evaluates to true

```solidity
assert(1 wei == 1);
assert(1 szabo == 1e12);
assert(1 finney == 1e15);
assert(1 ether == 1e18);
```

## Using Ether units for percentages

The code below is a really simple example of what a variable holding an ether value would look like.

```solidity
uint256 price = 0.06 ether;
require(msg.value == price);
```

This other example below will assume that the message value represents 0.06 % of an Ether.

```solidity
uint256 percentage = 6;
require(msg.value == 1 ether * percentage / 100);
```


# References

- [How to use a variable with an Ether unit suffix - Ethereum Stack Exchange](https://ethereum.stackexchange.com/questions/52241/how-to-use-a-variable-with-an-ether-unit-suffix)