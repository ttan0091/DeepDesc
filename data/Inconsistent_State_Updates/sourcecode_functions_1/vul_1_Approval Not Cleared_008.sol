function _swap1155(
    uint256 vaultId,
    uint256[] memory idsIn,
    uint256[] memory amounts,
    uint256[] memory idsOut,
    address to
) internal returns (address) {
    address vault = nftxFactory.vault(vaultId);
    require(vault != address(0), "NFTXZap: Vault does not exist");

    // Transfer tokens to zap and mint to NFTX.
    address assetAddress = INFTXVault(vault).assetAddress();
    IERC1155Upgradeable(assetAddress).safeBatchTransferFrom(msg.sender, address(this), idsIn, amounts, "");

    IERC1155Upgradeable(assetAddress).setApprovalForAll(vault, true);
    INFTXVault(vault).swapTo(idsIn, amounts, idsOut, to);

    return vault;
}