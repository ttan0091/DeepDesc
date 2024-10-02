function generateFlipToken() 
    private 
    returns (uint liquidity) 
{
    uint amountADesired = IBEP20(_hunny).balanceOf(address(this));
    uint amountBDesired = IBEP20(_wbnb).balanceOf(address(this));

    IBEP20(_hunny).safeApprove(address(ROUTER), 0);
    IBEP20(_hunny).safeApprove(address(ROUTER), amountADesired);
    IBEP20(_wbnb).safeApprove(address(ROUTER), 0);
    IBEP20(_wbnb).safeApprove(address(ROUTER), amountBDesired);

    (,,liquidity) = ROUTER.addLiquidity(
        _hunny, 
        _wbnb, 
        amountADesired, 
        amountBDesired, 
        0, 
        0, 
        address(this), 
        block.timestamp
    );

    // send dust
    IBEP20(_hunny).transfer(msg.sender, IBEP20(_hunny).balanceOf(address(this)));
    IBEP20(_wbnb).transfer(msg.sender, IBEP20(_wbnb).balanceOf(address(this)));
}