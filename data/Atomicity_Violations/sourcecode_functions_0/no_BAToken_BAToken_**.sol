function BAToken(
        address _ethFundDeposit,
        address _batFundDeposit,
        uint256 _fundingStartBlock,
        uint256 _fundingEndBlock)
    {
      isFinalized = false;                   //controls pre through crowdsale state
      ethFundDeposit = _ethFundDeposit;
      batFundDeposit = _batFundDeposit;
      fundingStartBlock = _fundingStartBlock;
      fundingEndBlock = _fundingEndBlock;
      totalSupply = batFund;
      balances[batFundDeposit] = batFund;    // Deposit Brave Intl share
      CreateBAT(batFundDeposit, batFund);  // logs Brave Intl fund
    }