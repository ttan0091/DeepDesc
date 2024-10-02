function _depositERC20(address asset, uint256 amount) internal returns (address aToken, uint256 sharesReceived) {
    aToken = liquidityToken(asset);
    uint256 aTokensBefore = IERC20(aToken).balanceOf(address(this));

    address lendingPool = ILendingPoolAddressesProvider(lendingPoolAddressesProvider).getLendingPool();

    // approve collateral to vault
    IERC20(asset).approve(lendingPool, 0);
    IERC20(asset).approve(lendingPool, amount);

    // lock collateral in vault
    AaveLendingPool(lendingPool).deposit(asset, amount, address(this), referralCode);

    sharesReceived = IERC20(aToken).balanceOf(address(this)).sub(aTokensBefore);
}