///@function			array_find_any(_things, _array)
///@description			looks for any of the things into the array
///@param	{array}		_array		target array to search things in 
///@param	{any}		_things		object/array of objects to search for
///@return	{real}		the index of the first occurrence of any of the things looked for in the target array or -1 if not found
function array_find_any(_array, _things) {
	if (!is_array(_things)) {
		var _lookup_array = [_things];
	}
	else {
		var _lookup_array = _things;
	}
	if (!is_array(_array)) {
		var _target_array = [_array];
	}
	else {
		var _target_array = _array;
	}
		
	var _n = array_length(_target_array);
	var _m = array_length(_lookup_array);
	var _j = 0;
	var _found = false;
	while (_j<_m && !_found) {
		var _i=0;			
		while (_i<_n && !_found) {
			if (_target_array[_i] == _lookup_array[_j]) {
				_found = true;
			}
			else {
				_i++;	
			}
		}
		if (!_found) {
			_j++;
		}
	}
		
	if (_found) {
		return _i;
	}
	else {
		return -1;
	}
}

///@function			array_resize_from_end(_array, _new_size)
///@description			resizes the array starting from the end working left
///@param	{array}		_array		target array
///@param	{real}		_new_size	the new size of the array
function array_resize_from_end(_array, _new_size) {
	var _n = array_length(_array);
	if (_new_size < _n) {		
		for (var _i=0; _i<_new_size; _i++) {
			// removed the array accessor @ since it's no longer on by default in GM
			_array[_i] = _array[_i+_n-_new_size];
		}
		array_resize(_array, _new_size);
	}
}

///@function		array_create_numeric(_value_start, _value_end, _increment_or_size)
///@description		creates a numeric array with start, end and increment conditions
///@param			{real}	_value_start		starting value
///@param			{real}	_value_end			ending value
///@param			{real}	_increment_or_size	increment value - if start=end, represents size instead
///@return			the array
function array_create_numeric(_value_start, _value_end, _increment_or_size=1) {
	var _arr = [];
	if (_value_start == _value_end)		repeat(_increment_or_size)				array_push(_arr, _value_start);
	else for (var _i=_value_start; _i<=_value_end; _i += _increment_or_size)	array_push(_arr, _i);
	return _arr;
}

///@function			array_random(array=[], probabilities=[], return_index=false)
///@description			selects an item or index from the array with the specified probability array
///@param				{array}		_array			the array that holds the values to select from
///@param				{array}		_probabilities	the array that holds the corresponding probabilities
///@param				{bool}		_return_index	if true return selected index; if false [default] return value from _array
///@return				{any}		the randomly selected item or index
function array_random(_array = [], _probabilities = [], _return_index = false) {
	// Specifying an empty _array means [0,1,...] the same size as _probs array
	// Specifying an empty _probs means considering uniform probabilities the same size as _array
	// If both are empty, generate a Bernoulli with p=0.5 (fair coin toss)
	var _arr = _array;
	var _probs = _probabilities;
	var _n = array_length(_arr);
	var _p = array_length(_probs);
	if (!is_array(_arr) && !is_array(_probs) || _n == 0 && _p == 0) {
		return choose(0,1);
	}
	else {
		if (array_length(_arr) == 0) 	for (var _i=0; _i<_p; _i++)		array_push(_arr, _i);
		if (array_length(_probs) == 0)	for (var _i=0; _i<_n; _i++)		array_push(_probs, 1/_n);
		_n = array_length(_arr);
		_p = array_length(_probs);
		if (_n != _p) throw("The value array and the probability array must be of the same size");
		var _neg = false;
		_i=0; 
		while (_i<_p && !_neg) {
			if (_probs[_i] < 0)		_neg = true;
			else _i++;
		}
		if (_neg) throw("The probability array cannot have negative values");
			
		
		// Normalize probability array
		var _sum = 0;
		for (var _i=0; _i<_p; _i++)		_sum += _probs[_i];
		if (abs(1-_sum) != 1)	for (var _i=0; _i<_p; _i++)		_probs[_i] /= _sum;
		
		// Generate continuous random variable and compare against CDF
		var _u = random(1);
		
		var _i = 0;
		var _cdf = _probs[0];
		while (_u > _cdf && _i<_p) {
			_i++;
			_cdf += _probs[_i];	
		}
			
		if (_return_index)	return _i;
		else return _arr[_i];
	}
}
