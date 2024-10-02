function mintFresh(address minter, uint mintAmount) internal returns (uint errorCode, uint actualMintAmount) {
    uint err = comptroller.mintAllowed(address(this), minter, mintAmount);
    require(err == 0, "mint is not allowed");

    uint exchangeRate = exchangeRateStored(); // exchangeRate has variable decimal precision

    /*
    * We call `doTransferIn` for the minter and the mintAmount.
    * Note: The cToken must handle variations between ERC-20 and ETH underlying.
    * `doTransferIn` reverts if anything goes wrong, since we can't be sure if
    * side-effects occurred. The function returns the amount actually transferred,
    * in case of a fee. On success, the cToken holds an additional `actualMintAmount`
    * of cash.
    */
    actualMintAmount = doTransferIn(minter, mintAmount); // 18 decimal precision

    // exchange rate precision: 18 - 8 + Underlying Token Decimals
    uint mintTokens = (actualMintAmount * 1e18) / exchangeRate; // (18 + 18) - 28 = 8 decimal precision
    _mint(minter, mintTokens);
    errorCode = 0;
}