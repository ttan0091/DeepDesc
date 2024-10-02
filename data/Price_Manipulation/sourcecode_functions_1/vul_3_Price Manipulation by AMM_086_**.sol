function _mintFromAssets(IAsset[] memory assets, uint256[] memory maxAmountsIn) internal {
    uint256 bptBefore = BALANCER_POOL_TOKEN.balanceOf(address(this));
    // Set msgValue when joining via ETH
    uint256 msgValue = assets[0] == IAsset(address(0)) ? maxAmountsIn[0] : 0;

    BALANCER_VAULT.joinPool{value: msgValue}(
        NOTE_ETH_POOL_ID,
        address(this),
        address(this), // sNOTE will receive the BPT
        IVault.JoinPoolRequest(
            assets,
            maxAmountsIn,
            abi.encode(
                IVault.JoinKind.EXACT_TOKENS_IN_FOR_BPT_OUT,
                maxAmountsIn,
                0 // Accept however much BPT the pool will give us
            ),
            false // Don't use internal balances
        )
    );
    uint256 bptAfter = BALANCER_POOL_TOKEN.balanceOf(address(this));

    // Balancer pool token amounts must increase
    _mint(msg.sender, bptAfter - bptBefore);
}