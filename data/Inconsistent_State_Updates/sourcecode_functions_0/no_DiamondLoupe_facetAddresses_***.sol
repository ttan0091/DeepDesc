function facetAddresses () external override view returns (address[] memory addresses) {
    DiamondBaseStorage.Layout storage l = DiamondBaseStorage.layout();

    addresses = new address[](l.selectorCount);
    uint256 numFacets;
    uint256 selectorIndex;

    for (uint256 slotIndex; selectorIndex < l.selectorCount; slotIndex++) {
      bytes32 slot = l.selectorSlots[slotIndex];

      for (uint256 selectorSlotIndex; selectorSlotIndex < 8; selectorSlotIndex++) {
        selectorIndex++;

        if (selectorIndex > l.selectorCount) {
          break;
        }

        bytes4 selector = bytes4(slot << (selectorSlotIndex << 5));
        address facet = address(bytes20(l.facets[selector]));

        bool continueLoop;

        for (uint256 facetIndex; facetIndex < numFacets; facetIndex++) {
          if (facet == addresses[facetIndex]) {
            continueLoop = true;
            break;
          }
        }

        if (continueLoop) {
          continue;
        }

        addresses[numFacets] = facet;
        numFacets++;
      }
    }

    // set the number of facet addresses in the array
    assembly { mstore(addresses, numFacets) }
  }