function _vestedAmount() private view returns (uint256) {
        uint256 currentBalance = FXS.balanceOf(address(this));
        uint256 totalBalance = currentBalance.add(_released);
        if (block.timestamp < _cliff) {
            return 0;
        } else if (block.timestamp >= _start.add(_duration) || _revoked) {
            return totalBalance;
        } else {
            return totalBalance.mul(block.timestamp.sub(_start)).div(_duration);
        }
    }