function _getImplementation () override internal view returns (address) {
    // inline storage layout retrieval uses less gas
    DiamondBaseStorage.Layout storage l;
    bytes32 slot = DiamondBaseStorage.STORAGE_SLOT;
    assembly { l.slot := slot }

    address implementation = address(bytes20(l.facets[msg.sig]));

    if (implementation == address(0)) {
      implementation = l.fallbackAddress;
      require(
        implementation != address(0),
        'DiamondBase: no facet found for function signature'
      );
    }

    return implementation;
  }