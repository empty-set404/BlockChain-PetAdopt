pragma solidity ^0.4.19;

import "./petmating.sol";

contract PetHelper is PetMating {
    uint levelUpFree = 0.001 ether;

    modifier aboveLevel(uint _level, uint _petId) {
        require(pets[_petId].level >= _level);
        _;
    }

    function withdraw() external onlyOwner {
//        this.balance 将返回当前合约存储了多少以太
        owner.transfer(this.balance);
    }

    function setLevelUpFee(uint _fee) external onlyOwner {
        levelUpFree = _fee;
    }

    function levelUp(uint _petId) external payable {
        require(msg.sender == levelUpFree);
        pets[_petId].level++;
        pets[_petId].strength = 10;
    }

    function changeName(uint _petId, string _newName) external aboveLevel(2, _petId) ownerOf(_petId) {
        pets[_petId].name = _newName;
    }

    function changeDna(uint _petId, uint _newDna) external aboveLevel(20, _petId) ownerOf(_petId) {
        pets[_petId].dna = _newDna;
    }

    function getPetsByOwner(address _owner) external view returns(uint[]) {
        uint[] memory result = new uint[](ownerPetCount[_owner]);
        uint counter = 0;
        for (uint i = 0; i < pets.length; i++) {
            if (petToOwner[i] == _owner) {
                result[counter] = i;
                counter++;
            }
        }
        return result;
    }
}
