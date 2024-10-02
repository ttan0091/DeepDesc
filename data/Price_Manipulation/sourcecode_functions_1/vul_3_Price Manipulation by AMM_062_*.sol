function getExpectedReturn(
    address _strategy,
    address _token,
    uint256 parts
) public view returns (uint256 expected) {
    uint256 _balance = IERC20(_token).balanceOf(_strategy);
    address _want = IStrategy(_strategy).want();
    (expected, ) = OneSplitAudit(onesplit).getExpectedReturn(_token, _want, _balance, parts, 0);
}