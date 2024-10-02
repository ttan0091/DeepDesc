function _addAllowanceIfNeeded(address owner, address spender, uint256 amountNeeded)
        internal
    {
        if(amountNeeded > 0 && !isSuperOperator(spender)) {
            uint256 currentAllowance = _allowances[owner][spender];
            if(currentAllowance < amountNeeded) {
                _approveFor(owner, spender, amountNeeded);
            }
        }
    }