function mint(address to, uint256 value, string memory proof,bytes32 taskHash) public whenNotPaused returns(bool){
        require(itemAddressExists(OPERATORHASH, msg.sender), "wrong operator");
        uint256 status = logic.mintLogic(value,to,proof,taskHash, msg.sender, operatorRequireNum);
        if (status == 1){
            emit Minting(to, value, proof, msg.sender);
        }else if (status == 3) {
            emit Minting(to, value, proof, msg.sender);
            emit Minted(to, value, proof);
            emit Transfer(address(0x0),to,value);
        }
        return true;
    }