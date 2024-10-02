function buyMalt()
    external
    onlyRole(BUYER_ROLE, "Must have buyer privs")
    returns (uint256 purchased)
{
    uint256 rewardBalance = rewardToken.balanceOf(address(this));

    if (rewardBalance == 0) {
        return 0;
    }

    rewardToken.approve(address(router), rewardBalance);

    address [oai_citation:1,Error](data:text/plain;charset=utf-8,%E6%89%BE%E4%B8%8D%E5%88%B0%E5%85%83%E6%95%B0%E6%8D%AE);
    path[0] = address(rewardToken);
    path[1] = address(malt);

    router.swapExactTokensForTokens(
        rewardBalance,
        0, // amountOutMin
        path,
        address(this),
        block.timestamp // change 'now' to 'block.timestamp' to be compliant with current Solidity versions
    );

    purchased = malt.balanceOf(address(this));
    malt.safeTransfer(msg.sender, purchased);
}