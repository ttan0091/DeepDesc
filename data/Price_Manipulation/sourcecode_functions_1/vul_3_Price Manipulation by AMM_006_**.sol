function unsafeTokenPriceInBNB(address _token) 
    private 
    view 
    returns (uint) 
{
    address pair = factory.getPair(_token, address(WBNB));
    uint decimal = uint(BEP20(_token).decimals());

    (uint reserve0, uint reserve1,) = IPancakePair(pair).getReserves();
    if (IPancakePair(pair).token0() == _token) {
        return reserve1.mul(10**decimal).div(reserve0);
    } else if (IPancakePair(pair).token1() == _token) {
        return reserve0.mul(10**decimal).div(reserve1);
    } else {
        return 0;
    }
}