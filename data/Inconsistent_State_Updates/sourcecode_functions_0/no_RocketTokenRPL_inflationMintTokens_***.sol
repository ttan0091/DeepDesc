function inflationMintTokens() override external returns (uint256) {
        // Only run inflation process if at least 1 interval has passed (function returns 0 otherwise)
        uint256 inflationLastCalcTime = getInflationCalcTime();
        uint256 intervalsSinceLastMint = _getInflationIntervalsPassed(inflationLastCalcTime);
        if (intervalsSinceLastMint == 0) {
            return 0;
        }
        // Address of the vault where to send tokens
        address rocketVaultAddress = getContractAddress("rocketVault");
        require(rocketVaultAddress != address(0x0), "rocketVault address not set");
        // Only mint if we have new tokens to mint since last interval and an address is set to receive them
        RocketVaultInterface rocketVaultContract = RocketVaultInterface(rocketVaultAddress);
        // Calculate the amount of tokens now based on inflation rate
        uint256 newTokens = _inflationCalculate(intervalsSinceLastMint);
        // Update last inflation calculation timestamp even if inflation rate is 0
        inflationCalcTime = inflationLastCalcTime.add(inflationInterval.mul(intervalsSinceLastMint));
        // Check if actually need to mint tokens (e.g. inflation rate > 0)
        if (newTokens > 0) {
            // Mint to itself, then allocate tokens for transfer to rewards contract, this will update balance & supply
            _mint(address(this), newTokens);
            // Initialise itself and allow from it's own balance (cant just do an allow as it could be any user calling this so they are msg.sender)
            IERC20 rplInflationContract = IERC20(address(this));
            // Get the current allowance for Rocket Vault
            uint256 vaultAllowance = rplFixedSupplyContract.allowance(rocketVaultAddress, address(this));
            // Now allow Rocket Vault to move those tokens, we also need to account of any other allowances for this token from other contracts in the same block
            require(rplInflationContract.approve(rocketVaultAddress, vaultAllowance.add(newTokens)), "Allowance for Rocket Vault could not be approved");
            // Let vault know it can move these tokens to itself now and credit the balance to the RPL rewards pool contract
            rocketVaultContract.depositToken("rocketRewardsPool", IERC20(address(this)), newTokens);
        }
        // Log it
        emit RPLInflationLog(msg.sender, newTokens, inflationCalcTime);
        // return number minted
        return newTokens;
    }