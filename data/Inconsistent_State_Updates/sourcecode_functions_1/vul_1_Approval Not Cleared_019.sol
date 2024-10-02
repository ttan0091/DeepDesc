function wrapETH2LD(
    string calldata label,
    address wrappedOwner,
    uint32 fuses,
    uint64 expiry,
    address resolver
) public {
    uint256 tokenId = uint256(keccak256(bytes(label)));
    address registrant = registrar.ownerOf(tokenId);
    registrar.transferFrom(registrant, address(this), tokenId);
    registrar.reclaim(tokenId, address(this));
    require(
        registrant == msg.sender ||
        registrar.isApprovedForAll(registrant, msg.sender),
        "Unauthorised"
    );
    emit WrapETH2LD(label, wrappedOwner, fuses, expiry, resolver);
}