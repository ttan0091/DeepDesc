function batchBurnFrom(Layout storage s, address sender, address[] calldata owners, uint256[] calldata values) internal {
        uint256 length = owners.length;
        require(length == values.length, "ERC20: inconsistent arrays");

        if (length == 0) return;

        uint256 totalValue;
        unchecked {
            for (uint256 i; i != length; ++i) {
                address from = owners[i];
                uint256 value = values[i];

                if (from != sender) {
                    s.decreaseAllowance(from, sender, value);
                }

                if (value != 0) {
                    uint256 balance = s.balances[from];
                    uint256 newBalance = balance - value;
                    require(newBalance < balance, "ERC20: insufficient balance");
                    s.balances[from] = newBalance;
                    totalValue += value; // totalValue cannot overflow if the individual balances do not underflow
                }

                emit Transfer(from, address(0), value);
            }

            if (totalValue != 0) {
                s.supply -= totalValue; // _totalSupply cannot underfow as balances do not underflow
            }
        }
    }