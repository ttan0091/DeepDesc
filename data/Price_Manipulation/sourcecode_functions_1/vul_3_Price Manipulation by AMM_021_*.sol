function getEGDPrice() public view returns (uint) {
    uint balance1 = EGD.balanceOf(pair);
    uint balance2 = U.balanceOf(pair);
    return (balance2 * 1e18 / balance1);
}