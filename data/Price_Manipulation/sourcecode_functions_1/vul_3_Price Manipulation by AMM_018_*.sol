function getprice() public view returns (uint256 _price) {
    uint256 lpusdtamount=usdt.balanceOf(_lpaddr);
    uint256 lpotheramount=other.balanceOf(_lpaddr);
    _price=lpusdtamount*10**18/lpotheramount;
}