function sendAndCall(address _from, uint16 _dstChainId, bytes32 _toAddress, uint _amount, uint _minAmount, bytes calldata _payload, uint64 _dstGasForCall, LzCallParams calldata _callParams) public payable virtual override {
        (_amount,) = _payOFTFee(_from, _dstChainId, _amount);
        _amount = _sendAndCall(_from, _dstChainId, _toAddress, _amount, _payload, _dstGasForCall, _callParams.refundAddress, _callParams.zroPaymentAddress, _callParams.adapterParams);
        require(_amount >= _minAmount, "BaseOFTWithFee: amount is less than minAmount");
    }