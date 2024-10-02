function decreaseAllowance(Layout storage s, address owner, address spender, uint256 value) internal {
        require(spender != address(0), "ERC20: approval to address(0)");
        uint256 allowance_ = s.allowances[owner][spender];

        if (allowance_ != type(uint256).max && value != 0) {
            unchecked {
                // save gas when allowance is maximal by not reducing it (see https://github.com/ethereum/EIPs/issues/717)
                uint256 newAllowance = allowance_ - value;
                require(newAllowance < allowance_, "ERC20: insufficient allowance");
                s.allowances[owner][spender] = newAllowance;
                allowance_ = newAllowance;
            }
        }
        emit Approval(owner, spender, allowance_);
    }