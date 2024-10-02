function depositAndStake(uint256 depositAmount, uint256 minTokenAmount)
    external
    payable
    override
    returns (uint256)
{
    uint256 amountMinted_ = depositFor(address(this), depositAmount, minTokenAmount);
    staker.stakeFor(msg.sender, amountMinted_);
    return amountMinted_;
}