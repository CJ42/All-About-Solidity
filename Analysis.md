# A string defined in memory inside the function body

For the Solidity code:

```solidity
function test() public {
    string memory test = "All About Solidity";
}
```
```asm
051 JUMPDEST
052 STOP
053 JUMPDEST    
054 PUSH1 00    
056 PUSH1 40    
058 MLOAD       
059 DUP1
060 PUSH1 40
062 ADD
063 PUSH1 40
065 MSTORE
066 DUP1
067 PUSH1 12
069 DUP2
070 MSTORE
071 PUSH1 20
073 ADD
074 PUSH32 416c6c2041626f757420536f6c69646974790000000000000000000000000000
107 DUP2
108 MSTORE
109 POP
110 SWAP1
111 POP
112 POP
113 JUMP
```
When we start, the stack looks like this:
```
33 | f8a88fd6d
```

The EVM performs 5 main steps here:

1. Get the free memory pointer
2. Allocate memory + update the new free memory pointer
3. Write the string length in memory
4. Write the string in memory
5. Clear the stack and stop execution

We first load the free memory pointer located at 0x40 in memory
Our free memory pointer tell us that the first free place in memory is at 0x80. This is what is on top of our stack

054 PUSH1 00    //         00 | 33 | f8a88fd6d
056 PUSH1 40    //         40 | 00 | 33 | f8a88fd6d
058 MLOAD       //         80 | 00 | 33 | f8a88fd6d

Because we are going to write a string in memory, we have to update our free memory pointer.
A string, according to the ABI specification is made of two parts: the string length + the string itself.
The next step is then to update the free memory pointer, to say to the EVM "I am going to write 2 x 32 bytes words in memory. So the free memory pointer is now going to be 64 bytes further.

What the opcodes do in the next steps is simple. It:
1. duplicate the current value of the free memory pointer = 0x80
2. add 0x40 to it (= 64 in decimals, for 64 bytes)
3. push 0x40 (= the location of the free memory pointer again) onto the stack
4. update the free memory pointer with the new value via MSTORE

059 DUP1        //         80 | 80 | 00 | 33 | f8a88fd6d
060 PUSH1 40    //         40 | 80 | 80 | 00 | 33 | f8a88fd6d
062 ADD         //         c0 | 80 | 00 | 33 | f8a88fd6d
063 PUSH1 40    //         40 | 80 | 00 | 33 | f8a88fd6d
065 MSTORE      //         80 | 00 | 33 | f8a88fd6d

This way, we have allocated memory for the string, at the position 0x80 in memory.

The next step is to write the string length in memory. Our string "All About Solidity" contains 18 characters (including whitespaces).

In the next steps, the EVM duplicate the location in memory that we have allocated for the string (0x80).
It then push the number 18 (= 0x12 in hex) onto the stack, this corresponding the string length.
Finally, it duplicates the allocated memory pointer being burried 2 levels from the top of the stack via DUP2, and write the string length via MSTORE

066 DUP1        //         80 | 80 | 00 | 33 | f8a88fd6d
067 PUSH1 12    //         12 | 80 | 80 | 00 | 33 | f8a88fd6d
069 DUP2        //         80 | 12 | 80 | 80 | 00 | 33 | f8a88fd6d
070 MSTORE      //         80 | 80 | 00 | 33 | f8a88fd6d

The next step is to write the string in memory. Since 0x80 holds the string length, the string itself will be written will be written in the next 32 bytes word.
To achieve this, the EVM push 0x20 (= 32 in decimal) and add it to the existing 0x80

0x20 + 0x80 = 0xa0 -> this will be the next location in memory where the string will be written.

The EVM then push a very long value as you can see. Each byte correspond to the utf8 hex values.
Paste the string here, and you will get the result "All About Solidity"
https://onlineutf8tools.com/convert-hexadecimal-to-utf8

DUP2 enables to remove the memory pointer on top of the stack, so that it can be provided as the first argument to MSTORE.
Finally MSTORE write the string in memory at location 0xa0

071 PUSH1 20    //         20 | 80 | 80 | 00 | 33 | f8a88fd6d
073 ADD         //         a0 | 80 | 00 | 33 | f8a88fd6d
074 PUSH32 416c6c2041626f757420536f6c69646974790000000000000000000000000000 //        416c6c2041626f757420536f6c69646974790000000000000000000000000000 |  a0 | 80 | 00 | 33 | f8a88fd6d
107 DUP2        //         a0 | 416c6c2041626f757420536f6c69646974790000000000000000000000000000 |  a0 | 80 | 00 | 33 | f8a88fd6d
108 MSTORE      //         a0 | 80 | 00 | 33 | f8a88fd6d

Finally, the EVM clear up the stack to go back to the initial location (a jump destination JUMPDEST), at counter 0x33 (= 51 in decimal)
The last two instructions at counter 051 and 052 simplify are the jump destination and the instruction STOP, telling the EVM to stop running the current instruction process.

109 POP         //         80 | 00 | 33 | f8a88fd6d
110 SWAP1       //         00 | 80 | 33 | f8a88fd6d
111 POP         //         80 | 33 | f8a88fd6d
112 POP         //         33 | f8a88fd6d
113 JUMP
--
051 JUMPDEST
052 STOP

---

# A string passed as a function argument

For the following Solidity code:

```solidity
function test(string memory input) public {
    // ...
}
```

```
000 PUSH1 80    
002 PUSH1 40
004 MSTORE
005 CALLVALUE
006 DUP1
007 ISZERO
008 PUSH2 0010
011 JUMPI           // all of that is just creating + allocating the free memory pointer + checking if no value is passed in the call (because the function is not payable). If there are some value passed in the call, it will revert. If not the case, it will jump to instruction 16 (0x10)

016 JUMPDEST
017 POP
018 PUSH1 04
020 CALLDATASIZE
021 LT              // this ensure that the calldata is at least 4 bytes (= a function selector). If it's not the case, it will jump to instruction nb 43 (0x4b), at which the EVM has instructions to revert
022 PUSH2 002b

025 JUMPI
026 PUSH1 00
028 CALLDATALOAD
029 PUSH1 e0
031 SHR
032 DUP1
033 PUSH4 f9fbd554
038 EQ
039 PUSH2 0030      // dispatcher -> load the calldata, shift the calldata to extract only the first 4 bytes and go to the function
042 JUMPI

048 JUMPDEST
049 PUSH2 004a
052 PUSH1 04
054 DUP1
055 CALLDATASIZE
056 SUB             // remove 4 bytes (the function selector) to the size of the calldata? (not sure if correct)
057 DUP2
058 ADD
059 SWAP1
060 PUSH2 0045
063 SWAP2
064 SWAP1
065 PUSH2 00bf
068 JUMP

191 JUMPDEST
192 PUSH1 00
194 PUSH1 20
196 DUP3
197 DUP5
198 SUB
199 SLT
200 ISZERO
201 PUSH2 00d5
204 JUMPI           // ??? not sure what this section does

213 JUMPDEST
214 PUSH1 00
216 DUP3            // here we put back 4 on top of the stack
217 ADD
218 CALLDATALOAD    // here we load the calldata starting at offset/index 4 (so excluding the selector). It will return 0x20, the offset where the string value (length + string itself) start
219 PUSH8 ffffffffffffffff
228 DUP2
229 GT
230 ISZERO          // ??? not sure what the rest is
231 PUSH2 00f3
234 JUMPI

243 JUMPDEST        // 20 | 00 | 04 | 64 | 45 | 4a | f9fbd554
244 PUSH2 00ff      // ff | 20 | 00 | 04 | 64 | 45 | 4a | f9fbd554
247 DUP5            // 64 | ff | 20 | 00 | 04 | 64 | 45 | 4a | f9fbd554
248 DUP3            // 20 | 64 | ff | 20 | 00 | 04 | 64 | 45 | 4a | f9fbd554
249 DUP6            // 04 | 20 | 64 | ff | 20 | 00 | 04 | 64 | 45 | 4a | f9fbd554
250 ADD             // 24 | 64 | ff | 20 | 00 | 04 | 64 | 45 | 4a | f9fbd554        Here we add 4 bytes (the selector we discard in the calldata) + the offset we previously loaded (0x20). We obtain 0x20
251 PUSH2 0091      
254 JUMP            // here we jump at instruction 145

145 JUMPDEST        
146 PUSH1 00        // 00 | 24 | 64 | ff | 20 | 00 | 04 | 64 | 45 | 4a | f9fbd554
148 DUP3            // 64 | 00 | 24 | 64 | ff | 20 | 00 | 04 | 64 | 45 | 4a | f9fbd554
149 PUSH1 1f        // 1f | 64 | 00 | 24 | 64 | ff | 20 | 00 | 04 | 64 | 45 | 4a | f9fbd554
151 DUP4            // 24 | 1f | 64 | 00 | 24 | 64 | ff | 20 | 00 | 04 | 64 | 45 | 4a | f9fbd554    36 bytes (0x24) (32 bytes + 4 bytes for the selector) + 31 (0x1f, what does that represent?)
152 ADD             // 43 | 64 | 00 | 24 | 64 | ff | 20 | 00 | 04 | 64 | 45 | 4a | f9fbd554
153 SLT             // 01 | 00 | 24 | 64 | ff | 20 | 00 | 04 | 64 | 45 | 4a | f9fbd554      signed less than comparison. We check if 0x43 (= 67) is less than (<) 0x64 (=100). I think 100 is the whole calldata (4bytes selector + offset + length + string as 32 bytes word). I am not sure what 
154 PUSH2 00a6      // 00a6 | 01 | 00 | 24 | 64 | ff | 20 | 00 | 04 | 64 | 45 | 4a | f9fbd554   JUMP to instruction nb 166 if it is 1 (the comparison before was true)
157 JUMPI   

166 JUMPDEST        00 | 24 | 64 | ff | 20 | 00 | 04 | 64 | 45 | 4a | f9fbd554
167 DUP2            24 | 00 | 24 | 64 | ff | 20 | 00 | 04 | 64 | 45 | 4a | f9fbd554
168 CALLDATALOAD    12 | 00 | 24 | 64 | ff | 20 | 00 | 04 | 64 | 45 | 4a | f9fbd554         Here we have loaded the string length 0x12 (= 18 characters)
169 PUSH2 00b6      00b6 | 12 | 00 | 24 | 64 | ff | 20 | 00 | 04 | 64 | 45 | 4a | f9fbd554
172 DUP5            64 | 00b6 | 12 | 00 | 24 | 64 | ff | 20 | 00 | 04 | 64 | 45 | 4a | f9fbd554
173 DUP3            12 | 64 | 00b6 | 12 | 00 | 24 | 64 | ff | 20 | 00 | 04 | 64 | 45 | 4a | f9fbd554
174 PUSH1 20        20 | 12 | 64 | 00b6 | 12 | 00 | 24 | 64 | ff | 20 | 00 | 04 | 64 | 45 | 4a | f9fbd554
176 DUP7            24 | 20 | 12 | 64 | 00b6 | 12 | 00 | 24 | 64 | ff | 20 | 00 | 04 | 64 | 45 | 4a | f9fbd554
177 ADD             44 | 12 | 64 | 00b6 | 12 | 00 | 24 | 64 | ff | 20 | 00 | 04 | 64 | 45 | 4a | f9fbd554           here after maniipulating the stakc, we obtain 68 (0x44). This will be the next offset probably used to load the string itself?
178 PUSH2 004f      004f | 44 | 12 | 64 | 00b6 | 12 | 00 | 24 | 64 | ff | 20 | 00 | 04 | 64 | 45 | 4a | f9fbd554
181 JUMP            // JUMP to instruction nb 79 (0x004f)

079 JUMPDEST
080 PUSH1 00        // more stack manipulation shits
082 PUSH2 0062
085 PUSH2 005d
088 DUP5
089 PUSH2 012d
092 JUMP
093 JUMPDEST
```


0xf9fbd554
  0000000000000000000000000000000000000000000000000000000000000020
  0000000000000000000000000000000000000000000000000000000000000012
  416c6c2041626f757420536f6c69646974790000000000000000000000000000