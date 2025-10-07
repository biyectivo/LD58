/// @title The Achoo object
/// @category Achoo object
/// @text This is the **object** you use at runtime to interact with defined achievements and stats.

self.achievements = [];
self.stats = [];
self.__private = {
	automatic_check: true,
	// Aux function for basic encryption
	string_encrypt: function(_string, _shift) {
		var _str = "";
		for (var _i=1, _n=string_length(_string); _i<=_n; _i++) {
			_str += chr(string_ord_at(_string, _i) + _shift);
		}
		return _str;
	},

}

#region Object methods
	
	///@function		get_all_achievements()
	///@description		gets the achievement array. You can also access the array directly (`Achoo.achievements`).
	///@return			{Array}				the array that contains the achievements that have been defined
	self.get_all_achievements = function() {
		return self.achievements;
	}
	
	///@function		get_all_stats()
	///@description		gets the stats array. You can also access the array directly (`Achoo.stats`).
	///@return			{Array}				the array that contains the stats that have been defined
	self.get_all_stats = function() {
		return self.stats;
	}
	
	///@function		set_automatic_check(automatic)
	///@description		enables or disables the automatic checking of achievements
	///@param			{Boolean}				_automatic	whether to enable automatic checking true or false
	self.set_automatic_check = function(_automatic) {
		self.__private.automatic_check = _automatic;
	}
	
	///@function		get_automatic_check()
	///@description		returns the automatic check status
	///@return			{Boolean}				whether the system is automatically checking for achievements
	self.get_automatic_check = function() {
		return self.__private.automatic_check;
	}
	
	
	///@function		get_achievement(achievement_id)
	///@description		gets an Achievement struct based on the achievement ID
	///@param			{String}				_id			the string ID for the Achievement
	///@return			{Struct.Achievement}				the achievement, or -1 if an Achievement with the provided ID does not exist
	self.get_achievement = function(_id) {
		var _idx = array_find_index(self.achievements, method({this_id: _id}, function(_elem) { return _elem.id == this_id; }));
		if (_idx != -1) return self.achievements[_idx];
		else return _idx;
	}
	
	///@function		achievement_exists(achievement_id)
	///@description		returns whether an Achievement with this ID exists
	///@param			{String}				_id			the string ID for the Achievement
	///@return			{Boolean}				whether the achievement exists
	self.achievement_exists = function(_id) {
		return self.get(_id) != -1;
	}
	
	
	///@function		check_all()
	///@description		checks all Achievements to see whether they have been unlocked and achieved according to their unlock condition and achievement condition<br>
	///					If automatic checking is enabled, this object will call the `check_all()` method in its End Step event.
	self.check_all = function() {
		for (var _i=0, _n=array_length(self.achievements); _i<_n; _i++) {
			var _ach = self.achievements[_i];
			_ach.check_unlock();
			_ach.check_achieve();
		}
	}
	
	///@function		get_achievements_save_string()
	///@description		gets the achievements save string. This function can be used to store the serialized data into a database (e.g. via an API)
	///@return			{String}		the save string with serialized data
	self.get_achievements_save_string = function() {
		return ACHOO_ENCRYPT ? self.__private.string_encrypt(base64_encode(json_stringify(self.achievements, true)), ACHOO_ENCRYPTION_SHIFT) : json_stringify(self.achievements, true);
	}
	
	///@function		get_stats_save_string()
	///@description		gets the stats save string. This function can be used to store the serialized data into a database (e.g. via an API)
	///@return			{String}		the save string with serialized data
	self.get_stats_save_string = function() {
		return ACHOO_ENCRYPT ? self.__private.string_encrypt(base64_encode(json_stringify(self.stats, true)), ACHOO_ENCRYPTION_SHIFT) : json_stringify(self.stats, true);
	}
	
	///@function		save_achievements(file)
	///@description		saves achievement data to persistent storage
	///@param			{String}		_file		the filename to save to
	self.save_achievements = function(_file) {
		var _buffer = buffer_create(1, buffer_grow, 1);
		var _var = self.get_achievements_save_string();
		buffer_write(_buffer, buffer_string, _var);
		buffer_save(_buffer, _file);
		buffer_delete(_buffer);
		if (ACHOO_VERBOSE)	show_debug_message($"[Achoo!] NOTE: Saved achievements to file {_file}");
	}
	
	
	///@function		load_achievements([file], [save_string])
	///@description		loads achievement data either from persistent storage (file) or from a save string (e.g. retrieved from an API)<br>
	///					Note if neither parameters are provided, it will throw an exception.
	///@param			{String}		[_file]			the filename to load from. This will take precedence over the save string, if both are specified.
	///@param			{String}		[_save_string]	the previously serialized save string
	self.load_achievements = function(_file="", _save_string="") {
		if (_file == "" && _save_string == "")						throw($"[Achoo!] ERROR: You must either provide a file name or a save string");
		if (_file != "" && _save_string != "" && ACHOO_VERBOSE)		show_debug_message($"[Achoo!] NOTE: Specified file {_file} took precedence over the save string specified");
		if (_save_string == "" && !file_exists(_file))				throw($"[Achoo!] ERROR: File does not exist, {_file}");
		
		var _var = "";
		if (_file != "") {
			var _buffer = buffer_load(_file);
			_var = ACHOO_ENCRYPT ? base64_decode(self.__private.string_encrypt(buffer_read(_buffer, buffer_string), -ACHOO_ENCRYPTION_SHIFT)) : buffer_read(_buffer, buffer_string);
			buffer_delete(_buffer);
		}
		else {
			_var = ACHOO_ENCRYPT ? base64_decode(self.__private.string_encrypt(_save_string, -ACHOO_ENCRYPTION_SHIFT)) : _save_string;
		}
		
		try {
			var _json = json_parse(_var);
		}
		catch (_exception) {
			throw($"[Achoo!] ERROR: Could not parse achievements data from {_file == "" ? "save string" : "file " + _file} - Corrupt data or incorrect encryption key used");
		}
		
		// loop through all achievements and reload data
		for (var _i=0, _n=array_length(self.achievements); _i<_n; _i++) {
			var _ach = self.achievements[_i];
			var _idx = array_find_index(_json, method({this_id: _ach.id}, function(_elem) {
				return _elem.id == this_id;
			}));
				
			if (_idx != -1) {
				_ach.__private.achieved = _json[_idx].__private.achieved;
				_ach.__private.locked = _json[_idx].__private.locked;
				_ach.__private.hidden = _json[_idx].__private.hidden;
				_ach.__private.date_unlocked = _json[_idx].__private.date_unlocked;
				_ach.__private.date_achieved = _json[_idx].__private.date_achieved;
				
				var _keys = variable_struct_get_names(_json[_idx].__private);
				for (var _j=0, _m=array_length(_keys); _j<_m; _j++) {
					if (string_pos("user_", _keys[_j]) == 1) {
						_ach.__private[$ _keys[_j]] = _json[_idx].__private[$ _keys[_j]];
					}
				}
				

			}
		}

		if (ACHOO_VERBOSE)	show_debug_message($"[Achoo!] NOTE: Loaded achievements from {_file == "" ? "save string" : "file " + _file}");
	}
	
	
	///@function		get_stat(name)
	///@description		gets a Stat by name
	///@param			{String}				_name		the stat name
	///@return			{Struct.Stat}			the stat, or -1 if it does not exist
	self.get_stat = function(_name) {
		var _idx = array_find_index(self.stats, method({this_name: _name}, function(_elem) { return _elem.name == this_name; }));
		if (_idx != -1) return self.stats[_idx];
		else return _idx;
	}
	
	///@function		stat_exists(name)
	///@description		returns whether a Stat exists
	///@param			{String}				_name			the name for the Stat
	///@return			{Boolean}				whether the Stat exists
	self.stat_exists = function(_name) {
		return self.get_stat(_name) != -1;
	}
	
	///@function		save_stats(file)
	///@description		saves stats data to persistent storage
	///@param			{String}		_file		the filename to save to
	self.save_stats = function(_file) {
		var _buffer = buffer_create(1, buffer_grow, 1);
		var _var = self.get_stats_save_string();
		buffer_write(_buffer, buffer_string, _var);
		buffer_save(_buffer, _file);
		buffer_delete(_buffer);
		if (ACHOO_VERBOSE)	show_debug_message($"[Achoo!] NOTE: Saved stats to file {_file}");
	}
	
	///@function		load_stats([file], [save_string])
	///@description		loads stats data either from persistent storage (file) or from a save string (e.g. retrieved from an API)<br>
	///					Note if neither parameters are provided, it will throw an exception.
	///@param			{String}		[_file]			the filename to load from
	///@param			{String}		[_save_string]	the previously serialized save string
	self.load_stats = function(_file="", _save_string="") {
		if (_file == "" && _save_string == "")						throw($"[Achoo!] ERROR: You must either provide a file name or a save string");
		if (_file != "" && _save_string != "" && ACHOO_VERBOSE)		show_debug_message($"[Achoo!] NOTE: Specified file {_file} took precedence over the save string specified");
		if (_save_string == "" && !file_exists(_file))				throw($"[Achoo!] ERROR: File does not exist, {_file}");
		
		var _var = "";
		if (_file != "") {
			var _buffer = buffer_load(_file);
			_var = ACHOO_ENCRYPT ? base64_decode(self.__private.string_encrypt(buffer_read(_buffer, buffer_string), -ACHOO_ENCRYPTION_SHIFT)) : buffer_read(_buffer, buffer_string);
			buffer_delete(_buffer);
		}
		else {
			_var = ACHOO_ENCRYPT ? base64_decode(self.__private.string_encrypt(_save_string, -ACHOO_ENCRYPTION_SHIFT)) : _save_string;
		}
		
		try {
			var _json = json_parse(_var);
		}
		catch (_exception) {
			throw($"[Achoo!] ERROR: Could not parse stats data from {_file == "" ? "save string" : "file " + _file} - Corrupt data or incorrect encryption key used");
		}
		
		// loop through all stats and reload data
		for (var _i=0, _n=array_length(self.stats); _i<_n; _i++) {
			var _stat = self.stats[_i];
			var _idx = array_find_index(_json, method({this_name: _stat.name}, function(_elem) {
				return _elem.name == this_name;
			}));
				
			if (_idx != -1) {
				_stat.__private.description = _json[_idx].__private.description;
				_stat.__private.value = _json[_idx].__private.value;
				_stat.__private.date_updated = _json[_idx].__private.date_updated;
			}
		}

		if (ACHOO_VERBOSE)	show_debug_message($"[Achoo!] NOTE: Loaded stats from {_file == "" ? "save string" : "file " + _file}");
	}
	
	
#endregion