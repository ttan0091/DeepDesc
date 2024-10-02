```solidity
function transferERC721(
    address to,
    address nftContract,
    uint256 tokenId
) external {
    if (msg.sender != _getOwner()) {
        require(
            nftApprovals[keccak256(abi.encodePacked(msg.sender, nftContract, tokenId))],
            "NFT not approved"
        );
    }
    for (uint256 i = 0; i < timelockERC721Keys[nftContract].length; i++) {
        if (tokenId == timelockERC721s[timelockERC721Keys[nftContract][i]].tokenId) {
            require(
                timelockERC721s[timelockERC721Keys[nftContract][i]].expires <= block.timestamp,
                "NFT locked and not expired"
            );
            require(
                timelockERC721s[timelockERC721Keys[nftContract][i]].recipient == msg.sender,
                "NFT not the recipient"
            );
        }
    }
    _removeNft(nftContract, tokenId);
    IERC721(nftContract).safeTransferFrom(address(this), to, tokenId);
}
```