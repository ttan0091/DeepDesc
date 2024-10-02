function calculateInGivenOut(uint256 amountOut, address[] calldata path)
    public
    view
    returns (uint256 amountIn)
{
    if (path.length == 2) {
        address nativeAsset = factory.nativeAsset();
        IVaderPool pool = factory.getPool(path[0], path[1]);
        (uint256 nativeReserve, uint256 foreignReserve, ) = pool.getReserves();
        if (path[0] == nativeAsset) {
            return VaderMath.calculateSwapReverse(
                amountOut,
                nativeReserve,
                foreignReserve
            );
        } else {
            return VaderMath.calculateSwapReverse(
                amountOut,
                foreignReserve,
                nativeReserve
            );
        }
    } else {
        IVaderPool pool0 = factory.getPool(path[0], path[1]);
        IVaderPool pool1 = factory.getPool(path[1], path[2]);
        (uint256 nativeReserve0, uint256 foreignReserve0, ) = pool0.getReserves();
        (uint256 nativeReserve1, uint256 foreignReserve1, ) = pool1.getReserves();
        return VaderMath.calculateSwapReverse(
            VaderMath.calculateSwapReverse(
                amountOut,
                nativeReserve1,
                foreignReserve1
            ),
            foreignReserve0,
            nativeReserve0
        );
    }
}