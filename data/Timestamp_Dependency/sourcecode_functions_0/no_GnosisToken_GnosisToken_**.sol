function GnosisToken(address dutchAuction, address[] owners, uint[] tokens)
        public
    {
        if (dutchAuction == 0)
            // Address should not be null.
            throw;
        totalSupply = 10000000 * 10**18;
        balances[dutchAuction] = 9000000 * 10**18;
        Transfer(0, dutchAuction, balances[dutchAuction]);
        uint assignedTokens = balances[dutchAuction];
        for (uint i=0; i<owners.length; i++) {
            if (owners[i] == 0)
                // Address should not be null.
                throw;
            balances[owners[i]] += tokens[i];
            Transfer(0, owners[i], tokens[i]);
            assignedTokens += tokens[i];
        }
        if (assignedTokens != totalSupply)
            throw;
    }