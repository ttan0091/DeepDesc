function minter_burn(uint256 amount) external onlyMinters {
        super._burn(msg.sender, amount);
        emit TokenBurned(msg.sender, amount);
    }