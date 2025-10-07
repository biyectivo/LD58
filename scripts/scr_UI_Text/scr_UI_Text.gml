/// @feather ignore all
#region UIText
	
	/// @constructor	UIText(_id, _x, _y, _text, [_relative_to=UI_DEFAULT_ANCHOR_POINT])
	/// @extends		UIWidget
	/// @description	A Text widget, which renders a Scribble text to the screen
	/// @param			{String}			_id				The Text's name, a unique string ID. If the specified name is taken, the Text will be renamed and a message will be displayed on the output log.
	/// @param			{Real}				_x				The x position of the Text, **relative to its parent**, according to the _relative_to parameter
	/// @param			{Real}				_y				The y position of the Text, **relative to its parent**, according to the _relative_to parameter		
	/// @param			{String}			_text			The text to display for the Button
	/// @param			{Enum}				[_relative_to]	The position relative to which the Text will be drawn. By default, uses UI_DEFAULT_ANCHOR_POINT macro in the config (top left if not changed) <br>
	///														See the [UIWidget](#UIWidget) documentation for more info and valid values.
	/// @return			{UIText}							self
	function UIText(_id, _x, _y, _text, _relative_to=UI_DEFAULT_ANCHOR_POINT) : __UIWidget(_id, _x, _y, 0, 0, -1, _relative_to) constructor {
		#region Private variables
			self.__type = UI_TYPE.TEXT;
			self.__text = _text;
			self.__text_mouseover = _text;
			self.__text_click = _text;
			self.__border_color = -1;
			self.__background_color = -1;
			self.__max_width = 0;
			self.__typist = undefined;
			self.__background_alpha = 1;
		#endregion
		#region Setters/Getters
			/// @method				getRawText()
			/// @description		Gets the text of the UIText, without Scribble formatting tags.
			///	@return				{String}	The text, without Scribble formatting tags.			
			self.getRawText = function()						{ return UI_TEXT_RENDERER(self.__text).get_text(); }
			
			/// @method				getText()
			/// @description		Gets the Scribble text string of the UIText, either via the defined binding or, if undefined, the defined text.
			///	@return				{String}	The Scribble text string of the button.
			self.getText = function() {
				return self.__text;
			}
			
			/// @method				setText(_text)
			/// @description		Sets the Scribble text string of the UIText.
			/// @param				{String}	_text	The Scribble string to assign to the UIText.			
			/// @return				{UIText}	self
			self.setText = function(_text)	{
				self.__text = _text;
				if (!is_undefined(self.__binding)) {
					self.__updateBoundVariable(_text);
				}
				return self;
			}
						
			/// @method				getRawTextMouseover()
			/// @description		Gets the text of the UIText when mouseovered, without Scribble formatting tags.
			///	@return				{String}	The text, without Scribble formatting tags.			
			self.getRawTextMouseover = function()				{ return UI_TEXT_RENDERER(self.__text_mouseover).get_text(); }	
			
			/// @method				getTextMouseover()
			/// @description		Gets the Scribble text string of the UIText when mouseovered.
			///	@return				{String}	The Scribble text string of the UIText when mouseovered.
			self.getTextMouseover = function()					{ return self.__text_mouseover; }
			
			/// @method				setTextMouseover(_text)
			/// @description		Sets the Scribble text string of the UIText when mouseovered.
			/// @param				{String}	_text	The Scribble string to assign to the UIText when mouseovered.
			/// @return				{UIText}	self
			self.setTextMouseover = function(_text_mouseover)	{ self.__text_mouseover = _text_mouseover; return self; }
			
			/// @method				getRawTextClick()
			/// @description		Gets the text of the UIText when clicked, without Scribble formatting tags.
			///	@return				{String}	The text, without Scribble formatting tags.			
			self.getRawTextClick = function()					{ return UI_TEXT_RENDERER(self.__text_click).get_text(); }
			
			/// @method				getTextClick()
			/// @description		Gets the Scribble text string of the UIText when clicked.
			///	@return				{String}	The Scribble text string of the UIText when clicked.
			self.getTextClick = function()						{ return self.__text_click; }
			
			/// @method				setTextClick(_text)
			/// @description		Sets the Scribble text string of the UIText when clicked.
			/// @param				{String}	_text	The Scribble string to assign to the UIText when clicked.
			/// @return				{UIText}	self
			self.setTextClick = function(_text_click)			{ self.__text_click = _text_click; return self; }
			
			/// @method				getBorderColor()
			/// @description		Gets the border color of the text, or -1 if invisible
			///	@return				{Constant.Colour}	The border color or -1
			self.getBorderColor = function()					{ return self.__border_color; }
			
			/// @method				setBorderColor(_color)
			/// @description		Sets the border color of the text to a color, or unsets it if it's -1
			/// @param				{Constant.Color}	_color	The color constant, or -1
			/// @return				{UIText}	self
			self.setBorderColor = function(_color)			{ self.__border_color = _color; return self; }
			
			/// @method				getBackgroundColor()
			/// @description		Gets the background color of the text, or -1 if invisible
			///	@return				{Constant.Colour}	The background color or -1
			self.getBackgroundColor = function()				{ return self.__background_color; }
			
			/// @method				setBackgroundColor(_color)
			/// @description		Sets the background color of the text to a color, or unsets it if it's -1
			/// @param				{Constant.Color}	_color	The color constant, or -1
			/// @return				{UIText}	self
			self.setBackgroundColor = function(_color)			{ self.__background_color = _color; return self; }
				
			/// @method				getBackgroundAlpha()
			/// @description		Gets the background alpha of the text background
			///	@return				{Real}	The background alpha
			self.getBackgroundAlpha = function()				{ return self.__background_alpha; }
			
			/// @method				setBackgroundAlpha(_alpha)
			/// @description		Sets the background alpha of the text background
			/// @param				{Real}	_alpha	The alpha value
			/// @return				{UIText}	self
			self.setBackgroundAlpha = function(_alpha)			{ self.__background_alpha = _alpha; return self; }
			
			/// @method				getTypist()
			/// @description		Gets the text renderer typist
			///	@return				{Any}	The typist
			self.getTypist = function()				{ return self.__background_color; }
			
			/// @method				setTypist(_typist)
			/// @description		Sets the text renderer typist
			/// @param				{Any}	_typist	The typist to set
			/// @return				{UIText}	self
			self.setTypist = function(_typist)			{ self.__typist = _typist; return self; }
			
				
			/// @method				getMaxWidth()
			/// @description		Gets the max width of the text element. If greater than zero, text will wrap to the next line when it reaches the maximum width.
			///	@return				{Real}	The max width, or 0 if unlimited
			self.getMaxWidth = function()				{ return self.__max_width; }
			
			/// @method				setMaxWidth(_max_width)
			/// @description		Sets the max width of the text element. If greater than zero, text will wrap to the next line when it reaches the maximum width.
			/// @param				{Real}	_max_width	The max width, or 0 if unlimited
			/// @return				{UIText}	self
			self.setMaxWidth = function(_max_width)			{ self.__max_width = _max_width; return self; }
		#endregion
		#region Methods
			self.__draw = function() {
				var _x = self.__dimensions.x;
				var _y = self.__dimensions.y;					
										
				var _text = self.getText();
				var _scale = "[scale,"+string(global.__gooey_manager_active.getScale())+"]";
										
				if (self.__events_fired[UI_EVENT.MOUSE_OVER])	{					
					_text =	self.__events_fired[UI_EVENT.LEFT_HOLD] ? self.__text_click : self.__text_mouseover;
				}
				
				var _s = UI_TEXT_RENDERER(_scale+string(_text));					
				if (self.__max_width > 0)	_s.wrap(self.__max_width);
					
				//self.setDimensions(self.getDimensions().offset_x+_s.get_width(),self.getDimensions().offset_y+_s.get_height(),_s.get_width(), _s.get_height());
					
				var _x1 = _s.get_left(_x);
				var _x2 = _s.get_right(_x);
				var _y1 = _s.get_top(_y);
				var _y2 = _s.get_bottom(_y);
				var _alpha = draw_get_alpha();
				draw_set_alpha(self.__background_alpha);
				if (self.__background_color != -1)	draw_rectangle_color(_x1, _y1, _x2, _y2, self.__background_color, self.__background_color, self.__background_color, self.__background_color, false);
				draw_set_alpha(_alpha);
				if (self.__border_color != -1)		draw_rectangle_color(_x1, _y1, _x2, _y2, self.__border_color, self.__border_color, self.__border_color, self.__border_color, true);
				_s.draw(_x, _y, self.__typist);
				//draw_circle_color(_x, _y, 2, c_red, c_red, false);					
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
	