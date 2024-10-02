function transferFrom(address _from, address _to, uint256 _value) public returns (bool success)`
   *
   * @dev Called by token owner on his own or approved address,
   *      an address approved earlier by token owner to
   *      transfer some amount of tokens on its behalf
   * @dev Throws on any error like
   *      * insufficient token balance or
   *      * incorrect `_to` address:
   *          * zero address or
   *          * same as `_from` address (self transfer)
   *          * smart contract which doesn't support ERC20
   *
   * @param _from token owner which approved caller (transaction sender)
   *      to transfer `_value` of tokens on its behalf
   * @param _to an address to transfer tokens to,
   *      must be either an external address or a smart contract,
   *      compliant with the ERC20 standard
   * @param _value amount of tokens to be transferred, must
   *      be greater than zero
   * @return success true on success, throws otherwise
   */
  function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
    // depending on `FEATURE_UNSAFE_TRANSFERS` we execute either safe (default)
    // or unsafe transfer
    // if `FEATURE_UNSAFE_TRANSFERS` is enabled
    // or receiver has `ROLE_ERC20_RECEIVER` permission
    // or sender has `ROLE_ERC20_SENDER` permission
    if(isFeatureEnabled(FEATURE_UNSAFE_TRANSFERS)
      || isOperatorInRole(_to, ROLE_ERC20_RECEIVER)
      || isSenderInRole(ROLE_ERC20_SENDER)) {
      // we execute unsafe transfer - delegate call to `unsafeTransferFrom`,
      // `FEATURE_TRANSFERS` is verified inside it
      unsafeTransferFrom(_from, _to, _value);
    }
    // otherwise - if `FEATURE_UNSAFE_TRANSFERS` is disabled
    // and receiver doesn't have `ROLE_ERC20_RECEIVER` permission
    else {
      // we execute safe transfer - delegate call to `safeTransferFrom`, passing empty `_data`,
      // `FEATURE_TRANSFERS` is verified inside it
      safeTransferFrom(_from, _to, _value, "");
    }

    // both `unsafeTransferFrom` and `safeTransferFrom` throw on any error, so
    // if we're here - it means operation successful,
    // just return true
    return true;
  }