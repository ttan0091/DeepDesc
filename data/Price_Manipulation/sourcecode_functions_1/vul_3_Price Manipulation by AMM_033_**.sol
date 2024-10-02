function burnShares(
    address from,
    uint256 principalAmount,
    uint256 yieldAmount
)
    internal
    returns (
        uint256 redeemedYieldTokens,
        uint256 fee,
        uint256 interestRate
    )
{
    require(IERC20(address(principalShare)).balanceOf(from) >= principalAmount, "Insufficient principal shares.");
    require(IERC20(address(yieldShare)).balanceOf(from) >= yieldAmount, "Insufficient yields.");

    // Redeeming prior to maturity is only allowed in equal amounts.
    require(matured || (principalAmount == yieldAmount), "Inequal redemption not allowed before maturity.");

    // Burn the appropriate shares
    PrincipalShare(address(principalShare)).burnFrom(from, principalAmount);
    YieldShare(address(yieldShare)).burnFrom(from, yieldAmount);

    uint256 currentRate = updateInterestRate();
    (redeemedYieldTokens, , fee, interestRate) = getRedemptionAmounts(principalAmount, yieldAmount, currentRate);
    totalFees += fee;
}