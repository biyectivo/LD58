///@function		random_sample(_array, _sample_size _with_replacement)
///@description		samples n items from an array
///@param			{array}		_array				the array to sample from
///@param			{real}		_sample_size		sample size
///@param			{bool}		_with_replacement	whether to sample with replacement or not - default: false
///@return			{any}		the selected sample
function random_sample(_array, _sample_size, _with_replacement=false) {
	var _sample = [];
	if (_with_replacement) {
		var _arr = [];
		array_copy(_arr, 0, _array, 0, array_length(_array));
		var _n = array_length(_arr);
		repeat (_sample_size) {
			var _idx = irandom_range(0, _n-1);
			array_push(_sample, _arr[_idx]);
			array_delete(_arr, _idx, 1);
			_n = array_length(_arr);
		}
	}
	else {
		var _n = array_length(_array);
		repeat (_sample_size)	array_push(_sample, _array[irandom_range(0, _n-1)]);
	}
	return _sample;
}