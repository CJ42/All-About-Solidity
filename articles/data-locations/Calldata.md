# All About Calldata

## Upcoming content

- [] Explain why you can’t use calldata inside internal functions. For instance if you constructed something in memory (e.g: a struct), and try to pass it to an internal function that specify calldata in a parameter. it will not compile. Explain why (good example).
- [] Explain how to retrieve some part of the calldata, using array slices and calldata offset.
- [] Explain what is happening under the hood for the following examples.
- Function takes calldata parameter. A variable inside is defined as calldata. What are the opcodes and what happen under the hood?
- Function takes calldata parameter. A variable inside defined as memory. What are the opcodes, what is happening under the hood?
- [] Explain why it is cheaper to use calldata instead of memory (in a function arguments, different number of opcodes + differences).
- [] Calldata is not a special place in memory. It’s its own location. Explain this and make it clear.
## References

- [Solidity `msg.sender`](https://medium.com/@devrann.simsek/solidity-msg-sender-9072c1561966)