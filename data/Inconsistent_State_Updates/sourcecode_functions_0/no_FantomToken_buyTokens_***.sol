function buyTokens() private {

        require(isMain());
        require(msg.value >= MINIMUM_CONTRIBUTION);
        require(whitelist[msg.sender]);

        uint tokens_available = TOKEN_MAIN_CAP.sub(tokensMain);

        // adjust tokens_available on first day, if necessary
        if (isMainFirstDay()) {
            uint tokens_available_first_day = firstDayTokenLimit().sub(balancesMain[msg.sender]);
            if (tokens_available_first_day < tokens_available) {
                tokens_available = tokens_available_first_day;
            }
        }

        require (tokens_available > 0);

        uint tokens_requested = ethToTokens(msg.value);
        uint tokens_issued = tokens_requested;

        uint eth_contributed = msg.value;
        uint eth_returned;

        if (tokens_requested > tokens_available) {
            tokens_issued = tokens_available;
            eth_returned = tokensToEth(tokens_requested.sub(tokens_available));
            eth_contributed = msg.value.sub(eth_returned);
        }

        balances[msg.sender] = balances[msg.sender].add(tokens_issued);
        balancesMain[msg.sender] = balancesMain[msg.sender].add(tokens_issued);
        tokensMain = tokensMain.add(tokens_issued);
        tokensIssuedTotal = tokensIssuedTotal.add(tokens_issued);

        ethContributed[msg.sender] = ethContributed[msg.sender].add(eth_contributed);
        totalEthContributed = totalEthContributed.add(eth_contributed);

        // ether transfers
        if (eth_returned > 0) msg.sender.transfer(eth_returned);
        wallet.transfer(eth_contributed);

        // log
        emit Transfer(0x0, msg.sender, tokens_issued);
        emit RegisterContribution(msg.sender, tokens_issued, eth_contributed, eth_returned);
    }