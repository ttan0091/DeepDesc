function removeFacetSelectors (
    Layout storage l,
    uint256 selectorCount,
    bytes32 selectorSlot,
    IDiamondCuttable.FacetCut memory facetCut
  ) internal returns (uint256, bytes32) {
    unchecked {
      require(
        facetCut.target == address(0),
        'DiamondBase: REMOVE target must be zero address'
      );

      uint256 selectorSlotCount = selectorCount >> 3;
      uint256 selectorInSlotIndex = selectorCount & 7;

      for (uint256 i; i < facetCut.selectors.length; i++) {
        bytes4 selector = facetCut.selectors[i];
        bytes32 oldFacet = l.facets[selector];

        require(
          address(bytes20(oldFacet)) != address(0),
          'DiamondBase: selector not found'
        );

        require(
          address(bytes20(oldFacet)) != address(this),
          'DiamondBase: selector is immutable'
        );

        if (selectorSlot == 0) {
          selectorSlotCount--;
          selectorSlot = l.selectorSlots[selectorSlotCount];
          selectorInSlotIndex = 7;
        } else {
          selectorInSlotIndex--;
        }

        bytes4 lastSelector;
        uint256 oldSelectorsSlotCount;
        uint256 oldSelectorInSlotPosition;

        // adding a block here prevents stack too deep error
        {
          // replace selector with last selector in l.facets
          lastSelector = bytes4(selectorSlot << (selectorInSlotIndex << 5));

          if (lastSelector != selector) {
            // update last selector slot position info
            l.facets[lastSelector] = (
              oldFacet & CLEAR_ADDRESS_MASK
            ) | bytes20(l.facets[lastSelector]);
          }

          delete l.facets[selector];
          uint256 oldSelectorCount = uint16(uint256(oldFacet));
          oldSelectorsSlotCount = oldSelectorCount >> 3;
          oldSelectorInSlotPosition = (oldSelectorCount & 7) << 5;
        }

        if (oldSelectorsSlotCount != selectorSlotCount) {
          bytes32 oldSelectorSlot = l.selectorSlots[oldSelectorsSlotCount];

          // clears the selector we are deleting and puts the last selector in its place.
          oldSelectorSlot = (
            oldSelectorSlot & ~(CLEAR_SELECTOR_MASK >> oldSelectorInSlotPosition)
          ) | (bytes32(lastSelector) >> oldSelectorInSlotPosition);

          // update storage with the modified slot
          l.selectorSlots[oldSelectorsSlotCount] = oldSelectorSlot;
        } else {
          // clears the selector we are deleting and puts the last selector in its place.
          selectorSlot = (
            selectorSlot & ~(CLEAR_SELECTOR_MASK >> oldSelectorInSlotPosition)
          ) | (bytes32(lastSelector) >> oldSelectorInSlotPosition);
        }

        if (selectorInSlotIndex == 0) {
          delete l.selectorSlots[selectorSlotCount];
          selectorSlot = 0;
        }
      }

      selectorCount = (selectorSlotCount << 3) | selectorInSlotIndex;

      return (selectorCount, selectorSlot);
    }
  }