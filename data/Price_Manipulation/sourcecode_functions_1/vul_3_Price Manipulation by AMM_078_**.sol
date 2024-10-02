function buyFlanAndBurn(
    address inputToken,
    uint256 amount,
    address recipient
) public override {
    address pair = VARS.factory.getPair(inputToken, VARS.flan);

    uint256 flanBalance = IERC20(VARS.flan).balanceOf(pair);
    uint256 inputBalance = IERC20(inputToken).balanceOf(pair);

    uint256 amountOut = getAmountOut(amount, inputBalance, flanBalance);
    uint256 amount0Out = inputToken < VARS.flan ? 0 : amountOut;
    uint256 amount1Out = inputToken < VARS.flan ? amountOut : 0;
    IERC20(inputToken).transfer(pair, amount);
    UniPairLike(pair).swap(amount0Out, amount1Out, address(this), "");
    uint256 reward = (amountOut / 100);
    ERC20Burnable(VARS.flan).transfer(recipient, reward);
    ERC20Burnable(VARS.flan).burn(amountOut - reward);
}