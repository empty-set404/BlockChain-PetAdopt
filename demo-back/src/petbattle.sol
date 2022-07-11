pragma solidity ^0.4.19;

import "./pethelper.sol";

contract PetBattle is PetHelper {
    uint randNonce = 0;
    uint battleVictoryProbability = 60;

    function randMod(uint _modulus) internal returns(uint) {
        randNonce++;
        return uint(keccak256(now, msg.sender, randNonce)) % _modulus;
    }

    function battle(uint _petId, uint _targetId) external ownerOf(_petId) {
        Pet storage myPet = pets[_petId];
        Pet storage enemyPet = pets[_targetId];
        uint rand = randMod(100);
        if (rand <= battleVictoryProbability) {
            myPet.winCount++;
            myPet.level++;
            enemyPet.lossCount++;
            enemyPet.strength = enemyPet.strength - 2 < 0 ? 0 :  enemyPet.strength - 2;
            if (myPet.strength > 0) {
                mateAndMulitply(_petId, enemyPet.dna, "pet");
            }
        } else {
            myPet.lossCount++;
            myPet.strength = myPet.strength - 2 < 0 ? 0 :  myPet.strength - 2;
            enemyPet.winCount++;
            _triggerGap(myPet);
        }
    }
}
