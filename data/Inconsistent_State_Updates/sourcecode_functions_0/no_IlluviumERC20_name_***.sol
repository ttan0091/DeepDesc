function name() public view returns (string)`
   *
   * @dev Field is declared public: getter name() is created when compiled,
   *      it returns the name of the token.
   */
  string public constant name = "Illuvium";

  /**
   * @notice Symbol of the token: ILV
   *
   * @notice ERC20 symbol of that token (short name)
   *
   * @dev ERC20 `function symbol() public view returns (string)`
   *
   * @dev Field is declared public: getter symbol() is created when compiled,
   *      it returns the symbol of the token
   */
  string public constant symbol = "ILV";

  /**
   * @notice Decimals of the token: 18
   *
   * @dev ERC20 `function decimals() public view returns (uint8)`
   *
   * @dev Field is declared public: getter decimals() is created when compiled,
   *      it returns the number of decimals used to get its user representation.
   *      For example, if `decimals` equals `6`, a balance of `1,500,000` tokens should
   *      be displayed to a user as `1,5` (`1,500,000 / 10 ** 6`).
   *
   * @dev NOTE: This information is only used for _display_ purposes: it in
   *      no way affects any of the arithmetic of the contract, including balanceOf() and transfer().
   */
  uint8 public constant decimals = 18;

  /**
   * @notice Total supply of the token: initially 7,000,000,
   *      with the potential to grow up to 10,000,000 during yield farming period (3 years)
   *
   * @dev ERC20 `function totalSupply() public view returns (uint256)`
   *
   * @dev Field is declared public: getter totalSupply() is created when compiled,
   *      it returns the amount of tokens in existence.
   */
  uint256 public totalSupply; // is set to 7 million * 10^18 in the constructor

  /**
   * @dev A record of all the token balances
   * @dev This mapping keeps record of all token owners:
   *      owner => balance
   */
  mapping(address => uint256) public tokenBalances;

  /**
   * @notice A record of each account's voting delegate
   *
   * @dev Auxiliary data structure used to sum up an account's voting power
   *
   * @dev This mapping keeps record of all voting power delegations:
   *      voting delegator (token owner) => voting delegate
   */
  mapping(address => address) public votingDelegates;

  /**
   * @notice A voting power record binds voting power of a delegate to a particular
   *      block when the voting power delegation change happened
   */
  struct VotingPowerRecord {
    /*
     * @dev block.number when delegation has changed; starting from
     *      that block voting power value is in effect
     */
    uint64 blockNumber;

    /*
     * @dev cumulative voting power a delegate has obtained starting
     *      from the block stored in blockNumber
     */
    uint192 votingPower;
  }