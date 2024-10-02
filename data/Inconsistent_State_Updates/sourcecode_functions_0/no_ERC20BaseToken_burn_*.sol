function burn(uint256 amount) external returns (bool) {
        _burn(msg.sender, amount);
        return true;
    }