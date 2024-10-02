function addFacetSelectors (
    Layout storage l,
    uint256 selectorCount,
    bytes32 selectorSlot,
    IDiamondCuttable.FacetCut memory facetCut
  ) internal returns (uint256, bytes32) {
    unchecked {
      require(
        facetCut.target == address(this) || facetCut.target.isContract(),
        'DiamondBase: ADD target has no code'
      );

      for (uint256 i; i < facetCut.selectors.length; i++) {
        bytes4 selector = facetCut.selectors[i];
        bytes32 oldFacet = l.facets[selector];

        require(
          address(bytes20(oldFacet)) == address(0),
          'DiamondBase: selector already added'
        );

        // add facet for selector
        l.facets[selector] = bytes20(facetCut.target) | bytes32(selectorCount);
        uint256 selectorInSlotPosition = (selectorCount & 7) << 5;

        // clear selector position in slot and add selector
        selectorSlot = (
          selectorSlot & ~(CLEAR_SELECTOR_MASK >> selectorInSlotPosition)
        ) | (bytes32(selector) >> selectorInSlotPosition);

        // if slot is full then write it to storage
        if (selectorInSlotPosition == 224) {
          l.selectorSlots[selectorCount >> 3] = selectorSlot;
          selectorSlot = 0;
        }

        selectorCount++;
      }

      return (selectorCount, selectorSlot);
    }
  }