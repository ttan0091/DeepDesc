function _getPriceFromAdapters(
    address _assetOne,
    address _assetTwo
)
    internal
    view
    returns (bool, uint256)
{
    for (uint256 i = 0; i < priceAdapters.length; i++) {
        (bool success, uint256 price) = priceAdapters[i].getPrice(_assetOne, _assetTwo);
        if (success) {
            return (true, price);
        }
    }
    return (false, 0);
}