; getItemUnitsStorage = 30 instructions                             v----- = top of the stack                            v----- = bottom of the stack
PUSH1 00   ; 1) manipulate + prepare the stack                      00 | 01 | 60 | selector
DUP1       ;                                                        00 | 00 | 01 | 60 | selector
PUSH1 00   ;                                                        00 | 00 | 00 | 01 | 60 | selector    
DUP1       ;                                                        00 | 00 | 00 | 00 | 01 | 60 | selector
DUP5       ;                                                        01 | 00 | 00 | 00 | 00 | 01 | 60 | selector
DUP2       ;                                                        00 | 01 | 00 | 00 | 00 | 00 | 01 | 60 | selector
MSTORE     ; 2.1) prepare the memory for hashing (1)                00 | 00 | 00 | 00 | 01 | 60 | selector 
PUSH1 20   ;                                                        20 | 00 | 00 | 00 | 00 | 01 | 60 | selector
ADD        ;                                                        20 | 00 | 00 | 00 | 01 | 60 | selector
SWAP1      ;                                                        00 | 20 | 00 | 00 | 01 | 60 | selector
DUP2       ;                                                        20 | 00 | 20 | 00 | 00 | 01 | 60 | selector
MSTORE     ; 2.2) prepare the memory for hashing (2)                20 | 00 | 00 | 01 | 60 | selector
PUSH1 20   ;                                                        20 | 20 | 00 | 00 | 01 | 60 | selector
ADD        ;                                                        40 | 00 | 00 | 01 | 60 | selector
PUSH1 00   ;                                                        00 | 40 | 00 | 00 | 01 | 60 | selector
SHA3       ; 3) compute the storage number to load via hashing      hash | 00 | 00 | 01 | 60 | selector
SWAP1      ;                                                        00 | hash | 00 | 01 | 60 | selector
POP        ;                                                        hash | 00 | 01 | 60 | selector
DUP1       ;                                                        hash | hash | 00 | 01 | 60 | selector
PUSH1 00   ;                                                        00 | hash | hash | 00 | 01 | 60 | selector
ADD        ;                                                        hash | hash | 00 | 01 | 60 | selector
SLOAD.     ; 4) load mapping value from storage                     value | hash | 00 | 01 | 60 | selector
SWAP2
POP
POP
SWAP2
SWAP1
POP
JUMP
JUMPDEST