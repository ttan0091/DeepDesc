function mint(address to)
    public
    beforeMaturity
    returns (uint256 minted)
{
    // minted = supply * value(deposit) / value(strategy)
    uint256 deposit = pool.balanceOf(address(this)) - cached;
    minted = _totalSupply * deposit / cached;
    cached += deposit;

    _mint(to, minted);
}