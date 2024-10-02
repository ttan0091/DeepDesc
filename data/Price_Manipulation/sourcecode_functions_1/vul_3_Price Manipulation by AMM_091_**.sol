function depositFor(
    address account,
    uint256 depositAmount,
    uint256 minTokenAmount
) public payable override notPaused returns (uint256) {
    uint256 rate = exchangeRate();
    if (isCapped()) {
        uint256 lpBalance = lpToken.balanceOf(account);
        uint256 stakedAndLockedBalance = staker.stakedAndActionLockedBalanceOf(account);
        uint256 currentUnderlyingBalance = (lpBalance + stakedAndLockedBalance).scaledMul(rate);
        require(
            currentUnderlyingBalance + depositAmount <= depositCap,
            Error.EXCEEDS_DEPOSIT_CAP
        );
    }
    _doTransferIn(msg.sender, depositAmount);
    uint256 mintedLp = depositAmount.scaledDiv(rate);
    require(mintedLp >= minTokenAmount, Error.INVALID_AMOUNT);
    lpToken.mint(account, mintedLp);
    _rebalanceVault();
    if (msg.sender == account || address(this) == account) {
        emit Deposit(msg.sender, depositAmount, mintedLp);
    } else {
        emit DepositFor(msg.sender, account, depositAmount, mintedLp);
    }
    return mintedLp;
}