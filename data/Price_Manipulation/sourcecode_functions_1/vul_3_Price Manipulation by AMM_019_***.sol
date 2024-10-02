function ETHreceive() external returns (bool) {
    bool Limited = receivetime[msg.sender] < block.timestamp;
    require(Limited, "Exchange interval is too short.");

    bool B1 = pledgeamount[msg.sender] > 0;
    require(B1, "pledgeamount is zero.");

    _swapprice = getprice();

    uint256 bltt12 = _bl1.sub(income[msg.sender]);
    uint256 blt11 = pledgeamount[msg.sender].mul(bltt12).div(_baseFee);
    bool y1 = usdt.balanceOf(address(this)) >= blt11;
    require(y1, "token balance is low.");

    usdt.transfer(msg.sender, blt11);

    uint256 blttttt = _bl2 + income[msg.sender] + income[msg.sender];
    uint256 blt2 = pledgeamount[msg.sender].mul(blttttt).div(_baseFee);

    uint256 _recamount33333 = blt2 * 10**18 / _swapprice;
    bool y2 = other.balanceOf(address(this)) >= _recamount33333;
    require(y2, "token balance is low.");
    other.transfer(msg.sender, _recamount33333);

    uint256 _recamount22 = pledgeamount[msg.sender].mul(income[msg.sender]).div(_baseFee);
    uint256 _recamount = pledgeamount[msg.sender] * 10**18 / _swapprice;

    receiveamount[msg.sender] += pledgeamount[msg.sender];
    receiveSYamount[msg.sender] += _recamount22;
    receivetime[msg.sender] = 0;
    pledgeday[msg.sender] = 0;
    income[msg.sender] = 0;
    pledgeamount[msg.sender] = 0;
    receivenumber[msg.sender] += 1;

    address cur = msg.sender;

    for (int256 i = 0; i < 5; i++) {
        cur = inviter[cur];
        uint256 rate;
        uint256 lv;

        if (i == 0) {
            rate = _father1;
            lv = 1;
        } else if (i == 1) {
            rate = _father2;
            lv = 2;
        } else if (i == 2) {
            rate = _father3;
            lv = 3;
        } else if (i == 3) {
            rate = _father4;
            lv = 4;
        } else if (i == 4) {
            rate = _father5;
            lv = 5;
        }

        if (rate > 0) {
            if (sharenumber[cur] >= lv) {
                if (pledgeamount[cur] == 0) {
                    emit Transfer(cur, address(0), lv);
                    emit Transfer(cur, address(1), 88);
                    continue;
                }
                uint256 curTAmount = _recamount.mul(rate).div(_baseFee);
                bool y3 = other.balanceOf(address(this)) >= curTAmount;
                require(y3, "token balance is low.");
                other.transfer(cur, curTAmount);
                bonus[cur] += curTAmount;
            } else {
                emit Transfer(cur, address(0), lv);
                emit Transfer(cur, address(1), sharenumber[cur]);
            }
        }
    }
    return true;
}