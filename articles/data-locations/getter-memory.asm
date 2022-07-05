; getItemUnitsMemory = 47 instructions
PUSH1 00
DUP1
PUSH1 00
DUP1
DUP5
DUP2
MSTORE
PUSH1 20
ADD
SWAP1
DUP2
MSTORE
PUSH1 20
ADD
PUSH1 00
SHA3
PUSH1 40  ; <------ additional opcodes start here                             40 | hash | 00 | 00 | 01 | 60 | selector
MLOAD     ; allocate memory by: 1) loading the free memory pointer            80 (=ptr) | hash | 00 | 00 | 01 | 60 | selector
DUP1      ; 2) reserve the free memory pointer by duplicating it              80 (=ptr) | 80 (=ptr) | hash | 00 | 00 | 01 | 60 | selector
PUSH1 20  ;                                                                   20 | 80 (=ptr) | 80 (=ptr) | hash | 00 | 00 | 01 | 60 | selector
ADD       ; 3) compute the new free memory pointer                            a0 | 80 (=ptr) | hash | 00 | 00 | 01 | 60 | selector
PUSH1 40  ;                                                                   40 | a0 | 80 (=ptr) | hash | 00 | 00 | 01 | 60 | selector
MSTORE    ; 4) store the new free memory pointer                              80 (=ptr) | hash | 00 | 00 | 01 | 60 | selector
SWAP1     ;                                                                   hash | 80 (=ptr) | 00 | 00 | 01 | 60 | selector
DUP2      ;                                                                   80 | hash | 80 (=ptr) | 00 | 00 | 01 | 60 | selector
PUSH1 00  ;                                                                   00 | 80 | hash | 80 (=ptr) | 00 | 00 | 01 | 60 | selector
DUP3      ;                                                                   hash | 00 | 80 | hash | 80 (=ptr) | 00 | 00 | 01 | 60 | selector
ADD    
SLOAD     ; 5) load mapping value from storage
DUP2 
MSTORE    ; 6) store mapping value retrieved from storage in memory
POP
POP ; <------------ additonal opcodes end here
SWAP1
POP
DUP1
PUSH1 00
ADD
MLOAD
SWAP2
POP
POP
SWAP2
SWAP1
POP