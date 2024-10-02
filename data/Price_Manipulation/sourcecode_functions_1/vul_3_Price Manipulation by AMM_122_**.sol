function redeem(uint256 redeemLpTokens, uint256 minRedeemAmount)
    public
    override
    returns (uint256)
{
    require(redeemLpTokens > 0, Error.INVALID_AMOUNT);
    ILpToken lpToken_ = lpToken;
    require(lpToken_.balanceOf(msg.sender) >= redeemLpTokens, Error.INSUFFICIENT_BALANCE);

    uint256 withdrawalFee = addressProvider.isAction(msg.sender) ? 0 : getWithdrawalFee(msg.sender, redeemLpTokens);
    uint256 redeemMinusFees = redeemLpTokens - withdrawalFee;
    
    // Pay no fees on the last withdrawal (avoid locking funds in the pool)
    if (redeemLpTokens == lpToken_.totalSupply()) {
        redeemMinusFees = redeemLpTokens;
    }
    
    uint256 redeemUnderlying = redeemMinusFees.scaledMul(exchangeRate());
    require(redeemUnderlying >= minRedeemAmount, Error.NOT_ENOUGH_FUNDS_WITHDRAWN);

    _rebalanceVault(redeemUnderlying);

    lpToken_.burn(msg.sender, redeemLpTokens);
    _doTransferOut(payable(msg.sender), redeemUnderlying);
    emit Redeem(msg.sender, redeemUnderlying, redeemLpTokens);
    return redeemUnderlying;
}