function addLiquidity1155ETHTo(
    uint256 vaultId,
    uint256[] memory ids,
    uint256[] memory amounts,
    uint256 minEthIn,
    address to
) public payable nonReentrant returns (uint256) {
    WETH.deposit{value: msg.value}();

    // Finish this.
    (, uint256 amountEth, uint256 liquidity) = _addLiquidity1155WETH(vaultId, ids, amounts, minEthIn, msg.value, to);

    // Return extras.
    if (amountEth < msg.value) {
        WETH.withdraw(msg.value - amountEth);
        payable(to).call{value: msg.value - amountEth}("");
    }

    return liquidity;
}