# Solidity Tutorial : all about Ether Units

Any literal number can take one of the following suffix to specify a sub-denomination of Ether: `wei`, `finney`, `szabo` or `ether` . The only effect of the sub-denomination suffix is a multiplication by a power of ten.

Ethers numbers without a postfix are assumed to be **Wei**.

- 1 ether = 1,000,000,000,000,000,000 **wei**
- 1 ether = 1,000,000 **szabo**
- 1 ether = 1,000 **finney**

---

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
````

---

# References

- How to use a variable with an Ether unit suffix
Thanks for contributing an answer to Ethereum Stack Exchange! Please be sure to answer the question. Provide details…ethereum.stackexchange.com