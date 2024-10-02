function createTokens() payable external {
      if (isFinalized) throw;
      if (block.number < fundingStartBlock) throw;
      if (block.number > fundingEndBlock) throw;
      if (msg.value == 0) throw;

      uint256 tokens = safeMult(msg.value, tokenExchangeRate); // check that we're not over totals
      uint256 checkedSupply = safeAdd(totalSupply, tokens);

      // return money if something goes wrong
      if (tokenCreationCap < checkedSupply) throw;  // odd fractions won't be found

      totalSupply = checkedSupply;
      balances[msg.sender] += tokens;  // safeAdd not needed; bad semantics to use here
      CreateBAT(msg.sender, tokens);  // logs token creation
    }