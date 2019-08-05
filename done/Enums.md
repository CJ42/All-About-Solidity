# Solidity Tutorial: all about Enums (edit)


The word **Enum** in Solidity stands for Enumerable. They are user defined type that contain human readable names for a set of constants, called member. The data representation for an enum is the same as the one in the C language.


---

## How and When to create an Enum ?
Enum need at least one member.

> A classical example of an Enum would be a deck of card, to represent:
> - The suits (Spades, Clubs, Diamonds, Hearts).
> - The ranks / values (2, 3, 4, 5, 6, 7, 8, 9, 10, Jack, King, Queen, Ace).

```
enum Value { Two, Three, Four, Five, Six, Seven, Eight, Nine, Ten, Jack, King, Queen, Ace }
enum Suit { Spades, Clubs, Diamonds, Hearts }
```

**Note 1 :** you can't use numbers (positive or negative) or boolean (true or false in lowercase) as members for an enum. However, True and False (Capitalised) are accepted.
**Note 2 :** you do not need to end the enum declaration with a semicolon. The compiler uses the semicolon ; and curly brackets {} to determine the scope of the code it's applied to.
- The semicolon determines the end of single instructions or declarations.
- The curly brackets determine the the start and end of arbitrary numbers of instructions or delcarations, like functions, modifiers, structs, enums and the contract itself.
So in the case of the enum I suppose it doesn't need you to specify when the end of the declaration is with a semicolon because it knows from the closing curly bracket.


Therefore, Enums are useful when you have a variable that can take one of a series of predefined values (or out of a small set of possible values).

Here are few other examples of possible enum in Solidity.

```
enum Direction { Left, Right, Straight, Back }
enum ContractType { permanent, temporary, apprentice }
enum State { Created, Locked, Inactive }
enum Status { ON, OFF }
```

> Enums are especially useful when we need to specify the current state / flow of a smart contract. For instance, if a smart contract needs to be turned on in order to be ready to accept deposits from users.


---

## How to define a variable of Enum type ?

```
Status constant defaultstatus = Status.OFF;
```

Using our previous example of the Status enum, you can modify its value as follow:

```
function turnOn() public { status = Status.ON; }
function turnOff() public { status = Status.OFF; }
```

However, this is not a good practice, as it makes our code really repetitive. If we have an enum with a lot of value, we would need to create a function for each possible member of the enum.

**Let's look at our CardDeck example from above :**

> A "standard" deck of playing cards consists of 52 cards in each of the 4 suits of Spades, Hearts, Diamonds, and Clubs. Each suit contains 13 cards: Ace, 2, 3, 4, 5, 6, 7, 8, 9, 10, Jack, Queen, King.

(This would be a lot of functions !)

Imagine now that we want to create a variable myCard , and a function that would store the card Suit and Value that we would like to choose.

We would need to create 52 functions (one for each possible card) to achieve this objective. Or we could create a function pick_a_card() that would accept two inputs : the Suit and the Value we want to select. Let's look at our code example below.

```
contract CardDeck {
enum Suit { Spades, Clubs, Diamonds, Hearts}
enum Value { 
        Two, Three, Four, Five, Six, 
        Seven, Eight, Nine, Ten, 
        Jack, King, Queen, Ace 
    }
struct Card {
        Suit suit;
        Value value;
    }
    
    Card public myCard;
    
    function pick_a_card(Suit _suit, Value _value) public returns (Suit, Value) {
        myCard.suit = _suit;
        myCard.value = _value;
        return (myCard.suit, myCard.value);
    }
}
```

Here we set up a Card struct, a custom type that include two properties with our two previously created enum : Suit and Value.

Then we create our function pick_a_card() with two parameters : aSuit and a Value.

If we deploy our contract on Remix, we will see that the two inputs of our functions are actually integers (see picture below). Why is that ?


> Enum are explicitly convertible to and from all integer type. The options are represented by subsequent unsigned integer values starting from 0, in the order they are defined.
 

Under the hood, enums are integers, not strings. Solidity will automatically handle converting name to ints. In the case of our Suit enum, the index of our members are : 0= Spades, 1= Clubs, 2 = Diamonds, 3 = Hearts. Same for our Value enum : 0 = One, 1 = Two, 2 = Three, etc…

If we would like to pick the Queen of Diamonds, we would use 1, 11 as an input in Remix.

Therefore, we could create our function using integers instead of enums as function parameters. Let's create another function to change the suit of our card.

```
// We can write the two functions as follow :

function changeSuit(uint _value) public {
      myCard.suit = Suit(_value);
}

function changeSuit(Suit _suit) public {
      myCard.suit = _suit;
}
```

## How to access an Enum value ?

There are two methods to access the value of a variable defined as an enum.

### Method 1 : using public to create a getter

```
Status public status;
```

Using the `public` keyword in front of your variable name is probably the safer bet. However, we can do it a bit more complicated to understand exactly the returned value.

### Method 2: return the enum index of a variable

> Enum are explicitly convertible to and from all integer type. The options are represented by subsequent unsigned integer values starting from 0. The integer type uint8 is large enough to hold all enums values. If you have more than 256 values, uint16 will be used and so on.

Enums value are numbered in the order they are defined, starting at 0. To get the value of an Enum type variable, simply write .

```
enum Status { ON, OFF }

Status status;

function getStatus() public view returns (Status) {
    return choice;
}
```

Looking at the Remix Compiler, we would see this.

[image here of the Remix compiler]

You could also return an enum value via a function by writing `uint(status)`.

```
function getStatus() public view returns (uint) {
    return uint(status);
}
```


---

## Use Enums with pure functions

_To be continued..._

---

Also need to describe this example:

```
function get() public pure returns (Status) {
    return Status.OFF;
}
```


---

## Transition through different Enums values

This is a good example of a how to move from different enums type.

```
enum Stages {
   AcceptingBlindedBids,
   RevealBids,
   AnotherStage,
   AreWeDoneYet,
   Finished
}

// This is the current stage.
Stages public stage = Stages.AcceptingBlindedBids;

function nextStage() internal {
   stage = Stages(uint(stage) + 1);
}
```

---

## Enums with modifiers

The next example (from the State Machine Example in the Solidity doc) shows how to use an Enum as part of modifiers.

```
modifier atStage(Stages _stage) {
   require(
       stage == _stage,
       "Function cannot be called at this time."
   );
   _;
}

// Go to the next stage after the function is done.
modifier transitionNext() {
   _;
   nextStage();
}

// Order of the modifiers matters here!
function bid() public payable atStage(Stages.AcceptingBlindedBids) {
        
   // We will not implement that here
}
```

## Represent Enums as Strings

So far, we have seen that `enum` can only be represented by their indices, which are uint . However, it is a pain, and we could make it a bit more friendly.

We could create some getters to return the string representations of our enum. Let's take the example of the Suit enum. Fairly easy to represent, since there is only 4 possible value. We can write a custom function.

```
function getSuitKeyByValue(Suit _suit) internal pure returns (string memory) {
        
     // Error handling for input
     require(uint8(_suit) <= 4);
        
     // Loop through possible options
     if (Suit.Spades == _suit) return "Spades";
     if (Suit.Clubs == _suit) return "Clubs";
     if (Suit.Diamonds == _suit) return "Diamonds";
     if (Suit.Hearts == _suit) return "Hearts";
}

// Retrieve the Suit of our card
function getSuit() public view returns (string memory) {
     Suit _cardSuit = myCard.suit; 
     return getSuitKeyByValue(_cardSuit);
}
```
Let's look at our function `getSuitKeyByValue()`. Our function accept an enum as an argument, the `Suit` of our card. It returns the represent of our card Suit as a string.

First, we check that the value for our Suit enum we enter is not greater than 4 (among the possibilities), otherwise, we throw an error, stop the function running and revert.

Then we loop through all the possible options using an if statement and returns a string representation of each possible enum member.

> We can use only an `if` statement to check via looping since there is no match loop (compared to Javascript or Rust).
> 
> See a similar concept for Rust in the following book p44 :
> Blandy and Orendorff (2018) : _Programming Rust: Fast, Safe system development_, O'Reilly, p44


---

## Use Hash Functions with Enums

Blockchain programming is all about Hashing Functions ! A key component in any Blockchain Project !

```
function checkSuitValueByKey (string memory _mySuit) internal pure returns (Suit) {
        
    // keccak256() only accept bytes as arguments, 
    // so we need explicit conversion
    bytes memory mySuit = bytes(_mySuit);
    bytes32 Hash = keccak256(mySuit);

    // Loop to check
    if (Hash == keccak256("Spades") || Hash == keccak256("spades")) return Suit.Spades;
    if (Hash == keccak256("Clubs") || Hash == keccak256("clubs")) return Suit.Clubs;
    if (Hash == keccak256("Diamonds") || Hash == keccak256("diamonds")) return Suit.Diamonds;
    if (Hash == keccak256("Hearts") || Hash == keccak256("hearts")) return Suit.Hearts;
    revert();
}
   
   
function changeSuit(string memory _suit) public {
    myCard.suit = checkSuitValueByKey(_suit);
}
```

In this example, we have modified our changeSuit() function by enabling to enter a string instead of an uint. The function checkSuitValueByKey() simply enables this feature.

checkSuitValueByKey() takes first our input string and convert it into bytes in order to hash it with keccak256(). We then compare the obtained Hash with the Hash of each possible options : Spades, Clubs, Diamonds and Hearts (We also made the case for lowercase strings, so "spades", "clubs", "diamonds" and "hearts".

If something is found, we return the string representation associated with enum member. If nothing is found, we revert and stop the function execution. Try to enter "Triangle" in Remix in the changeSuit() function and you will see the following error message :

```
" transact to CardDeck.changeSuit errored: VM error: revert. revert The transaction has been reverted to the initial state. "
```


---

## Use Enums as a KeyType in Mappings

> **Warning ! Experimental [see this answer on StackExchange](https://ethereum.stackexchange.com/questions/10108/is-it-possible-to-have-enum-as-a-mapping-key-type)**
 

Normally, enums are not allowed to be used as a KeyType inside mappings. However, a workaround could be used.

Since enums members are represented by uint , we can use uint inside our mapping to a mapping of Enum > Enum. Consider the following code example :

```
enum Suit { Spades, Clubs, Diamonds, Hearts}

enum Value { 
     Two, Three, Four, Five, Six, 
     Seven, Eight, Nine, Ten, 
     Jack, King, Queen, Ace 
}

//       Suit     Value
//        |         |
//        v         v
mapping (uint8 => uint8) cardDeck;
```
---

## What you can't do with Enums in Solidity ?

- Implicit conversion is not allowed !
- Enums can't be used as KeyTypes in mappings !
- You can't return an Enum within a function. This is because Enums types are not part of the ABI.
- You can't define Enums in an interface if your Solidity compiler version is less than 0.5.0.