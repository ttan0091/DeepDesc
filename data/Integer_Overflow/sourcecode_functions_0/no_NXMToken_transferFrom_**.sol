function transferFrom(
        address from,
        address to,
        uint256 value
    )
        public
        canTransfer(to)
        returns (bool)
    {
        require(isLockedForMV[from] < now); // if not voted under governance
        require(value <= _balances[from]);
        require(value <= _allowed[from][msg.sender]);
        _transferFrom(from, to, value);
        return true;
    }