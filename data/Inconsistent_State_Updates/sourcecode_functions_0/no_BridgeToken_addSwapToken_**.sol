function addSwapToken(address contractAddress, uint256 supplyIncrement)
        public
    {
        require(bridgeRoles.has(msg.sender), "Unauthorized.");
        require(isContract(contractAddress), "Address is not contract.");

        // If the swap token is not already supported, add it with the total supply of supplyIncrement.
        // Otherwise, increment the current supply.
        if (swapTokens[contractAddress].tokenContract == address(0)) {
            swapTokens[contractAddress] = SwapToken({
                tokenContract: contractAddress,
                supply: supplyIncrement
            });
        } else {
            swapTokens[contractAddress].supply =
                swapTokens[contractAddress].supply +
                supplyIncrement;
        }
        emit AddSwapToken(contractAddress, supplyIncrement);
    }