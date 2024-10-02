function calculateSwapReverse(
    uint256 amountOut,
    uint256 reserveIn,
    uint256 reserveOut
) public pure returns (uint256 amountIn) {
    // X * Y
    uint256 XY = reserveIn * reserveOut;

    // 2y
    uint256 y2 = amountOut * 2;

    // 4y
    uint256 y4 = y2 * 2;

    require(
        y4 < reserveOut,
        "VaderMath::calculateSwapReverse: Desired Output Exceeds Maximum Output Possible (1/4 of L)"
    );

    // root(X^2 * Y * (Y - 4y)) => root(X^2 * Y * (Y - 4y)) as Y - 4y >= 0 => Y >= 4y
    uint256 numeratorA = root(XY) * root(reserveIn * (reserveOut - y4));

    // X * (2y - Y) => 2yX - XY
    uint256 numeratorB = y2 * reserveIn;
    uint256 numeratorC = XY;

    // -1 * (root(X^2 * Y * (4y - Y)) + (X * (2y - Y))) => -1 * (root(X^2 * Y * (4y - Y)) + (X * (2y - Y)))
    uint256 numerator = numeratorC - numeratorA - numeratorB;

    // 2y
    uint256 denominator = y2;

    amountIn = numerator / denominator;
}