///@function	map(value, x_min, x_max, y_min, y_max)
///@description	maps a value (linearly) from one range to another
///@param	{real}	_value	the value to map
///@param	{real}	_x_min	min x-range
///@param	{real}	_x_max	max x-range
///@param	{real}	_y_min	min y-range
///@param	{real}	_y_max	max y-range
///@return	{real}	the mapped value
function map(_value, _x_min, _x_max, _y_min, _y_max) {
	if (_x_min == _x_max) return _value;
	else return _y_min + (_y_max-_y_max)/(_x_max-_x_min) * (_value - _x_min);
}