function _provideLiquidity(
    address sender,
    IVault vault,
    bytes32 poolId,
    IERC20[] memory ammTokens,
    uint256[] memory ammBalances,
    uint256 sharesAmount,
    address recipient
) private returns (uint256[] memory) {
    uint256[] memory ammLiquidityProvisionAmounts = ammBalances.getLiquidityProvisionSharesAmounts(sharesAmount);

    if (sender != address(this)) {
        ammTokens[0].safeTransferFrom(sender, address(this), ammLiquidityProvisionAmounts[0]);
        ammTokens[1].safeTransferFrom(sender, address(this), ammLiquidityProvisionAmounts[1]);
    }

    ammTokens[0].safeIncreaseAllowance(address(vault), ammLiquidityProvisionAmounts[0]);
    ammTokens[1].safeIncreaseAllowance(address(vault), ammLiquidityProvisionAmounts[1]);

    IVault.JoinPoolRequest memory request = IVault.JoinPoolRequest({
        assets: ammTokens,
        maxAmountsIn: ammLiquidityProvisionAmounts,
        userData: abi.encode(uint8(ITempusAMM.JoinKind.EXACT_TOKENS_IN_FOR_BPT_OUT), ammLiquidityProvisionAmounts, sharesAmount),
        fromInternalBalance: false
    });

    // Provide TPS/TYS liquidity to TempusAMM
    vault.joinPool(poolId, address(this), recipient, request);

    return ammLiquidityProvisionAmounts;
}