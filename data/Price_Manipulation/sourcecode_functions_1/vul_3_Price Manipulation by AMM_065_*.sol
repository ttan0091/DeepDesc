function getTokensForShares(uint256 shares, address asset) public override returns (uint256 amount) {
    if (shares == 0) return 0;
    address cToken = liquidityToken[asset];
    amount = ICToken(cToken).balanceOfUnderlying(address(this)).mul(shares).div(IERC20(cToken).balanceOf(address(this)));
}