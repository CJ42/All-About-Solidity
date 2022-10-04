
# Solidity Tutorial : all about Error Handling

  

## assert()

```
assert(bool condition);
```

**assert()** causes an invalid opcode and a state reversion. It is mostly used for internal errors

  

## require()

```
require(bool condition, string memory message);
```

**require()** will cause state reversion if the condition is invalid. It is mostly used to check errors on inputs or external components.

  

## revert()

```
revert(string memory reason);
```

**revert()** will abort the execution and reverse the state. Like **require()**, it is also used to check errors on inputs or external components.


## References

- [try / catch (from Twitter)](https://twitter.com/cleanunicorn/status/1574808522130194432?s=46&t=ZSDpK77I_lTaaZNacgpUEA)