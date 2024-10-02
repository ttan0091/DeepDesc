function _creditTo(
        uint16 _srcChainId,
        address _toAddress,
        uint256 _amount
    ) internal override whenNotPaused returns (uint256) {
        uint256 amount = super._creditTo(_srcChainId, _toAddress, _amount);

        if (whitelist[_toAddress]) {
            return amount;
        }

        uint256 receivedTokenAmount;
        uint256 lastReceivedTimestamp = chainIdToLastReceivedTimestamp[
        _srcChainId
        ];
        uint256 currTimestamp = block.timestamp;
        if ((currTimestamp / (1 days)) > (lastReceivedTimestamp / (1 days))) {
            receivedTokenAmount = amount;
        } else {
            receivedTokenAmount =
            chainIdToReceivedTokenAmount[_srcChainId] +
            amount;
        }

        uint256 inboundCap = chainIdToInboundCap[_srcChainId];
        if (receivedTokenAmount > inboundCap) {
            revert ExceedInboundCap(inboundCap, receivedTokenAmount);
        }

        chainIdToReceivedTokenAmount[_srcChainId] = receivedTokenAmount;
        chainIdToLastReceivedTimestamp[_srcChainId] = currTimestamp;

        return amount;
    }