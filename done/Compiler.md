
# Solidity Tutorial: all about the Compiler

![](https://cdn-images-1.medium.com/max/2600/1*ecaO8ZlRR2_ujfbh864mPA.jpeg)


Today we are looking at the Solidity Compiler from Command Line Interface (CLI)

# Define the compiler version with `pragma`

In Solidity, you define the compiler version using the keyword `pragma solidity` followed by the compiler version. There are different ways to specify the compiler version.

-   stating the version like `0.x.x` . This will say that you are using the **exact version specified**.
-   using the `^` symbol: this will tell the compiler to use either the latest version or the current version specified.
- You can also use the operators `<`, `>`, `<=` and `>=` to specify a range.

# Available output options with the Solidity compiler

```
Output Components:
  --ast                AST of all source files.  
  --ast-json           AST of all source files in JSON format.
  --ast-compact-json   AST of all source files in a compact JSON format.
  --asm                EVM assembly of the contracts.
  --asm-json           EVM assembly of the contracts in JSON format.
  --opcodes            Opcodes of the contracts.
  --bin                Binary of the contracts in hex.
  --bin-runtime        Binary of the runtime part of the contracts in hex.
  --clone-bin          Binary of the clone contracts in hex.
  --abi                ABI specification of the contracts.
  --hashes             Function signature hashes of the contracts.
  --userdoc            Natspec user documentation of all contracts.
  --devdoc             Natspec developer documentation of all contracts.
  --metadata           Combined Metadata JSON whose Swarm hash is stored on-chain.
  --formal             Translated source suitable for formal analysis.
```

Let's have a look to the different options available.

## Abstract Syntax Tree ( flag `--ast` )

[According to the Wikipedia definition]([https://en.wikipedia.org/wiki/Abstract_syntax_tree](https://en.wikipedia.org/wiki/Abstract_syntax_tree)), an AST is :

> the tree representation of the abstract syntactic structure of a source code written in a programming language.

Let's see a really simple example. Create a file `first-contract.sol` and paste the following source code into it :

```solidity
pragma solidity >=0.4.16 <0.7.0;

contract MyFirstContract {

	string name = "your name";
	
}
```

Save it and compile it using the `solc` compiler via the Command Line Interface and the `--ast` option.

```
solc first-contract.sol --ast
``` 

You should obtain the following output :

```
======= first-contract.sol =======
PragmaDirective
   Source: "pragma solidity >=0.4.16 <0.7.0;"
ContractDefinition "MyFirstContract"
   Source: "contract MyFirstContract {\n\n\tstring name = \"your name\";\n}"
  VariableDeclaration "name"
     Type: string storage ref
     Source: "string name = \"your name\""
    ElementaryTypeName string
       Source: "string"
    Literal, token: [no token] value: your name
       Type: literal_string "your name"
       Source: "\"your name\""
```

# References
[_https://ethereum.stackexchange.com/questions/36704/how-to-get-an-output-similar-to-remix-in-solc-woth-opcodes-comments-from-sour_](https://ethereum.stackexchange.com/questions/36704/how-to-get-an-output-similar-to-remix-in-solc-woth-opcodes-comments-from-sour)
