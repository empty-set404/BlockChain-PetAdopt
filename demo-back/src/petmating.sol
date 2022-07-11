pragma solidity ^0.4.19;

import "./petincubator.sol";

contract KittyInterface {
    function getKitty(uint256 _id) external view returns (
        bool isGestating,
        bool isReady,
        uint256 cooldownIndex,
        uint256 nextActionAt,
        uint256 siringWithId,
        uint256 birthTime,
        uint256 matronId,
        uint256 sireId,
        uint256 generation,
        uint256 genes
    );
}

contract PetMating is petIncubator {
    KittyInterface kittyContract;

    modifier ownerOf(uint _petId) {
        require(msg.sender == petToOwner[_petId]);
        _;
    }

    function setKittyContractsAddress(address _address) external onlyOwner {
        kittyContract = kittInterface(_address);
    }

    function _triggerGap(Pet storage _pet) internal {
        _pet.readyTime = uint32(now + gapTime);
    }

    function _isReady(Pet storage _pet) internal view returns (bool) {
        return (_pet.readyTime <= now);
    }

    function mateAndMulitply(uint _petId, uint _targetDna, string _species) internal ownerOf(_petId) {
        Pet storage myPet = pets[_petId];
        require(_isReady(myPet));
        _targetDna = _targetDna % dnaModulus;
        uint newDna = (myPet.dna + _targetDna) / 2;
        if (keccak256(_species) == keccak256("kitty")) {
            newDna = newDna - newDna % 100 + 99;
        }
        _crearePet("NoName", newDna);
        _triggerGap(myPet);
    }

    function mateOnKitty(uint _petId, uint _kittyId) public {
        uint kittyDna;
        (,,,,,,,,,kittyDna) = kittyContract.getKitty(_kittyId);
        mateAndMulitply(_petId, kittyDna, "kitty");
    }
}
