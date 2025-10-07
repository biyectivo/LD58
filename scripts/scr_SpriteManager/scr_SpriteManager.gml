// Feather ignore all
#macro	SPRITEMAN_VERSION		"2024.11"


function SpriteManager(_name="") constructor {
	self.name = _name;
	self.states = [];
	self.current_state_index = -1;
	self.counter = 0;
	self.current_frame = -1;
	self.max_counter = -1;
	
	self.last_sprite = undefined;
	self.last_index = undefined;
	self.last_image_xscale = undefined;
	
	self.__owner = other;
	self.__ts = undefined;
	
	/// @func	add_state(state, direction, sprite, start_frame=0, [num_frames=sprite_get_number[sprite]], [delay=SPRITEMAN_DEFAULT_DELAY], [increment=1], [loops=true], [flip_horizontal=false])
	/// @desc	creates a new animation state consisting of a state (name) and an optional direction/qualifier
	/// @param	{String}				_state				the name of the state
	/// @param	{String}				_direction			the name of an optional qualifier or "suffix" a state can have. Useful for representing sprite direction or other topics. For example, an animation state could consist of a state name "Idle" and direction "North"
	/// @param	{Asset.GMSprite}		_sprite				the sprite asset to use
	/// @param	{Real}					_start_frame		the first image index of the animation
	/// @param	{Real}					[_num_frames]		the number of frames to use for the animation. Optional - by default, the number of frames in the sprite asset. Note this is NOT the final frame to show but rather the total count of frames to display before either looping or ending
	/// @param	{Real}					[_delay]			the delay to use before changing to the next frame of animation. Optional - by default, the configured value in SpriteMan's Configuration Script
	/// @param	{Real}					[_increment]		the number of frames to change. Optional - by default, 1, which means the next frame will be the one directly after the previous one. Can be negative if needed
	/// @param	{Bool}					[_loops]			whether to loop the animation after the number of frames has been reached. Optional - by default, true
	/// @param	{Bool}					[_flip_horizontal]	whether to flip the sprite horizontally. Optional - by default, false. Note that it will preserve the absolute value of the image xscale (when drawing automatically)
	static add_state = function(_state, _direction, _sprite, _start_frame=0, _num_frames=sprite_get_number(_sprite), _delay=SPRITEMAN_DEFAULT_DELAY, _increment=1, _loops=true, _flip_horizontal=false) {
		if (_start_frame < 0)	throw(string($"[SpriteMan] ERROR: Trying to add state {_state} direction {_direction}: Start frame must be nonnegative."));
		if (_num_frames <= 0)	throw(string($"[SpriteMan] ERROR: Trying to add state {_state} direction {_direction}: Number of frames must be positive."));
		if (_delay < 0)			throw(string($"[SpriteMan] ERROR: Trying to add state {_state} direction {_direction}: Delay must be nonnegative."));
		if (_increment == 0)	throw(string($"[SpriteMan] ERROR: Trying to add state {_state} direction {_direction}: Increment must be non-zero."));
		
		var _struct =	{	
							state: _state, 
							direction: _direction, 
							sprite: _sprite, 
							start_frame: _start_frame,
							num_frames: _num_frames, 
							delay: _delay,
							delay_type: SPRITEMAN_TIME_SOURCE_DEFAULT_DELAY_TYPE,
							time_source_parent: SPRITEMAN_TIME_SOURCE_DEFAULT_PARENT,
							increment: _increment, 
							loops: _loops, 
							loop_boomerang: false,
							flip_horizontal: _flip_horizontal,
							started: false,
							ended: false,
							repeated_times: 0,
							cumulative_repeated_times: 0,
							callbacks: [],
							
							__: {
								original_start_frame: _start_frame,
								original_increment: _increment,
							}
						};
		array_push(self.states, _struct);
	}
	
	/// @func	add_callback(state, direction, moment, callback, [repeats_every_loop=false])
	/// @desc	adds a callback to trigger at a specific moment (frame count). Note it is the frame COUNT, not the frame index (for example, the first moment is 1, not 0)
	/// @param	{String}				_state							the name of the state
	/// @param	{String}				_direction						the name of an optional qualifier or "suffix" a state can have. Useful for representing sprite direction or other topics. For example, an animation state could consist of a state name "Idle" and direction "North"
	/// @param	{Real}					_moment							the "moment" (frame count) to trigger the callback
	/// @param	{Function}				_callback						the callback function to use
	/// @param	{Bool}					[_repeats_every_loop=false]		whether to call the callback again when the animation loops (at every equivalent moment). Optional - by default, false, which means the callback will only be called the first moment. Note that if loop type is "boomerang" the callback will be called at every modulo moment (for example, with moment 1, the callback will be called at the first frame when going forward, then it will be called again on the first frame when going backwards etc.)
	static add_callback = function(_state, _direction, _moment, _callback, _repeats_every_loop=false) {
		var _idx = get(_state, _direction); // check if exists to throw error if it doesn't
		if (_moment == 0)				show_debug_message(string($"[SpriteMan] WARNING: Adding callback to state {_state} direction {_direction}: Callback will never occur, perhaps you meant moment 1 (the first animation frame)?"));
		if (_moment < 0)				show_debug_message(string($"[SpriteMan] WARNING: Adding callback to state {_state} direction {_direction}: Callback will never occur (moment is negative)"));
		if (!is_callable(_callback))	throw(string($"[SpriteMan] ERROR: Adding callback to state {_state} direction {_direction}: Callback is not callable"));
		
		var _state_struct = get(_state, _direction);
		array_push(_state_struct.callbacks,
			{
				moment: _moment,
				callback: _callback,
				repeats_every_loop: _repeats_every_loop,
			}
		);
	}
	
	/// @func	set(state, direction, [start=true])
	/// @desc	sets the sprite manager to a specific state name and direction and throws an error if it does not exist
	/// @param	{String}				_state				the name of the state
	/// @param	{String}				_direction			the name of an optional qualifier or "suffix" a state can have. Useful for representing sprite direction or other topics. For example, an animation state could consist of a state name "Idle" and direction "North"
	/// @param	{Bool}					[_state]			whether to initialize the state. Optional - by default, true
	static set = function(_state, _direction, _start=true) {
		self.current_state_index = array_find_index(self.states, method({state: _state, direction: _direction}, function (_elem, _index) {
			return _elem.state = state && _elem.direction = direction;
		}));
		if (self.current_state_index == -1)	throw(string($"[SpriteMan] ERROR: State+direction combo {_state},{_direction} does not exist"));
		
		if (_start) start();
	}
	
	/// @func	get(_state, _direction)
	/// @desc	gets the state with the given state name and direction and throws an error if it does not exist
	/// @param	{String}				_state				the name of the state
	/// @param	{String}				_direction			the name of an optional qualifier or "suffix" a state can have. Useful for representing sprite direction or other topics. For example, an animation state could consist of a state name "Idle" and direction "North"
	/// @return	{Struct}				the state struct
	static get = function(_state, _direction) {
		var _idx = array_find_index(self.states, method({state: _state, direction: _direction}, function (_elem, _index) {
			return _elem.state = state && _elem.direction = direction;
		}));
		
		if (_idx == -1) throw(string($"[SpriteMan] ERROR: State+direction combo {_state},{_direction} does not exist"));
		return self.states[_idx];
	}
	
	/// @func	get_active_state()
	/// @desc	gets the active state, or undefined if no active state has been set
	/// @return	{Struct}	the state struct, or undefined
	static get_active_state = function() {
		if (self.current_state_index != -1)		return self.states[self.current_state_index];
		else return undefined;
	}
	
	/// @func	start()
	/// @desc	starts the active animation state, initializes all of its attributes. Throws an error if no active state has been set
	static start = function() {
		if (self.current_state_index == -1)	throw("[SpriteMan] ERROR: No active state+direction set");
		
		var _state = self.states[self.current_state_index];
		self.counter = 0;
		self.current_frame = -1;
		self.last_sprite = undefined;
		self.last_index = undefined;
		self.last_image_xscale = undefined;
		self.max_counter = _state.num_frames;
		_state.start_frame = _state.__.original_start_frame;
		_state.increment = _state.__.original_increment;
		_state.started = true;
		_state.ended = false;
		_state.repeated_times = 0;
		if (time_source_exists(self.__ts)) time_source_destroy(self.__ts);
	}
	
	/// @func	step([return_values=false])
	/// @desc	performs a step of the animation. This method should be called on each frame of the object in the Step event. Does nothing if no active step has been set.
	/// @param	{Bool}		[_return_values]		whether to return a struct of sprite index, image index and image xscale instead of setting the corresponding object variables. Optional - by default, false (hence the method will return undefined). Setting to true is useful to control manual drawing of the sprites (i.e. draw layered sprites when using multiple SpriteManagers, etc.)
	/// @return	{Struct}	undefined, or a struct of sprite index, image index and image xscale (if return_values is set to true)
	static step = function(_return_values = false) {
		if (self.current_state_index == -1)	return;
		
		var _state = self.states[self.current_state_index];
		
		if (!sprite_exists(_state.sprite)) {
			if (_return_values)		return {sprite_index: _state.sprite, image_idx: 0, image_xscale: self.last_image_xscale, state_data: _state};
			return;
		}
		
		if (_state.started && !_state.ended) {
			var _index = undefined;
			if ((!time_source_exists(self.__ts) || (time_source_exists(self.__ts) && time_source_get_state(self.__ts) == time_source_state_stopped))) {
				if (_state.loops || !_state.loops && self.counter < self.max_counter) {
					self.counter += 1;
					self.current_frame = (self.counter-1) % _state.num_frames;
					var _index = _state.start_frame + self.current_frame * _state.increment;
					if (_index < 0) _index = _state.num_frames+_index;
					else _index = _index % (sprite_exists(_state.sprite) ? sprite_get_number(_state.sprite) : 1);
				
					if (SPRITEMAN_VERBOSE) show_debug_message($"[SpriteMan] INFO: SpriteMan '{self.name}' State: {_state.state}, Direction: {_state.direction}: Counter:{self.counter} Max Counter:{self.max_counter} Current Frame:{self.current_frame} Start Frame:{_state.start_frame} Image Index:{_index}");
					
					// Process callbacks
					for (var _i=0, _n=array_length(_state.callbacks); _i<_n; _i++) {
						var _callback = _state.callbacks[_i];
						if (_callback.repeats_every_loop) {
							if (self.current_frame+1 == _callback.moment) {
								_callback.callback();
							}
						}
						else {
							if (self.counter == _callback.moment) {
								_callback.callback();
							}
						}
					}
					
					if (time_source_exists(self.__ts)) time_source_destroy(self.__ts);
					self.__ts = time_source_create(_state.time_source_parent, _state.delay, _state.delay_type, function() {}, [], 1, time_source_expire_after);
					time_source_start(self.__ts);
					
					self.last_sprite = _state.sprite;
					self.last_index = _index;
					self.last_image_xscale = abs(self.__owner.image_xscale) * (_state.flip_horizontal ? -1 : 1);
					
					if (!_return_values) {
						self.__owner.sprite_index = _state.sprite;
						self.__owner.image_index = _index;
						self.__owner.image_xscale = abs(self.__owner.image_xscale) * (_state.flip_horizontal ? -1 : 1);
					}
					
					if (_state.loops && self.counter > 0 && self.counter % self.max_counter == 1) {
						_state.repeated_times += 1;
						_state.cumulative_repeated_times += 1;
					}
					
					if (_state.loops && _state.loop_boomerang && self.counter % self.max_counter == 0) {
						_state.increment *= -1;
						if (_state.repeated_times % 2 == 1) {
							_state.start_frame = _index;
						}
						else {
							_state.start_frame = _state.__.original_start_frame;
						}
					}
					
					if (!_state.loops && self.counter == self.max_counter) _state.ended = true;
				}
				
				if (_return_values) return {sprite_index: _state.sprite, image_idx: _index, image_xscale: abs(self.__owner.image_xscale) * (_state.flip_horizontal ? -1 : 1), state_data: _state};
			}
			else {
				if (_return_values)	return {sprite_index: self.last_sprite, image_idx: self.last_index, image_xscale: self.last_image_xscale,  state_data: _state};
			}
		}
		else {
			if (_return_values)	return {sprite_index: self.last_sprite, image_idx: self.last_index, image_xscale: self.last_image_xscale, state_data: _state};
		}		
	}
	
	/// @func	pause()
	/// @desc	pauses the active animation state if it's running. Throws an error if no active state has been set.
	static pause = function() {
		if (is_running())	time_source_pause(self.__ts);
	}
	
	/// @func	resume()
	/// @desc	resumes the active animation state if it's paused. Throws an error if no active state has been set.
	static resume = function() {
		if (is_paused())	time_source_resume(self.__ts);
	}
	
	/// @func	toggle_pause()
	/// @desc	toggles the active animation state between running and paused. Throws an error if no active state has been set.
	static toggle_pause = function() {
		if (is_running())		pause();
		else if (is_paused())	resume();
	}
	
	/// @func	stop()
	/// @desc	stops the active animation state and marks it as ended. Throws an error if no active state has been set.
	static stop = function() {
		if (self.current_state_index == -1)	throw("[SpriteMan] ERROR: No active state+direction set");
		
		var _state = self.states[self.current_state_index];
		if (time_source_exists(self.__ts))	{
			time_source_destroy(self.__ts);
		}
		_state.ended = true;
	}
	
	/// @func	reset()
	/// @desc	resets the animation, i.e. stops and starts the animation from the beginning
	static reset = function() {
		stop();
		start();
	}
	
	/// @func	has_started()
	/// @desc	checks whether the active state has started. Throws an error if no active state has been set.
	/// @return	{Bool}	whether the active state has started
	static has_started = function() {
		if (self.current_state_index == -1)	throw("[SpriteMan] ERROR: No active state+direction set");
		else return self.states[self.current_state_index].started;
	}
	
	/// @func	has_ended()
	/// @desc	checks whether the active state has ended. Throws an error if no active state has been set.
	/// @return	{Bool}	whether the active state has ended
	static has_ended = function() {
		if (self.current_state_index == -1)	throw("[SpriteMan] ERROR: No active state+direction set");
		else return self.states[self.current_state_index].ended;
	}
	
	/// @func	is_running()
	/// @desc	checks whether the active state is running. Throws an erroriof no active state has been set.
	/// @return	{Bool}	whether the active state is running
	static is_running = function() {
		if (self.current_state_index == -1)	throw("[SpriteMan] ERROR: No active state+direction set");
		else return time_source_exists(self.__ts) && time_source_get_state(self.__ts) == time_source_state_active;
	}
	
	/// @func	is_paused()
	/// @desc	checks whether the active state is paused. Throws an error if no active state has been set.
	/// @return	{Bool}	whether the active state is paused
	static is_paused = function() {
		if (self.current_state_index == -1)	throw("[SpriteMan] ERROR: No active state+direction set");
		else return time_source_exists(self.__ts) && time_source_get_state(self.__ts) == time_source_state_paused;
	}
	
	/// @func	cleanup()
	/// @desc	destroys the associated time source. Should be called on the corresponding object's Cleanup event to prevent memory leaks.
	static cleanup = function() {
		if (time_source_exists(self.__ts)) time_source_destroy(self.__ts);
	}
}

show_debug_message($"[SpriteMan] Welcome to SpriteMan {SPRITEMAN_VERSION}, an easy to use sprite animation manager, by manta ray");