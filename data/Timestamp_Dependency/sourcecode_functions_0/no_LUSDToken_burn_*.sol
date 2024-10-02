function burn(address _account, uint256 _amount) external override {
        _requireCallerIsBOorTroveMorSP();
        _burn(_account, _amount);
    }