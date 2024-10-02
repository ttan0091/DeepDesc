function removeQuote(uint256 lpTokenAmount) public view returns (uint256, uint256) {
    uint256 lpTokenSupply = lpToken.totalSupply();
    uint256 baseTokenOutputAmount = (baseTokenReserves() * lpTokenAmount) / lpTokenSupply;
    uint256 fractionalTokenOutputAmount = (fractionalTokenReserves() * lpTokenAmount) / lpTokenSupply;
    return (baseTokenOutputAmount, fractionalTokenOutputAmount);
}