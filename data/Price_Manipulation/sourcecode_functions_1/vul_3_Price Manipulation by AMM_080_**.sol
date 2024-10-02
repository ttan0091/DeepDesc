
function mint(address to, uint256 amount)
    public
    override
    returns (uint256)
{
    uint256 _redeemRate = redeemRate();
    require(
        IERC20(baseToken).transferFrom(msg.sender, address(this), amount)
    );
    uint256 baseBalance = IERC20(baseToken).balanceOf(address(this));
    uint256 proxy = (baseBalance * ONE) / _redeemRate;
    _mint(to, proxy);
}