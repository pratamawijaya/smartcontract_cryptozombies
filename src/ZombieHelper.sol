pragma solidity ^0.8.28;

import "./ZombieFeeding.sol";

contract ZombieHelper is ZombieFeeding {
    uint256 levelUpFee = 0.01 ether; // 0.01 ETH

    function levelUp(uint256 _zombieId) external payable {
        require(msg.value == levelUpFee);
        zombies[_zombieId].level++;
    }

    function withdraw() external onlyOwner {
        address payable _owner = payable(address(uint160(owner())));
        _owner.transfer(address(this).balance);
    }

    function setLevelUpFee(uint256 _fee) external onlyOwner {
        levelUpFee = _fee;
    }

    modifier aboveLevel(uint256 _level, uint256 _zombieId) {
        require(zombies[_zombieId].level >= _level);
        _;
    }

    function changeName(uint256 _zombieId, string calldata _newName)
        external
        aboveLevel(2, _zombieId)
        ownerOf(_zombieId)
    {
        zombies[_zombieId].name = _newName;
    }

    function changeDna(uint256 _zombieId, uint256 _newDna) external aboveLevel(20, _zombieId) ownerOf(_zombieId) {
        zombies[_zombieId].dna = _newDna;
    }

    // view functions don't cost any gas when they're called externally by a user.
    // This is because view functions don't actually change anything on the blockchain – they only read the data.

    // If a view function is called internally from another function in the same contract that is not a view function,
    // it will still cost gas.
    function getZombiesByOwner(address _owner) external view returns (uint256[] memory) {
        // One of the more expensive operations in Solidity is using storage — particularly writes.
        // In order to keep costs down, you want to avoid writing data to storage except when absolutely necessary.
        // Sometimes this involves seemingly inefficient programming logic — like rebuilding an array in memory every
        // time a function is called instead of simply saving that array in a variable for quick lookups.
        uint256[] memory result = new uint256[](ownerZombieCount[_owner]);

        uint256 counter = 0;
        for (uint256 i = 0; i < zombies.length; i++) {
            if (zombieToOwner[i] == _owner) {
                result[counter] = i;
                counter++;
            }
        }
        return result;
    }
}
