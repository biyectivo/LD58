/// @feather ignore all
#region UISprite
	
	/// @constructor	UISprite(_id, _x, _y, _width, _height, _sprite, [_starting_frame=0], [_relative_to=UI_DEFAULT_ANCHOR_POINT], [_time_source_parent=time_source_global])
	/// @extends		UIWidget
	/// @description	A Sprite widget to draw a sprite onto
	/// @param			{String}			_id						The Sprite's name, a unique string ID. If the specified name is taken, the Sprite will be renamed and a message will be displayed on the output log.
	/// @param			{Real}				_x						The x position of the Sprite, **relative to its parent**, according to the _relative_to parameter
	/// @param			{Real}				_y						The y position of the Sprite, **relative to its parent**, according to the _relative_to parameter	
	/// @param			{Asset.GMSprite}	_sprite					The sprite ID to use for rendering the Sprite
	/// @param			{Real}				[_width]				The width of the Sprite (by default, the original width) 
	/// @param			{Real}				[_height]				The height of the Sprite (by default, the original height)
	/// @param			{Real}				[_starting_frame]		The starting frame index (by default 0)
	/// @param			{Enum}				[_relative_to]			The position relative to which the Sprite will be drawn. By default, uses UI_DEFAULT_ANCHOR_POINT macro in the config (top left if not changed) <br>
	///																See the [UIWidget](#UIWidget) documentation for more info and valid values.
	/// @param			{Real}				[_time_source_parent]	The parent of the time source used to animate the sprite (by default, time_source_global)
	/// @return			{UISprite}									self
	function UISprite(_id, _x, _y, _sprite, _width=0, _height=0, _starting_frame=0, _relative_to=UI_DEFAULT_ANCHOR_POINT, _time_source_parent=time_source_global) : __UIWidget(_id, _x, _y, _width, _height, _sprite, _relative_to) constructor {
		#region Private variables
			self.__type = UI_TYPE.SPRITE;	
			self.__starting_frame = _starting_frame;
			self.__image = _starting_frame;
			self.__animation_step = 1;
			self.__animation_speed = sprite_get_speed(_sprite) > 0 ? round(game_get_speed(gamespeed_fps) / sprite_get_speed(_sprite)) : 0;
			self.__animation_length = sprite_get_number(_sprite);
			self.__time_source = noone;
			self.__time_source_parent = _time_source_parent;
			self.__num_frames = 0;
		#endregion
		#region Setters/Getters
			
			/// @method				getAnimationStep()
			/// @description		Gets the number of frames advanced each animation time
			///	@return				{Real}	the number of frames advanced each time
			self.getAnimationStep = function()				{ return self.__animation_step; }
			
			/// @method				setAnimationStep(_step)
			/// @description		Sets the number of frames advanced each animation time
			/// @param				{Real}	_step	the number of frames advanced each time
			/// @return				{UISprite}	self
			self.setAnimationStep = function(_step)			{ self.__animation_step = _step; return self; }
				
			/// @method				getAnimationSpeed()
			/// @description		Gets the animation speed of the sprite (as handled by the UI library). The speed is the number of frames between each frame change, not the frames per second. <br>
			///						For example, a sprite with 30 fps at a gamespeed of 60 fps, will change frames every 2 frames. Thus, this function will return 2.
			///	@return				{Real}	the animation speed
			self.getAnimationSpeed = function()				{ return self.__animation_speed; }
			
			/// @method				setAnimationSpeed(_speed, [_units = time_source_units_frames], [_start=true])
			/// @description		Sets the animation speed of the sprite (as handled by the UI library). This will NOT modify the actual sprite speed (e.g. by using `sprite_set_speed`). <br>
			///						The speed is the number of frames between each frame change, not the frames per second.<br>
			///						For example, a sprite with 30 fps at a gamespeed of 60 fps, will change frames every 2 frames. Thus, you will set this function to 2 in order to achieve 30 fps.
			/// @param				{Real}	_speed	the animation speed
			/// @param				{Real}	[_units] the animation units (by default, frames), according to the time_source_units_* constants
			/// @param				{Bool}	[_start] whether to automatically start the animation (by default, true)
			/// @return				{UISprite}	self
			self.setAnimationSpeed = function(_speed, _units = time_source_units_frames, _start=true) {
				self.__animation_speed = _speed;
				if (_speed > 0)	{
					if (time_source_exists(self.__time_source))	time_source_destroy(self.__time_source);
					self.__time_source = time_source_create(self.__time_source_parent, self.__animation_speed, _units, function() {							
						self.__image += self.__animation_step;
						if (self.__image < 0)	self.__image = sprite_get_number(self.__sprite) + self.__image;
						else if (self.__image > sprite_get_number(self.__sprite))	self.__image = self.__image % sprite_get_number(self.__sprite);							
						self.__num_frames++;
						if (self.__num_frames == self.__animation_length) {
							self.__image = self.__starting_frame;
							self.__num_frames = 0;
						}
					}, [], -1);						
					if (_start)	time_source_start(self.__time_source);
				}
				return self;
			}
				
			/// @method				getAnimationLength()
			/// @description		Gets the number of frames to consider in the animation
			///	@return				{Real}	the number of frames to consider
			self.getAnimationLength = function()				{ return self.__animation_length; }
			
			/// @method				setAnimationLength(_length)
			/// @description		Sets the number of frames to consider in the animation
			/// @param				{Real}	_length	the number of frames to consider
			/// @return				{UISprite}	self
			self.setAnimationLength = function(_length)			{ self.__animation_length = _length; return self; }
			
			/// @method				getAnimationStartingFrame()
			/// @description		Gets the starting frame for the animation
			///	@return				{Real}	the starting frame
			self.getAnimationStartingFrame = function()				{ return self.__starting_frame; }
			
			/// @method				setAnimationStartingFrame(_frame)
			/// @description		Sets the starting frame for the animation
			/// @param				{Real}	_frame	the starting frame
			/// @return				{UISprite}	self
			self.setAnimationStartingFrame = function(_frame)			{ self.__starting_frame = _frame; return self; }
				
		#endregion
		#region Methods
				
			/// @method				animationStart()
			/// @description		Starts the animation of the sprite				
			/// @return				{UISprite}	self
			self.animationStart = function() {
				if (time_source_exists(self.__time_source) && time_source_get_state(self.__time_source) != time_source_state_active) time_source_start(self.__time_source);					
				return self;
			}
				
			/// @method				animationPause()
			/// @description		Pauses the animation of the sprite				
			/// @return				{UISprite}	self
			self.animationPause = function() {
				if (time_source_exists(self.__time_source) && time_source_get_state(self.__time_source) == time_source_state_active) time_source_pause(self.__time_source);					
				return self;
			}
				
			/// @method				animationRestart()
			/// @description		Restarts the animation of the sprite				
			/// @return				{UISprite}	self
			self.animationRestart = function() {
				self.__num_frames = 0;
				self.__image = self.__starting_frame;
				self.setAnimationSpeed(self.__animation_speed);
				return self;
			}
				
			self.__draw = function() {
				if (self.__dimensions.width == 0) {
					self.setDimensions(,, sprite_exists(self.__sprite) ? sprite_get_width(self.__sprite) : 0);
				}
				if (self.__dimensions.height == 0) {
					self.setDimensions(,,, sprite_exists(self.__sprite) ? sprite_get_height(self.__sprite) : 0);
				}
				var _x = self.__dimensions.x;
				var _y = self.__dimensions.y;
				var _width = self.__dimensions.width * global.__gooey_manager_active.getScale();
				var _height = self.__dimensions.height * global.__gooey_manager_active.getScale();
				if (sprite_exists(self.__sprite)) draw_sprite_stretched_ext(self.__sprite, self.__image, _x, _y, _width, _height, self.__image_blend, self.__image_alpha);				
			}
			
			self.__parent_destroy = method(self, destroy);
			self.destroy = function() {
				if (time_source_exists(self.__time_source))	time_source_destroy(self.__time_source);
				self.__parent_destroy();
			}
		#endregion
			
		// Start animation
		self.setAnimationSpeed(self.__animation_speed);
			
		self.__register();
		return self;
	}
	
#endregion
	