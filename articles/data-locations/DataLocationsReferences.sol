// SPDX-License-Identifier: Apache-2
pragma solidity ^0.8.0;

contract DataLocationsReferences {

    bytes someData;

    function storageReferences() public {
        bytes storage a = someData;
        bytes memory b;
        bytes calldata c;

        // storage variables can reference storage variables as long as the storage reference they refer to is initialized.
        bytes storage d = a;

        // if the storage reference it refers to was not initiliazed, it will lead to an error
        //  "This variable (refering to a) is of storage pointer type and can be accessed without prior assignment, 
        //  which would lead to undefined behaviour."
        // basically you cannot create a storage reference that points to another storage reference that points to nothing
        // f -> e -> (nothing) ???
        /// bytes storage e;
        /// bytes storage f = e;

        // storage pointers cannot point to memory pointers (whether the memory pointer was initialized or not
        /// bytes storage x = b;
        /// bytes memory r = new bytes(3);
        /// bytes storage s = r;

        // storage pointer cannot point to a calldata pointer (whether the calldata pointer was initialized or not).
        /// bytes storage y = c;
        /// bytes calldata m = msg.data;
        /// bytes storage n = m;
    }

    function memoryReferences() public {
        bytes storage a = someData;
        bytes memory b;
        bytes calldata c;

        // this is valid. It will copy from storage to memory
        bytes memory d = a;

        // this is invalid since the storage pointer x is not initialized and does not point to anywhere.
        /// bytes storage x;
        /// bytes memory y = x;

        // this is valid too. `e` now points to same location in memory than `b`;
        // if the variable `b` is edited, so will be `e`, as they point to the same location
        // same the other way around. If the variable `e` is edited, so will be `b`
        bytes memory e = b;

        // this is invalid, as here c is a calldata pointer but is uninitialized, so pointing to nothing.
        /// bytes memory f = c;

        // a memory reference can point to a calldata reference as long as the calldata reference
        // was initialized and is pointing to somewhere in the calldata.
        // This simply result in copying the offset in the calldata pointed by the variable reference
        // inside the memory
        bytes calldata g = msg.data[10:];
        bytes memory h = g;

        // this is valid. It can copy the whole calldata (or a slice of the calldata) in memory
        bytes memory i = msg.data;
        bytes memory j = msg.data[4:16];
    }

    function calldataReferences() public {
        bytes storage a = someData;
        bytes memory b;
        bytes calldata c;

        // it's probably the same than storage.
        // calldata pointers can only reference to the actual calldata or other calldata pointers.
    }
}
