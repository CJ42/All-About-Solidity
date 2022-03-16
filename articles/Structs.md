# All About Structs - Solidity

Solidity Tutorial: all about Structs (edit)
Structs are another custom type in Solidity. They simply enable to group several variables of multiple types.
We can say that it is a way to define new types in Solidity.

## How to define Structs ?

```
struct Instructor {
    uint age;
    uint first_name;
    uint last_name;
}
```

## How to declare a new variable of type Struct ?
There are actually multiple way to do that.

### The conventional (methodic) way
```
function method_1(address _address, uint _age, string _first_name, string _last_name) {
    
    Instructor memory instructor = instructors[_address];
    instructor.age = _age;
    instructor.first_name = _first_name;
    instructor.last_name = _last_name;
    instructorAccounts.push(_address) - 1;
}
```

### The readable way
```
function method_2(address _address, uint _age, string _first_name, string _last_name) {
    
    instructors[_address] = Instructor(
        {
            age: _age,
            first_name: _first_name,
            last_name: _last_name
        }
    );
    
    instructorAccounts.push(_address) - 1;
}
```

### The shorter way
```
function method_3(address _address, uint _age, string _first_name, string _last_name) {
    
    instructors[_address] = Instructor(_age, _first_name, _last_name);
    instructorAccounts.push(_address) - 1;
}
```

The readable and shorter way are similar to how you instantiate in Rust (if you are familiar with this language).

### How to access values inside a Struct ?


### Structs, Mappings and Arrays: the good mix
Structs work really well with mappings and arrays, although it is a bit complex initially to get used to it. Some good things to know about Structs when the two previously cited:
* Structs can be used inside mappings and arrays as ValueType.
* Structs can contain themselves mappings and arrays.
* A struct can contain a dynamic sized array of its own type.

### Use Structs as ValueTypes in mappings.
The declaration below is a mapping that reference each Instructor by their ethereum address.

```
mapping(address => Instructor) instructors;
```

You can lookup a specific instructor with their ethereum address and retrieve their age, first name and last name.

We would need to return a list of all the instructors. The following array will store all the instructor's addresses.

```
address[] public instructorAccounts;
```


### Storage, Memory and Calldata with Structs
If you assign the Struct type to a local variable, you always have to mention the data location: storage, memory or calldata (stack).
* If storage is specified, this will only stores a reference. It will not copy the struct.

However, assignments to the members of the local variable will write and modify the state.

### Other things to know about Structs
You can use the Solidity built-in function delete on a variable of Struct type to reset all its members. This will act like if the variable would be declared as a Struct without assigning any value to its members.

### What you can't do with Structs ?

* Recursive Structs: a Struct is said recursive when it contains within its definition a member variable in its own type.

We naturally understand why this is not possible: a struct can't contain a member of its own type because the size of the struct has to be finite.

The Remix compiler would throw an ErrorType as displayed below.

Let's use the example above to better understand the problem.

Imagine we want to create a new player: Christiano Ronaldo ! We would then create a new variable _Christiano_Ronaldo and assign to him some values.

Each FootballPlayer (the struct), has a name (a string), an age (an uint) and a mentor (another FootballPlayer, so the struct itself).

The problem here is that since every football player has a mentor being a football player itself, the definition of the variable would never end.

[Insert image here]

For a bit of fun, the in-depth look at our variable _Christiano_Ronaldo would look something like this:


[insert image here]

* A Struct can't be used as a KeyType of a mapping. Otherwise, the compiler will throw the following error: "Parser Error: Expected Elementary type name for mapping key type"



## References

* https://www.youtube.com/watch?v=t0DE5ytTcvs