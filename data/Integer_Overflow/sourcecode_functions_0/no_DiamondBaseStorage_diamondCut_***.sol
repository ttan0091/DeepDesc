function diamondCut(
    Layout storage l,
    IDiamondCuttable.FacetCut[] memory facetCuts,
    address target,
    bytes memory data
  ) internal {
    unchecked {
      uint256 originalSelectorCount = l.selectorCount;
      uint256 selectorCount = originalSelectorCount;
      bytes32 selectorSlot;

      // Check if last selector slot is not full
      if (selectorCount & 7 > 0) {
        // get last selectorSlot
        selectorSlot = l.selectorSlots[selectorCount >> 3];
      }

      for (uint256 i; i < facetCuts.length; i++) {
        IDiamondCuttable.FacetCut memory facetCut = facetCuts[i];
        IDiamondCuttable.FacetCutAction action = facetCut.action;

        require(
          facetCut.selectors.length > 0,
          'DiamondBase: no selectors specified'
        );

        if (action == IDiamondCuttable.FacetCutAction.ADD) {
          (selectorCount, selectorSlot) = l.addFacetSelectors(
            selectorCount,
            selectorSlot,
            facetCut
          );
        } else if (action == IDiamondCuttable.FacetCutAction.REMOVE) {
          (selectorCount, selectorSlot) = l.removeFacetSelectors(
            selectorCount,
            selectorSlot,
            facetCut
          );
        } else if (action == IDiamondCuttable.FacetCutAction.REPLACE) {
          l.replaceFacetSelectors(facetCut);
        }
      }

      if (selectorCount != originalSelectorCount) {
        l.selectorCount = uint16(selectorCount);
      }

      // If last selector slot is not full
      if (selectorCount & 7 > 0) {
        l.selectorSlots[selectorCount >> 3] = selectorSlot;
      }

      emit DiamondCut(facetCuts, target, data);
      initialize(target, data);
    }
  }