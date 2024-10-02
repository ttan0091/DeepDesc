function deposit(uint256 _amount)
    external
    override
    nonReentrant
    returns (uint256)
{
    require(_depositsAllowed, "Deposits not allowed");
    _baseToken.safeTransferFrom(msg.sender, address(this), _amount);
    // Calculate fees and shares to mint including latent contract funds
    uint256 _amountToDeposit = _baseToken.balanceOf(address(this));
    // Record deposit before fee is taken
    if (address(_depositHook) != address(0)) {
        _depositHook.hook(msg.sender, _amount, _amountToDeposit);
    }
    /**
     * Add 1 to avoid rounding to zero, only process deposit if user is
     * depositing an amount large enough to pay a fee.
     */
    uint256 _fee = (_amountToDeposit * _mintingFee) / FEE_DENOMINATOR + 1;
    require(_amountToDeposit > _fee, "Deposit amount too small");
    _baseToken.safeTransfer(_treasury, _fee);
    _amountToDeposit -= _fee;

    uint256 _valueBefore = _strategyController.totalValue();
    _baseToken.approve(address(_strategyController), _amountToDeposit);
    _strategyController.deposit(_amountToDeposit);
    uint256 _valueAfter = _strategyController.totalValue();
    _amountToDeposit = _valueAfter - _valueBefore;

    uint256 _shares = 0;
    if (totalSupply() == 0) {
        _shares = _amountToDeposit;
    } else {
        /**
         * # of shares owed = amount deposited / cost per share, cost per
         * share = total supply / total value.
         */
        _shares = (_amountToDeposit * totalSupply()) / (_valueBefore);
    }
    _mint(msg.sender, _shares);
    return _shares;
}