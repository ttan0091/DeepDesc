function _debitFrom(
        address _from,
        uint16 _dstChainId,
        bytes32 _toAddress,
        uint256 _amount
    ) internal override whenNotPaused returns (uint256) {
        uint256 amount = super._debitFrom(
            _from,
            _dstChainId,
            _toAddress,
            _amount
        );

        if (whitelist[_from]) {
            return amount;
        }

        uint256 sentTokenAmount;
        uint256 lastSentTimestamp = chainIdToLastSentTimestamp[_dstChainId];
        uint256 currTimestamp = block.timestamp;
        if ((currTimestamp / (1 days)) > (lastSentTimestamp / (1 days))) {
            sentTokenAmount = amount;
        } else {
            sentTokenAmount = chainIdToSentTokenAmount[_dstChainId] + amount;
        }

        uint256 outboundCap = chainIdToOutboundCap[_dstChainId];
        if (sentTokenAmount > outboundCap) {
            revert ExceedOutboundCap(outboundCap, sentTokenAmount);
        }

        chainIdToSentTokenAmount[_dstChainId] = sentTokenAmount;
        chainIdToLastSentTimestamp[_dstChainId] = currTimestamp;

        return amount;
    }