function _transfer(address _sender, address _recipient, uint256 _amount) private {
        require(_sender != address(0), "BaseToken: transfer from the zero address");
        require(_recipient != address(0), "BaseToken: transfer to the zero address");

        if (inPrivateTransferMode) {
            require(isHandler[msg.sender], "BaseToken: msg.sender not whitelisted");
        }

        _updateRewards(_sender);
        _updateRewards(_recipient);

        balances[_sender] = balances[_sender].sub(_amount, "BaseToken: transfer amount exceeds balance");
        balances[_recipient] = balances[_recipient].add(_amount);

        if (nonStakingAccounts[_sender]) {
            nonStakingSupply = nonStakingSupply.sub(_amount);
        }
        if (nonStakingAccounts[_recipient]) {
            nonStakingSupply = nonStakingSupply.add(_amount);
        }

        emit Transfer(_sender, _recipient,_amount);
    }