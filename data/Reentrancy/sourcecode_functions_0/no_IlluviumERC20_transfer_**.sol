function transfer(address _to, uint256 _value) public returns (bool success)`
   *
   * @dev Called by token owner (an address which has a
   *      positive token balance tracked by this smart contract)
   * @dev Throws on any error like
   *      * insufficient token balance or
   *      * incorrect `_to` address:
   *          * zero address or
   *          * self address or
   *          * smart contract which doesn't support ERC20
   *
   * @param _to an address to transfer tokens to,
   *      must be either an external address or a smart contract,
   *      compliant with the ERC20 standard
   * @param _value amount of tokens to be transferred, must
   *      be greater than zero
   * @return success true on success, throws otherwise
   */
  function transfer(address _to, uint256 _value) public returns (bool success) {
    // just delegate call to `transferFrom`,
    // `FEATURE_TRANSFERS` is verified inside it
    return transferFrom(msg.sender, _to, _value);
  }