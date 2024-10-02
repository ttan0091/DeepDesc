function transferAndCall(address to, uint value, bytes calldata data) external override returns (bool) {
        require(to != address(0) || to != address(this));
        
        uint256 balance = balanceOf[msg.sender];
        require(balance >= value, "WERC10: transfer amount exceeds balance");

        balanceOf[msg.sender] = balance - value;
        balanceOf[to] += value;
        emit Transfer(msg.sender, to, value);

        return ITransferReceiver(to).onTokenTransfer(msg.sender, value, data);
    }