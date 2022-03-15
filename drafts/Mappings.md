# Solidity Tutorial : all about Mappings

[picture of the hash table from notebook]

Mappings in Solidity are similar to the concept of hashmap in Java or dictionnary in C an Python. They act a bit like hash tables, although they are slightly different in the following way.

In Solidity, mappings are virtually initialised such that every possible key exists and is mapped to a value whose bytes representation are all zeros. In other words: **all possible variables are initialised by default.**

Because of this, **mappings do not have a length**. There is no concept of a key and a value being set. The key data is not stored in a mapping but rather its keccak256 hash is used for storing the value the key data references to.

---

## How to define a Mapping ?

```
mapping (_KeyType => _ValueType) mappingName;
```

A good tips is to use the keyword public before the mapping name. This will create automatically a getter function for the mapping. You will only need to pass the **\_KeyType** as a parameter to the getter to return the **\_ValueType**.

```
mapping (_KeyType => _ValueType) public mappingName;
```

## KeyTypes and ValueTypes allowed in Mappings

_Show the image_

---

## When to use a Mapping ?

- Useful for associations, like associate a unique Ethereum address with a value: `mapping(address => _valueType) my_mapping`
- `mapping(uint => _valueType) my_mapping`

An example would be a Game that associates a user level with an ethereum address.

```
mapping(address => uint) public userLevel;
```

Another example would be a mapping that list Ethereum addresses that are allowed to send ether for instance:

```
mapping(address => bool) allowedToSend;
```

Here is another example of a mapping where the value type is a Struct.

```
struct someStruct {}

mapping(uint => someStruct) canDoSomething;

uint canDoSomethingKey = 0;


function addCanDoSomething() {
     canDoSomething[canDoSomethingKey] = someStruct(arg1, arg2, ...);
     canDoSomethingKey++;
}
```

In the example, the variable `canDoSomethingKey` is at the end the length of the mapping.

---

## How to get a value from a Mapping ?

```
function currentLevel(address userAddress) public view returns (uint) {
     return userLevel[userAddress];
}
```

---

## Use a Mapping as a ValueType inside another Mapping

If the \_ValueType of a mapping turns up to be a mapping too, then the getter function will have a single parameter for every \_KeyType recursively.

\_Use this good example fromt the Solidity documentation: \_https://solidity.readthedocs.io/en/v0.5.11/miscellaneous.html#mappings-and-dynamic-arrays

---

## Iterate through a mapping

You can't iterate a mapping directly because of the reason stated at the beginning.

> … mappings are virtually initialised such that every possible key exists and is mapped to a value …

However, it is possible to implement a data structure on top of a mapping in in order to make a mapping iterable.

The solution is to have a counter that tells you the length of the mapping where the last value is stored.

---

## Mappings as function parameters

This is a difficult topic, but we will attempt to discuss about it. Mappings can be passed as parameters inside functions, but they must satisfy the following two requirements :

1. Mapping can be used as parameter only for private and internal functions.
2. The data location for the function parameter (our mapping) can only be storage.

---

## What you can't do with Mappings in Solidity ?

- You can't not define variables as the \_ValueType of a mapping. The Remix compiler will throw a TypeError as shown below:

_show picture_

- You can't iterate in a mapping directly
- It is impossible to retrieve a list of values or keys, like you would do it in Java for instance. The reason is still the same: all variables already initialised by default. So it's internally not possible.
- Mappings can't be passed as parameters inside public and external functions in smart contracts.
- Mappings can't be used as return value for function

|             Variable Type              |      Key Type      |     Value Type     |
| :------------------------------------: | :----------------: | :----------------: |
|              `int / uint`              | :heavy_check_mark: | :heavy_check_mark: |
|                `string`                | :heavy_check_mark: | :heavy_check_mark: |
|             `byte / bytes`             | :heavy_check_mark: | :heavy_check_mark: |
|               `address`                | :heavy_check_mark: | :heavy_check_mark: |
|                `struct`                |        :x:         | :heavy_check_mark: |
|               `mapping`                |        :x:         | :heavy_check_mark: |
|                 `enum`                 |        :x:         | :heavy_check_mark: |
|               `contract`               |        :x:         | :heavy_check_mark: |
|    \* fixed-sized array <br>`T[k]`     | :heavy_check_mark: | :heavy_check_mark: |
|    \* dynamic-sized array <br>`T[]`    |        :x:         | :heavy_check_mark: |
| \* multi-dimentional array <br>`T[][]` |        :x:         | :heavy_check_mark: |
|               `variable`               |        :x:         |        :x:         |

- <sub>For arrays, `T` refers to Type and `k` to the length of the array.</sub>
