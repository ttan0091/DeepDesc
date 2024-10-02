function exchangeCanonicalForOld(address bridge_token_address, uint256 token_amount) external nonReentrant validBridgeToken(bridge_token_address) returns (uint256 bridge_tokens_out) {
        require(!exchangesPaused && canSwap[bridge_token_address], "Exchanges paused");
        
        // Burn the canonical tokens
        super._burn(msg.sender, token_amount);

        // Handle the fee, if applicable
        bridge_tokens_out = token_amount;
        if (!_isFeeExempt(msg.sender)) {
            bridge_tokens_out -= ((bridge_tokens_out * swap_fees[bridge_token_address][1]) / PRICE_PRECISION);
        }

        // Give old tokens to the sender
        TransferHelper.safeTransfer(bridge_token_address, msg.sender, bridge_tokens_out);
    }