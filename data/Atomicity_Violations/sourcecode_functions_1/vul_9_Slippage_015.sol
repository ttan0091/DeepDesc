```solidity
function calculateSwapReverse(
    uint256 amountOut,
    uint256 reserveIn,
    uint256 reserveOut
) public pure returns (uint256 amountIn) {
    // X*Y
    uint256 XY = reserveIn * reserveOut;

    // 2y
    uint256 y2 = amountOut * 2;

    // 4y
    uint256 y4 = y2 * 2;

    require(
        y4 < reserveOut,
        "VaderMath::calculateSwapReverse: Desired Output Exceeds Maximum Output Possible (1/4 of Liquidity)"
    );

    // Calculate parts of the numerator
    uint256 numeratorA = reserveIn * reserveIn * reserveOut;
    uint256 numeratorB = reserveIn * (2 * amountOut - reserveOut);
    uint256 numeratorC = amountOut * amountOut * reserveIn * 4;

    // Numerator: -X^2 * Y * (2y - Y)
    uint256 numerator = numeratorA + numeratorB + numeratorC;

    // Denominator: 2y
    uint256 denominator = y2;

    amountIn = numerator / denominator;
}
```