# All About Variables - Solidity 

Variable visibility.
Like functions, variables can be assigned a specific visibility in Solidity. They can be defined as public , private or internal (Only the external specifier is not available for state variables).
Here is an example of a Solidity code :

```
pragma solidity ^0.5.10;
contract Test {
 
    uint internal internal_number;
    
    uint private private_number;
    
    uint public public_number;
    
    function set_internal_number(uint _value) public {
        internal_number = _value;
    }
    
    function set_private_number(uint _value) public {
        private_number = _value;
    }
    
    function set_public_number(uint _value) public {
        public_number = _value;
    }
    
    
    function get_internal_number() public view returns (uint) {
        return internal_number;
    }
    
    function get_private_number() public view returns (uint) {
        return private_number;
    }
    
    function get_public_number() public view returns (uint) {
        return public_number;
    }
    
    
}
contract Test2 is Test {
    
    function addInternal(uint _value) public view returns (uint) {
        return _value + internal_number;
    }
    // You will get `undeclared identifier` error message here
    function addPrivate(uint _value) public view returns (uint) {
        return _value + private_number;
    }
    
    function addPublic(uint _value) public view returns (uint) {
        return _value + public_number;
    }
}
```