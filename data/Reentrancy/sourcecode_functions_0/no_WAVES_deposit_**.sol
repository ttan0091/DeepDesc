function deposit(address account, uint256 amount) external onlyOwner onlyNotDeprecated override virtual returns (bool)  {
    require(amount > 0, "amount should be > 0");
    require(account != address(0), "deposit to the zero address");

    uint256 liquidDeposit = _liquidDeposit;
    require(liquidDeposit + amount >= liquidDeposit, "addition overflow for deposit");
    _liquidDeposit = liquidDeposit + amount;

    uint256 oldDeposit = _deposits[account];
    if (oldDeposit == 0) {
      _balances[account] = balanceOf(account);
      _rewardIndexForAccount[account] = _percents.length - 1;
      _deposits[account] = amount;
    } else {
      uint256 rewardIndex = _rewardIndexForAccount[account];
      if (rewardIndex == _percents.length - 1) {
        require(oldDeposit + amount >= oldDeposit, "addition overflow for deposit");
        _deposits[account] = oldDeposit + amount;
      } else {
        _balances[account] = balanceOf(account);
        _rewardIndexForAccount[account] = _percents.length - 1;
        _deposits[account] = amount;
      }
    }

    emit Transfer(address(0), account, amount);
    return true;
  }