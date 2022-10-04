## All About Smart Contract Security

> This page should be much larger, and probably its own repository overtime. The scope of smart contract and solidity security is too big for one markdown page.

Security / Ethical Hacking

You can do this (mainnet hard fork) as suggested by Hadrien in the comments.

https://twitter.com/paulrberg/status/1574375484120616961?s=46&t=ZSDpK77I_lTaaZNacgpUEA

https://blog.ethereum.org/2016/06/10/smart-contract-security/

Upgradeability: be careful when the contract get upgraded that it is initialised properly.

Use Pausable on the contract, to pause any interaction while making fixes, or if it got exploited.

Visibility: keep things closed, and open it up.

Be very careful with initialize(…) functions!!!

You should never audit your own code. You should get a new pair of eyes, because you are developing and you are in a particular mindset, so you are creating the bug.

## References

- [A Historical Collection of Reentrancy attacks](https://github.com/pcaversaccio/reentrancy-attacks)