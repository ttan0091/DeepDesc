function registerLockedTokens(address _account, uint _tokens, uint _term) internal returns (uint idx) {
        require(_term > now, "lock term must be in the future");

        // find a slot (clean up while doing this)
        // use either the existing slot with the exact same term,
        // of which there can be at most one, or the first empty slot
        idx = 9999;
        uint[LOCK_SLOTS] storage term = lockTerm[_account];
        uint[LOCK_SLOTS] storage amnt = lockAmnt[_account];
        for (uint i; i < LOCK_SLOTS; i++) {
            if (term[i] < now) {
                term[i] = 0;
                amnt[i] = 0;
                if (idx == 9999) idx = i;
            }
            if (term[i] == _term) idx = i;
        }

        // fail if no slot was found
        require(idx != 9999, "registerLockedTokens: no available slot found");

        // register locked tokens
        if (term[idx] == 0) term[idx] = _term;
        amnt[idx] = amnt[idx].add(_tokens);
        mayHaveLockedTokens[_account] = true;
        emit RegisteredLockedTokens(_account, idx, _tokens, _term);
    }