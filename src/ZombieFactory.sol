pragma solidity ^0.8.28;

import "./Ownable.sol";
contract ZombieFactory is Ownable {
    
    // event
    event zombie_created(uint256 zombieId, string name, uint256 dna);

    // mapping
    mapping(uint256 => address) public zombieToOwner; // maps the owner of a zombie to its ID.
    mapping(address => uint256) ownerZombieCount; // keeps track of how many zombies an owner has.

    uint256 dnaDigits = 16;
    uint256 dnaModulus = 10 ** dnaDigits;

    // Solidity also contains the time units seconds, minutes, hours, days, weeks and years.
    // These will convert to a uint of the number of seconds in that length of time.
    // So 1 minutes is 60, 1 hours is 3600 (60 seconds x 60 minutes),
    // 1 days is 86400 (24 hours x 60 minutes x 60 seconds), etc.
    uint256 cooldownTime = 1 days;

    struct Zombie {
        string name;
        uint256 dna;
        uint32 level;
        uint32 readyTime;
        uint16 winCount;
        uint16 lossCount;
    }

    Zombie[] public zombies;

    // the _name variable should be stored in memory, this is required for all references types
    // such as arrays, structs, mappings and strings.
    function _createZombie(string memory _name, uint256 _dna) internal {
        uint256 id = zombies.length;
        zombies.push(Zombie(_name, _dna, 1, uint32(block.timestamp + cooldownTime), 0, 0));

        zombieToOwner[id] = msg.sender; // set the owner of the newly created zombie.
        ownerZombieCount[msg.sender]++; // increment the count of zombies owned by the sender.

        // emit an event when a new zombie is created.
        // Events are a way for your contract to communicate that something happened on the blockchain to your app's front-end.
        emit zombie_created(id, _name, _dna);
    }

    // helper function for generate random dna from a string input.
    // The below function doesn't actually change state in Solidity — e.g. it doesn't change any values or write anything.
    // So in this case we could declare it as a view function, meaning it's only viewing the data but not modifying it:
    function _generateRandomDna(string memory _str) private view returns (uint256) {
        uint256 rand = uint256(keccak256(abi.encodePacked(_str)));
        return rand % dnaModulus;
    }

    // create a random zombie with the given name. This is the main entry point for creating a new zombie.
    function createRandomZombie(string memory _name) public {
        require(ownerZombieCount[msg.sender] == 0, "You can only have one zombie");
        uint256 randDna = _generateRandomDna(_name);
        _createZombie(_name, randDna);
    }
}
