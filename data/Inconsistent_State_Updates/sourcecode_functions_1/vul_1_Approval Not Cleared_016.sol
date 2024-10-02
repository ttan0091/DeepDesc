function reclaimRequestedMint(uint256[] calldata tokenIds) external virtual {
    address _assetAddress = vault.assetAddress();
    bool _is1155 = is1155;

    for (uint256 i = 0; i < tokenIds.length; i++) {
        uint256 tokenId = tokenIds[i];
        uint256 amount = mintRequests[msg.sender][tokenId];
        require(amount > 0, "NFTXVault: nothing to reclaim");
        require(!approvedMints[msg.sender][tokenId], "Eligibility: cannot be approved");

        mintRequests[msg.sender][tokenId] = 0;
        approvedMints[msg.sender][tokenId] = false;

        if (_is1155) {
            IERC1155Upgradeable(_assetAddress).safeTransferFrom(
                address(this),
                msg.sender,
                tokenId,
                amount,
                ""
            );
        } else {
            IERC721(_assetAddress).safeTransferFrom(
                address(this),
                msg.sender,
                tokenId
            );
        }
    }
}