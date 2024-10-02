function lookupCheckpoint(uint128[] storage ckpts, uint256 blockNumber)
        internal
        view
        returns (uint96)
    {
        // We run a binary search to look for the earliest checkpoint taken
        // after `blockNumber`. During the loop, the index of the wanted
        // checkpoint remains in the range [low-1, high). With each iteration,
        // either `low` or `high` is moved towards the middle of the range to
        // maintain the invariant.
        // - If the middle checkpoint is after `blockNumber`,
        //   we look in [low, mid)
        // - If the middle checkpoint is before or equal to `blockNumber`,
        //   we look in [mid+1, high)
        // Once we reach a single value (when low == high), we've found the
        // right checkpoint at the index high-1, if not out of bounds (in that
        // case we're looking too far in the past and the result is 0).
        // Note that if the latest checkpoint available is exactly for
        // `blockNumber`, we end up with an index that is past the end of the
        // array, so we technically don't find a checkpoint after
        // `blockNumber`, but it works out the same.
        require(blockNumber < block.number, "Block not yet determined");

        uint256 high = ckpts.length;
        uint256 low = 0;
        while (low < high) {
            uint256 mid = Math.average(low, high);
            uint32 midBlock = decodeBlockNumber(ckpts[mid]);
            if (midBlock > blockNumber) {
                high = mid;
            } else {
                low = mid + 1;
            }
        }

        return high == 0 ? 0 : decodeValue(ckpts[high - 1]);
    }