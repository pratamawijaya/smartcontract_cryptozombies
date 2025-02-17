pragma solidity ^0.8.28;

import "./ZombieHelper.sol";

contract ZombieAttack is ZombieHelper {
    uint256 randNonce = 0;
    uint256 attackVictoryProbability = 70; // 70% chance of winning an attack

    function randMod(uint256 _modulus) internal returns (uint256) {
        randNonce++;
        return uint256(keccak256(abi.encodePacked(block.timestamp, msg.sender, randNonce))) % _modulus;
    }

    function attack(uint256 _zombieId, uint256 _targetId) external onlyOwnerOf(_zombieId) {
        Zombie storage myZombie = zombies[_zombieId];
        Zombie storage enemyZombie = zombies[_targetId];

        uint256 rand = randMod(100);

        if (rand <= attackVictoryProbability) {
            // Attack wins
            myZombie.winCount++;
            myZombie.level++;
            feedAndMultiply(_zombieId, enemyZombie.dna, "zombie");
        } else {
            // Attack loses
            myZombie.lossCount++;
            enemyZombie.winCount++;
            _triggerCooldown(myZombie);
        }
    }
}
