function generalVote(bytes32 digest, Signature[] memory signatures) internal {
      require(signatures.length >= 2 * oraclesSet.length / 3, "Not enough signatures");
      require(!finishedVotings[digest], "Vote is already finished");
      uint signum = signatures.length;
      uint last_signer = 0;
      for(uint i=0; i<signum; i++) {
        address signer = signatures[i].signer;
        require(isOracle[signer], "Unauthorized signer");
        uint next_signer = uint(signer);
        require(next_signer > last_signer, "Signatures are not sorted");
        last_signer = next_signer;
        checkSignature(digest, signatures[i]);
      }
      finishedVotings[digest] = true;
    }