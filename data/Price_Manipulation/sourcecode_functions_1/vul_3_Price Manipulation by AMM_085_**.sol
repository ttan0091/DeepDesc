function _mint(address account, uint256 bptAmount) internal override(ERC20Upgradeable, ERC20VotesUpgradeable) {
    // Cannot mint if a cooldown is already in effect. If an account mints during a cooldown period,
    // they would be able to redeem the tokens immediately, bypassing the cooldown.
    _requireAccountNotInCoolDown(account);

    // Immediately after minting, we need to satisfy the equality:
    // (sNOTEToMint * bptBalance) / (totalSupply + sNOTEToMint) == bptAmount

    // Rearranging to get sNOTEToMint on one side:
    // (sNOTEToMint * bptBalance) = (totalSupply + sNOTEToMint) * bptAmount
    // (sNOTEToMint * bptBalance) = totalSupply * bptAmount + sNOTEToMint * bptAmount
    // (sNOTEToMint * bptBalance) - (sNOTEToMint * bptAmount) = totalSupply * bptAmount
    // sNOTEToMint * (bptBalance - bptAmount) = totalSupply * bptAmount
    // sNOTEToMint = (totalSupply * bptAmount) / (bptBalance - bptAmount)

    // NOTE: at this point the BPT has already been transferred into the sNOTE contract, so this
    // bptBalance includes bptAmount.
    uint256 bptBalance = BALANCER_POOL_TOKEN.balanceOf(address(this));
    uint256 _totalSupply = totalSupply();
    uint256 sNOTEToMint;

    if (_totalSupply == 0) {
        sNOTEToMint = bptAmount;
    } else {
        sNOTEToMint = (_totalSupply * bptAmount) / (bptBalance - bptAmount);
    }

    // Handles event emission, balance update, and total supply update
    super._mint(account, sNOTEToMint);
}