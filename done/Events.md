# Solidity Tutorial: all about Events

> Solidity events give an abstraction on top of the EVM's logging functionality. Applications can subscribe and listen to these events through the RPC interface of an Ethereum client.

Events and logs are important in Ethereum because they facilitate communication between smart contracts and their user interfaces. Events allow the convenient usage of the EVM logging facilities.

In Solidity, emitting an Event is considered to modify the state.

Arguments in an Event are stored in the transaction log, a special data structure in the Ethereum Blockchain.


---

## What are Events in Solidity ?

In traditional web development, a server response is provided in a callback to the frontend. In Ethereum, when a transaction is mined, smart contracts can emit events and write logs to the blockchain that the frontend can then process.


---

## When to use Events ?
There are 3 main use cases for events and logs:

- a smart contract return values for the user interface
- asynchronous triggers with data
- a cheaper form of storage



---

## How to declare events in Solidity ?

- events are declared outside of the function
- event names must be different from function names
- event names are CapWords per Solidity style guide
- an event name that is more than 1 character/case different than a function name leads to less confusion



---

## How to use an Event ?

You may fire events inside any function using the `emit` keyword, followed by the name of the event and the arguments (if any) in parentheses.

Any such invocation (even deeply nested) can be detected from the Javascript API by filtering for the event name.


---

## Using the indexed keyword

You can add the attribute `indexed` to up to three parameters which adds them to a special data structure known as "topics" instead of the data part of the log. 

If you use arrays (including `string` and `bytes`) as indexed arguments, its Keccak-256 hash is stored as a topic instead, this is because a topic can only hold a single word (32 bytes).

Topics allow you to search for events, for example when filtering a sequence of blocks for certain events. You can also filter events by the address of the contract that emitted the event.


---

## Where are events stored ?
In the Ethereum Blockchain, each transaction has an attached receipt which contains zero or more log entries. Log entries represent the result of events having fired from a smart contract.

**Therefore, because events are stored in a log entries, they modify the state.**


---

## Anonymous Events

Events can be declared as `anonymous` in Solidity. By default, all events will have a topic, which is the function signature. Use anonymous to log events without a topic. Anonymous events will also be part of the ABI.

```solidity
event Message(
    address _recipient, 
    string _message
) anonymous;
```

Anonymous events are **less expensive** to use. However, you can't filter them by name, only by their contract address.

There are in total five LOGn opcodes, LOG0 to LOG4, where n indicates the number of topics in the log. Topic0 is always the identifier of the event type, defined by the hash of its signature, but it can be skipped by using LOG0, which specifies an anonymous event. Each additional topic requires another slot in the stack, pushing that many more arguments out of the reachable list.

The hash of the signature of the event is one of the topics except you declared the event with anonymous specifier. This means that it is not possible to filter for specific anonymous events by name.

---

## To deepen in:

https://ethereum.stackexchange.com/questions/12950/what-are-event-topics
https://media.consensys.net/technical-introduction-to-events-and-logs-in-ethereum-a074d65dd61e

---

# References

- Contracts - Solidity 0.5.10 documentation
Contracts in Solidity are similar to classes in object-oriented languages. They contain persistent data in state…solidity.readthedocs.io

- "Stack Too Deep"- Error in Solidity
Happy New Year and may we all have great accomplishments in 2019! Aventus is welcoming you back from the winter…blog.aventus.io

- Ethereum Builder's Guide
Edit descriptionethereumbuilders.gitbooks.io

- web3.eth.abi.decodeLog returns incorrect log parameter values
I have an Ethereum contract with an event defined like so: event Apple(address indexed a, address b, address c); The…stackoverflow.com

- Ethereum Cookbook
Mine Ether, deploy smart contracts, tokens, and ICOs, and manage security vulnerabilities of EthereumKey FeaturesBuild…books.google.co.uk

- Contracts - Solidity 0.5.4 documentation
Contracts in Solidity are similar to classes in object-oriented languages. They contain persistent data in state…solidity.readthedocs.io
ethereum/wiki

- The Ethereum Wiki. Contribute to ethereum/wiki development by creating an account on GitHub.github.com

- What are event topics?
I know that indexed arguments index the values for those arguments so that filtering will be faster. But what are…ethereum.stackexchange.com
