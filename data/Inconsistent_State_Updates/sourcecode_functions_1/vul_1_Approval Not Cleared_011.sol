function mintAndSell1155WETH(
    uint256 vaultId,
    uint256[] memory ids,
    uint256[] memory amounts,
    uint256 minWethOut,
    address[] calldata path,
    address to
) public nonReentrant {
    require(to != address(0));
    require(ids.length != 0);
    
    (address vault, uint256 vaultTokenBalance) = _mint1155(vaultId, ids, amounts);
    _sellVaultTokenWETH(vault, minWethOut, vaultTokenBalance, path, to);

    uint256 count;
    for (uint256 i = 0; i < ids.length; i++) {
        count += amounts[i];
    }
    emit Sell(count, amounts[1], to);
}