
function _mint1155(
    uint256 vaultId,
    uint256[] memory ids,
    uint256[] memory amounts
) internal returns (address, uint256) {
    address vault = nftxFactory.vault(vaultId);
    require(vault != address(0), "NFTXZap: Vault does not exist");

    // Transfer tokens to zap and mint to NFTX.
    address assetAddress = INFTXVault(vault).assetAddress();
    IERC1155Upgradeable(assetAddress).safeBatchTransferFrom(msg.sender, address(this), ids, amounts, "");

    IERC1155Upgradeable(assetAddress).setApprovalForAll(vault, true);
    uint256 count = INFTXVault(vault).mint(ids, amounts);
    uint256 balance = (count * BASE) - INFTXVault(vault).mintFee() * count;
    require(balance == IERC20Upgradeable(vault).balanceOf(address(this)), "Did not receive expected balance");

    return (vault, balance);
}