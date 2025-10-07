/// @feather ignore all
#region UIOptionGroup
	
	/// @constructor	UIOptionGroup(_id, _x, _y, _option_array, _sprite, [_initial_idx=0], [_relative_to=UI_DEFAULT_ANCHOR_POINT])
	/// @extends		UIWidget
	/// @description	An option group widget, clickable UI widget that lets the user select from a list of values.
	/// @param			{String}			_id				The Checkbox's name, a unique string ID. If the specified name is taken, the checkbox will be renamed and a message will be displayed on the output log.
	/// @param			{Real}				_x				The x position of the Checkbox, **relative to its parent**, according to the _relative_to parameter
	/// @param			{Real}				_y				The y position of the Checkbox, **relative to its parent**, according to the _relative_to parameter	
	/// @param			{Array<String>}		_option_array	An array with at least one string that contains the text for each of the options
	/// @param			{Asset.GMSprite}	_sprite			The sprite ID to use for rendering the option group
	/// @param			{Real}				[_initial_idx]	The initial selected index of the Option group (default=0, the first option)
	/// @param			{Enum}				[_relative_to]	The position relative to which the Checkbox will be drawn. By default, uses UI_DEFAULT_ANCHOR_POINT macro in the config (top left if not changed) <br>
	///														See the [UIWidget](#UIWidget) documentation for more info and valid values.
	/// @return			{UIOptionGroup}						self
	function UIOptionGroup(_id, _x, _y, _option_array, _sprite, _initial_idx=-1, _relative_to=UI_DEFAULT_ANCHOR_POINT) : __UIWidget(_id, _x, _y, 0, 0, _sprite, _relative_to) constructor {
		#region Private variables
			self.__type = UI_TYPE.OPTION_GROUP;
			self.__option_array_unselected = _option_array;
			self.__option_array_selected = _option_array;
			self.__option_array_mouseover = _option_array;
			self.__text_format_unselected = "[fa_left]";
			self.__text_format_selected = "[fa_left]";
			self.__text_format_mouseover = "[fa_left]";
			self.__sprite_unselected = _sprite;
			self.__sprite_selected = _sprite;
			self.__sprite_mouseover = _sprite;			
			self.__image_unselected = 0;
			self.__image_selected = 1;
			self.__image_mouseover = -1;
			self.__index = _initial_idx;
			self.__vertical = true;
			self.__spacing = 10;
				
			self.__option_array_dimensions = [];
		#endregion
		#region Setters/Getters			
			/// @method				getRawOptionArrayUnselected()
			/// @description		Gets the options text array of the group, for the unselected state, without Scribble formatting tags.
			///	@return				{Array<String>}	The options text array on the unselected state, without Scribble formatting tags
			self.getRawOptionArrayUnselected = function()	{ 
				var _arr = [];
				for (var _i=0, _n=array_length(self.__option_array_unselected); _i<_n; _i++)		array_push(_arr, UI_TEXT_RENDERER(self.__option_array_unselected[_i]).get_text());
				return _arr;
			}
				
			/// @method				getOptionArrayUnselected()
			/// @description		Gets the options text array of the group
			///	@return				{Array<String>}	The options text array on the unselected state
			self.getOptionArrayUnselected = function()						{ return self.__option_array_unselected; }
			
			/// @method				setOptionArrayUnselected(_option_array)
			/// @description		Sets the options text array of the group
			/// @param				{Array<String>}	_option_array	The array containing the text for each of the options
			///	@return				{UIOptionGroup}	self
			self.setOptionArrayUnselected = function(_option_array)			{ self.__option_array_unselected = _option_array; return self; }
				
			/// @method				getRawOptionArraySelected()
			/// @description		Gets the options text array of the group, for the selected state, without Scribble formatting tags.
			///	@return				{Array<String>}	The options text array on the selected state, without Scribble formatting tags
			self.getRawOptionArraySelected = function()	{ 
				var _arr = [];
				for (var _i=0, _n=array_length(self.__option_array_selected); _i<_n; _i++)		array_push(_arr, UI_TEXT_RENDERER(self.__option_array_selected[_i]).get_text());
				return _arr;
			}
				
			/// @method				getOptionArraySelected()
			/// @description		Gets the options text array of the group
			///	@return				{Array<String>}	The options text array on the selected state
			self.getOptionArraySelected = function()						{ return self.__option_array_selected; }
			
			/// @method				setOptionArraySelected(_option_array)
			/// @description		Sets the options text array of the group
			/// @param				{Array<String>}	_option_array	The array containing the text for each of the options
			///	@return				{UIOptionGroup}	self
			self.setOptionArraySelected = function(_option_array)			{ self.__option_array_selected = _option_array; return self; }
				
			/// @method				getRawOptionArrayMouseover()
			/// @description		Gets the options text array of the group, for the mouseover state, without Scribble formatting tags.
			///	@return				{Array<String>}	The options text array on the mouseover state, without Scribble formatting tags
			self.getRawOptionArrayMouseover = function()	{ 
				var _arr = [];
				for (var _i=0, _n=array_length(self.__option_array_mouseover); _i<_n; _i++)		array_push(_arr, UI_TEXT_RENDERER(self.__option_array_mouseover[_i]).get_text());
				return _arr;
			}
				
			/// @method				getOptionArrayMouseover()
			/// @description		Gets the options text array of the group
			///	@return				{Array<String>}	The options text array on the mouseover state
			self.getOptionArrayMouseover = function()						{ return self.__option_array_mouseover; }
			
			/// @method				setOptionArrayMouseover(_option_array)
			/// @description		Sets the options text array of the group
			/// @param				{Array<String>}	_option_array	The array containing the text for each of the options
			///	@return				{UIOptionGroup}	self
			self.setOptionArrayMouseover = function(_option_array)			{ self.__option_array_mouseover = _option_array; return self; }				
				
			
			/// @method				getSpriteMouseover()
			/// @description		Gets the sprite ID of the options group button when mouseovered			
			/// @return				{Asset.GMSprite}	The sprite ID of the button when mouseovered
			self.getSpriteMouseover = function()				{ return self.__sprite_mouseover; }
			
			/// @method				setSpriteMouseover(_sprite)
			/// @description		Sets the sprite to be rendered when mouseovered.
			/// @param				{Asset.GMSprite}	_sprite		The sprite ID
			/// @return				{UIOptionGroup}	self
			self.setSpriteMouseover = function(_sprite)			{ self.__sprite_mouseover = _sprite; return self; }
			
			/// @method				getImageMouseover()
			/// @description		Gets the image index of the options group button when mouseovered.		
			/// @return				{Real}	The image index of the button when mouseovered
			self.getImageMouseover = function()					{ return self.__image_mouseover; }
			
			/// @method				setImageMouseover(_image)
			/// @description		Sets the image index of the options group button when mouseovered
			/// @param				{Real}	_image	The image index
			/// @return				{UIOptionGroup}	self
			self.setImageMouseover = function(_image)			{ self.__image_mouseover = _image; return self; }
			
			/// @method				getSpriteSelected()
			/// @description		Gets the sprite ID of the options group button used for the selected state.
			/// @return				{Asset.GMSprite}	The sprite ID of the options group button used for the selected state.
			self.getSpriteSelected = function()					{ return self.__sprite_selected; }
			
			/// @method				setSpriteSelected(_sprite)
			/// @description		Sets the sprite to be used for the selected state.
			/// @param				{Asset.GMSprite}	_sprite		The sprite ID
			/// @return				{UIOptionGroup}	self
			self.setSpriteSelected = function(_sprite)			{ self.__sprite_selected = _sprite; return self; }
			
			/// @method				getImageSelected()
			/// @description		Gets the image index of the options group button used for the selected state.
			/// @return				{Real}	The image index of the options group button used for the selected state.
			self.getImageSelected = function()					{ return self.__image_selected; }
			
			/// @method				setImageSelected(_image)
			/// @description		Sets the image index of the options group button used for the selected state.
			/// @param				{Real}	_image	The image index
			/// @return				{UIOptionGroup}	self
			self.setImageSelected = function(_image)			{ self.__image_selected = _image; return self; }				
				
			/// @method				getSpriteUnselected()
			/// @description		Gets the sprite ID of the options group button used for the unselected state.	
			/// @return				{Asset.GMSprite}	The sprite ID of the options group button used for the unselected state.	
			self.getSpriteUnselected = function()				{ return self.__sprite_unselected; }
			
			/// @method				setSpriteUnselected(_sprite)
			/// @description		Sets the sprite to be used for the unselected state.	
			/// @param				{Asset.GMSprite}	_sprite		The sprite ID
			/// @return				{UIOptionGroup}	self
			self.setSpriteUnselected = function(_sprite)			{ self.__sprite_unselected = _sprite; return self; }
			
			/// @method				getImageUnselected()
			/// @description		Gets the image index of the options group button used for the unselected state.		
			/// @return				{Real}	The image index of the options group button  used for the unselected state.	
			self.getImageUnselected = function()					{ return self.__image_unselected; }
			
			/// @method				setImageUnselected(_image)
			/// @description		Sets the image index of the options group button used for the unselected state.	
			/// @param				{Real}	_image	The image index
			/// @return				{UIOptionGroup}	self
			self.setImageUnselected = function(_image)			{ self.__image_unselected = _image; return self; }
				
			/// @method				getIndex()
			/// @description		Gets the index of the selected option, or -1 if no option is currently selected.
			/// @return				{Real}	The selected option index
			self.getIndex = function()							{ return self.__index; }
				
			/// @method				setIndex(_index)
			/// @description		Sets the index of the selected option. If set to -1, it will select no options.<br>
			///						If the number provided exceeds the range of the options array, no change will be performed.
			/// @param				{Real}	_index	The index to set
			/// @return				{UIOptionGroup}	self
			self.setIndex = function(_index) {
				var _old = self.__index;
				var _new = (_index == -1 ? -1 : clamp(_index, 0, array_length(self.__option_array_unselected)));
				var _changed = (_old != _new);					
				if (_changed) {
					self.__index = _new;
					self.__callbacks[UI_EVENT.VALUE_CHANGED](_old, _new);
					if (!is_undefined(self.__binding)) {
						self.__updateBoundVariable(_new);
					}
				}
				return self;
			}
				
			/// @method				getOptionRawText()
			/// @description		Gets the raw text of the selected option, or "" if no option is currently selected, without Scribble formatting tags
			/// @return				{String}	The selected option text
			self.getOptionRawText = function()					{ return self.__index == -1 ? "" : UI_TEXT_RENDERER(self.__option_array_selected[self.__index]).get_text(); }
				
			/// @method				getOptionText()
			/// @description		Gets the text of the selected option, or "" if no option is currently selected.
			/// @return				{String}	The selected option text
			self.getOptionText = function()						{ return self.__index == -1 ? "" : self.__option_array_selected[self.__index]; }
				
			/// @method				getVertical()
			/// @description		Gets whether the options group is rendered vertically (true) or horizontally (false)
			/// @return				{Bool}	Whether the group is rendered vertically
			self.getVertical = function()						{ return self.__vertical; }
				
			/// @method				setVertical(_is_vertical)
			/// @description		Sets whether the options group is rendered vertically (true) or horizontally (false)
			/// @param				{Bool}	_is_vertical	Whether to render the group vertically
			/// @return				{UIOptionGroup}	self
			self.setVertical = function(_is_vertical)			{ self.__vertical = _is_vertical; return self; }
				
			/// @method				getSpacing()
			/// @description		Gets the spacing between options when rendering
			/// @return				{Real}	The spacing in px
			self.getSpacing = function()						{ return self.__spacing; }
				
			/// @method				setSpacing(_spacing)
			/// @description		Sets the spacing between options when rendering
			/// @param				{Real}	_spacing	The spacing in px
			/// @return				{UIOptionGroup}	self
			self.setSpacing = function(_spacing)				{ self.__spacing = _spacing; return self; }
				
			/// @method			getTextFormatUnselected()
			/// @description	Gets the text format for unselected items
			/// @return			{Any}	the format
			self.getTextFormatUnselected = function() {
				return self.__text_format_unselected;
			}

			/// @method			setTextFormatUnselected(_format)
			/// @description	Sets the text format for unselected items
			/// @param			{Any}	_format	the format to set
			/// @return			{Struct}	self
			self.setTextFormatUnselected = function(_format) {
				self.__text_format_unselected = _format+"[fa_left][fa_middle]";
				return self;
			}

			/// @method			getTextFormatSelected()
			/// @description	Gets text format for selected items
			/// @return			{Any}	the format
			self.getTextFormatSelected = function() {
				return self.__text_format_selected;
			}

			/// @method			setTextFormatSelected(_format)
			/// @description	Sets text format for selected items
			/// @param			{Any}	_format	the format to set
			/// @return			{Struct}	self
			self.setTextFormatSelected = function(_format) {
				self.__text_format_selected = _format+"[fa_left][fa_middle]";
				return self;
			}

			/// @method			getTextFormatMouseover()
			/// @description	Gets text format for mouseovered items
			/// @return			{Any}	the format
			self.getTextFormatMouseover = function() {
				return self.__text_format_mouseover;
			}

			/// @method			setTextFormatMouseover(_format)
			/// @description	Sets text format for mouseovered items
			/// @param			{Any}	_format	the value to set
			/// @return			{Struct}	self
			self.setTextFormatMouseover = function(_format) {
				self.__text_format_mouseover = _format+"[fa_left][fa_middle]";
				return self;
			}


				
		#endregion
		#region Methods
			self.__draw = function() {
				var _x = self.__dimensions.x;
				var _y = self.__dimensions.y;
					
				var _curr_x = _x;
				var _curr_y = _y;
				var _sum_width = 0;
				var _sum_height = 0;
				var _max_width = 0;
				var _max_height = 0;
				var _n=array_length(self.__option_array_unselected);
					
				self.__option_array_dimensions = array_create(_n);
				for (var _i=0; _i<_n; _i++)	self.__option_array_dimensions[_i] = {x:0, y:0, width:0, height:0};
				for (var _i=0; _i<_n; _i++) {
					var _sprite = self.__index == _i ? self.__sprite_selected : self.__sprite_unselected;
					var _image = self.__index == _i ? self.__image_selected : self.__image_unselected;
					var _text = self.__index == _i ? self.__option_array_selected[_i] : self.__option_array_unselected[_i];
					var _text_format = self.__index == _i ? self.__text_format_selected : self.__text_format_unselected;
					var _w_selected =   sprite_exists(self.__sprite_selected) ? sprite_get_width(self.__sprite_selected) : 0;
					var _h_selected =   sprite_exists(self.__sprite_selected) ? sprite_get_height(self.__sprite_selected) : 0;
					var _w_unselected = sprite_exists(self.__sprite_unselected) ? sprite_get_width(self.__sprite_unselected) : 0;
					var _h_unselected = sprite_exists(self.__sprite_unselected) ? sprite_get_height(self.__sprite_unselected) : 0;
					var _width = (self.__index == _i ? _w_selected : _w_unselected) * global.__gooey_manager_active.getScale();
					var _height = (self.__index == _i ? _h_selected : _h_unselected) * global.__gooey_manager_active.getScale();
					
					if (point_in_rectangle(device_mouse_x_to_gui(global.__gooey_manager_active.getMouseDevice()), device_mouse_y_to_gui(global.__gooey_manager_active.getMouseDevice()), _curr_x, _curr_y, _curr_x + _width, _curr_y + _height)) {
						var _sprite = self.__index == _i ? self.__sprite_selected : self.__sprite_mouseover;
						var _image = self.__index == _i ? self.__image_selected : self.__image_mouseover;
						var _text = self.__index == _i ? self.__option_array_selected[_i] : self.__option_array_mouseover[_i];
						var _text_format = self.__index == _i ? self.__text_format_selected : self.__text_format_mouseover;
					}
					
					if (sprite_exists(_sprite)) draw_sprite_stretched_ext(_sprite, _image, _curr_x, _curr_y, _width, _height, self.__image_blend, self.__image_alpha);
					var _scale = "[scale,"+string(global.__gooey_manager_active.getScale())+"]";				
					var _s = UI_TEXT_RENDERER(_scale+_text_format+_text);
					var _text_x = _curr_x + _width;
					var _text_y = _curr_y + _height/2;
					_s.draw(_text_x, _text_y);
						
					self.__option_array_dimensions[_i].x = _curr_x;
					self.__option_array_dimensions[_i].y = _curr_y;
					self.__option_array_dimensions[_i].width = _width + _s.get_width();
					self.__option_array_dimensions[_i].height = _height;
						
					if (self.__vertical) {
						_curr_y += _height + (_i<_n-1 ? self.__spacing : 0);
					}						
					else {
						_curr_x += _width + _s.get_width() + (_i<_n-1 ? self.__spacing : 0);
					}
						
					_sum_width += _width + _s.get_width() + (_i<_n-1 ? self.__spacing : 0);
					_sum_height += _height + (_i<_n-1 ? self.__spacing : 0);
					_max_width = max(_max_width, _width + _s.get_width());
					_max_height = max(_max_height, _height);
				}
					
				if (self.__vertical) {
					self.setDimensions(,, _max_width, _sum_height);
				}
				else {
					self.setDimensions(,, _sum_width, _max_height);
				}
					
			}
			self.__generalBuiltInBehaviors = method(self, __builtInBehavior);
			self.__builtInBehavior = function() {
				if (self.__events_fired[UI_EVENT.LEFT_CLICK]) {
					var _clicked = -1;
					var _n=array_length(self.__option_array_unselected);
					var _i=0;
					while (_i<_n && _clicked == -1) {
						if (point_in_rectangle(device_mouse_x_to_gui(global.__gooey_manager_active.getMouseDevice()), device_mouse_y_to_gui(global.__gooey_manager_active.getMouseDevice()), self.__option_array_dimensions[_i].x, self.__option_array_dimensions[_i].y, self.__option_array_dimensions[_i].x + self.__option_array_dimensions[_i].width, self.__option_array_dimensions[_i].y + self.__option_array_dimensions[_i].height)) {
							_clicked = _i;
						}
						else {
							_i++;
						}
					}
						
					if (_clicked != -1 && _clicked != self.__index)	{
						self.setIndex(_clicked);
					}
				}
					
				var _arr = array_create(GOOEY_NUM_CALLBACKS, true);
				self.__generalBuiltInBehaviors(_arr);
			}
		#endregion
		
		self.__register();
		return self;
	}
	
#endregion