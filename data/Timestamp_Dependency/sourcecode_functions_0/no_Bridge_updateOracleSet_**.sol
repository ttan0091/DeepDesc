function updateOracleSet(int oracleSetHash, address[] memory newSet) internal {
      uint oldSetLen = oraclesSet.length;
      for(uint i = 0; i < oldSetLen; i++) {
        isOracle[oraclesSet[i]] = false;
      }
      oraclesSet = newSet;
      uint newSetLen = oraclesSet.length;
      for(uint i = 0; i < newSetLen; i++) {
        require(!isOracle[newSet[i]], "Duplicate oracle in Set");
        isOracle[newSet[i]] = true;
      }
      emit NewOracleSet(oracleSetHash, newSet);
    }