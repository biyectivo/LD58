#region FSM
	
	function StateMachine(_name="") constructor {		
		
		self.__target_id = other.id;
		self.__state_id = 0;
		self.__state_machine_name = _name;
		self.__states = {};
		self.__transitions = [];
		self.__current_state_name = "";
		self.__state_name_history = [];
		self.__max_state_name_history = 4; // Default
		
		static get_state_timer = function() {
			return self.__states[$ self.__current_state_name].timer;
		}
		
		static set_max_state_name_history = function(_num_states) {
			self.__max_state_name_history = max(2, _num_states);
		}
		
		static get_state_history = function() {
			return self.__state_name_history;
		}
		
		static get_current_state_name = function() {
			return self.__current_state_name;
		}
		
		static get_previous_state_name = function() {
			var _n = array_length(self.__state_name_history);
			return _n > 0 ? self.__state_name_history[_n-1] : "";
		}
		
		static exists = function(_state_name) {
			return variable_struct_exists(self.__states, _state_name);
		}
		
		static init = function(_state_name) {
			if (self.exists(_state_name)) {
				array_push(self.__state_name_history, _state_name);
				self.__current_state_name = _state_name;	
				self.__states[$ _state_name].functions.enter(); // Execute enter state for initial state		
			}
		}
		
		
		
		static add = function(_state_name, _state_functions = { "enter": method(self.__target_id, function() {}), "step": method(self.__target_id, function() {}), "leave": method(self.__target_id, function() {})}) {
			if (!self.exists(_state_name)) {
				variable_struct_set(self.__states, _state_name, {});
				variable_struct_set(self.__states[$ _state_name], "functions", {});
				
				// Assign specified state functions
				var _state_function_names = variable_struct_get_names(_state_functions);
				for (var _i=0, _n=array_length(_state_function_names); _i<_n; _i++) {
					variable_struct_set(self.__states[$ _state_name].functions, _state_function_names[_i], method(self.__target_id, _state_functions[$ _state_function_names[_i]]));
				}
				
				// Assign default state functions
				if (!variable_struct_exists(self.__states[$ _state_name].functions, "enter"))		variable_struct_set(self.__states[$ _state_name].functions, "enter", method(self.__target_id, function() {}));
				if (!variable_struct_exists(self.__states[$ _state_name].functions, "step"))		variable_struct_set(self.__states[$ _state_name].functions, "step",  method(self.__target_id, function() {}));
				if (!variable_struct_exists(self.__states[$ _state_name].functions, "leave"))		variable_struct_set(self.__states[$ _state_name].functions, "leave", method(self.__target_id, function() {}));
				
				self.__states[$ _state_name].timer = 0;
				self.__states[$ _state_name].state_id = ++self.__state_id;
			}
		}
		
		static add_transition = function(_from_states, _to_state, _condition, _priority = 0, _exclude_to_state_in_from = true) {
			var _arr = [];
			var _state_names = variable_struct_get_names(self.__states);
			if (is_array(_from_states) && array_length(_from_states) == 0) {
				_arr = _state_names;
			}
			else if (is_array(_from_states)) {
				_arr = _from_states;
			}
			else {
				_arr = [_from_states];
			}
			
			if (_exclude_to_state_in_from) {
				var _idx = array_find_index(_arr, method({to_state: _to_state}, function(_elem) {
					return _elem == to_state;
				}));
				if (_idx >= 0) array_delete(_arr, _idx, 1);
			}
			
			array_push(self.__transitions, { from: _arr, to: _to_state, condition: _condition, priority: _priority });
		}
		
		static step = function() {
			if (self.exists(self.__current_state_name)) {
				self.__states[$ self.__current_state_name].timer++;
				self.__states[$ self.__current_state_name].functions[$ "step"]();
			}
		}
		
		
		static trigger = function(_state_name) {
			if (self.exists(_state_name)) {
				// Leave current state				
				if (self.exists(self.__current_state_name)) {
					self.__states[$ self.__current_state_name].timer = 0;
					self.__states[$ self.__current_state_name].functions[$ "leave"]();
				}
				// Push current
				array_push(self.__state_name_history, self.__current_state_name);
				// Set and enter new state
				self.__current_state_name = _state_name;			
				self.__states[$ self.__current_state_name].functions[$ "enter"]();
				
				// Trim state history
				if (array_length(self.__state_name_history) > self.__max_state_name_history)	array_resize_from_end(self.__state_name_history, self.__max_state_name_history);			
			}
		}
		
		static transition = function() {
			// Search for applicable transitions
			var _applicable_transitions = [];
			var _n = array_length(self.__transitions);		
			for (var _i=0; _i<_n; _i++) {	
				var _trx = self.__transitions[_i];
				if (_trx.condition() && array_find_index(self.__transitions[_i].from, method({state_name: self.__current_state_name}, function(_elem) {
						return _elem == state_name;
				})) != -1) {
					array_push(_applicable_transitions, _trx);
				}
			}
			
			if (array_length(_applicable_transitions) > 0) {				
				// Sort by priority and then by newest state
				array_sort(_applicable_transitions, function(_e1, _e2) {
					if (_e1.priority == _e2.priority) {
						return self.__states[$ _e2.to].state_id - self.__states[$ _e1.to].state_id;
					}
					else {
						return _e1.priority - _e2.priority;
					}
				});
				
				// Trigger the transition
				var _transition = _applicable_transitions[0];
				trigger(_transition.to);
			}
				
		}
		
		static function_exists = function(_function) {
			return variable_struct_exists(self.__states[$ self.__current_state_name].functions, _function);
		}
		
		static call = function(_function, _param_array = undefined) {
			self.__states[$ self.__current_state_name].functions[$ _function](_param_array);
		}
		
		///@function			array_resize_from_end(_array, _new_size)
		///@description			resizes the array starting from the end working left
		///@param	{array}		_array		target array
		///@param	{real}		_new_size	the new size of the array
		static array_resize_from_end = function(_array, _new_size) {
			var _n = array_length(_array);
			if (_new_size < _n) {		
				for (var _i=0; _i<_new_size; _i++) {
					// removed the array accessor @ since it's no longer on by default in GM
					_array[_i] = _array[_i+_n-_new_size];
				}
				array_resize(_array, _new_size);
			}
		}
		
	}

#endregion
