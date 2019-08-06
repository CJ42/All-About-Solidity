# Solidity Tutorial: all about Blocks & Transactions Properties


## Block Properties

```solidity
blockhash(uint blockNumber) returns (bytes32)
```

Return the hash of the given block - only works for 256 most recent, excluding current, blocks

The function `blockhash` was previously known as `block.blockhash`, which was deprecated in version 0.4.22 and removed in version 0.5.0.

The block hashes are not available for all blocks for scalability reasons. You can only access the hashes of the most recent 256 blocks, all other values will be zero.

```solidity
block.coinbase (address payable)
```
current block miner's address

```solidity
block.difficulty (uint)
```
current block difficulty

```solidity
block.gaslimit (uint)
```
current block gaslimit

```solidity
block.number (uint)
```
current block number

```solidity
block.timestamp (uint)
```
current block timestamp as seconds since unix epoch


> The Solidity documentation states to not rely on `block.timestamp`and `blockhash` as a source of randomness, unless you know what you are doing.

> Both the timestamp and the block hash can be influenced by miners to some degree. Bad actors in the mining community can for example run a casino payout function on a chosen hash and just retry a different hash if they did not receive any money.

The current block timestamp must be strictly larger than the timestamp of the last block, but the only guarantee is that it will be somewhere between the timestamps of two consecutive blocks in the canonical chain.

---

## Messages Properties

- `msg.data (bytes calldata)`: complete calldata
- `msg.sender (address payable)`: sender of the message (current call)
- `msg.sig (bytes4)`: first four bytes of the calldata (i.e. function identifier)
- `msg.value (uint)`: number of wei sent with the message

**Note:** according to the Solidity documentation, the values of all members of `msg`, including `msg.sender` and `msg.value` can change for every external function call. This includes calls to library functions.

---

## Transactions Properties

- `tx.gasprice (uint)`: gas price of the transaction
- `tx.origin (address payable)`: sender of the transaction (full call chain)