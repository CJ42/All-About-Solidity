# Solidity Tutorial: all about Cryptographic & Mathematical Functions

## Modulo

```solidity
addmod(uint x, uint y, uint k) returns (uint)
```

The `addmod()` function enables to compute `(x + y) % k` where the addition is performed with arbitrary precision and does not wrap around at `2**256`. 

Assert that `k != 0` starting from version 0.5.0.


```solidity
mulmod(uint x, uint y, uint k) returns (uint)
```

The function enables to compute `(x * y) % k` where the multiplication is performed with arbitrary precision and does not wrap around at `2**256`. 

Assert that `k != 0` starting from version 0.5.0.

---

## Keccak256

```
keccak256(bytes memory) returns (bytes32)
```

The `keccak256()` function enables to compute the Keccak-256 hash of the input.

> **Note:** there used to be an alias for `keccak256` called `sha3`, which was removed in version 0.5.0.
 
---

## SHA256

**SHA** stands for **Secure Hash Algorithm**

```solidity
sha256(bytes memory) returns (bytes32)
```

The `sha256` function enables to compute the SHA-256 hash of the input. It returns a 256 bits value (= 32 bytes)

---

## RIPEMD160

**RIPEMD** stands for **RIPE Message Digest.**

```solidity
ripemd160(bytes memory) returns (bytes20)
```

The `ripemd160()` function enables to compute RIPEMD-160 hash of the input

---

## Create a Bitcoin address in Solidity

If you are a bit familiar with Bitcoin, you might know that a Bitcoin address is the RIPMED160 of the SHA256 of the public Key. Let's try to create a Bitcoin address from scratch using the previously covered functions.

---

## ECRECOVER

```solidity
ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) returns (address)
```

The `ecrecover()` function enables to recover the address associated with the public key from elliptic curve signature. It returns zero on error.

The function parameters correspond to ECDSA values of the signature:

- `r` = first 32 bytes of signature
- `s` = second 32 bytes of signature
- `v` = final 1 byte of signature

`ecrecover` returns an `address`, and not an `address payable`. See address payable for conversion, in case you need to transfer funds to the recovered address.

If you use `ecrecover`, be aware that a valid signature can be turned into a different valid signature without requiring knowledge of the corresponding private key. This is usually not a problem unless you require signatures to be unique or use them to identify items. OpenZeppelin have a ECDSA helper library that you can use as a wrapper for ecrecover without this issue.

---

## Considerations

When running `sha256`, `ripemd160` or `ecrecover` on a private blockchain, you might encounter Out-of-Gas. This is because these functions are implemented as "precompiled contracts" and only really exist after they receive the first message (although their contract code is hardcoded).

Messages to non-existing contracts are more expensive and thus the execution might run into an Out-of-Gas error. A workaround for this problem is to first send Wei (1 for example) to each of the contracts before you use them in your actual contracts. This is not an issue on the main or test net.
