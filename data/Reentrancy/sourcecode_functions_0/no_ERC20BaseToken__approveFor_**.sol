function _approveFor(address owner, address spender, uint256 amount)
        internal
    {
        require(
            owner != address(0) && spender != address(0),
            "Cannot approve with 0x0"
        );
        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }