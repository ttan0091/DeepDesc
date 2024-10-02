function buyAndRedeemWETH(
    uint256 vaultId,
    uint256 amount,
    uint256[] memory specificIds,
    uint256 maxWethIn,
    address[] calldata path,
    address to
) public nonReentrant {
    require(to != address(0));
    require(amount != 0);

    IERC20Upgradeable(address(WETH)).transferFrom(msg.sender, address(this), maxWethIn);
    INFTXVault vault = INFTXVault(nftxFactory.vault(vaultId));
    uint256 totalFee = (vault.targetRedeemFee() * specificIds.length) + (vault.randomRedeemFee() * (amount - specificIds.length));
    uint256[] memory amounts = _buyVaultToken(address(vault), (amount * BASE) + totalFee, maxWethIn, path);
    _redeem(vaultId, amount, specificIds, to);

    emit Buy(amount, amounts[0], to);

    uint256 remaining = WETH.balanceOf(address(this));
    WETH.transfer(to, remaining);
}