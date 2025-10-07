///@function	approach(start, end, shift)
///@description	gradually increments or decrements a value towards a target by a shift increment
///@param	{real}	_start	starting value
///@param	{real}	_end	ending value
///@param	{real}	_shift	absolute increment size
///@return	{real}	the value
function approach(_start, _end, _shift) {
	if (_start < _end)	return min(_start + _shift, _end); 
	else				return max(_start - _shift, _end);
}