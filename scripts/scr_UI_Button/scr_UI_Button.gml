/// @feather ignore all
#region UIButton
	
	/// @constructor	UIButton(_id, _x, _y, _width, _height, _text, _sprite, [_relative_to=UI_DEFAULT_ANCHOR_POINT])
	/// @extends		UIWidget
	/// @description	A Button widget, clickable UI widget that performs an action
	/// @param			{String}			_id				The Button's name, a unique string ID. If the specified name is taken, the Button will be renamed and a message will be displayed on the output log.
	/// @param			{Real}				_x				The x position of the Button, **relative to its parent**, according to the _relative_to parameter
	/// @param			{Real}				_y				The y position of the Button, **relative to its parent**, according to the _relative_to parameter	
	/// @param			{Real}				_width			The width of the Button
	/// @param			{Real}				_height			The height of the Button
	/// @param			{String}			_text			The text to display for the Button
	/// @param			{Asset.GMSprite}	_sprite			The sprite ID to use for rendering the Button
	/// @param			{Enum}				[_relative_to]	The position relative to which the Button will be drawn. By default, uses UI_DEFAULT_ANCHOR_POINT macro in the config (top left if not changed) <br>
	///														See the [UIWidget](#UIWidget) documentation for more info and valid values.
	/// @return			{UIButton}							self
	function UIButton(_id, _x, _y, _width, _height, _text, _sprite, _relative_to=UI_DEFAULT_ANCHOR_POINT) : __UIWidget(_id, _x, _y, _width, _height, _sprite, _relative_to) constructor {
		#region Private variables
			self.__type = UI_TYPE.BUTTON;
			self.__text = _text;
			self.__text_mouseover = _text;
			self.__text_click = _text;
			self.__text_disabled = _text;
			self.__sprite_mouseover = _sprite;
			self.__sprite_click = _sprite;
			self.__sprite_disabled = _sprite;
			self.__image_mouseover = 0;
			self.__image_click = 0;			
			self.__image_disabled = 0;
			self.__text_format = "";
			self.__text_format_mouseover = "";
			self.__text_format_click = "";
			self.__text_format_disabled = "";
			self.__text_relative_to = UI_RELATIVE_TO.MIDDLE_CENTER;
			self.__text_offset = {x: 0, y:0};
		#endregion
		#region Setters/Getters
			
			// Note: set/get sprite, set/get image inherited from UIWidget.
			
			/// @method				getRawText()
			/// @description		Gets the text of the button, without Scribble formatting tags.
			///	@return				{String}	The text, without Scribble formatting tags.			
			self.getRawText = function()						{ return UI_TEXT_RENDERER(self.__text).get_text(); }
			
			/// @method				getText()
			/// @description		Gets the Scribble text string of the button, either via the defined binding or, if undefined, the defined text.
			///	@return				{String}	The Scribble text string of the button.
			self.getText = function()	{
				return self.__text;
			}
			
			/// @method				setText(_text)
			/// @description		Sets the Scribble text string of the button.
			/// @param				{String}	_text	The Scribble string to assign to the button.			
			/// @return				{UIButton}	self
			self.setText = function(_text)	{
				self.__text = _text;
				if (!is_undefined(self.__binding)) {
					self.__updateBoundVariable(_text);
				}
				return self;
			}
						
			/// @method				getRawTextMouseover()
			/// @description		Gets the text of the button when mouseovered, without Scribble formatting tags.
			///	@return				{String}	The text, without Scribble formatting tags.			
			self.getRawTextMouseover = function()				{ return UI_TEXT_RENDERER(self.__text_mouseover).get_text(); }	
			
			/// @method				getTextMouseover()
			/// @description		Gets the Scribble text string of the button when mouseovered.
			///	@return				{String}	The Scribble text string of the button when mouseovered.
			self.getTextMouseover = function()					{ return self.__text_mouseover; }
			
			/// @method				setTextMouseover(_text)
			/// @description		Sets the Scribble text string of the button when mouseovered.
			/// @param				{String}	_text	The Scribble string to assign to the button when mouseovered.
			/// @return				{UIButton}	self
			self.setTextMouseover = function(_text_mouseover)	{ self.__text_mouseover = _text_mouseover; return self; }
			
			/// @method				getRawTextClick()
			/// @description		Gets the text of the button when clicked, without Scribble formatting tags.
			///	@return				{String}	The text, without Scribble formatting tags.			
			self.getRawTextClick = function()					{ return UI_TEXT_RENDERER(self.__text_click).get_text(); }
			
			/// @method				getTextClick()
			/// @description		Gets the Scribble text string of the button when clicked.
			///	@return				{String}	The Scribble text string of the button when clicked.
			self.getTextClick = function()						{ return self.__text_click; }
			
			/// @method				setTextClick(_text)
			/// @description		Sets the Scribble text string of the button when clicked.
			/// @param				{String}	_text	The Scribble string to assign to the button when clicked.
			/// @return				{UIButton}	self
			self.setTextClick = function(_text_click)			{ self.__text_click = _text_click; return self; }
				
			/// @method				getRawTextDisabled()
			/// @description		Gets the text of the button when disabled, without Scribble formatting tags.
			///	@return				{String}	The text, without Scribble formatting tags.			
			self.getRawTextDisabled = function()					{ return UI_TEXT_RENDERER(self.__text_disabled).get_text(); }
			
			/// @method				getTextDisabled()
			/// @description		Gets the Scribble text string of the button when disabled.
			///	@return				{String}	The Scribble text string of the button when disabled.
			self.getTextDisabled = function()						{ return self.__text_disabled; }
			
			/// @method				setTextDisabled(_text)
			/// @description		Sets the Scribble text string of the button when disabled.
			/// @param				{String}	_text	The Scribble string to assign to the button when disabled.
			/// @return				{UIButton}	self
			self.setTextDisabled = function(_text_disabled)			{ self.__text_disabled = _text_disabled; return self; }
				
				
			/// @method				getTextFormat()
			/// @description		Gets the general Scribble string format (tags) of the button on its normal state
			///	@return				{String}	The Scribble text string format
			self.getTextFormat = function()					{ return self.__text_format; }
			
			/// @method				setTextFormat(_text_format)
			/// @description		Sets the general Scribble string format (tags) of the button on its normal state
			/// @param				{String}	_text_format	The Scribble tag format to render the button 
			/// @return				{UIButton}	self
			self.setTextFormat = function(_text_format)	{ self.__text_format = _text_format; return self; }
				
			/// @method				getTextFormatMouseover()
			/// @description		Gets the general Scribble string format (tags) of the button on its mouseovered state
			///	@return				{String}	The Scribble text string format
			self.getTextFormatMouseover = function()					{ return self.__text_format_mouseover; }
			
			/// @method				setTextFormatMouseover(_text_format)
			/// @description		Sets the general Scribble string format (tags) of the button on its mouseovered state
			/// @param				{String}	_text_format	The Scribble tag format to render the button when mouseovered
			/// @return				{UIButton}	self
			self.setTextFormatMouseover = function(_text_format)	{ self.__text_format_mouseover = _text_format; return self; }
				
			/// @method				getTextFormatClick()
			/// @description		Gets the general Scribble string format (tags) of the button on its clicked state
			///	@return				{String}	The Scribble text string format
			self.getTextFormatClick = function()					{ return self.__text_format_click; }
			
			/// @method				setTextFormatClick(_text_format)
			/// @description		Sets the general Scribble string format (tags) of the button on its clicked state
			/// @param				{String}	_text_format	The Scribble tag format to render the button when clicked
			/// @return				{UIButton}	self
			self.setTextFormatClick = function(_text_format)	{ self.__text_format_click = _text_format; return self; }
				
			/// @method				getTextFormatDisabled()
			/// @description		Gets the general Scribble string format (tags) of the button on its disabled state
			///	@return				{String}	The Scribble text string format
			self.getTextFormatDisabled = function()					{ return self.__text_format_disabled; }
			
			/// @method				setTextFormatDisabled(_text_format)
			/// @description		Sets the general Scribble string format (tags) of the button on its disabled state
			/// @param				{String}	_text_format	The Scribble tag format to render the button when disabled
			/// @return				{UIButton}	self
			self.setTextFormatDisabled = function(_text_format)	{ self.__text_format_disabled = _text_format; return self; }
				
			/// @method				getSpriteMouseover()
			/// @description		Gets the sprite ID of the button when mouseovered			
			/// @return				{Asset.GMSprite}	The sprite ID of the button when mouseovered
			self.getSpriteMouseover = function()				{ return self.__sprite_mouseover; }
			
			/// @method				setSpriteMouseover(_sprite)
			/// @description		Sets the sprite to be rendered when mouseovered.
			/// @param				{Asset.GMSprite}	_sprite		The sprite ID
			/// @return				{UIButton}	self
			self.setSpriteMouseover = function(_sprite)			{ self.__sprite_mouseover = _sprite; return self; }
			
			/// @method				getSpriteClick()
			/// @description		Gets the sprite ID of the button when clicked.			
			/// @return				{Asset.GMSprite}	The sprite ID of the button when clicked
			self.getSpriteClick = function()					{ return self.__sprite_click; }
						
			/// @method				setSpriteClick(_sprite)
			/// @description		Sets the sprite to be rendered when clicked.
			/// @param				{Asset.GMSprite}	_sprite		The sprite ID
			/// @return				{UIButton}	self
			self.setSpriteClick = function(_sprite)				{ self.__sprite_click = _sprite; return self; }
								
			/// @method				getSpriteDisabled()
			/// @description		Gets the sprite ID of the button when disabled.			
			/// @return				{Asset.GMSprite}	The sprite ID of the button when disabled
			self.getSpriteDisabled = function()					{ return self.__sprite_disabled; }
						
			/// @method				setSpriteDisabled(_sprite)
			/// @description		Sets the sprite to be rendered when disabled.
			/// @param				{Asset.GMSprite}	_sprite		The sprite ID
			/// @return				{UIButton}	self
			self.setSpriteDisabled = function(_sprite)				{ self.__sprite_disabled = _sprite; return self; }

			/// @method				getImageMouseover()
			/// @description		Gets the image index of the button when mouseovered.		
			/// @return				{Real}	The image index of the button when mouseovered
			self.getImageMouseover = function()					{ return self.__image_mouseover; }
			
			/// @method				setImageMouseover(_image)
			/// @description		Sets the image index of the button when mouseovered
			/// @param				{Real}	_image	The image index
			/// @return				{UIButton}	self
			self.setImageMouseover = function(_image)			{ self.__image_mouseover = _image; return self; }
			
			/// @method				getImageClick()
			/// @description		Gets the image index of the button when clicked.
			/// @return				{Real}	The image index of the button when clicked
			self.getImageClick = function()						{ return self.__image_click; }
			
			/// @method				setImageClick(_image)
			/// @description		Sets the image index of the button when clicked.
			/// @param				{Real}	_image	The image index
			/// @return				{UIButton}	self
			self.setImageClick = function(_image)				{ self.__image_click = _image; return self; }
				
			/// @method				getImageDisabled()
			/// @description		Gets the image index of the button when disabled.
			/// @return				{Real}	The image index of the button when disabled
			self.getImageDisabled = function()						{ return self.__image_disabled; }
			
			/// @method				setImageDisabled(_image)
			/// @description		Sets the image index of the button when disabled.
			/// @param				{Real}	_image	The image index
			/// @return				{UIButton}	self
			self.setImageDisabled = function(_image)				{ self.__image_disabled = _image; return self; }
				
			/// @method				getTextRelativeTo()
			/// @description		Gets the positioning of the button text relative to the button, according to UI_RELATIVE_TO
			/// @return				{Enum}	The relative positioning of the text within the button
			self.getTextRelativeTo = function()						{ return self.__text_relative_to; }
			
			/// @method				setTextRelativeTo(_relative_to)
			/// @description		Sets the positioning of the button text relative to the button, according to UI_RELATIVE_TO
			/// @param				{Enum}	_relative_to	The relative positioning of the text within the button
			/// @return				{UIButton}	self
			self.setTextRelativeTo = function(_relative_to)			{ self.__text_relative_to = _relative_to; return self; }
				
			/// @method				getTextOffset()
			/// @description		Gets the text x-y offset for the button, starting from the anchor point
			/// @return				{Struct}	A struct with x and y position
			self.getTextOffset = function()						{ return self.__text_offset; }
			
			/// @method				setTextOffset(_offset)
			/// @description		Sets the text x-y offset for the button, starting from the anchor point
			/// @param				{Struct}	_offset		A struct with x and y position
			/// @return				{UIButton}	self
			self.setTextOffset = function(_offset)			{ self.__text_offset = _offset; return self; }
				
		#endregion
		#region Methods
			self.__draw = function() {
				var _x = self.__dimensions.x;
				var _y = self.__dimensions.y;
				var _width = self.__dimensions.width * global.__gooey_manager_active.getScale();
				var _height = self.__dimensions.height * global.__gooey_manager_active.getScale();
					
				var _bound = !is_undefined(self.__binding);
										
				if (self.__enabled) {
					var _sprite = self.__sprite;
					var _image = self.__image;
					var _text = self.getText();
					var _fmt = self.getTextFormat();
					if (self.__events_fired[UI_EVENT.MOUSE_OVER])	{					
						_sprite =	self.__events_fired[UI_EVENT.LEFT_HOLD] ? self.__sprite_click : self.__sprite_mouseover;
						_image =	self.__events_fired[UI_EVENT.LEFT_HOLD] ? self.__image_click : self.__image_mouseover;
						_text =		self.__events_fired[UI_EVENT.LEFT_HOLD] ? (_bound ? self.getText() : self.__text_click) : (_bound ? self.getText() : self.__text_mouseover);
						_fmt =		self.__events_fired[UI_EVENT.LEFT_HOLD] ? self.getTextFormatClick() : self.getTextFormatMouseover();											
					}
				}
				else {
					var _sprite = self.__sprite_disabled;
					var _image = self.__image_disabled;
					var _text = (_bound ? self.getText() : self.__text_disabled);
					var _fmt = self.getTextFormatDisabled();
				}
				if (sprite_exists(_sprite)) draw_sprite_stretched_ext(_sprite, _image, _x, _y, _width, _height, self.__image_blend, self.__image_alpha);
					
				if (self.__text_relative_to == UI_RELATIVE_TO.TOP_CENTER || self.__text_relative_to == UI_RELATIVE_TO.MIDDLE_CENTER || self.__text_relative_to == UI_RELATIVE_TO.BOTTOM_CENTER)	_x += self.__dimensions.width / 2;
				if (self.__text_relative_to == UI_RELATIVE_TO.TOP_RIGHT || self.__text_relative_to == UI_RELATIVE_TO.MIDDLE_RIGHT || self.__text_relative_to == UI_RELATIVE_TO.BOTTOM_RIGHT)		_x += self.__dimensions.width;
				if (self.__text_relative_to == UI_RELATIVE_TO.MIDDLE_LEFT || self.__text_relative_to == UI_RELATIVE_TO.MIDDLE_CENTER || self.__text_relative_to == UI_RELATIVE_TO.MIDDLE_RIGHT)	_y += self.__dimensions.height / 2;
				if (self.__text_relative_to == UI_RELATIVE_TO.BOTTOM_LEFT || self.__text_relative_to == UI_RELATIVE_TO.BOTTOM_CENTER || self.__text_relative_to == UI_RELATIVE_TO.BOTTOM_RIGHT)	_y += self.__dimensions.height;
					
				_x += self.__text_offset.x;
				_y += self.__text_offset.y;
					
				var _scale = "[scale,"+string(global.__gooey_manager_active.getScale())+"]";
				UI_TEXT_RENDERER(_scale+_fmt+string(_text)).draw(_x, _y);
			}
			self.__generalBuiltInBehaviors = method(self, __builtInBehavior);
			self.__builtInBehavior = function() {
				if (self.__events_fired[UI_EVENT.LEFT_CLICK]) 	self.__callbacks[UI_EVENT.LEFT_CLICK]();
				var _arr = array_create(GOOEY_NUM_CALLBACKS, true);
				_arr[UI_EVENT.LEFT_CLICK] = false;
				self.__generalBuiltInBehaviors(_arr);
			}
		#endregion
		
		self.__register();
		return self;
	}
	
	
#endregion
	