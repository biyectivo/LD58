global.animatron_animations = {};

#macro ANIMATRON_VERSION								2025.9
#macro ANIMATRON_CALLBACK_POINT_PRECISION_THRESHOLD		0.0001
#macro ANIMATRON_TIME_SOURCE_PARENT						time_source_game

function animation_add(_id, _instance_or_struct, _variable_name, _target, _num_frames, _animation_curve, _loops=false, _target_is_delta=false, _callbacks=[], _animation_curve_channel_index = 0) {
	if (_instance_or_struct != "global" && !instance_exists(_instance_or_struct) && !is_struct(_instance_or_struct))	throw(string($"ERROR: Animatron: invalid variable, must be either the string 'global' or the reference of an instance or struct"));
	if (!is_real(_target)) throw(string($"ERROR: Animatron: target must be real"));
	if (!is_real(_num_frames) || _num_frames <= 0) throw(string($"ERROR: Animatron: invalid number of frames, must be positive"));
	if (!animcurve_exists(_animation_curve)) throw(string($"Error: Animatron: animation curve does not exist"));
	if (!is_real(_animation_curve_channel_index) || _animation_curve_channel_index < 0) throw(string($"Error: Animatron: animation curve channel index must be >= 0"));
	if (!is_bool(_target_is_delta)) throw(string($"Error: Animatron: target_is_delta must be boolean"));
	if (!is_array(_callbacks)) throw(string($"Error: Animatron: callbacks parameter must be a array containing \{time, callback\} structs, where time should be between 0.0 and 1.0, and callback must be a callable function"));
	for (var _i=0, _n=array_length(_callbacks); _i<_n; _i++) {
		var _callback = _callbacks[_i];
		if (_callback.time < 0.0 || _callback.time > 1.0) throw(string($"Error: Animatron: invalid time key '{_callback.time}' in callback struct - must be a real between 0.0 and 1.0"));
		if (!is_callable(_callback.callback)) throw(string($"Error: Animatron: callback configured for '{_callback.time}' needs to be a callable function"));
	}
	
	global.animatron_animations[$ _id] = {	
		instance_or_struct: _instance_or_struct,
		variable_name: _variable_name,
		target: _target,
		num_frames: _num_frames,
		animation_curve: _animation_curve,
		animation_curve_channel_index: _animation_curve_channel_index,
		target_is_delta: _target_is_delta,
		callbacks: _callbacks,
		loops: _loops,
		
		
		start_value: undefined,
		current_frame: undefined,
		current_x: undefined,
		current_value: undefined,
		started: false,
		ended: false,
		ts: undefined,
	};	
}

function animation_start(_id) {
	if (!variable_struct_exists(global.animatron_animations, _id)) throw(string($"Error: Animatron: animation id does not exist, '{_id}'"));
	var _anim = global.animatron_animations[$ _id];
	
	if (_anim.instance_or_struct == "global" && !variable_global_exists(_anim.variable_name))													throw(string($"Error: Animatron: global variable '{_anim.variable_name}' configured in animation {_id}, no longer exists"));
	if (is_struct(_anim.instance_or_struct) && !variable_struct_exists(_anim.instance_or_struct, _anim.variable_name))							throw(string($"Error: Animatron: struct variable '{_anim.variable_name}' configured in animation {_id}, no longer exists"));
	if (!is_struct && !instance_exists(_anim.instance_or_struct))																				throw(string($"Error: Animatron: instance '{_anim.instance_or_struct}' configured in animation {_id}, no longer exists"));
	if (!is_struct && instance_exists(_anim.instance_or_struct) && !variable_instance_exists(_anim.instance_or_struct, _anim.variable_name))	throw(string($"Error: Animatron: instance variable '{_anim.variable_name}' configured in animation {_id}, no longer exists"));
	
	if (_anim.instance_or_struct == "global" && !variable_global_exists(_anim.variable_name))	throw(string($"Error: Animatron: global variable '{_anim.variable_name}' configured in animation {_id}, no longer exists"));
	
	_anim.start_value = _anim.instance_or_struct == "global" ? variable_global_get(_anim.variable_name) : (is_struct(_anim.variable_name) ? struct_get(_anim.instance_or_struct, _anim.variable_name) : variable_instance_get(_anim.instance_or_struct, _anim.variable_name) );
	_anim.current_frame = 0;
	_anim.current_x = 0;
	_anim.started = true;
	
	if (time_source_exists(_anim.ts)) time_source_destroy(_anim.ts);
	
	_anim.ts = time_source_create(ANIMATRON_TIME_SOURCE_PARENT, 1, time_source_units_frames, method({id: _id}, function() {
		var _anim = global.animatron_animations[$ id];
		
		var _delta = _anim.target_is_delta ? _anim.target : (_anim.target-_anim.start_value);
		
		_anim.current_value = animcurve_channel_evaluate(animcurve_get_channel(_anim.animation_curve, _anim.animation_curve_channel_index), _anim.current_x) * _delta;
		
		// Set value
		if (_anim.instance_or_struct == "global")	variable_global_set(_anim.variable_name, _anim.start_value + _anim.current_value);
		else if (is_struct(_anim.variable_name))	struct_set(_anim.instance_or_struct, _anim.variable_name, _anim.start_value + _anim.current_value);
		else										variable_instance_set(_anim.instance_or_struct, _anim.variable_name, _anim.start_value + _anim.current_value);
		
		//show_debug_message($"Info: Animatron: x={_anim.current_x} f(x)={_anim.current_value} start value = {_anim.start_value} current value = {_anim.start_value + _anim.current_value}");
		
		// Process callbacks
		for (var _i=0, _n=array_length(_anim.callbacks); _i<_n; _i++) {
			var _callback = _anim.callbacks[_i];
			if (abs(_callback.time - _anim.current_x) < ANIMATRON_CALLBACK_POINT_PRECISION_THRESHOLD) {
				_callback.callback();
			}
		}
		
		// Update values
		
		_anim.current_frame++;
		_anim.current_x += 1/_anim.num_frames;
		
		if (_anim.current_x > 1) {
			if (_anim.loops) {
				animation_start(id);
			}
			else {
				_anim.ended = true;
				time_source_destroy(_anim.ts);
			}
		}
		
	}), [], _anim.num_frames+1, time_source_expire_nearest);
	
	time_source_start(_anim.ts);
}

function animation_pause(_id) {
	if (!variable_struct_exists(global.animatron_animations, _id)) throw(string($"Error: Animatron: animation id does not exist, '{_id}'"));
	var _anim = global.animatron_animations[$ _id];
	if (!_anim.started || _anim.ended) exit;
	
	if (time_source_get_state(_anim.ts) == time_source_state_active) time_source_pause(_anim.ts);
}

function animation_resume(_id) {
	if (!variable_struct_exists(global.animatron_animations, _id)) throw(string($"Error: Animatron: animation id does not exist, '{_id}'"));
	var _anim = global.animatron_animations[$ _id];
	if (!_anim.started || _anim.ended) exit;
	
	if (time_source_get_state(_anim.ts) == time_source_state_paused) time_source_resume(_anim.ts);
}

function animation_exists(_id) {
	return variable_struct_exists(global.animatron_animations, _id);
}

function animation_get(_id) {
	if (!variable_struct_exists(global.animatron_animations, _id)) throw(string($"Error: Animatron: animation id does not exist, '{_id}'"));
	var _anim = global.animatron_animations[$ _id];
	return _anim;
}

function animation_has_started(_id) {
	if (!variable_struct_exists(global.animatron_animations, _id)) throw(string($"Error: Animatron: animation id does not exist, '{_id}'"));
	var _anim = global.animatron_animations[$ _id];
	return _anim.started;
}

function animation_has_ended(_id) {
	if (!variable_struct_exists(global.animatron_animations, _id)) throw(string($"Error: Animatron: animation id does not exist, '{_id}'"));
	var _anim = global.animatron_animations[$ _id];
	return _anim.ended;
}

function animation_is_running(_id) {
	if (!variable_struct_exists(global.animatron_animations, _id)) throw(string($"Error: Animatron: animation id does not exist, '{_id}'"));
	var _anim = global.animatron_animations[$ _id];
	return _anim.started && !_anim.ended;
}

function animation_add_after(_id, _id_after, _delay=0) {
	if (!variable_struct_exists(global.animatron_animations, _id)) throw(string($"Error: Animatron: animation id does not exist, '{_id}'"));
	if (!variable_struct_exists(global.animatron_animations, _id_after)) throw(string($"Error: Animatron: animation to add after '{_id}' does not exist, '{_id_after}'"));
	var _anim = global.animatron_animations[$ _id];
	array_push(_anim.callbacks, {time: 1, callback: method({id_after: _id_after, delay: _delay}, function() {
		if (delay > 0) call_later(delay, time_source_units_frames, method({id_after}, function() { animation_start(id_after); }), false);
		else animation_start(id_after);
	})});
}

function animation_stop(_id) {
	if (!variable_struct_exists(global.animatron_animations, _id)) throw(string($"Error: Animatron: animation id does not exist, '{_id}'"));
	var _anim = global.animatron_animations[$ _id];
	if (!_anim.started || _anim.ended) exit;
	
	if (time_source_exists(_anim.ts)) time_source_destroy(_anim.ts);
	
	_anim.start_value = undefined;
	_anim.current_frame = undefined;
	_anim.current_x = undefined;
	_anim.current_value = undefined;
	_anim.started = false;
	_anim.ended = false;
	_anim.ts = undefined;	
}

function animation_pause_all() {
	var _arr = variable_struct_get_names(global.animatron_animations);
	for (var _i=0, _n=array_length(_arr); _i<_n; _i++) {
		animation_pause(_arr[_i]);
	}
}

function animation_resume_all() {
	var _arr = variable_struct_get_names(global.animatron_animations);
	for (var _i=0, _n=array_length(_arr); _i<_n; _i++) {
		animation_resume(_arr[_i]);
	}
}

function animation_stop_all() {
	var _arr = variable_struct_get_names(global.animatron_animations);
	for (var _i=0, _n=array_length(_arr); _i<_n; _i++) {
		animation_stop(_arr[_i]);
	}
}

show_debug_message($"Welcome to Animatron v{ANIMATRON_VERSION}, a simple tweening library by manta ray");