function swap(address token, uint256 amount) public {
        require(isContract(token), "Token is not a contract.");
        require(
            swapTokens[token].tokenContract != address(0),
            "Swap token is not a contract."
        );
        require(
            amount <= swapTokens[token].supply,
            "Swap amount is more than supply."
        );

        // Update the allowed swap amount.
        swapTokens[token].supply = swapTokens[token].supply - amount;

        // Burn the old token.
        ERC20Burnable swapToken = ERC20Burnable(
            swapTokens[token].tokenContract
        );
        swapToken.burnFrom(msg.sender, amount);

        // Mint the new token.
        _mint(msg.sender, amount);

        emit Swap(token, amount);
    }