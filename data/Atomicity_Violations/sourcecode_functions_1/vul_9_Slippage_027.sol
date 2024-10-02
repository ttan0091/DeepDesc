function liquidate(address trader) override external whenNotPaused {
    updatePositions(trader);
    if (isMaker(trader)) {
        _liquidateMaker(trader);
    } else {
        _liquidateTaker(trader);
    }
}