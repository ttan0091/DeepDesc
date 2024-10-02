function burn(address from,uint256 value,string memory btcAddress,string memory proof, bytes32 taskHash)
    public whenNotPaused returns(bool){
        require(itemAddressExists(OPERATORHASH, msg.sender), "wrong operator");
        uint256 status = logic.burnLogic(from,value,btcAddress,proof,taskHash, msg.sender, operatorRequireNum);
        if (status == 1){
           emit Burning(from, value, proof,btcAddress, msg.sender);
        }else if (status == 3) {
           emit Burning(from, value, proof,btcAddress,  msg.sender);
           emit Burned(from, value, proof,btcAddress);
           emit Transfer(from, address(0x0),value);
        }
        return true;
    }