function calculateCollateralRatio(uint256 _balance, uint256 _liquidityShares) public returns (uint256) {
    uint256 _interest = interestToPay().mul(_balance).div(totalSupply());
    address _collateralAsset = poolConstants.collateralAsset;
    address _strategy = poolConstants.poolSavingsStrategy;
    uint256 _currentCollateralTokens = IYield(_strategy).getTokensForShares(_liquidityShares, _collateralAsset);
    uint256 _equivalentCollateral = getEquivalentTokens(_collateralAsset, poolConstants.borrowAsset);
    uint256 _ratio = _equivalentCollateral.mul(10**30).div(_balance.add(_interest));
}