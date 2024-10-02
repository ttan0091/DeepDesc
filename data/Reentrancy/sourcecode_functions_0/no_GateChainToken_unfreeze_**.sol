function unfreeze(uint256 value) public onlyActive returns (bool success) {
        if (freezeOf[msg.sender] < value) {
            revert();
        }
		if (value <= 0) {
		    revert();
		}
        freezeOf[msg.sender] = freezeOf[msg.sender].sub(value);
		balances[msg.sender] = balances[msg.sender].add(value);
        emit Unfreeze(msg.sender, value);
        return true;
    }