```solidity
function addLiquidity(
    IERC20 tokenA,
    IERC20 tokenB,
    uint256 amountADesired,
    uint256 amountBDesired,
    address to,
    uint256 deadline
)
    public
    override
    ensure(deadline)
    returns (
        uint256 amountA,
        uint256 amountB,
        uint256 liquidity
    )
{
    IVaderPool pool;
    (pool, amountA, amountB) = _addLiquidity(
        address(tokenA),
        address(tokenB),
        amountADesired,
        amountBDesired
    );
    tokenA.safeTransferFrom(msg.sender, address(pool), amountA);
    tokenB.safeTransferFrom(msg.sender, address(pool), amountB);
    liquidity = pool.mint(to);
}
```