function facets () external override view returns (Facet[] memory diamondFacets) {
    DiamondBaseStorage.Layout storage l = DiamondBaseStorage.layout();

    diamondFacets = new Facet[](l.selectorCount);

    uint8[] memory numFacetSelectors = new uint8[](l.selectorCount);
    uint256 numFacets;
    uint256 selectorIndex;

    // loop through function selectors
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
          if (diamondFacets[facetIndex].target == facet) {
            diamondFacets[facetIndex].selectors[numFacetSelectors[facetIndex]] = selector;
            // probably will never have more than 256 functions from one facet contract
            require(numFacetSelectors[facetIndex] < 255);
            numFacetSelectors[facetIndex]++;
            continueLoop = true;
            break;
          }
        }

        if (continueLoop) {
          continue;
        }

        diamondFacets[numFacets].target = facet;
        diamondFacets[numFacets].selectors = new bytes4[](l.selectorCount);
        diamondFacets[numFacets].selectors[0] = selector;
        numFacetSelectors[numFacets] = 1;
        numFacets++;
      }
    }

    for (uint256 facetIndex; facetIndex < numFacets; facetIndex++) {
      uint256 numSelectors = numFacetSelectors[facetIndex];
      bytes4[] memory selectors = diamondFacets[facetIndex].selectors;

      // setting the number of selectors
      assembly { mstore(selectors, numSelectors) }
    }

    // setting the number of facets
    assembly { mstore(diamondFacets, numFacets) }
  }