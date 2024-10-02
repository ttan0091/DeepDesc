function mintMaxAllowableVolt(address to)
    external
    virtual
    override
    whenNotPaused
{
    uint256 amount = Math.min(individualBuffer(msg.sender), buffer());

    _depleteIndividualBuffer(msg.sender, amount);
    _mintVolt(to, amount);
}