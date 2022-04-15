pragma solidity >=0.8;

import "./ownable.sol";

contract ZombieFactory is Ownable{

     //events
    //way for your contract to communicate that something hapened on the blockchain to your app front-end
    event NewZombie(uint zombieId, string name, uint dna);

    //state variables
    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;

    //structs
    struct Zombie {
        string name;
        uint dna;
    }

    //If you declare as public, Solidity will automatically create a Getter method
    Zombie[] public zombies;
    
    mapping(uint => address) public zombieToOwner;
    mapping(address=> uint) ownerZombieCount;

    //two ways to pass an argument to a Solidity function:
        // By value, which means that the Solidity compiler creates a new copy of the parameter's value
        // and passes it to your function. This modifies the value without changing the INITIAL parameters.

        //By reference, which means that the function is called with a reference to the original variable.
        //This modifies the INITIAL variable.

    //Start function parameter variables with an underscore _

    function _createZombie(string memory _name, uint _dna) internal {
        uint id = zombies.push(Zombie(_name, _dna)) - 1;
        zombieToOwner[id] = msg.sender;
        ownerZombieCount[msg.sender]++;
        emit NewZombie(id, _name, _dna);
    }


    //view functions don't change state in Solidity, i.e. it doesn't change any values or write anything
    //pure functions don't access any data in the app (its return value depends only on its parameters)
     function _generateRandomDna(string memory _str) private view returns (uint) {
        uint rand = uint(keccak256(abi.encodePacked(_str)));
        return rand % dnaModulus;
    }

        function createRandomZombie(string memory _name) public {
        require(ownerZombieCount[msg.sender]==0);
        uint randDna = _generateRandomDna(_name);
        _createZombie(_name, randDna);
    }

   
}

