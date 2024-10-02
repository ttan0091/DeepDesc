function generateFLNQuote() public override {
    latestFlanQuotes[1] = latestFlanQuotes[0];
    (
        latestFlanQuotes[0].DaiScxSpotPrice,
        latestFlanQuotes[0].DaiBalanceOnBehodler
    ) = getLatestFLNQuote();
    latestFlanQuotes[0].blockProduced = block.number;
}