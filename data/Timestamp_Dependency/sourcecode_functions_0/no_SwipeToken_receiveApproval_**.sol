function receiveApproval(address from, uint256 tokens, address token, bytes memory data) public;

}



// ----------------------------------------------------------------------------

// Owned contract

// ----------------------------------------------------------------------------

contract Owned {

    address public owner;

    event OwnershipTransferred(address indexed _from, address indexed _to);


    constructor() public {

        owner = msg.sender;

    }


    modifier onlyOwner {

        require(msg.sender == owner);

        _;

    }


    function transferOwnership(address newOwner) public onlyOwner {

        owner = newOwner;
        emit OwnershipTransferred(owner, newOwner);

    }

}