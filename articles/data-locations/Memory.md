# Interacting with memory

## `MSTORE`

## `MLOAD`


## `MSIZE`

The `MSIZE` opcode might make you think that it returns the actual size (in bytes) of data stored in memory. It does not.

One way to understand the msize opcode in Solidity is by looking directly at the [Solidity C++ source code](https://github.com/ethereum/solidity/blob/develop/libevmasm/SemanticInformation.cpp#L193).

![image](https://user-images.githubusercontent.com/31145285/180866698-be9c1226-f420-4174-87e6-5d371e44dbb3.png)

The  `MSIZE` opcode returns the highest byte offset that was accessed in memory in the current execution environment (= largest accessed memory index). The size will always be a multiple of word (32 bytes).

See this example below.

```solidity
pragma solidity ^0.8.0;

contract TestingMsize {

    function test() public pure returns (uint256 freeMemBefore, uint256 freeMemAfter, uint256 memorySize) {
        // before allocating new memory
        assembly {
            freeMemBefore := mload(0x40)
        }

        bytes memory data = hex"cafecafecafecafecafecafecafecafecafecafecafecafecafecafecafecafe";

        // after allocating new memory
        assembly {
            // freeMemAfter = freeMemBefore + 32 bytes for length of data + data value (32 bytes long)
            // = 128 (0x80) + 32 (0x20) + 32 (0x20) = 0xc0
            freeMemAfter := mload(0x40)

            // now we try to access something further in memory than the new free memory pointer :)
            let whatIsInThere := mload(freeMemAfter)

            // now msize will return 224.
            memorySize := msize()
        }
    }

}
```

See the details of the `MSIZE` opcode on [evm.codes](https://www.evm.codes/).

# `memory` references as functions parameters

## A string passed as a function argument

For the following Solidity code:

```solidity
function test(string memory input) public {
    // ...
}
```

When a parameter is given the data location `memory`, the EVM perform the following steps:

1. Load the string offset from the calldata (to know where the string is inside the calldata)
2. Load the string length onto the stack

    2.1. calculate the calldata offset where the string length is located

    2.2. use this offset to load the string length from the calldata into the stack

    2.3. calculate the offset to load the string itself.

3. allocate some memory space to move the string out of the calldata into memory

    3.1. load the free memory pointer
    
    3.2. allocate some memory space (64 bytes), by calculating the new free memory pointer.

    3.3. update the free memory pointer (= write the new free memory pointer into 0x80 offset in memory).

4. transfer the string from the calldata to the memory

    4.1. write the string length in memory using MSTORE
    4.2. write the string itself in memory using CALLDATACOPY

5. Finally clear the stack with some SWAP and POP instructions


```asm
; 1) load the string offset from the calldata
213 JUMPDEST
214 PUSH1 00
216 DUP3            ; put back 4 on top of the stack
217 ADD
218 CALLDATALOAD    ; load the calldata starting at offset 4 (= excluding function selector). Will return 0x20, the offset where the string starts (length + string itself).

; additional checks to ensure that the string offset is the maximum offset allowed (which is the max uint64 value basically)

; 2) Load the string length onto the stack

; 2.1) calculate the offset where the first part (= string length) is located in the calldata (0x20 + 0x04).
243 JUMPDEST       
244 PUSH2 00ff     
247 DUP5            
248 DUP3           
249 DUP6            ; prepare the stack by putting back relevant items up onto the stack
250 ADD             ; result = 0x24 = 4 bytes (the function selectored discarded from the calldata) + the offset (0x20) previously loaded.
251 PUSH2 0091      
254 JUMP

; 2.2) load the string length from the calldata onto the stack
166 JUMPDEST
167 DUP2
168 CALLDATALOAD

; 2.3) calculate the offset to load the string itself
169 PUSH2 00b6
172 DUP5
173 DUP3
174 PUSH1 20
176 DUP7
177 ADD

; 3) allocate some memory space to move the string out of the calldata into memory

; 3.1) load the current free memory pointer
291 JUMPDEST
292 PUSH1 00
294 PUSH1 40
296 MLOAD     ; load the free memory pointer

; 3.2) calculate the new free memory pointer 
; new free memory pointer = current memory pointer + 64 bytes (32 bytes for string length + 32 bytes for string word)
374 JUMPDEST
375 DUP2
376 ADD

; 3.3) update the free memory pointer
405 JUMPDEST
406 DUP1
407 PUSH1 40
409 MSTORE    ; update the free memory pointer

; 4) write the string in memory

; 4.1) write the string length in memory using MSTORE
098 JUMPDEST
099 SWAP1
100 POP
101 DUP3      ; put the string length 0x12 (18 characters) back on top of the stack
102 DUP2      ; put the allocated memory pointer back on top of the stack
103 MSTORE    ; store the string length in memory at memory offset 0x80

; 4.2) copy the string from the calldata into the memory using CALLDATACOPY opcode
350 JUMPDEST
351 DUP3
352 DUP2
353 DUP4
354 CALLDATACOPY    ; copy the string from the calldata into memory
```

### CALLDATACOPY

Here the string passed as a parameter in the calldata is copied in memory via the opcode CALLDATACOPY.

The EVM uses this opcode giving it 3 parameters:
1) the destination (offset) in memory
2) the source (offset) in the calldata
3) the number of bytes to copy

The parameters are the following in our scenario:
1) memory destination = 0xa0 = the place in memory that was allocated for our string (*find the sequence of opcodes that does this*)
2) source in calldata = 0x44 = 68 bytes (4 bytes selector + 32 bytes for the offset + 32 bytes for the string length, this is where the string start)
3) number of bytes to copy = 0x12 = 18 in decimal = the number of characters in our string

```asm
298 JUMPDEST        ; 44 | a0 | 12 | 0173 | a0 | 80 | ...
299 DUP3            ; 12 | 44 | a0 | 12 | 0173 | a0 | 80 | ...
300 DUP2            ; 44 | 12 | 44 | a0 | 12 | 0173
301 DUP4            ; a0 | 44 | 12 | 44 | a0 | 12 | 0173
302 CALLDATACOPY    ; 44 | a0 | 12 | 0173
303 PUSH1 00        ; 00 | 44 | a0 | 12 | 0173
305 DUP4            ; 12 | 00 | 44 | a0 | 12 | 0173
306 DUP4            ; a0 | 12 | 00 | 44 | a0 | 12 | 0173
307 ADD             ; b2 | 00 | 44 | a0 | 12 | 0173
308 MSTORE          ; 44 | a0 | 12 | 0173     I am not sure what it does here. It just write "0" at location b2 in memory. Probably irrelevant
309 POP             ; clear the stack  
310 POP
311 POP
312 JUMP
```

The rest of the opcodes are about clearing the stack


## Calldata

```
0xf9fbd554
  0000000000000000000000000000000000000000000000000000000000000020
  0000000000000000000000000000000000000000000000000000000000000012
  416c6c2041626f757420536f6c69646974790000000000000000000000000000
```

## Full opcodes (details)


<details>
  <summary>Click to see the details of the debugged opcodes</summary>

```asm
; Free memory pointer
000 PUSH1 80    
002 PUSH1 40
004 MSTORE
005 CALLVALUE
006 DUP1
007 ISZERO
008 PUSH2 0010
011 JUMPI           ; all of that is just creating + allocating the free memory pointer + checking if no value is passed in the call (because the function is not payable). If there are some value passed in the call, it will revert. If not the case, it will jump to instruction 16 (0x10)

; calldata verification
016 JUMPDEST
017 POP
018 PUSH1 04
020 CALLDATASIZE
021 LT              ; this ensure that the calldata is at least 4 bytes (= a function selector). If it's not the case, it will jump to instruction nb 43 (0x4b), at which the EVM has instructions to revert
022 PUSH2 002b

; function dispatcher
025 JUMPI
026 PUSH1 00
028 CALLDATALOAD
029 PUSH1 e0
031 SHR
032 DUP1
033 PUSH4 f9fbd554
038 EQ
039 PUSH2 0030      ; dispatcher -> load the calldata, shift the calldata to extract only the first 4 bytes and go to the function
042 JUMPI

048 JUMPDEST
049 PUSH2 004a
052 PUSH1 04
054 DUP1
055 CALLDATASIZE
056 SUB             ; remove 4 bytes (the function selector) to the size of the calldata? (not sure if correct)
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
204 JUMPI           ; ??? not sure what this section does

; 1. load the string offset from the calldata
213 JUMPDEST
214 PUSH1 00
216 DUP3            ; here we put back 4 on top of the stack
217 ADD
218 CALLDATALOAD    ; here we load the calldata starting at offset/index 4 (so excluding the selector). It will return 0x20, the offset where the string value (length + string itself) start
219 PUSH8 ffffffffffffffff
228 DUP2            ; duplicate the string offset retrieved (0x20)
229 GT              ; check that the string offset is not greater than 0xffffffffffffffff (18_446_744_073_709_551_615), which is basically the max value allowed for a uint64 (= bytes8)
230 ISZERO          ; ??? not sure what the rest is
231 PUSH2 00f3      ; JUMP Destination = instruction nb 243 (0x00f3)
234 JUMPI   ; JUMP if the result of the previous comparison is 0

; 2.1) calculate calldata offset where the string length is located
243 JUMPDEST        ; 20 | 00 | 04 | 64 | 45 | 4a | f9fbd554
244 PUSH2 00ff      ; ff | 20 | 00 | 04 | 64 | 45 | 4a | f9fbd554
247 DUP5            ; 64 | ff | 20 | 00 | 04 | 64 | 45 | 4a | f9fbd554
248 DUP3            ; 20 | 64 | ff | 20 | 00 | 04 | 64 | 45 | 4a | f9fbd554
249 DUP6            ; 04 | 20 | 64 | ff | 20 | 00 | 04 | 64 | 45 | 4a | f9fbd554
250 ADD             ; 24 | 64 | ff | 20 | 00 | 04 | 64 | 45 | 4a | f9fbd554        Here we add 4 bytes (the selector we discard in the calldata) + the offset we previously loaded (0x20). We obtain 0x24
251 PUSH2 0091      
254 JUMP            ; here we jump at instruction 145

; Don't understand what this check is used for here
145 JUMPDEST        
146 PUSH1 00        ; 00 | 24 | 64 | ff | 20 | 00 | 04 | 64 | 45 | 4a | f9fbd554
148 DUP3            ; 64 | 00 | 24 | 64 | ff | 20 | 00 | 04 | 64 | 45 | 4a | f9fbd554
149 PUSH1 1f        ; 1f | 64 | 00 | 24 | 64 | ff | 20 | 00 | 04 | 64 | 45 | 4a | f9fbd554
151 DUP4            ; 24 | 1f | 64 | 00 | 24 | 64 | ff | 20 | 00 | 04 | 64 | 45 | 4a | f9fbd554    36 bytes (0x24) (32 bytes + 4 bytes for the selector) + 31 (0x1f, what does that represent?)
152 ADD             ; 43 | 64 | 00 | 24 | 64 | ff | 20 | 00 | 04 | 64 | 45 | 4a | f9fbd554
153 SLT             ; 01 | 00 | 24 | 64 | ff | 20 | 00 | 04 | 64 | 45 | 4a | f9fbd554      signed less than comparison. We check if 0x43 (= 67) is less than (<) 0x64 (=100). I think 100 is the whole calldata (4bytes selector + offset + length + string as 32 bytes word). I am not sure what this is used for.
154 PUSH2 00a6      ; 00a6 | 01 | 00 | 24 | 64 | ff | 20 | 00 | 04 | 64 | 45 | 4a | f9fbd554   JUMP to instruction nb 166 if it is 1 (the comparison before was true)
157 JUMPI   

; 2.2) load the string length from the calldata into the stack
; 2.3) calculate the offset to load the string itself
166 JUMPDEST        ; 00 | 24 | 64 | ff | 20 | 00 | 04 | 64 | 45 | 4a | f9fbd554
167 DUP2            ; 24 | 00 | 24 | 64 | ff | 20 | 00 | 04 | 64 | 45 | 4a | f9fbd554
168 CALLDATALOAD    ; 12 | 00 | 24 | 64 | ff | 20 | 00 | 04 | 64 | 45 | 4a | f9fbd554         Here we have loaded the string length 0x12 (= 18 characters) onto the stack
169 PUSH2 00b6      ; 00b6 | 12 | 00 | 24 | 64 | ff | 20 | 00 | 04 | 64 | 45 | 4a | f9fbd554
172 DUP5            ; 64 | 00b6 | 12 | 00 | 24 | 64 | ff | 20 | 00 | 04 | 64 | 45 | 4a | f9fbd554
173 DUP3            ; 12 | 64 | 00b6 | 12 | 00 | 24 | 64 | ff | 20 | 00 | 04 | 64 | 45 | 4a | f9fbd554
174 PUSH1 20        ; 20 | 12 | 64 | 00b6 | 12 | 00 | 24 | 64 | ff | 20 | 00 | 04 | 64 | 45 | 4a | f9fbd554
176 DUP7            ; 24 | 20 | 12 | 64 | 00b6 | 12 | 00 | 24 | 64 | ff | 20 | 00 | 04 | 64 | 45 | 4a | f9fbd554
177 ADD             ; 44 | 12 | 64 | 00b6 | 12 | 00 | 24 | 64 | ff | 20 | 00 | 04 | 64 | 45 | 4a | f9fbd554           here after manipulating the stack, we obtain 68 (0x44). This will be the next offset probably used to load the string itself?
178 PUSH2 004f      ; 004f | 44 | 12 | 64 | 00b6 | 12 | 00 | 24 | 64 | ff | 20 | 00 | 04 | 64 | 45 | 4a | f9fbd554
181 JUMP            ; JUMP to instruction nb 79 (0x004f)

079 JUMPDEST
080 PUSH1 00        ; more stack manipulation
082 PUSH2 0062
085 PUSH2 005d      ; push number 93 onto the stack (= a JUMP Destination)
088 DUP5
089 PUSH2 012d
092 JUMP
093 JUMPDEST

; Don't understand what this check is used for here
301 JUMPDEST
302 PUSH1 00
304 PUSH8 ffffffffffffffff  ; we are checking something here, but not sure what (?)
313 DUP3
314 GT
315 ISZERO
316 PUSH2 0148    ; push number 328 onto the stack (= a JUMP DESTINATION)
319 JUMPI

; Prepare some JUMP Destinations on the stack
328 JUMPDEST
329 PUSH2 0151    ; push number 337 onto the stack (= a JUMP DESTINATION)
332 DUP3
333 PUSH2 01e1    ; push 481 onto the stack (= a JUMP DESTINATION)
336 JUMP
337 JUMPDEST

; more stack manipulations, but not sure what happen
481 JUMPDEST
482 PUSH1 00  
484 PUSH1 1f      ; 1f | 00
486 NOT           ; what does that do?
487 PUSH1 1f
489 DUP4
490 ADD
491 AND
492 SWAP1
493 POP
494 SWAP2
495 SWAP1
496 POP 
497 JUMP          ; JUMP to instruction number 337

; not relevant
337 JUMPDEST
338 SWAP1
339 POP
340 PUSH1 20
342 DUP2
343 ADD
344 SWAP1
345 POP
346 SWAP2
347 SWAP1
348 POP
349 JUMP
350 JUMPDEST

; JUMP somewhere else in the bytecode (not relevant)
093 JUMPDEST
094 PUSH2 0108
097 JUMP

; JUMP somewhere else in the bytecode (not relevant)
264 JUMPDEST
265 PUSH1 00
267 PUSH2 0112
270 PUSH2 0123
273 JUMP

; 3) allocate memory to pass the string from the calldata to the memory
; 3.1) load the current free memory pointer
291 JUMPDEST
292 PUSH1 00
294 PUSH1 40
296 MLOAD     ; load the free memory pointer
297 SWAP1
298 POP
299 SWAP1
300 JUMP

; not relevant
274 JUMPDEST
275 SWAP1
276 POP
277 PUSH2 011e
280 DUP3
281 DUP3
282 PUSH2 016d
285 JUMP

; not relevant
365 JUMPDEST
366 PUSH2 0176
369 DUP3
370 PUSH2 01e1
373 JUMP

; not relevant
481 JUMPDEST
482 PUSH1 00
484 PUSH1 1f
486 NOT
487 PUSH1 1f
489 DUP4
490 ADD        
491 AND
492 SWAP1
493 POP
494 SWAP2
495 SWAP1
496 POP
497 JUMP

; 3.2) calculate the new free memory pointer
374 JUMPDEST
375 DUP2
376 ADD        ; probably add 64 bytes (string length + string word), so that we can update the free memory pointer
377 DUP2
378 DUP2      ; not sure to understand what is happening here
379 LT
380 PUSH8 ffffffffffffffff      ; same as before, max offset value allowed is max value of uint64
389 DUP3
390 GT
391 OR
392 ISZERO
393 PUSH2 0195
396 JUMPI

; 3.3) update the free memory pointer
405 JUMPDEST
406 DUP1
407 PUSH1 40
409 MSTORE    ; update the free memory pointer (before was)
410 POP
411 POP
412 POP
413 JUMP

; some stack manipulation (not relevant)
286 JUMPDEST
287 SWAP2
288 SWAP1
289 POP
290 JUMP

; 4.1) write the string length in memory using MSTORE
098 JUMPDEST
099 SWAP1
100 POP
101 DUP3      ; put the string length 0x12 (18 characters) back on top of the stack
102 DUP2      ; put the allocated memory pointer back on top of the stack
103 MSTORE    ; store the string length in memory at memory offset 0x80
104 PUSH1 20
106 DUP2
107 ADD
108 DUP5
109 DUP5
110 DUP5
111 ADD
112 GT
113 ISZERO
114 PUSH2 007e
117 JUMPI

126 JUMPDEST
127 PUSH2 0089
130 DUP5
131 DUP3
132 DUP6
133 PUSH2 015e
136 JUMP

; 4.2) copy the string from the calldata into the memory using CALLDATACOPY opcode
350 JUMPDEST
351 DUP3
352 DUP2
353 DUP4
354 CALLDATACOPY    ; copy the string from the calldata into memory
355 PUSH1 00
357 DUP4
358 DUP4
359 ADD
360 MSTORE        ; write "0x00" at offset 0xb2 in memory. This is probably to match with the free memory pointer
361 POP
362 POP
363 POP
364 JUMP          ; jump at instruction number 137 (0x89)

; stack clearing -> 18 items on the stack
137 JUMPDEST
138 POP
139 SWAP4
140 SWAP3
141 POP
142 POP     
143 POP
144 JUMP  ; 14 items left on the stack

; more stack clearing -> 13 items left on the stack (previous item was taken for JUMP instruction)
182 JUMPDEST
183 SWAP2
184 POP
185 POP
186 SWAP3
187 SWAP2
188 POP
189 POP
190 JUMP     ; 9 items left on the stack

; more stack clearing -> 8 items left on the stack
255 JUMPDEST 
256 SWAP2
257 POP
258 POP
259 SWAP3
260 SWAP2
261 POP
262 POP
263 JUMP    ; 4 items left on the stack

; more stack clearing -> 3 items left on the stack
069 JUMPDEST  
070 PUSH2 004c
073 JUMP
074 JUMPDEST
077 POP
078 JUMP  ; 2 items left on the stack

074 JUMPDEST
075 STOP
```

</details>


# `memory` references inside functions body


## A string defined in memory inside the function body

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

```asm
054 PUSH1 00    ;         00 | 33 | f8a88fd6d
056 PUSH1 40    ;         40 | 00 | 33 | f8a88fd6d
058 MLOAD       ;         80 | 00 | 33 | f8a88fd6d
```

Because we are going to write a string in memory, we have to update our free memory pointer.
A string, according to the ABI specification is made of two parts: the string length + the string itself.
The next step is then to update the free memory pointer, to say to the EVM "I am going to write 2 x 32 bytes words in memory. So the free memory pointer is now going to be 64 bytes further.

What the opcodes do in the next steps is simple. It:
1. duplicate the current value of the free memory pointer = 0x80
2. add 0x40 to it (= 64 in decimals, for 64 bytes)
3. push 0x40 (= the location of the free memory pointer again) onto the stack
4. update the free memory pointer with the new value via MSTORE

```asm
059 DUP1        ;         80 | 80 | 00 | 33 | f8a88fd6d
060 PUSH1 40    ;         40 | 80 | 80 | 00 | 33 | f8a88fd6d
062 ADD         ;         c0 | 80 | 00 | 33 | f8a88fd6d
063 PUSH1 40    ;         40 | 80 | 00 | 33 | f8a88fd6d
065 MSTORE      ;         80 | 00 | 33 | f8a88fd6d
```

This way, we have allocated memory for the string, at the position 0x80 in memory.

The next step is to write the string length in memory. Our string "All About Solidity" contains 18 characters (including whitespaces).

In the next steps, the EVM duplicate the location in memory that we have allocated for the string (0x80).
It then push the number 18 (= 0x12 in hex) onto the stack, this corresponding the string length.
Finally, it duplicates the allocated memory pointer being burried 2 levels from the top of the stack via DUP2, and write the string length via MSTORE

```asm
066 DUP1        ;         80 | 80 | 00 | 33 | f8a88fd6d
067 PUSH1 12    ;         12 | 80 | 80 | 00 | 33 | f8a88fd6d
069 DUP2        ;         80 | 12 | 80 | 80 | 00 | 33 | f8a88fd6d
070 MSTORE      ;         80 | 80 | 00 | 33 | f8a88fd6d
```

The next step is to write the string in memory. Since 0x80 holds the string length, the string itself will be written will be written in the next 32 bytes word.
To achieve this, the EVM push 0x20 (= 32 in decimal) and add it to the existing 0x80

0x20 + 0x80 = 0xa0 -> this will be the next location in memory where the string will be written.

The EVM then push a very long value as you can see. Each byte correspond to the utf8 hex values.
Paste the string here, and you will get the result "All About Solidity"
https://onlineutf8tools.com/convert-hexadecimal-to-utf8

DUP2 enables to remove the memory pointer on top of the stack, so that it can be provided as the first argument to MSTORE.
Finally MSTORE write the string in memory at location 0xa0

```asm
071 PUSH1 20    ;         20 | 80 | 80 | 00 | 33 | f8a88fd6d
073 ADD         ;         a0 | 80 | 00 | 33 | f8a88fd6d
074 PUSH32 416c6;041626f757420536f6c69646974790000000000000000000000000000 //        416c6c2041626f757420536f6c69646974790000000000000000000000000000 |  a0 | 80 | 00 | 33 | f8a88fd6d
107 DUP2        ;         a0 | 416c6c2041626f757420536f6c69646974790000000000000000000000000000 |  a0 | 80 | 00 | 33 | f8a88fd6d
108 MSTORE      ;         a0 | 80 | 00 | 33 | f8a88fd6d
```

Finally, the EVM clear up the stack to go back to the initial location (a jump destination JUMPDEST), at counter 0x33 (= 51 in decimal)
The last two instructions at counter 051 and 052 simplify are the jump destination and the instruction STOP, telling the EVM to stop running the current instruction process.

```asm
109 POP         ;         80 | 00 | 33 | f8a88fd6d
110 SWAP1       ;         00 | 80 | 33 | f8a88fd6d
111 POP         ;         80 | 33 | f8a88fd6d
112 POP         ;         33 | f8a88fd6d
113 JUMP
; --
051 JUMPDEST
052 STOP
```

---




# The Return statement

Any `return` statement uses the underlying EVM opcode `return`. The `return` opcode always accept 2 parameters: the offset in memory + the number of bytes to return. Therefore, return statement in Solidity always operate on the memory, whatever their data type.


## A number as return parameter

Let's understand the steps performed by the EVM to return a simple number from a function.

1. Put the number to return onto the stack
2. Load the free memory pointer
3. Write the number 8 in memory at the free memory pointer
4. Return 32 bytes from memory at the free memory pointer location (where we previously wrote)

<details>
  <summary>Details</summary>

```asm
072 PUSH1 00
074 PUSH1 08  ; push the number 8 onto the stack
076 SWAP1
077 POP
078 SWAP1
079 JUMP

051 JUMPDEST
052 PUSH1 40
054 MLOAD   ; load the free memory pointer
055 PUSH1 3e
057 SWAP2
058 SWAP1
059 PUSH1 5d
061 JUMP

093 JUMPDEST
094 PUSH1 00
096 PUSH1 20
098 DUP3
099 ADD
100 SWAP1
101 POP
102 PUSH1 70
104 PUSH1 00
106 DUP4
107 ADD
108 DUP5
109 PUSH1 50
111 JUMP

080 JUMPDEST
081 PUSH1 57
083 DUP2
084 PUSH1 76
086 JUMP

118 JUMPDEST
119 PUSH1 00
121 DUP2
122 SWAP1
123 POP
124 SWAP2
125 SWAP1
126 POP
127 JUMP

087 JUMPDEST
088 DUP3
089 MSTORE    ; write the number 8 in memory at the free memory pointer
090 POP
091 POP
092 JUMP

112 JUMPDEST
113 SWAP3
114 SWAP2
115 POP
116 POP
117 JUMP

062 JUMPDEST
063 PUSH1 40
065 MLOAD     
066 DUP1
067 SWAP2
068 SUB     ; need to understand this calculation here
069 SWAP1 
070 RETURN  ; return 32 bytes from memory at memory location 0x80
```

</details>

# A string as a returned parameter

<details>
  <summary>Details</summary>

```asm
079 PUSH1 60
081 PUSH1 40
083 MLOAD     ; load the free memory pointer
084 DUP1
085 PUSH1 40
087 ADD
088 PUSH1 40
090 MSTORE    ; allocate some memory for the returned string, so update the free memory pointer
091 DUP1
092 PUSH1 12  ; push 0x12 (= 18) onto the stack. This is the string length (number of characters in the string)
094 DUP2  
095 MSTORE    ; store the string length in memory
096 PUSH1 20
098 ADD
099 PUSH32 416c6c2041626f757420536f6c69646974790000000000000000000000000000     ; push the utf8 encoded characters of the string onto the stack
132 DUP2
133 MSTORE   ; store the string itself in memory
134 POP
135 SWAP1
136 POP
137 SWAP1
138 JUMP  ; jump at instruction number 56 (0x38)

056 JUMPDEST
057 PUSH1 40
059 MLOAD   ; load the free memory pointer (don't know why)
060 PUSH2 0045    
063 SWAP2
064 SWAP1
065 PUSH2 00c4
068 JUMP    ; jump at instruction number 196 (0x00c4)

; don't know what it is happening here
196 JUMPDEST
197 PUSH1 00
199 PUSH1 20
201 DUP3
202 ADD
203 SWAP1
204 POP
205 DUP2
206 DUP2
207 SUB
208 PUSH1 00
210 DUP4
211 ADD
212 MSTORE
213 PUSH2 00de
216 DUP2
217 DUP5
218 PUSH2 008b
221 JUMP

; stack manipulation
139 JUMPDEST
140 PUSH1 00
142 PUSH2 0096
145 DUP3
146 PUSH2 00e6
149 JUMP

; don't know what is happening here
230 JUMPDEST
231 PUSH1 00
233 DUP2
234 MLOAD
235 SWAP1
236 POP
237 SWAP2
238 SWAP1
239 POP
240 JUMP

; don't know what is happening here
150 JUMPDEST
151 PUSH2 00a0
154 DUP2
155 DUP6
156 PUSH2 00f1
159 JUMP

241 JUMPDEST
242 PUSH1 00
244 DUP3
245 DUP3
246 MSTORE
247 PUSH1 20
249 DUP3
250 ADD
251 SWAP1
252 POP
253 SWAP3
254 SWAP2
255 POP
256 POP
257 JUMP

; Return the string located at specific location in memory
069 JUMPDEST
070 PUSH1 40
072 MLOAD
073 DUP1
074 SWAP2
075 SUB
076 SWAP1
077 RETURN
```


</details>

# Memory between function calls

Between function calls, a fresh instance of memory is always obtained. This means a **clear and empty memory instance**. This is due to the fact that memory is not persistent between function call.

Take a look at the following two contracts, when debugging a transaction made from the `Source` contract to the `Target` contract.

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Source {

    Target target;

    constructor(Target _target) {
        target = _target;
    }

    function testIn(string memory input) public {
        target.testTarget(input);
    }   

}

contract Target {

    function testTarget(string memory input) public {
        // do whatever
    }
}
```

![image](https://user-images.githubusercontent.com/31145285/181069249-40c9f50f-8954-4b71-bf32-9fce3efec9ed.png)

Let's test this scenario to understand what is happening. We are going to deploy and interact with both contracts via the Remix IDE.

We will use the Javascript VM and compile the contracts with solc 0.8.7 without any optimization enabled or runs.

1. deploy `Target` contract.
2. deploy `Source` contract, providing the `address` of `Target` as a constructor argument.
3. on the `Source` contract, run the function `callTarget()`
4. on the console, click on the **Debug** button.

Let's now analyze each opcodes.

```asm
054 PUSH1 00
056 DUP1
057 SLOAD ; load the value for `target` state variable from storage
058 SWAP1
059 PUSH2 0100  ; more stack manipulation
062 EXP
063 SWAP1
064 DIV
065 PUSH20 ffffffffffffffffffffffffffffffffffffffff
086 AND
087 PUSH20 ffffffffffffffffffffffffffffffffffffffff
108 AND
109 PUSH4 82692679  ; 1. load the function selector of doSomething()
114 PUSH1 40
116 MLOAD       ; 2. load the free memory pointer
117 DUP2
118 PUSH4 ffffffff
123 AND
124 PUSH1 e0    ; 3.1 push 224 (0x0e) on the stack
126 SHL         ; 3.2 shift the functin selector of doSomething() left by 224 bits, so to prepare the calldata to be sent to the Target contract
127 DUP2
128 MSTORE      ; 4. store the calldata to be sent to the Target contract in memory, at memory location pointed to by the free memory pointer
129 PUSH1 04
131 ADD
132 PUSH1 00
134 PUSH1 40
136 MLOAD
137 DUP1
138 DUP4
139 SUB
140 DUP2
141 PUSH1 00
143 DUP8
144 DUP1
145 EXTCODESIZE ; get the size of the code of the Target address, to ensure it is a contract 
146 ISZERO      ; if the codesize at Target address is zero, then the address is not a contract, so we will stop execution later
147 DUP1
148 ISZERO
149 PUSH1 9c
151 JUMPI 
156 JUMPDEST
157 POP
158 GAS
159 CALL        ; 5. make the external call to the Target contract, with the calldata to be sent to it (`doSomething()`)
```

When debugging this transaction in Remix, pay attention to what the memory looks like before and after passing the `CALL` opcode.

_Before the `CALL` opcode_

![memory-before-function-call](https://user-images.githubusercontent.com/31145285/181080368-d95e958e-bde9-40ee-978f-4cea0dd7b1e6.png)

_After the `CALL` opcode_

![memory-after-function-call](https://user-images.githubusercontent.com/31145285/181080396-e2acb747-86da-4194-b7b7-11b270d4c939.png)

# References

- [Solidity Documentation - Layout in Memory](https://docs.soliditylang.org/en/v0.8.15/internals/layout_in_memory.html)
- [evm.codes](https://www.evm.codes/)
- [Ethereum StackExchange - When should I use calldata and when should I use memory?](https://stackoverflow.com/a/33839164/8245387)
- [Ethereum StackExchange - Understanding MLOAD Assembly function](https://ethereum.stackexchange.com/questions/9603/understanding-mload-assembly-function/9610)
- [OpenZeppelin Blog - Ethereum In Depth Part II](https://blog.openzeppelin.com/ethereum-in-depth-part-2-6339cf6bddb9/)
- [Solwaify (outdoteth) - Memory is better for composability than calldata](https://github.com/outdoteth/solwaifu/blob/a9fa6fe5891ae81867e1f96cfe019d54084d9054/src/ERC20Deployer.sol#L14)
- [In Ethereum Solidity, what is the purpose of the `memory` keyword? - StackOverflow](https://stackoverflow.com/questions/33839154/in-ethereum-solidity-what-is-the-purpose-of-the-memory-keyword)

## MSIZE
- https://www.evm.codes/about#memoryexpansion
- https://ethereum.stackexchange.com/a/28457/21704
