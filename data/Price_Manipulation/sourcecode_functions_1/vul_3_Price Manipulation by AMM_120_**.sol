function depositFor(
    address account,
    uint256 depositAmount,
    uint256 minTokenAmount
) public payable override notPaused returns (uint256) {
    if (depositAmount == 0) return 0;
    uint256 rate = exchangeRate();

    _doTransferIn(msg.sender, depositAmount);
    uint256 mintedLp = depositAmount.scaledDiv(rate);
    require(mintedLp >= minTokenAmount && mintedLp > 0, Error.INVALID_AMOUNT);

    lpToken.mint(account, mintedLp);
    _rebalanceVault();

    if (msg.sender == account || address(this) == account) {
        emit Deposit(msg.sender, depositAmount, mintedLp);
    } else {
        emit DepositFor(msg.sender, account, depositAmount, mintedLp);
    }
    return mintedLp;
}