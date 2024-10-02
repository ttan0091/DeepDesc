function transferFrom(
		address from,
		address to,
		uint256 value
		)
	public
returns (bool)
{
	require(value <= _allowed[from][msg.sender]);

_allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
_transfer(from, to, value);
return true;
  }