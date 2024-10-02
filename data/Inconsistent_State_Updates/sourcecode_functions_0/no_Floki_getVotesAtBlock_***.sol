function getVotesAtBlock(address account, uint32 blockNumber) public view returns (uint224) {
        require(
            blockNumber < block.number,
            "FLOKI:getVotesAtBlock:FUTURE_BLOCK: Cannot get votes at a block in the future."
        );

        uint32 nCheckpoints = numCheckpoints[account];
        if (nCheckpoints == 0) {
            return 0;
        }

        // First check most recent balance.
        if (checkpoints[account][nCheckpoints - 1].blockNumber <= blockNumber) {
            return checkpoints[account][nCheckpoints - 1].votes;
        }

        // Next check implicit zero balance.
        if (checkpoints[account][0].blockNumber > blockNumber) {
            return 0;
        }

        // Perform binary search.
        uint32 lowerBound = 0;
        uint32 upperBound = nCheckpoints - 1;
        while (upperBound > lowerBound) {
            uint32 center = upperBound - (upperBound - lowerBound) / 2;
            Checkpoint memory checkpoint = checkpoints[account][center];

            if (checkpoint.blockNumber == blockNumber) {
                return checkpoint.votes;
            } else if (checkpoint.blockNumber < blockNumber) {
                lowerBound = center;
            } else {
                upperBound = center - 1;
            }
        }

        // No exact block found. Use last known balance before that block number.
        return checkpoints[account][lowerBound].votes;
    }