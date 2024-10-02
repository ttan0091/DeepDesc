function _getPrice(
    address asset_,
    address denomination_,
    bool revert_
) internal view returns (uint256) {
    try _feedRegistry.latestRoundData(asset_, denomination_) returns (
        uint80 roundID_,
        int256 price_,
        uint256 startedAt,
        uint256 timeStamp_,
        uint80 answeredInRound_
    ) {
        require(timeStamp_ != 0, Error.ROUND_NOT_COMPLETE);
        require(block.timestamp <= timeStamp_ + stalePriceDelay, Error.STALE_PRICE);
        require(price_ != 0, Error.NEGATIVE_PRICE);
        require(answeredInRound_ >= roundID_, Error.STALE_PRICE);
        return uint256(price_).scaleFrom(_feedRegistry.decimals(asset_, denomination_));
    } catch Error(string memory reason) {
        if (revert_) revert(reason);
        if (denomination_ == Denominations.USD) {
            return
                (_getPrice(asset_, Denominations.ETH, true) *
                    _getPrice(Denominations.ETH, Denominations.USD, true)) / 1e18;
        }
        return
            (_getPrice(asset_, Denominations.USD, true) * 1e18) /
            _getPrice(Denominations.ETH, Denominations.USD, true);
    }
}