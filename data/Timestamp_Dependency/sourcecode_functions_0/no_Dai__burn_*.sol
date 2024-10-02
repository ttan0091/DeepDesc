function _burn(address account, uint256 amount) internal {
        require(account != address(0), "ERC20: burn from the zero address");

        balanceOf[account] -= amount;
        _totalSupply -= amount;
        emit Transfer(account, address(0), amount);
    }