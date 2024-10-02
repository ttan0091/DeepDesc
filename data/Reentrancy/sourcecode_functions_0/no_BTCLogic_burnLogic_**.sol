function burnLogic(address from, uint256 value,string calldata btcAddress,
        string calldata proof,bytes32 taskHash, address supportAddress, uint256 requireNum)
        external onlyCaller returns(uint256){

        uint256 balance = store.balanceOf(from);
        require(balance >= value,"sender address not have enough HBTC");
        require(value > 0, "value need > 0");
        require(taskHash == keccak256((abi.encodePacked(from,value,btcAddress,proof))),"taskHash is wrong");
        uint256 status = supportTask(BURNTASK, taskHash, supportAddress, requireNum);

        if ( status == TASKDONE ){
            uint256 totalSupply = store.getTotalSupply();
            totalSupply = totalSupply.safeSub(value);
            balance = balance.safeSub(value);
            store.setBalance(from,balance);
            store.setTotalSupply(totalSupply);

        }
        return status;
    }