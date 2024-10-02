function _addLiquidity1155WETH(
    uint256 vaultId,
    uint256[] memory ids,
    uint256[] memory amounts,
    uint256 minWethIn,
    uint256 wethIn,
    address to
) internal returns (uint256, uint256, uint256) {
    address vault = nftxFactory.vault(vaultId);
    require(vault != address(0), "NFTXZap: Vault does not exist");

    // Transfer tokens to zap and mint to NFTX.
    address assetAddress = INFTXVault(vault).assetAddress();
    IERC1155Upgradeable(assetAddress).safeBatchTransferFrom(msg.sender, address(this), ids, amounts, "");

    IERC1155Upgradeable(assetAddress).setApprovalForAll(vault, true);
    uint256 count = INFTXVault(vault).mint(ids, amounts);
    uint256 balance = (count * BASE); // We should not be experiencing fees.
    require(balance == IERC20Upgradeable(vault).balanceOf(address(this)), "Did not receive expected balance");

    return _addLiquidityAndLock(vaultId, vault, balance, minWethIn, wethIn, to);
}