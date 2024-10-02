function _getPriceFromAdapters(
    address _assetOne,
    address _assetTwo
)
    internal
    view
    returns (bool, uint256)
{
    for (uint256 i = 0; i < adapters.length; i++) {
        (
            bool priceFound,
            uint256 price
        ) = IOracleAdapter(adapters[i]).getPrice(_assetOne, _assetTwo);
        if (priceFound) {
            return (priceFound, price);
        }
    }
    return (false, 0);
}