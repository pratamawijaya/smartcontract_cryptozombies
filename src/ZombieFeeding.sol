pragma solidity ^0.8.28;

import "./ZombieFactory.sol";

interface KittyInterface {
    function getKitty(uint256 _id)
        external
        view
        returns (
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

contract ZombieFeeding is ZombieFactory {
    KittyInterface kittyContract;

    // setKittyContractAddress is external, so anyone can call it!
    // That means anyone who called the function could change the address of the CryptoKitties contract,
    // and break our app for all its users.
    //
    // so we need implement Ownable, make the contract has an Owner
    function setKittyContractAddress(address _address) external onlyOwner {
        kittyContract = KittyInterface(_address);
    }

    function feedAndMultiply(uint256 _zombieId, uint256 _targetDna, string memory _species) public {
        require(msg.sender == zombieToOwner[_zombieId]);
        Zombie storage myZombie = zombies[_zombieId];

        _targetDna = _targetDna % dnaModulus;
        uint256 newDna = (myZombie.dna + _targetDna) / 2;

        if (keccak256(abi.encodePacked(_species)) == keccak256(abi.encodePacked("kitty"))) {
            newDna = newDna - newDna % 100 + 99;
        }

        _createZombie("NoName", newDna);
    }

    function feedOnKitty(uint256 _zombieId, uint256 _kittyId) public {
        uint256 kittyDna;
        (,,,,,,,,, kittyDna) = kittyContract.getKitty(_kittyId);
        require(msg.sender == zombieToOwner[_zombieId]);
        feedAndMultiply(_zombieId, kittyDna, "kitty");
    }
}
