function mint(address dst, uint rawAmount) external {
        require(msg.sender == minter, "Uni::mint: only the minter can mint");
        require(block.timestamp >= mintingAllowedAfter, "Uni::mint: minting not allowed yet");
        require(dst != address(0), "Uni::mint: cannot transfer to the zero address");

        // record the mint
        mintingAllowedAfter = SafeMath.add(block.timestamp, minimumTimeBetweenMints);

        // mint the amount
        uint96 amount = safe96(rawAmount, "Uni::mint: amount exceeds 96 bits");
        require(amount <= SafeMath.div(SafeMath.mul(totalSupply, mintCap), 100), "Uni::mint: exceeded mint cap");
        totalSupply = safe96(SafeMath.add(totalSupply, amount), "Uni::mint: totalSupply exceeds 96 bits");

        // transfer the amount to the recipient
        balances[dst] = add96(balances[dst], amount, "Uni::mint: transfer amount overflows");
        emit Transfer(address(0), dst, amount);

        // move delegates
        _moveDelegates(address(0), delegates[dst], amount);
    }