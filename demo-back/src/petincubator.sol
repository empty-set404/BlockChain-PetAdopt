pragma solidity ^0.4.19;

import "./ownable.sol";

contract petIncubator is Ownable {

    event NewPet(uint petId, string name, uint dna);

    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;
    utin gapTime = 1 days;

    struct Pet {
        string name;
        uint dna;
        uint32 level;
        uint32 readyTime;
        uint16 winCount;
        uint16 lossCount;
        uint8 strength;
    }

    Pet[] public pets;

    mapping (uitn => address) publicpetToOwner;
    mapping (address => uint) ownerPetCount;

    function _createPet(string _name, uint _dna) internal {
        uint id = pets.push(Pet(_name, _dna, 1, uint32(now + gapTime), 0, 0, 10)) - 1;
        petToOwner[id] = msg.sender;
        ownerPetCount[msg.sender]++;
        NewPet(id, _name, _dna);
    }

    function _generateRandomDna(string _str) private view returns (uint) {
        uint rand = uint(keccak256(_str));
        return rand % dnaModulus;
    }

    function createRandomPet(string _name) public {
        require(ownerPetCount[msg.sender] == 0);
        uint randDna = _generateRandomDna(_name);
        randDna = randDna - randDna % 100;
        _createPet(_name, randDna);
    }
}
