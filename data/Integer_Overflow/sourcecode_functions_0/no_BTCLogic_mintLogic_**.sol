function mintLogic(uint256 value,address to,string calldata proof,
        bytes32 taskHash, address supportAddress, uint256 requireNum)
        external onlyCaller returns(uint256){
        require(to != address(0), "cannot be burned from zero address");
        require(value > 0, "value need > 0");
        require(taskHash == keccak256((abi.encodePacked(to,value,proof))),"taskHash is wrong");
        uint256 status = supportTask(MINTTASK, taskHash, supportAddress, requireNum);

        if( status == TASKDONE){
            uint256 totalSupply = store.getTotalSupply();
            uint256 balanceTo = store.balanceOf(to);
            balanceTo = balanceTo.safeAdd(value);
            totalSupply = totalSupply.safeAdd(value);
            store.setBalance(to,balanceTo);
            store.setTotalSupply(totalSupply);
        }
        return status;
    }