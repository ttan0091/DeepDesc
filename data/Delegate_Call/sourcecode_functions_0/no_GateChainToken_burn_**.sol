function burn(uint256 value) public onlyActive returns (bool success) {
        if (balances[msg.sender] < value) {
            revert();
        }
		if (value <= 0) {
		    revert();
		}
        balances[msg.sender] = balances[msg.sender].sub(value);
        _totalSupply = _totalSupply.sub(value);
        emit Burn(msg.sender, value);
        return true;
    }