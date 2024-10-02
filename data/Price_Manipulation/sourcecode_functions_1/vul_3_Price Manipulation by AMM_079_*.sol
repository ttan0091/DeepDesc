function redeemRate() public view returns (uint256) {
    uint256 balanceOfBase = IERC20(baseToken).balanceOf(address(this));
    if (totalSupply() == 0 || balanceOfBase == 0) return ONE;
    return (balanceOfBase * ONE) / totalSupply();
}