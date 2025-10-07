/// @feather ignore all
#region UIDropDown
	
	/// @constructor	UIDropdown(_id, _x, _y, _option_array, _sprite_dropdown, _sprite, [_initial_idx=0], [_relative_to=UI_DEFAULT_ANCHOR_POINT])
	/// @extends		UIOptionGroup
	/// @description	A Dropdown widget, clickable UI widget that lets the user select from a list of values. Extends UIOptionGroup as it provides the same functionality with different interface.
	/// @param			{String}			_id					The Dropdown's name, a unique string ID. If the specified name is taken, the checkbox will be renamed and a message will be displayed on the output log.
	/// @param			{Real}				_x					The x position of the Dropdown, **relative to its parent**, according to the _relative_to parameter
	/// @param			{Real}				_y					The y position of the Dropdown, **relative to its parent**, according to the _relative_to parameter
	/// @param			{Array<String>}		_option_array		An array with at least one string that contains the text for each of the options
	/// @param			{Asset.GMSprite}	_sprite_dropdown	The sprite ID to use for rendering the background of the list of values
	/// @param			{Asset.GMSprite}	_sprite				The sprite ID to use for rendering each value within the list of values
	/// @param			{Real}				[_initial_idx]		The initial selected index of the Dropdown list (default=-1, placeholder text)
	/// @param			{Enum}				[_relative_to]		The position relative to which the Dropdown will be drawn. By default, uses UI_DEFAULT_ANCHOR_POINT macro in the config (top left if not changed) <br>
	///															See the [UIWidget](#UIWidget) documentation for more info and valid values.
	/// @return			{UIDropdown}							self
	function UIDropdown(_id, _x, _y, _option_array, _sprite_dropdown, _sprite, _initial_idx=-1, _relative_to=UI_DEFAULT_ANCHOR_POINT) : UIOptionGroup(_id, _x, _y, _option_array, _sprite, _initial_idx, _relative_to) constructor {
		#region Private variables
			self.__type = UI_TYPE.DROPDOWN;
			self.__sprite_arrow = noone;
			self.__image_arrow = 0;
			self.__sprite_dropdown = _sprite_dropdown;
			self.__image_dropdown = 0;
			self.__dropdown_active = false;
			
			self.__padding_top = 10;
			self.__padding_bottom = 10;
			self.__padding_left = 10;
			self.__padding_right = 10;
			self.__placeholder_text = "";
			
			self.__currently_hovered = -1;
			self.__current_total_height = 0;
		#endregion
		#region Setters/Getters			
			/// @method				getSpriteDropdown()
			/// @description		Gets the sprite ID of the dropdown background
			/// @return				{Asset.GMSprite}	The sprite ID of the dropdown
			self.getSpriteDropdown = function()				{ return self.__sprite_dropdown; }
			
			/// @method				setSpriteDropdown(_sprite)
			/// @description		Sets the sprite ID of the dropdown background
			/// @param				{Asset.GMSprite}	_sprite		The sprite ID
			/// @return				{UIDropdown}	self
			self.setSpriteDropdown = function(_sprite)			{ self.__sprite_dropdown = _sprite; return self; }
			
			/// @method				getImageDropdown()
			/// @description		Gets the image index of the dropdown background
			/// @return				{Real}	The image index of the dropdown background
			self.getImageDropdown = function()					{ return self.__image_dropdown; }
			
			/// @method				setImageDropdown(_image)
			/// @description		Sets the image index of the dropdown background
			/// @param				{Real}	_image	The image index
			/// @return				{UIOptionGroup}	self
			self.setImageDropdown = function(_image)			{ self.__image_dropdown = _image; return self; }
				
			/// @method				getSpriteArrow()
			/// @description		Gets the sprite ID of the arrow icon for the dropdown
			/// @return				{Asset.GMSprite}	The sprite ID of the dropdown
			self.getSpriteArrow = function()				{ return self.__sprite_arrow; }
			
			/// @method				setSpriteArrow(_sprite)
			/// @description		Sets the sprite ID of the arrow icon for the dropdown
			/// @param				{Asset.GMSprite}	_sprite		The sprite ID
			/// @return				{UIArrow}	self
			self.setSpriteArrow = function(_sprite)			{ self.__sprite_arrow = _sprite; return self; }
			
			/// @method				getImageArrow()
			/// @description		Gets the image index of the arrow icon for the dropdown
			/// @return				{Real}	The image index of the arrow icon for the dropdown
			self.getImageArrow = function()					{ return self.__image_arrow; }
			
			/// @method				setImageArrow(_image)
			/// @description		Sets the image index of the arrow icon for the dropdown
			/// @param				{Real}	_image	The image index
			/// @return				{UIOptionGroup}	self
			self.setImageArrow = function(_image)			{ self.__image_arrow = _image; return self; }
			
			/// @method			getPaddingTop()
			/// @description	Gets the value of the top padding of the drop down box
			/// @return	{Any}	the value of top padding
			self.getPaddingTop = function() {
				return self.__padding_top;
			}

			/// @method			setPaddingTop(_padding_top)
			/// @description	Sets the value of the top padding of the drop down box
			/// @param	{Any}	_padding_top	the value to set
			/// @return	{Struct}	self
			self.setPaddingTop = function(_padding_top) {
				self.__padding_top = _padding_top;
				return self;
			}

			/// @method			getPaddingBottom()
			/// @description	Gets the value of the bottom padding of the drop down box
			/// @return	{Any}	the value of bottom padding
			self.getPaddingBottom = function() {
				return self.__padding_bottom;
			}

			/// @method			setPaddingBottom(_padding_bottom)
			/// @description	Sets the value of the bottom padding of the drop down box
			/// @param	{Any}	_padding_bottom	the value to set
			/// @return	{Struct}	self
			self.setPaddingBottom = function(_padding_bottom) {
				self.__padding_bottom = _padding_bottom;
				return self;
			}

			/// @method			getPaddingLeft()
			/// @description	Gets the value of the left padding of the drop down box
			/// @return	{Any}	the value of left padding
			self.getPaddingLeft = function() {
				return self.__padding_left;
			}

			/// @method			setPaddingLeft(_padding_left)
			/// @description	Sets the value of the left padding of the drop down box
			/// @param	{Any}	_padding_left	the value to set
			/// @return	{Struct}	self
			self.setPaddingLeft = function(_padding_left) {
				self.__padding_left = _padding_left;
				return self;
			}

			/// @method			getPaddingRight()
			/// @description	Gets the value of the right padding of the drop down box
			/// @return	{Any}	the value of right padding
			self.getPaddingRight = function() {
				return self.__padding_right;
			}

			/// @method			setPaddingRight(_padding_right)
			/// @description	Sets the value of the right padding of the drop down box
			/// @param	{Any}	_padding_right	the value to set
			/// @return	{Struct}	self
			self.setPaddingRight = function(_padding_right) {
				self.__padding_right = _padding_right;
				return self;
			}
			
			/// @method			setPaddings(_padding)
			/// @description	Sets the value of all paddings to the same value
			/// @param	{Any}	_padding the value to set
			/// @return	{Struct}	self
			self.setPaddings = function(_padding) {
				self.setPaddingLeft(_padding).setPaddingRight(_padding).setPaddingTop(_padding).setPaddingBottom(_padding);
				return self;
			}

			/// @method			getPlaceholderText()
			/// @description	Gets the value of the placeholder text to display (when nothing is selected)
			/// @return	{Any}	the value of the placeholder text
			self.getPlaceholderText = function() {
				return self.__placeholder_text;
			}

			/// @method			setPlaceholderText(_placeholder_text)
			/// @description	Sets the value of the placeholder text to display (when nothing is selected)
			/// @param	{Any}	_placeholder_text	the value to set
			/// @return	{Struct}	self
			self.setPlaceholderText = function(_placeholder_text) {
				self.__placeholder_text = _placeholder_text;
				return self;
			}
			
			/// @method			isDropdownActive()
			/// @description	Returns whether the dropdown is active (i.e. the list is being displayed).
			/// @return			{Bool}	whether it's active or not
			self.isDropdownActive = function() {
				return self.__dropdown_active;
			}


			
		#endregion
		#region Methods
			self.__draw = function() {
				var _x = self.__dimensions.x;
				var _y = self.__dimensions.y;
				var _pad_left = self.__padding_left;
				var _pad_right = self.__padding_right + (sprite_exists(self.__sprite_arrow) ? sprite_get_width(self.__sprite_arrow) : 0);
				var _pad_top = self.__padding_top + (sprite_exists(self.__sprite_arrow) ? sprite_get_height(self.__sprite_arrow)/2 : 0);
				var _pad_bottom = self.__padding_bottom + (sprite_exists(self.__sprite_arrow) ? sprite_get_height(self.__sprite_arrow)/2 : 0);
					
				var _sprite = self.__index == -1 ? self.__sprite_unselected : self.__sprite_selected;
				var _image = self.__index == -1 ? self.__image_unselected : self.__image_selected;
				var _fmt = self.__index == -1 ? self.__text_format_unselected : self.__text_format_selected;
				var _text = self.__index == -1 ? self.__placeholder_text : self.__option_array_selected[self.__index];
				var _scale = "[scale,"+string(global.__gooey_manager_active.getScale())+"]";
				var _t = UI_TEXT_RENDERER(_scale+_fmt+_text);
				
				// Determine max width
				var _max_w = 0;
				var _total_h = 0;
				for (var _i=0, _n=array_length(self.__option_array_unselected); _i<_n; _i++) {
					var _txt = UI_TEXT_RENDERER(_scale+_fmt+self.__option_array_unselected[_i]);
					_max_w = max(_max_w, _txt.get_width());
					_total_h += _txt.get_height();
				}
				for (var _i=0, _n=array_length(self.__option_array_selected); _i<_n; _i++) {
					var _txt = UI_TEXT_RENDERER(_scale+_fmt+self.__option_array_selected[_i]);
					_max_w = max(_max_w, _txt.get_width());
				}
				for (var _i=0, _n=array_length(self.__option_array_mouseover); _i<_n; _i++) {
					var _txt = UI_TEXT_RENDERER(_scale+_fmt+self.__option_array_mouseover[_i]);
					_max_w = max(_max_w, _txt.get_width());
				}
				
				var _width = self.__dimensions.width == 0 ? _max_w + _pad_left+_pad_right : self.__dimensions.width;
				var _height = _t.get_height() + _pad_top+_pad_bottom;
				
				if (point_in_rectangle(device_mouse_x_to_gui(global.__gooey_manager_active.getMouseDevice()), device_mouse_y_to_gui(global.__gooey_manager_active.getMouseDevice()), _x, _y, _x + _width, _y + _height)) {
					_sprite =	self.__sprite_mouseover;
					_image =	self.__image_mouseover;
					_fmt =		self.__text_format_mouseover;
					_text =		self.__index == -1 ? self.__placeholder_text : self.__option_array_mouseover[self.__index];
					_t = UI_TEXT_RENDERER(_scale+_fmt+_text);
					var _height = _t.get_height() + _pad_top+_pad_bottom;
				}
				
				if (sprite_exists(_sprite)) draw_sprite_stretched_ext(_sprite, _image, _x, _y, _width, _height, self.__image_blend, self.__image_alpha);
						
				var _x = _x + _pad_left;
				var _y = _y + _height * global.__gooey_manager_active.getScale()/2;
				_t.draw(_x, _y);
				
				// Arrow
				var _x = self.__dimensions.x + _width - _pad_right;
				if (sprite_exists(self.__sprite_arrow)) draw_sprite_ext(self.__sprite_arrow, self.__image_arrow, _x, _y - sprite_get_height(self.__sprite_arrow)/2, 1, 1, 0, self.__image_blend, self.__image_alpha);
					
				if (self.__dropdown_active) {  // Draw actual dropdown list
					var _x = self.__dimensions.x;
					var _y = self.__dimensions.y + _height;
					var _y0 = _y + _pad_top;
					
					var _n = array_length(self.__option_array_unselected);
					if (sprite_exists(self.__sprite_dropdown)) draw_sprite_stretched_ext(self.__sprite_dropdown, self.__image_dropdown, _x, _y, _width, _total_h + self.__spacing * (_n-1) + _pad_top + _pad_bottom, self.__image_blend, self.__image_alpha);
					
					_x += _pad_left;
					
					var _cum_h = 0;
					self.__currently_hovered = -1;
					for (var _i=0; _i<_n; _i++) {
						var _fmt = self.__text_format_unselected;
						_t = UI_TEXT_RENDERER(_scale+_fmt+self.__option_array_unselected[_i]);
						if (point_in_rectangle(device_mouse_x_to_gui(global.__gooey_manager_active.getMouseDevice()), device_mouse_y_to_gui(global.__gooey_manager_active.getMouseDevice()), _x, _y0 + _cum_h, _x + _width, _y0 + _cum_h + _t.get_height())) {
							_fmt =	self.__text_format_mouseover;
							_t = UI_TEXT_RENDERER(_scale+_fmt+self.__option_array_mouseover[_i]);
							self.__currently_hovered = _i;
						}
						
						_y = _y0 + _cum_h;
						_t.draw(_x, _y+_t.get_height()/2);
						_cum_h += _t.get_height();
						
						if (_i<_n-1) _cum_h += self.__spacing;
					}
				}
					
				//self.setDimensions(,,_width, self.__dropdown_active ? _height + _total_h + self.__spacing * (_n-1) + _pad_top + _pad_bottom : _height);
				self.setDimensions(,,_width, _height);
				self.__current_total_height = self.__dropdown_active ? _height + _total_h + self.__spacing * (_n-1) + _pad_top + _pad_bottom : _height;
					
			}
			//self.__generalBuiltInBehaviors = method(self, __UIWidget.__builtInBehavior);
			self.__builtInBehavior = function() {
				if (self.__events_fired[UI_EVENT.LEFT_CLICK]) {
					if (self.__dropdown_active) {
						if (self.__currently_hovered != -1 && self.__currently_hovered != self.__index)	{
							self.setIndex(self.__currently_hovered);
						}
							
						self.__dropdown_active = false;
					}
					else {
						self.__dropdown_active = true;
					}						
				}
				var _arr = array_create(GOOEY_NUM_CALLBACKS, true);
				self.__generalBuiltInBehaviors(_arr);
			}
		#endregion
		
		// Do not register since it extends UIOptionGroup and that one already registers
		//self.__register();
		return self;
	}
	
#endregion
	