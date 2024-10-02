function _transfer(address sender, address recipient, uint256 amount) internal onlyNotDeprecated virtual {
    require(amount > 0, "amount should be > 0");
    require(sender != address(0), "ERC20: transfer from the zero address");
    require(recipient != address(0), "ERC20: transfer to the zero address");

    uint256 oldDeposit = _deposits[sender];
    uint256 rewardIndex = _rewardIndexForAccount[sender];
    uint256 depositDiff = 0;

    if (oldDeposit == 0 || rewardIndex != _percents.length - 1) {
      uint256 senderBalance = balanceOf(sender);
      require(amount <= senderBalance, "ERC20: transfer amount exceeds balance");
      _balances[sender] = senderBalance - amount;

      _deposits[sender] = 0;
      _rewardIndexForAccount[sender] = _percents.length - 1;
    } else {
      if (amount <= oldDeposit) {
        _deposits[sender] = oldDeposit - amount;
        depositDiff = amount;
      } else {
        uint256 senderBalance = _balances[sender];
        require(amount - oldDeposit <= senderBalance, "ERC20: transfer amount exceeds balance");
        _balances[sender] = senderBalance - (amount - oldDeposit);
        _deposits[sender] = 0;
        depositDiff = oldDeposit;
      }
    }

    oldDeposit = _deposits[recipient];
    rewardIndex = _rewardIndexForAccount[recipient];
    if (oldDeposit == 0 || rewardIndex != _percents.length - 1) {
      uint256 recipientBalance = balanceOf(recipient);
      require((amount - depositDiff) + recipientBalance >= recipientBalance, "ERC20: addition overflow for recipient balance");
      _balances[recipient] = recipientBalance + (amount - depositDiff);
      _rewardIndexForAccount[recipient] = _percents.length - 1;
      _deposits[recipient] = depositDiff;
    } else {
      uint256 recipientBalance = _balances[recipient];
      _balances[recipient] = recipientBalance + (amount - depositDiff);
      _deposits[recipient] = oldDeposit + depositDiff;
    }

    emit Transfer(sender, recipient, amount);
  }