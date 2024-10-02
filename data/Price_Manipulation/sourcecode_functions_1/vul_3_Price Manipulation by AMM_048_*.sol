function exchangeRateStored() public view returns (uint256) {
    uint256 totalSupply_ = uErc20.totalSupply();
    if (totalSupply_ == 0) {
        return initialExchangeRateMantissa;
    } else {
        return (totalRedeemable * WAD) / totalSupply_;
    }
}