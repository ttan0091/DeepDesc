function exchangeRate() public view override returns (uint256) {
    uint256 totalUnderlying_ = totalUnderlying();
    uint256 totalSupply = lpToken.totalSupply();
    if (totalSupply == 0 || totalUnderlying_ == 0) {
        return ScaledMath.ONE;
    }

    return totalUnderlying_.scaledDiv(totalSupply);
}