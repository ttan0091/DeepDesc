function latestRoundData()
    public
    view
    override
    returns (
        uint80 roundId,
        int256 answer,
        uint256 startedAt,
        uint256 updatedAt,
        uint80 answeredInRound
    )
{
    (, int256 answerA, , uint256 assetUpdatedAtA, ) = oracleA.latestRoundData();
    (, int256 answerB, , uint256 assetUpdatedAtB, ) = oracleB.latestRoundData();
    uint256 priceA = uint256(answerA);
    uint256 priceB = uint256(answerB);
    uint160 sqrtPriceX96 = uint160(
        MathPow.sqrt((priceA.mul(_tokenDecimalsUnitB).mul(1 << 96)) / (priceB.mul(_tokenDecimalsUnitA)))
    );

    (uint256 rA, uint256 rB) = pool.getUnderlyingBalancesAtPrice(sqrtPriceX96);
    require(rA > 0 || rB > 0, "C100");
    uint256 totalSupply = pool.totalSupply();
    require(totalSupply >= 1e9, "C101");

    answer = int256(
        priceA.mul(rA.mul(_tokenDecimalsOffsetA)).add(priceB.mul(rB.mul(_tokenDecimalsOffsetB))).div(totalSupply)
    );
    updatedAt = assetUpdatedAtA;

    // use earlier time for updatedAt
    if (assetUpdatedAtA > assetUpdatedAtB) {
        updatedAt = assetUpdatedAtB;
    }
}