function unstakeAndRedeem(uint256 redeemLpTokens, uint256 minRedeemAmount)
    external
    override
    returns (uint256)
{
    uint256 lpBalance_ = lpToken.balanceOf(msg.sender);
    require(
        lpBalance_ + staker.balanceOf(msg.sender) >= redeemLpTokens,
        Error.INSUFFICIENT_BALANCE
    );
    if (lpBalance_ < redeemLpTokens) {
        staker.unstakeFor(msg.sender, msg.sender, redeemLpTokens - lpBalance_);
    }
    return redeem(redeemLpTokens, minRedeemAmount);
}