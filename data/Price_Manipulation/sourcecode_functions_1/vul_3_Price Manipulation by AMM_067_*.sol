function getTokensForShares(uint256 shares, address asset) public view override returns (uint256 am
    if (shares == 0) return 0;
    address aToken = liquidityToken(asset);

    (, , , , , , , uint256 liquidityIndex, , ) = IProtocolDataProvider(protocolDataProvider).getRes
    amount = IScaledBalanceToken(aToken).scaledBalanceOf(address(this)).mul(liquidityIndex).mul(sha
    IERC20(aToken).balanceOf(address(this))
    );
}