function transferFrom(address from, address to, uint256 value) external override returns (bool) {
        require(to != address(0) || to != address(this));
        if (from != msg.sender) {
            // _decreaseAllowance(from, msg.sender, value);
            uint256 allowed = allowance[from][msg.sender];
            if (allowed != type(uint256).max) {
                require(allowed >= value, "WERC10: request exceeds allowance");
                uint256 reduced = allowed - value;
                allowance[from][msg.sender] = reduced;
                emit Approval(from, msg.sender, reduced);
            }
        }
        
        uint256 balance = balanceOf[from];
        require(balance >= value, "WERC10: transfer amount exceeds balance");

        balanceOf[from] = balance - value;
        balanceOf[to] += value;
        emit Transfer(from, to, value);
        
        return true;
    }