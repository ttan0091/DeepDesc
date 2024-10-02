function burn(uint256 value) external returns (bool) {
        _burn(msg.sender, value);
        return true;
    }