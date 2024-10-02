function requestTokenExchange(uint _tokens) public {
        require(isMigrationPhaseOpen);
        require(_tokens > 0 && _tokens <= unlockedTokensInternal(msg.sender));
        balances[msg.sender] = balances[msg.sender].sub(_tokens);
        tokensIssuedTotal = tokensIssuedTotal.sub(_tokens);
        emit Transfer(msg.sender, 0x0, _tokens);
        emit TokenExchangeRequested(msg.sender, _tokens);
    }