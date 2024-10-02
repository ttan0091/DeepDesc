function checkpoints(address account, uint32 pos)
        public
        view
        virtual
        returns (Checkpoint memory checkpoint)
    {
        (uint32 fromBlock, uint96 votes) = decodeCheckpoint(
            _checkpoints[account][pos]
        );
        checkpoint = Checkpoint(fromBlock, votes);
    }