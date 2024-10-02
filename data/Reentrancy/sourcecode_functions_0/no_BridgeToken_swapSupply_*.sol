function swapSupply(address token) public view returns (uint256) {
        return swapTokens[token].supply;
    }