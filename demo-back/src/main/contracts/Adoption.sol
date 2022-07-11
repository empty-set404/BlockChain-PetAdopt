pragma solidity ^0.4.25;

contract Adoption {
    uint8 userIndex;
    mapping(address => uint8) userMapping;
    
    address[8] public adopters;
    
    constructor() public {
        userIndex = 0;
    }
    
    function register(address user) public returns(uint8) {
        if (userMapping[user] > 0) {
            return userMapping[user];
        }
        userIndex++;
        userMapping[user] = userIndex;
        return userIndex;
    }
    
    function login(address user) public view returns(uint8) {
        return userMapping[user];
    }
    
    function adopt(uint petId) public returns(uint) {
        require(petId >= 0 && petId <= 7);
        uint userNotExist =  404;
        if (userMapping[msg.sender] == 0) {
            return userNotExist;
        }
        
        adopters[petId] = msg.sender;
        return petId;
    }
    
    function getAdopters() public view returns (address[8]) {
        return adopters;
    }
}