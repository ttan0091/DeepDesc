```solidity
function _safeTransferFrom(
    address _from,
    address _to,
    uint256 _tokenId,
    bytes memory _data
) private {
    address tokenOwner = idToOwner[_tokenId];
    require(tokenOwner == _from, "Incorrect owner.");
    require(_to != address(0));

    _transfer(_to, _tokenId);

    if (isContract(_to)) {
        bytes4 retval = ERC721TokenReceiver(_to).onERC721Received(
            msg.sender,
            _from,
            _tokenId,
            _data
        );
        require(retval == MAGIC_ERC721_RECEIVED);
    }
}
```