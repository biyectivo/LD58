/// @feather ignore all
#region UISlider
	
	/// @constructor	UISlider(_id, _x, _y, _length, _sprite, _sprite_handle, _value, _min_value, _max_value, [_orientation=UI_ORIENTATION.HORIZONTAL], [_relative_to=UI_DEFAULT_ANCHOR_POINT])
	/// @extends		UIWidget
	/// @description	A Slider widget, that allows the user to select a value from a range by dragging, clicking or scrolling
	/// @param			{String}			_id				The Slider's name, a unique string ID. If the specified name is taken, the Slider will be renamed and a message will be displayed on the output log.
	/// @param			{Real}				_x				The x position of the Slider, **relative to its parent**, according to the _relative_to parameter
	/// @param			{Real}				_y				The y position of the Slider, **relative to its parent**, according to the _relative_to parameter	
	/// @param			{Real}				_length			The length of the Slider in pixels (this will be applied either horizontally or vertically depending on the `_orientation` parameter)
	/// @param			{Asset.GMSprite}	_sprite			The sprite ID to use for rendering the Slider base
	/// @param			{Asset.GMSprite}	_sprite_handle	The sprite ID to use for rendering the Slider handle
	/// @param			{Real}				_value			The initial value of the Slider
	/// @param			{Real}				_min_value		The minimum value of the Slider
	/// @param			{Real}				_max_value		The maximum value of the Slider
	/// @param			{Enum}				[_orientation]	The orientation of the Slider, according to UI_ORIENTATION. By default: HORIZONTAL
	/// @param			{Enum}				[_relative_to]	The position relative to which the Slider will be drawn. By default, uses UI_DEFAULT_ANCHOR_POINT macro in the config (top left if not changed) <br>
	///														See the [UIWidget](#UIWidget) documentation for more info and valid values.
	/// @return			{UISlider}							self
	function UISlider(_id, _x, _y, _length, _sprite, _sprite_handle, _value, _min_value, _max_value, _orientation=UI_ORIENTATION.HORIZONTAL, _relative_to=UI_DEFAULT_ANCHOR_POINT) : __UIWidget(_id, _x, _y, 0, 0, _sprite, _relative_to) constructor {
		#region Private variables
			self.__type = UI_TYPE.SLIDER;
			self.__draggable = true;
			self.__length = _length;
			self.__sprite_base = _sprite;
			self.__sprite_handle = _sprite_handle;
			self.__sprite_handle_mouseover = _sprite_handle;
			self.__sprite_progress = noone;
			self.__sprite_progress_offset = {x: 0, y: 0};
			self.__image_base = 0;
			self.__image_handle = 0;
			self.__image_handle_mouseover = 0;
			self.__image_progress = 0;
			self.__value = _value;
			self.__min_value = _min_value;
			self.__max_value = _max_value;
			self.__drag_change = 1;
			self.__scroll_change = 1;
			self.__click_change = 2;
			self.__show_min_max_text = true;
			self.__show_handle_text = true;
			self.__text_format = "[fa_left][fa_middle]";
			self.__orientation = _orientation;
			self.__handle_hold = false;
			self.__handle_anchor = UI_RELATIVE_TO.TOP_LEFT;
			self.__handle_offset = {x: 0, y: 0};
			self.__handle_text_offset = {x: 0, y: 0};
			self.__click_to_set = false;
		#endregion
		#region Setters/Getters			
				
			/// @method				getLength()
			/// @description		Gets the length of the slider in pixels (this will be applied either horizontally or vertically depending on the orientation parameter)
			/// @return				{Real}	The length of the slider in pixels
			self.getLength = function()								{ return self.__length; }
			
			/// @method				setLength(_length)
			/// @description		Sets the length of the slider in pixels (this will be applied either horizontally or vertically depending on the orientation parameter)
			/// @param				{Real}	_length		The length of the slider in pixels
			/// @return				{UISlider}	self
			self.setLength = function(_length)						{ self.__length = _length; return self; }
				
			/// @method				getSpriteBase()
			/// @description		Gets the sprite ID used for the base of the slider.
			/// @return				{Asset.GMSprite}	The sprite ID used for the base of the slider.
			self.getSpriteBase = function()							{ return self.__sprite_base; }
			
			/// @method				setSpriteBase(_sprite)
			/// @description		Sets the sprite to be used for the base of the slider
			/// @param				{Asset.GMSprite}	_sprite		The sprite ID
			/// @return				{UISlider}	self
			self.setSpriteBase = function(_sprite)					{ self.__sprite_base = _sprite; return self; }
				
			/// @method				getSpriteProgress()
			/// @description		Gets the sprite ID used for the progress of the slider.
			/// @return				{Asset.GMSprite}	The sprite ID used for the progress of the slider.
			self.getSpriteProgress = function()							{ return self.__sprite_progress; }
			
			/// @method				setSpriteProgress(_sprite)
			/// @description		Sets the sprite to be used for the progress of the slider
			/// @param				{Asset.GMSprite}	_sprite		The sprite ID
			/// @return				{UISlider}	self
			self.setSpriteProgress = function(_sprite)					{ self.__sprite_progress = _sprite; return self; }
			
			/// @method				getImageBase()
			/// @description		Gets the image index of the sprite used for the base of the slider.
			/// @return				{Real}	The image index of the sprite used for the base of the slider
			self.getImageBase = function()							{ return self.__image_base; }
			
			/// @method				setImageBase(_image)
			/// @description		Sets the image index of the sprite used for the base of the slider
			/// @param				{Real}	_image	The image index
			/// @return				{UISlider}	self
			self.setImageBase = function(_image)					{ self.__image_base = _image; return self; }				
				
			/// @method				getImageProgress()
			/// @description		Gets the image index of the sprite used for the progress of the slider.
			/// @return				{Real}	The image index of the sprite used for the progress of the slider
			self.getImageProgress = function()							{ return self.__image_progress; }
			
			/// @method				setImageProgress(_image)
			/// @description		Sets the image index of the sprite used for the progress of the slider
			/// @param				{Real}	_image	The image index
			/// @return				{UISlider}	self
			self.setImageProgress = function(_image)					{ self.__image_progress = _image; return self; }	
				
			/// @method				getSpriteProgressOffset()
			/// @description		Gets the x,y offset of the sprite used for the progress of the slider, relative to the x,y of the base sprite
			/// @return				{Struct}	The x,y struct defining the offset
			self.getSpriteProgressOffset = function()							{ return self.__sprite_progress_offset; }
			
			/// @method				setSpriteProgressOffset(_offset)
			/// @description		Sets the x,y offset of the sprite used for the progress of the slider, relative to the x,y of the base sprite
			/// @param				{Struct}	_offset		The x,y struct defining the offset
			/// @return				{UISlider}	self
			self.setSpriteProgressOffset = function(_offset)					{ self.__sprite_progress_offset = _offset; return self; }	
				
				
			/// @method				getSpriteHandle()
			/// @description		Gets the sprite ID used for the handle of the slider.
			/// @return				{Asset.GMSprite}	The sprite ID used for the handle of the slider.
			self.getSpriteHandle = function()						{ return self.__sprite_handle; }
			
			/// @method				setSpriteHandle(_sprite)
			/// @description		Sets the sprite to be used for the handle of the slider
			/// @param				{Asset.GMSprite}	_sprite		The sprite ID
			/// @return				{UISlider}	self
			self.setSpriteHandle = function(_sprite)				{ self.__sprite_handle = _sprite; return self; }
				
			/// @method				getSpriteHandleMouseover()
			/// @description		Gets the sprite ID used for the handle of the slider when mouseovered
			/// @return				{Asset.GMSprite}	The sprite ID used for the handle of the slider when mouseovered
			self.getSpriteHandleMouseover = function()						{ return self.__sprite_handle_mouseover; }
			
			/// @method				setSpriteHandleMouseover(_sprite)
			/// @description		Sets the sprite to be used for the handle of the slider when mouseovered
			/// @param				{Asset.GMSprite}	_sprite		The sprite ID
			/// @return				{UISlider}	self
			self.setSpriteHandleMouseover = function(_sprite)				{ self.__sprite_handle_mouseover = _sprite; return self; }
				
			/// @method				getImageHandle()
			/// @description		Gets the image index of the sprite used for the handle of the slider.
			/// @return				{Real}	The image index of the sprite used for the handle of the slider
			self.getImageHandle = function()						{ return self.__image_handle; }
			
			/// @method				setImageHandle(_image)
			/// @description		Sets the image index of the sprite used for the handle of the slider
			/// @param				{Real}	_image	The image index
			/// @return				{UISlider}	self
			self.setImageHandle = function(_image)					{ self.__image_handle = _image; return self; }		
				
				
			/// @method				getImageHandleMouseover()
			/// @description		Gets the image index of the sprite used for the handle of the slider when mouseovered
			/// @return				{Real}	The image index of the sprite used for the handle of the slider when mouseovered
			self.getImageHandleMouseover = function()						{ return self.__image_handle_mouseover; }
			
			/// @method				setImageHandleMouseover(_image)
			/// @description		Sets the image index of the sprite used for the handle of the slider when mouseovered
			/// @param				{Real}	_image	The image index of the sprite when mouseovered
			/// @return				{UISlider}	self
			self.setImageHandleMouseover = function(_image)					{ self.__image_handle_mouseover = _image; return self; }		
				
			/// @method				getClickToSet()
			/// @description		Gets how the slider click action is managed
			/// @return				{Bool}	Return whether clicking sets the value immediately to the spot (true) or modifies its value by a set amount (false)
			self.getClickToSet = function()						{ return self.__click_to_set; }
			
			/// @method				setClickToSet(_set)
			/// @description		Sets how the slider click action is managed
			/// @param				{Bool}	_set	Whether clicking sets the value immediately to the spot (true) or modifies its value by a set amount (false)
			/// @return				{UISlider}	self
			self.setClickToSet = function(_set)					{ self.__click_to_set = _set; return self; }
				
			/// @method				getValue()
			/// @description		Gets the value of the slider
			/// @return				{Real}	the value of the slider
			self.getValue = function()								{ return self.__value; }
				
			/// @method				setValue(_value)
			/// @description		Sets the value of the slider
			/// @param				{Real}	_value	the value to set
			/// @return				{UISlider}	self
			self.setValue = function(_value) { 
				var _old = self.__value;
				var _new = clamp(_value, self.__min_value, self.__max_value);
				var _changed = (_new != _old);					
				if (_changed) {
					self.__value = _new;
					self.__callbacks[UI_EVENT.VALUE_CHANGED](_old, _new);	
					if (!is_undefined(self.__binding)) {
						self.__updateBoundVariable(_new);
					}
				}
				return self;
			}
				
			/// @method				getMinValue()
			/// @description		Gets the minimum value of the slider
			/// @return				{Real}	the minimum value of the slider
			self.getMinValue = function()							{ return self.__min_value; }
				
			/// @method				setMinValue(_min_value)
			/// @description		Sets the minimum value of the slider
			/// @param				{Real}	_min_value	the value to set
			/// @return				{UISlider}	self
			self.setMinValue = function(_min_value)					{ self.__min_value = _min_value; return self; }
				
			/// @method				getMaxValue()
			/// @description		Gets the maximum value of the slider
			/// @return				{Real}	the maximum value of the slider
			self.getMaxValue = function()							{ return self.__max_value; }
				
			/// @method				setMaxValue(_max_value)
			/// @description		Sets the maximum value of the slider
			/// @param				{Real}	_max_value	the value to set
			/// @return				{UISlider}	self
			self.setMaxValue = function(_max_value)					{ self.__max_value = _max_value; return self; }
				
			/// @method				getDragChange()
			/// @description		Gets the amount changed when dragging the handle
			/// @return				{Real}	the drag change amount
			self.getDragChange = function()						{ return self.__drag_change; }
				
			/// @method				setDragChange(_max_value)
			/// @description		Sets the amount changed when dragging the handle
			/// @param				{Real}	_amount	the drag change amount
			/// @return				{UISlider}	self
			self.setDragChange = function(_amount)					{ self.__drag_change = _amount; return self; }
				
			/// @method				getScrollChange()
			/// @description		Gets the amount changed when scrolling with the mouse
			/// @return				{Real}	the mouse scroll change amount
			self.getScrollChange = function()						{ return self.__scroll_change; }
				
			/// @method				setScrollChange(_max_value)
			/// @description		Sets the amount changed when scrolling with the mouse
			/// @param				{Real}	_amount	the mouse scroll change amount
			/// @return				{UISlider}	self
			self.setScrollChange = function(_amount)					{ self.__scroll_change = _amount; return self; }
				
			/// @method				getClickChange()
			/// @description		Gets the amount changed when clicking on an empty area of the slider
			/// @return				{Real}	the change amount when clicking
			self.getClickChange = function()							{ return self.__click_change; }
				
			/// @method				setClickChange(_max_value)
			/// @description		Sets the amount changed when clicking on an empty area of the slider
			/// @param				{Real}	_amount	the change amount when clicking
			/// @return				{UISlider}	self
			self.setClickChange = function(_amount)					{ self.__click_change = _amount; return self; }
				
			/// @method				getOrientation()
			/// @description		Gets the orientation of the slider according to UI_ORIENTATION
			/// @return				{Enum}	the orientation of the slider
			self.getOrientation = function()						{ return self.__orientation; }
				
			/// @method				setOrientation(_orientation)
			/// @description		Sets the orientation of the slide
			/// @param				{Enum}	_orientation	the orientation according to UI_ORIENTATION
			/// @return				{UISlider}	self
			self.setOrientation = function(_orientation)			{ self.__orientation = _orientation; return self; }
				
			/// @method				getShowMinMaxText()
			/// @description		Gets whether the slider renders text for the min and max values
			/// @return				{Bool}	whether the slider renders min/max text
			self.getShowMinMaxText = function()						{ return self.__show_min_max_text; }
				
			/// @method				setShowMinMaxText(_value)
			/// @description		Sets whether the slider renders text for the min and max values
			/// @param				{Bool}	_value	whether the slider renders min/max text
			/// @return				{UISlider}	self
			self.setShowMinMaxText = function(_value)				{ self.__show_min_max_text = _value; return self; }
				
			/// @method				getShowHandleText()
			/// @description		Gets whether the slider renders text for the handle value
			/// @return				{Bool}	whether the slider renders renders text for the handle value
			self.getShowHandleText = function()						{ return self.__show_handle_text; }
				
			/// @method				setShowHandleText(_value)
			/// @description		Sets whether the slider renders text for the handle value
			/// @param				{Bool}	_value	whether the slider renders text for the handle value
			/// @return				{UISlider}	self
			self.setShowHandleText = function(_value)				{ self.__show_handle_text = _value; return self; }
				
			/// @method				getTextFormat()
			/// @description		Gets the text format for the slider text
			/// @return				{String}	the Scribble text format used for the slider text
			self.getTextFormat = function()							{ return self.__text_format; }
				
			/// @method				setTextFormat(_format)
			/// @description		Sets the text format for the slider text
			/// @param				{String}	_format	the Scribble text format used for the slider text
			/// @return				{UISlider}	self
			self.setTextFormat = function(_format)					{ self.__text_format = _format; return self; }
				
			/// @method				getInheritLength()
			/// @description		Gets whether the widget inherits its length (width or height, according to UI_ORIENTATION) from its parent.
			/// @returns			{Bool}	Whether the widget inherits its length from its parent
			self.getInheritLength = function()					{ return self.__orientation == UI_ORIENTATION.HORIZONTAL ?  self.__dimensions.inherit_width : self.__dimensions.inherit_length; }
				
			/// @method				setInheritLength(_inherit_length)
			/// @description		Sets whether the widget inherits its length (width or height, according to UI_ORIENTATION) from its parent.
			/// @param				{Bool}	_inherit_length Whether the widget inherits its length from its parent
			/// @return				{UIWidget}	self
			self.setInheritLength = function(_inherit_length)	{ 
				if (self.__orientation == UI_ORIENTATION.HORIZONTAL) {
					self.__dimensions.inherit_width = _inherit_length;
				}
				else {
					self.__dimensions.inherit_height = _inherit_length;
				}
				self.__dimensions.calculateCoordinates();
				self.__updateChildrenPositions();
				return self;
			}
				
			/// @method				getHandleOffset()
			/// @description		Gets the x,y offset of the handle sprite, relative to the default (by default, it displays at the baseline of the rail, depending on orientation)
			/// @return				{Struct}	The x,y struct defining the offset
			self.getHandleOffset = function()							{ return self.__handle_offset; }
			
			/// @method				setHandleOffset(_offset)
			/// @description		Sets the x,y offset of the handle sprite, relative to the default (by default, it displays at the baseline of the rail, depending on orientation)
			/// @param				{Struct}	_offset		The x,y struct defining the offset
			/// @return				{UISlider}	self
			self.setHandleOffset = function(_offset)					{ self.__handle_offset = _offset; return self; }	
				
			/// @method				getHandleTextOffset()
			/// @description		Gets the x,y offset of the handle value text, relative to the default (by default, it displays the value at the top or the left of the handle, depending on orientation)
			/// @return				{Struct}	The x,y struct defining the offset
			self.getHandleTextOffset = function()							{ return self.__handle_text_offset; }
			
			/// @method				setHandleTextOffset(_offset)
			/// @description		Sets the x,y offset of the handle value text, relative to the default (by default, it displays the value at the top or the left of the handle, depending on orientation)
			/// @param				{Struct}	_offset		The x,y struct defining the offset
			/// @return				{UISlider}	self
			self.setHandleTextOffset = function(_offset)					{ self.__handle_text_offset = _offset; return self; }
				
		#endregion
		#region Methods
			self.__getHandle = function() {
				var _proportion = (self.__value - self.__min_value)/(self.__max_value - self.__min_value);
				var _handle_x, _handle_y;
				if (self.__orientation == UI_ORIENTATION.HORIZONTAL) {
					var _width = self.__length * global.__gooey_manager_active.getScale();
					var _height = sprite_exists(self.__sprite_handle) ? sprite_get_height(self.__sprite_handle) * global.__gooey_manager_active.getScale() : 0;
					var _handle_x = self.__dimensions.x + _width * _proportion + self.__handle_offset.x;
					var _handle_y = self.__dimensions.y;
				}
				else {
					var _width = sprite_exists(self.__sprite_handle) ? sprite_get_width(self.__sprite_handle) * global.__gooey_manager_active.getScale() : 0;
					var _height = self.__length * global.__gooey_manager_active.getScale();
					var _handle_x = self.__dimensions.x;
					var _handle_y = self.__dimensions.y + _height * _proportion + self.__handle_offset.y;						
				}
				return {x: _handle_x, y: _handle_y};
			}
				
			self.__draw = function() {
				var _x = self.__dimensions.x;
				var _y = self.__dimensions.y;
					
				var _proportion = (self.__value - self.__min_value)/(self.__max_value - self.__min_value);
					
				if (self.__orientation == UI_ORIENTATION.HORIZONTAL) {
					var _width = self.__length * global.__gooey_manager_active.getScale();
					var _height = sprite_exists(self.__sprite_handle) ? sprite_get_height(self.__sprite_handle) * global.__gooey_manager_active.getScale() : 0;
					var _width_base = _width;
					var _height_base = sprite_exists(self.__sprite_base) ? sprite_get_height(self.__sprite_base) * global.__gooey_manager_active.getScale() : 0;
					var _width_progress = _width * _proportion;
					var _height_progress = sprite_exists(self.__sprite_progress) ? sprite_get_height(self.__sprite_progress) * global.__gooey_manager_active.getScale() : 0;
						
					var _x_sprites = _x + (sprite_exists(self.__sprite_handle) ? sprite_get_width(self.__sprite_handle)/2 : 0);
					var _y_sprites = _y - self.__handle_offset.y;
					var _width_widget = _width + (sprite_exists(self.__sprite_handle) ? sprite_get_width(self.__sprite_handle) : 0);
					var _height_widget = _height;
				}
				else {
					var _width = sprite_exists(self.__sprite_handle) ? sprite_get_width(self.__sprite_handle) * global.__gooey_manager_active.getScale() : 0;
					var _height = self.__length * global.__gooey_manager_active.getScale();
					var _width_base = sprite_exists(self.__sprite_base) ? sprite_get_width(self.__sprite_base) * global.__gooey_manager_active.getScale() : 0;
					var _height_base = _height;
					var _width_progress = sprite_exists(self.__sprite_progress) ? sprite_get_width(self.__sprite_progress) * global.__gooey_manager_active.getScale() : 0;
					var _height_progress = _height * _proportion;
						
					var _x_sprites = _x - self.__handle_offset.x;
					var _y_sprites = _y + (sprite_exists(self.__sprite_handle) ? sprite_get_height(self.__sprite_handle)/2 : 0);
					var _width_widget = _width;
					var _height_widget = _height + (sprite_exists(self.__sprite_handle) ? sprite_get_height(self.__sprite_handle) : 0);
				}
				var _handle = self.__getHandle();
					
				var _m_x = device_mouse_x_to_gui(global.__gooey_manager_active.getMouseDevice());
				var _m_y = device_mouse_y_to_gui(global.__gooey_manager_active.getMouseDevice());
				var _w_handle = sprite_exists(self.__sprite_handle) ? sprite_get_width(self.__sprite_handle) : 0;
				var _h_handle = sprite_exists(self.__sprite_handle) ? sprite_get_height(self.__sprite_handle) : 0;
				var _within_handle = point_in_rectangle(_m_x, _m_y, _handle.x, _handle.y, _handle.x + _w_handle * global.__gooey_manager_active.getScale(), _handle.y + _h_handle);
					
				// Draw
				if (sprite_exists(self.__sprite_base))			draw_sprite_stretched_ext(self.__sprite_base, self.__image_base, _x_sprites, _y_sprites, _width_base, _height_base, self.__image_blend, self.__image_alpha);
				if (sprite_exists(self.__sprite_progress))		draw_sprite_stretched_ext(self.__sprite_progress, self.__image_progress, _x_sprites + self.__sprite_progress_offset.x, _y_sprites + self.__sprite_progress_offset.y, _width_progress, _height_progress, self.__image_blend, self.__image_alpha);
					
				if (_within_handle || global.__gooey_manager_active.__currentlyDraggedWidget == self) {
					if (sprite_exists(self.__sprite_handle_mouseover))			draw_sprite_ext(self.__sprite_handle_mouseover, self.__image_handle_mouseover, _handle.x, _handle.y, 1, 1, 0, self.__image_blend, self.__image_alpha);
				}
				else {
					if (sprite_exists(self.__sprite_handle))			draw_sprite_ext(self.__sprite_handle, self.__image_handle, _handle.x, _handle.y, 1, 1, 0, self.__image_blend, self.__image_alpha);
				}
					
				self.setDimensions(,, _width_widget, _height_widget);
					
				if (self.__show_min_max_text) {
					var _smin = UI_TEXT_RENDERER(self.__text_format + string(self.__min_value));
					var _smax = UI_TEXT_RENDERER(self.__text_format + string(self.__max_value));												
					if (self.__orientation == UI_ORIENTATION.HORIZONTAL) {
						_smin.draw(_x - _smin.get_width(), _y_sprites);
						//_smax.draw(_x + _width, _y);
						_smax.draw(_x + _width_widget, _y_sprites);
					}
					else {
						_smin.draw(_x_sprites, _y - _smin.get_height());
						//_smax.draw(_x, _y + _height);
						_smax.draw(_x_sprites, _y + _height_widget);
					}
				}
					
				if (self.__show_handle_text) {
					var _stxt = UI_TEXT_RENDERER(self.__text_format + string(self.__value));
					if (self.__orientation == UI_ORIENTATION.HORIZONTAL) {
						var _w_handle = sprite_exists(self.__sprite_handle) ? sprite_get_width(self.__sprite_handle) : 0;					
						_stxt.draw(_handle.x + _w_handle/2 + self.__handle_text_offset.x, _handle.y - _stxt.get_height() + self.__handle_text_offset.y);
					}
					else {
						var _h_handle = sprite_exists(self.__sprite_handle) ? sprite_get_height(self.__sprite_handle) : 0;
						_stxt.draw(_handle.x - _stxt.get_width() + self.__handle_text_offset.x, _handle.y + _h_handle/2 + self.__handle_text_offset.y);
					}
				}
										
			}
			self.__generalBuiltInBehaviors = method(self, __builtInBehavior);
			self.__builtInBehavior = function() {
					
				// Check if click is outside handle
				var _m_x = device_mouse_x_to_gui(global.__gooey_manager_active.getMouseDevice());
				var _m_y = device_mouse_y_to_gui(global.__gooey_manager_active.getMouseDevice());
				var _handle = self.__getHandle();
				var _w_handle = sprite_exists(self.__sprite_handle) ? sprite_get_width(self.__sprite_handle) : 0;
				var _h_handle = sprite_exists(self.__sprite_handle) ? sprite_get_height(self.__sprite_handle) : 0;
				var _within_handle = point_in_rectangle(_m_x, _m_y, _handle.x, _handle.y, _handle.x + _w_handle * global.__gooey_manager_active.getScale(), _handle.y + _h_handle);
				// Check if before or after handle
				if (self.__orientation == UI_ORIENTATION.HORIZONTAL) {
					var _before = _m_x < _handle.x;
					var _after = _m_x > _handle.x + _w_handle;
				}
				else {
					var _before = _m_y < _handle.y;
					var _after = _m_y > _handle.y + _h_handle;
				}
					
				if (!_within_handle && self.__events_fired[UI_EVENT.LEFT_CLICK]) {
					if (self.__click_to_set) {
						self.__drag();
					}
					else {
						self.setValue(self.__value + (_before ? -1 : (_after ? 1 : 0)) * self.__click_change);
					}
				}					
				else if (self.__events_fired[UI_EVENT.MOUSE_WHEEL_DOWN]) {
					self.setValue(self.__value + self.__scroll_change);
				}
				else if (self.__events_fired[UI_EVENT.MOUSE_WHEEL_UP]) {
					self.setValue(self.__value - self.__scroll_change);
				}					
					
				var _arr = array_create(GOOEY_NUM_CALLBACKS, true);
				self.__generalBuiltInBehaviors(_arr);
			}
				
			self.__dragCondition = function() {
				var _m_x = device_mouse_x_to_gui(global.__gooey_manager_active.getMouseDevice());
				var _m_y = device_mouse_y_to_gui(global.__gooey_manager_active.getMouseDevice());
				var _handle = self.__getHandle();
				var _w_handle = sprite_exists(self.__sprite_handle) ? sprite_get_width(self.__sprite_handle) : 0;
				var _h_handle = sprite_exists(self.__sprite_handle) ? sprite_get_height(self.__sprite_handle) : 0;
					
				var _within_handle = point_in_rectangle(_m_x, _m_y, _handle.x, _handle.y, _handle.x + _w_handle * global.__gooey_manager_active.getScale(), _handle.y + _h_handle);
				if (_within_handle) {
					global.__gooey_manager_active.__drag_data.__drag_specific_start_x = _m_x;
					global.__gooey_manager_active.__drag_data.__drag_specific_start_y = _m_y;
					global.__gooey_manager_active.__drag_data.__drag_specific_start_width = _w_handle * global.__gooey_manager_active.getScale();
					global.__gooey_manager_active.__drag_data.__drag_specific_start_height = _h_handle * global.__gooey_manager_active.getScale();
					global.__gooey_manager_active.__drag_data.__drag_specific_start_value = self.__value;
				}
				return _within_handle;
			}
				
			self.__drag = function() {
				var _w_handle = sprite_exists(self.__sprite_handle) ? sprite_get_width(self.__sprite_handle) : 0;
				var _h_handle = sprite_exists(self.__sprite_handle) ? sprite_get_height(self.__sprite_handle) : 0;
					
				if (self.__orientation == UI_ORIENTATION.HORIZONTAL) {
					var _width = self.__length * global.__gooey_manager_active.getScale();
					var _current_value_proportion = (self.__value - self.__min_value)/(self.__max_value - self.__min_value);
					//var _current_handle_x_center = self.__getHandle().x + _w_handle/2;
					var _m_x = device_mouse_x_to_gui(global.__gooey_manager_active.getMouseDevice());
					var _new_handle_x_center = _m_x  - _w_handle/2;
					var _new_value_proportion = clamp((_new_handle_x_center - self.__dimensions.x - self.__handle_offset.x) / _width, 0, 1);			
				}
				else {
					var _height = self.__length * global.__gooey_manager_active.getScale();
					var _current_value_proportion = (self.__value - self.__min_value)/(self.__max_value - self.__min_value);
					//var _current_handle_y_center = self.__getHandle().y + _h_handle/2;
					var _m_y = device_mouse_y_to_gui(global.__gooey_manager_active.getMouseDevice());
					var _new_handle_y_center = _m_y  - _h_handle/2;
					var _new_value_proportion = clamp((_new_handle_y_center - self.__dimensions.y - self.__handle_offset.y) / _height , 0, 1);	
				}
					
				if (abs(_new_value_proportion - _current_value_proportion) > 0.00001) {
					var _raw_value = _new_value_proportion * (self.__max_value - self.__min_value) + self.__min_value;
					if (_raw_value >= self.__max_value)			self.setValue(self.__max_value);
					else if (_raw_value <= self.__min_value)	self.setValue(self.__min_value);
					else {
						if (_raw_value < self.__value) {
							var _max_unit = self.__value;
							var _min_unit = max(self.__min_value, _max_unit - self.__drag_change);
								
							while (!(_raw_value <= _max_unit && _raw_value >= _min_unit)) {
								_max_unit = _min_unit;
								_min_unit = max(self.__min_value, _min_unit - self.__drag_change);
							}
							self.setValue( abs(_min_unit - _raw_value) < abs(_max_unit - _raw_value) ? _min_unit : _max_unit );								
						}
						else if (_raw_value > self.__value) {
							var _min_unit = self.__value;
							var _max_unit = min(self.__max_value, _min_unit + self.__drag_change);
								
							while (!(_raw_value <= _max_unit && _raw_value >= _min_unit)) {
								_min_unit = _max_unit;
								_max_unit = min(self.__max_value, _max_unit + self.__drag_change);
							}
							self.setValue( abs(_min_unit - _raw_value) < abs(_max_unit - _raw_value) ? _min_unit : _max_unit );								
						}		
					}						
				}
			}
				
		#endregion
		
		self.__register();
		return self;
	}
	
#endregion
