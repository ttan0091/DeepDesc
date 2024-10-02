function buyAndSwap1155WETH(
    uint256 vaultId,
    uint256[] memory idsIn,
    uint256[] memory amounts,
    uint256[] memory specificIds,
    uint256 maxWethIn,
    address[] calldata path,
    address to
) public payable nonReentrant {
    require(to != address(0), "Invalid address");
    require(idsIn.length != 0, "IDs array is empty");

    // Transfer WETH from the sender to this contract
    IERC20Upgradeable(address(WETH)).transferFrom(msg.sender, address(this), maxWethIn);

    uint256 count;
    for (uint256 i = 0; i < idsIn.length; i++) {
        uint256 amount = amounts[i];
        require(amount > 0, "Transferring < 1");
        count += amount;
    }

    INFTXVault vault = INFTXVault(nftxFactory.vault(vaultId));
    uint256 redeemFees = (vault.targetSwapFee() * specificIds.length) + (vault.randomSwapFee() * (count - specificIds.length));

    uint256[] memory swapAmounts = _buyVaultToken(address(vault), redeemFees, msg.value, path);
    _swap1155(vaultId, idsIn, amounts, specificIds, to);

    emit Swap(count, swapAmounts[0], to);

    // Return excess WETH
    uint256 remaining = WETH.balanceOf(address(this));
    WETH.transfer(to, remaining);
}