function peek(bytes32 base, bytes32 quote, uint256 amount)
    external view virtual override
    returns (uint256 value, uint256 updateTime)
{
    uint256 price = 1e18;
    bytes6 base_ = base.b6();
    bytes6 quote_ = quote.b6();
    bytes6[] memory path = paths[base_][quote_];
    for (uint256 p = 0; p < path.length; p++) {
        (price, updateTime) = _peek(base_, path[p]);
        base_ = path[p];
    }
    (price, updateTime) = _peek(base_, quote_);
    value = price * amount / 1e18;
}