/// @title Achoo! Constructors
/// @category API Reference
/// @text Here are the **constructors** used to create new achievements and stats for your game.

#macro	ACHOO_VERSION		0.3

/// @constructor Achievement([id], condition, [title], [description], [locked], [unlocking_condition], [hidden], [on_unlock], [on_achieve])
// @function Achievement([id], condition, [title], [description], [locked], [unlocking_condition], [hidden], [on_unlock], [on_achieve])
/// @description This is the main achievement constructor used to generate new achievements.<br><br>
/// **Examples**<br>
/// You can use this to define an achievement for your game. For example:<br><br>

// @code
/// ```var _ach = new Achievement("Test", function() { return Game.score == 100; }, "First Achievement", "Score 100 points in a game session");```<br><br>

// @text This simple achievement is achieved when you reach 100 points in your game, as recorded on your `Game` controller object.<br><br>
/// This simple achievement is achieved when you reach 100 points in your game, as recorded on your `Game` controller object.<br><br>
/// A more complete example, with other parameters defined:<br><br>

// @code
/// ```var _ach = new Achievement(	"Level2_FirstAchievement",<br>
///								function() { return Game.score == 100; },<br>
///								"Master of the Galaxy",<br>
///								"Find the Sword of Might",<br>
///								true,<br>
///								function() { return Game.level2_unlocked; },<br>
///								,<br>
///								function() { show_debug_message("New achievement unlocked!"); },<br>
///								function() { show_debug_message("You have found the Sword of Might!"); }<br>
///								);```<br><br>

// @text This sets up an achievement that is initially locked (unlocks when we reach level 2) and has two callbacks: one when unlocked and one when achieved.
/// This sets up an achievement that is initially locked (unlocks when we reach level 2) and has two callbacks: one when unlocked and one when achieved.<br>

/// @param {String}				[id]					Achievement ID. If no ID is provided, Achoo will generate a unique ID for you
/// @param {Asset.GMFunction}	condition				A function that checks for an achievement condition and returns a boolean
/// @param {String}				[title]					The achievement title
/// @param {String}				[description]			The achievement description
/// @param {String}				[locked]				Whether the achievement is locked
/// @param {Asset.GMFunction}	[unlocking_condition]	A function that checks for an unlocking condition and returns a boolean
/// @param {String}				[hidden]				Whether the achievement is hidden
/// @param {Asset.GMFunction}	[on_unlock]				Callback function to run when the achievement is unlocked
/// @param {Asset.GMFunction}	[on_achieve]			Callback function to run when the achievement is achieved

// @text ### Examples<br>

function Achievement(_id=undefined, _condition, _title="", _description="", _locked=false, _unlocking_condition=function() { return false; }, _hidden = false, _on_unlock = function() {}, _on_achieve = function() {}) constructor {
	
	#region Initialization
		// Check object existence
		if  (!instance_exists(Achoo)) {
			instance_create_depth(-1, -1, 16001, Achoo);
		}
		
		// Check unicity of achievement ID
		if (is_undefined(_id)) {
			var _i=-1;
			do {
				_i++;
				_id = string($"Achievement{_i}");
			}
			until (array_find_index(Achoo.achievements, method({this_id: _id}, function(_elem) { return _elem.id == this_id; } )) == -1);
			if (ACHOO_VERBOSE)	show_debug_message($"[Achoo!] NOTE: No ID provided for achievement. Achievement generated with ID {_id}");
		}
		
		if (array_find_index(Achoo.achievements, method({this_id: _id}, function(_elem) { return _elem.id == this_id; } )) != -1)		throw(string($"[Achoo!] ERROR: Achivement with id {_id} already created"));
	
	#endregion
	
	#region Private variables
	
		self.__private = {
			condition: _condition,
			title: _title,
			description: _description,
			unlocking_condition: _unlocking_condition,
			on_unlock: _on_unlock,
			on_achieve: _on_achieve,
			// These will be persisted to file and/or reloaded from file
			achieved: false,
			locked: _locked,
			hidden: _hidden,
			originally_hidden: _hidden,
			date_unlocked: -1,
			date_achieved: -1,
		}
	
	#endregion
	
	#region Public variables
		
		self.id = _id;
	
	#endregion
	
	#region Methods
		
		/// @method			get_condition()
		/// @description	returns the condition function for unlocking the achievement
		/// @return			{Asset.GMFunction}	the condition function
		self.get_condition = function() {
			return self.__private.condition;
		}

		/// @method			set_condition(_condition)
		/// @description	Sets the condition function for unlocking the achievement
		/// @param			{Asset.GMFunction}	_condition	the condition function to set
		/// @return			{Struct}	self
		self.set_condition = function(_condition) {
			self.__private.condition = _condition;
			return self;
		}

		/// @method			get_title()
		/// @description	Gets the title of the achievement
		/// @return			{String}	the title
		self.get_title = function() {
			return self.__private.title;
		}

		/// @method			set_title(_title)
		/// @description	Sets the title for the achievement
		/// @param			{String}	_title	the title to set
		/// @return			{Struct}	self
		self.set_title = function(_title) {
			self.__private.title = _title;
			return self;
		}

		/// @method			get_description()
		/// @description	Gets the description of the achievement
		/// @return			{String}	the description
		self.get_description = function() {
			return self.__private.description;
		}

		/// @method			set_description(_description)
		/// @description	Sets the description of the achievement
		/// @param			{String}	_description	the description to set
		/// @return			{Struct}	self
		self.set_description = function(_description) {
			self.__private.description = _description;
			return self;
		}

		/// @method			get_unlocking_condition()
		/// @description	Gets the function determining the unlocking condition for the achievement
		/// @return			{Asset.GMFunction}	the unlocking function
		self.get_unlocking_condition = function() {
			return self.__private.unlocking_condition;
		}
		
		/// @method			set_unlocking_condition(_unlocking_condition)
		/// @description	Sets the function determining the unlocking condition for the achievement
		/// @param			{Asset.GMFunction}	_unlocking_condition	the function to set
		/// @return			{Struct}	self
		self.set_unlocking_condition = function(_unlocking_condition) {
			self.__private.unlocking_condition = _unlocking_condition;
			return self;
		}

		/// @method			get_on_unlock()
		/// @description	Gets the function to be executed on unlock of the achievement
		/// @return			{Asset.GMFunction}	the function
		self.get_on_unlock = function() {
			return self.__private.on_unlock;
		}

		/// @method			set_on_unlock(_on_unlock)
		/// @description	Sets the function to be executed on unlock of the achievement
		/// @param			{Asset.GMFunction}	_on_unlock	the function to set
		/// @return			{Struct}	self
		self.set_on_unlock = function(_on_unlock) {
			self.__private.on_unlock = _on_unlock;
			return self;
		}

		/// @method			get_on_achieve()
		/// @description	Gets the function to be executed when achieving the achievement
		/// @return			{Asset.GMFunction}	the function
		self.get_on_achieve = function() {
			return self.__private.on_achieve;
		}

		/// @method			set_on_achieve(_on_achieve)
		/// @description	Sets the function to be executed when achieving the achievement
		/// @param			{Asset.GMFunction}	_on_achieve		the function to set
		/// @return			{Struct}	self
		self.set_on_achieve = function(_on_achieve) {
			self.__private.on_achieve = _on_achieve;
			return self;
		}

		/// @method			get_date_unlocked()
		/// @description	Gets the date when the achievement was unlocked, or -1 if it has not been achieved
		/// @return			{Date}	the unlocking date or -1
		self.get_date_unlocked = function() {
			return self.__private.date_unlocked;
		}

		/// @method			get_date_achieved()
		/// @description	Gets the date when the achievement was achieved, or -1 if it has not been achieved
		/// @return			{Date}	the achieved date or -1
		self.get_date_achieved = function() {
			return self.__private.date_achieved;
		}
		
		///@method			is_unlocked()
		///@description		gets whether the achievement is unlocked
		///@return			{Boolean}		whether the achievement has been unlocked
		self.is_unlocked = function() {
			return !self.__private.locked;
		}
		
		///@method			is_achieved()
		///@description		gets whether the achievement has been achieved
		///@return			{Boolean}		whether the achievement has been achieved
		self.is_achieved = function() {
			return self.__private.achieved;
		}
		
		///@method			is_hidden()
		///@description		gets whether the achievement is hidden
		///@return			{Boolean}		whether the achievement is hidden
		self.is_hidden = function() {
			return self.__private.hidden;
		}
		
		///@method			check_unlock()
		///@description		checks whether the achievement has been unlocked according to its unlocking condition. It the condition holds, and the achievement is not unlocked, it will unlock it.<br>
		///					Note that this is different from `set_unlock()`, which will ignore the unlocking condition and will unlock the achievement if it has not been previously unlocked, and also different from `force_unlock()`, which will force it unlocked no matter what.<br>
		///					The on_unlock function will receive a reference to the unlocked achievement struct, so you can handle it inside the function logic.
		self.check_unlock = function() {
			var _cond = !self.is_unlocked() && self.__private.unlocking_condition();
			if (_cond) {
				self.__private.locked = false;
				self.__private.date_unlocked = date_current_datetime();
				if (ACHOO_VERBOSE)	show_debug_message($"[Achoo!] NOTE: Achievement {self.id} unlocked");
				if (is_callable(self.__private.on_unlock)) self.__private.on_unlock(self);
			}
		}
		
		///@method			set_unlocked()
		///@description		checks whether achievement is locked, and if so it will unlock it, irrespective of the unlocking condition.<br>
		///					Note that this is different from `check_unlock()`, which will only unlock the achievement if both the unlocking condition is met AND the achievement has not been unlocked before, and also different from `force_unlock()`, which will force it unlocked no matter what.<br>
		///					The on_unlock function will receive a reference to the unlocked achievement struct, so you can handle it inside the function logic.
		self.set_unlock = function() {
			var _cond = self.__private.is_unlocked();
			if (_cond) {
				self.__private.locked = false;
				self.__private.date_unlocked = date_current_datetime();
				if (ACHOO_VERBOSE)	show_debug_message($"[Achoo!] NOTE: Achievement {self.id} set unlocked");
				if (is_callable(self.__private.on_unlock)) self.__private.on_unlock(self);
			}
		}
		
		///@method			force_unlock()
		///@description		forces the achievement to be unlocked, irrespective of the unlock condition, overriding the unlock date and status<br>
		///					Note that this is different from `check_unlock()`, which will only unlock the achievement if both the unlocking condition is met AND the achievement has not been unlocked before, and also different from `set_unlock()`, which will unlock it if the unlocking condition is met, irrespective of its previous unlocked state.<br>
		///					The on_unlock function will receive a reference to the unlocked achievement struct, so you can handle it inside the function logic.
		self.force_unlock = function() {
			self.__private.locked = false;
			self.__private.date_unlocked = date_current_datetime();
			if (ACHOO_VERBOSE)	show_debug_message($"[Achoo!] NOTE: Achievement {self.id} forced unlocked");
			if (is_callable(self.__private.on_unlock)) self.__private.on_unlock(self);
		}
		
		///@method			force_lock()
		///@description		forces the achievement to be locked, overriding the unlock date and status
		self.force_lock = function() {
			self.__private.locked = true;
			self.__private.date_unlocked = -1;
			if (ACHOO_VERBOSE)	show_debug_message($"[Achoo!] NOTE: Achievement {self.id} forced locked");
		}
		
		///@method			check_achieve()
		///@description		checks whether the achievement has been achieved according to its achieve condition. It the condition holds, and the achievement is unlocked, it will mark it as achieved.<br>
		///					Note that this is different from `set_achieve()`, which will ignore the achieve condition and will mark the achievement as achieved if it has not been previously achieved before, and also different from `force_achieve()`, which will force it as achieved no matter what.<br>
		///					The on_achieve function will receive a reference to the completed achievement struct, so you can handle it inside the function logic.
		self.check_achieve = function() {
			var _achieved = !self.__private.achieved && self.is_unlocked() && self.__private.condition();
			if (_achieved) {
				self.__private.achieved = true;
				self.__private.hidden = false; // Once you achieve it, it becomes visible no matter what
				self.__private.date_achieved = date_current_datetime();
				if (ACHOO_VERBOSE)	show_debug_message($"[Achoo!] NOTE: Achievement {self.id} achieved");
				if (is_callable(self.__private.on_achieve)) self.__private.on_achieve(self);
			}
		}
		
		///@method			set_achieve()
		///@description		checks whether the achievement has not been achieved before and is unlocked. If so, it will mark it as achieved, irrespective of whether the achieve condition holds.<br>
		///					Note that this is different from `check_achieve()`, which will check not only whether it's unlocked and has not been achieved before, but it will check the achieve condition holds, and also different from `force_achieve()`, which will force it as achieved no matter what.<br>
		///					The on_achieve function will receive a reference to the completed achievement struct, so you can handle it inside the function logic.
		self.set_achieve = function() {
			var _achieved = !self.__private.achieved && self.is_unlocked();
			if (_achieved) {
				self.__private.achieved = true;
				self.__private.hidden = false; // Once you achieve it, it becomes visible no matter what
				self.__private.date_achieved = date_current_datetime();
				if (ACHOO_VERBOSE)	show_debug_message($"[Achoo!] NOTE: Achievement {self.id} set achieved");
				if (is_callable(self.__private.on_achieve)) self.__private.on_achieve(self);
			}
		}
		
		///@method			force_achieve()
		///@description		forces the achievement to be achieved, irrespective of the unlock or previously achieved condition, overriding the unlock date and status<br>
		///					Note that this is different from `check_achieve()`, which will check not only whether it's unlocked and has not been achieved before, but it will check the achieve condition holds, and also different from `set_achieve()`, which will check the unlock status and previously achieved status, but will set it achieved irrespective of the achieve condition.<br>
		///					The on_achieve function will receive a reference to the completed achievement struct, so you can handle it inside the function logic.
		self.force_achieve = function() {
			self.__private.achieved = true;
			self.__private.hidden = false; // Once you achieve it, it becomes visible no matter what
			self.__private.date_achieved = date_current_datetime();
			if (ACHOO_VERBOSE)	show_debug_message($"[Achoo!] NOTE: Achievement {self.id} forced achieved");
			if (is_callable(self.__private.on_achieve)) self.__private.on_achieve(self);
		}

		///@method			force_unachieve()
		///@description		forces the achievement to be unachieved, overriding the date and status.
		self.force_unachieve = function() {
			self.__private.achieved = false;
			self.__private.date_achieved = -1;
			self.__private.hidden = self.__private.originally_hidden;
			if (ACHOO_VERBOSE)	show_debug_message($"[Achoo!] NOTE: Achievement {self.id} forced unachieved");
		}		
		
		///@method			get_user_data(key)
		///@description		gets a custom data element from this achievement
		///@param			{String}	_key		the key name for the data to get
		///@return			{Any}		the custom data, or -1 if the key does not exist
		self.get_user_data = function(_key) {
			if (variable_struct_exists(self.__private, "user_"+string(_key))) {
				return self.__private[$ "user_"+string(_key)];
			}
			else {
				return -1;
			}
		}
		
		///@method			set_user_data(key, value)
		///@description		adds custom data to this achievement
		///@param			{String}	_key		the key name for the data to add
		///@param			{Any}		_value		the value to add
		self.set_user_data = function(_key, _value) {
			self.__private[$ "user_"+string(_key)] = _value;			
		}
		
		
		///@method			delete_user_data(key)
		///@description		deletes a custom data key for this achievement<br>
		///					ignored if the key does not exist
		///@param			{String}	_key		the key name for the data to delete
		self.delete_user_data = function(_key) {
			if (variable_struct_exists(self.__private, "user_"+string(_key)))	struct_remove(self.__private, "user_"+string(_key));
		}
		
	#endregion
	
	array_push(Achoo.achievements, self);
	if (ACHOO_VERBOSE)	show_debug_message($"[Achoo!] NOTE: Achievement {_id} created")
	return self;

}

/// @constructor Stat(name, value, [description])
// @function Stat(name, value, [description])
/// @description This constructor lets you create statistics for the game - basically, a name and a value (and optional description).<br>
// @text ### Examples<br>
/// You can use this to create a simple statistic that will be stored and tracked, which in turn could help you to define achievements (or many other things!), like so:<br><br>

// @code
/// ```var _stat = new Stat("monsters_killed", 0, "Total monsters killed since you started playing");```<br><br>

// @text Then, you could update this stat when killing a monster, by using the `get_stat()` method of the `Achoo` object:
/// Then, you could update this stat when killing a monster, by using the `get_stat()` method of the `Achoo` object:<br><br>

// @code
/// ```// Monster Destroy event, for example<br>
/// Achoo.get_stat("monsters_killed").increment_value();```<br><br>

// @text Finally, you can refer to this in an achievement, now using `get_value()`:
/// Finally, you can refer to this in an achievement, now using `get_value()`:<br><br>

// @code
/// ```var _ach = new Achievement(		"MonsterSlayer",<br>
///									function() {<br>
///										var _ach = Achoo.get_stat("monsters_killed");<br>
///										return _ach.get_value() == 100;<br>
///									}, <br>
///									"Monster Slayer",<br>
///									"Kill 100 monsters");```<br>

/// @param {String}	name The stat name
/// @param {String}	value The value
/// @param {String}	[description] Optional description for the stat
function Stat(_name, _value, _description="") constructor {
	
	#region Initialization
		// Check object existence
		if  (!instance_exists(Achoo)) {
			instance_create_depth(-1, -1, 16001, Achoo);
		}
		
		if (array_find_index(Achoo.stats, method({this_name: _name}, function(_elem) { return _elem.name == this_name; } )) != -1)		throw(string($"[Achoo!] ERROR: Stat {_name} already exists"));
	
	#endregion
	
	#region Private variables
	
		self.__private = {
			description: _description,
			value: _value,
			date_updated: -1,
		}
	
	#endregion
	
	#region Public variables
		
		self.name = _name;
	
	#endregion
	
	#region Methods
	
		///@method			get_value()
		///@description		gets the value of the stat
		///@return			{Any}		the stored value
		self.get_value = function() {
			return self.__private.value;
		}

		///@method			get_date_updated()
		///@description		gets the last update date
		///@return			{Date}		the last update date for the value
		self.get_date_updated = function() {
			return self.__private.date_updated;
		}
		
		///@method			get_description()
		///@description		gets the description for the stat
		///@return			{String}		the description
		self.get_description = function() {
			return self.__private.description;
		}
		
		///@method			set_value(value)
		///@description		sets the value of the stat
		///@param			{Any}	_value	value to store
		self.set_value = function(_value) {
			self.__private.value = _value;
			self.__private.date_updated = date_current_datetime();
		}
		
		///@method			increment_value(value)
		///@description		increments the (numeric) value of the stat
		///@param			{Real}	[_increment]	value to increment - by default 1
		self.increment_value = function(_increment=1) {
			if (!is_numeric(self.__private.value) || !is_numeric(_increment))	throw($"[Achoo!] ERROR: Increment and stat must be numeric in order to use this method");
			self.__private.value += _increment;
			self.__private.date_updated = date_current_datetime();
		}
		
		///@method			set_description(description)
		///@description		sets the description of the stat
		///@param			{String}	_description	the description
		self.set_description = function(_description) {
			self.__private.description = _description;
		}
	
	#endregion
	
	array_push(Achoo.stats, self);
	if (ACHOO_VERBOSE)	show_debug_message($"[Achoo!] NOTE: Stat {_name} created")
	return self;
}


show_debug_message($"[Achoo!] Welcome to Achoo! v{ACHOO_VERSION}, simple achievements system by manta ray")