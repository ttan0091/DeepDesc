function _processReBuy(uint amount) internal {
    U.approve(address(router), amount);
    address [oai_citation:1,Error](data:text/plain;charset=utf-8,%E6%89%BE%E4%B8%8D%E5%88%B0%E5%85%83%E6%95%B0%E6%8D%AE);
    path[0] = address(U);
    path[1] = address(EGD);
    router.swapExactTokensForTokensSupportingFeeOnTransferTokens(amount, 0, path, address(this), block.timestamp);
}