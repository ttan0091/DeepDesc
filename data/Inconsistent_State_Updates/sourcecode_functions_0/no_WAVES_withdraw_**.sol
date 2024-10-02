function withdraw(address account) external onlyOwner onlyNotDeprecated override virtual returns (bool) {
    uint256 oldDeposit = _deposits[account];
    uint256 rewardIndex = _rewardIndexForAccount[account];

    if (rewardIndex == _percents.length - 1) {
      uint256 balance = _balances[account];
      require(balance <= _liquidTotalSupply, "subtraction overflow for total supply");
      _liquidTotalSupply = _liquidTotalSupply - balance;

      require(oldDeposit <= _liquidDeposit, "subtraction overflow for liquid deposit");
      _liquidDeposit = _liquidDeposit - oldDeposit;

      require(balance + oldDeposit >= balance, "addition overflow for total balance + oldDeposit");
      emit Transfer(account, address(0), balance + oldDeposit);
    } else {
      uint256 balance = balanceOf(account);
      uint256 liquidTotalSupply = _liquidTotalSupply;
      require(balance <= liquidTotalSupply, "subtraction overflow for total supply");
      _liquidTotalSupply = liquidTotalSupply - balance;
      emit Transfer(account, address(0), balance);
    }

    _balances[account] = 0;
    _deposits[account] = 0;
    return true;
  }