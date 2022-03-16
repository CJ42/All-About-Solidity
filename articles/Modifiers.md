# Solidity Tutorial : all about Modifiers

"Modifier can be used to amend the semantics of functions in a declarative way." (Solidity Docs).

In Solidity, Modifiers express what actions are occuring in a declarative and readable manner. They are a bit similar to the decorator pattern used in Object Oriented Programming.

# What is exactly a Modifier in Solidity ?
According to the Solidity Docs, a Modifier is a"compile-time source code roll-up". It aims to change the behaviour of the functions to which it is attached.
For instance, automatically checking a condition prior to executing the function (this is mainly what they are used for). If the function does not meet the modifier requirement, an exception is thrown.
**Modifiers** are useful because they reduce code redundancy. You can re-use the same modifier in multiple functions if you are checking for the same condition over and over.


# How to create and use Modifiers ?
Modifiers can be created (declared) as follow:
[Github code here]


# What is the _; symbol ?
Modifiers must have the symbol _; within their body in order to execute. It is mandatory !

This symbol is called a merge wildcard. It merges the function code with the modifier code at the _; location.

In other terms, the body of the function (to which the modifier is attached to) will be inserted where the special symbol  _; appears in the modifier's definition. The Solidity docs states "returns the flow of execution to the original function code".

However, be aware of the place where the symbol _; is placed in your modifier declaration. This will decide if the function is executed before, in between or after.

You can place the _; at the beginning, middle or the end. In practice, (especially until you understand how modifiers work really well), the safest usage pattern is to place the _; at the end. In this scenario, the modifier serves for consistent validation check, so to check a condition upfront and then carry on.

[add the code from the booknote here]

# Pass arguments to Modifiers.
[copy the three code examples from the booknote]
* See other examples on CryptoZombie, chapter 8 and 9.
* Look at the modifier nonReentrant from Open Zeppelin.

# Apply multiple Modifiers to a function.
Multiple modifiers can be applied to a function by specifying them in a white space separated list in the function definition. They will be evaluated and executed in the order they are presented, so from left to right.

# Advanced: use Modifiers with getters.
You can use modifiers in conjunction with getter functions. The idea is that clients, other contracts and other internal functions can use the getter function to fetch / check the individual concerns (if they want to).

Functions that should be guarded by a certain combination of concerns can use the modifier so the logic of it all (and your intent) remains very clear to reviewers.

[add code example from the booknote]

The example above enables to keep the code organised while making the state discoverable to clients and ensure potentially that a complex logic is consistently applied.

You can then have several functions like above which have some tricky steps. Hopefully, they can be understood as individual concerns. Then when used in combination, you can reduce repetition and improve readability with a modifier.

# Advanced: use Modifiers with Enums

[paste the code example from the booknote]