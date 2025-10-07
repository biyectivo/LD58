/// @feather ignore all
#region UIGroup
	
	/// @constructor	UIGroup(_id, _x, _y, _width, _height, _sprite, [_relative_to=UI_DEFAULT_ANCHOR_POINT])
	/// @extends		UIWidget
	/// @description	A Group widget, packs several widgets on a single, related group
	/// @param			{String}			_id				The Group's name, a unique string ID. If the specified name is taken, the Group will be renamed and a message will be displayed on the output log.
	/// @param			{Real}				_x				The x position of the Group, **relative to its parent**, according to the _relative_to parameter
	/// @param			{Real}				_y				The y position of the Group, **relative to its parent**, according to the _relative_to parameter	
	/// @param			{Real}				_width			The width of the Group
	/// @param			{Real}				_height			The height of the Group
	/// @param			{Asset.GMSprite}	_sprite			The sprite ID to use for rendering the Group
	/// @param			{Enum}				[_relative_to]	The position relative to which the Group will be drawn. By default, uses UI_DEFAULT_ANCHOR_POINT macro in the config (top left if not changed) <br>
	///														See the [UIWidget](#UIWidget) documentation for more info and valid values.
	/// @return			{UIGroup}							self
	function UIGroup(_id, _x, _y, _width, _height, _sprite, _relative_to=UI_DEFAULT_ANCHOR_POINT) : __UIWidget(_id, _x, _y, _width, _height, _sprite, _relative_to) constructor {
		#region Private variables
			self.__type = UI_TYPE.GROUP;
			self.__debug_draw = false;
		#endregion
		#region Setters/Getters
			
		#endregion
		#region Methods
			self.__draw = function() {
				var _x = self.__dimensions.x;
				var _y = self.__dimensions.y;
				var _width = self.__dimensions.width * global.__gooey_manager_active.getScale();
				var _height = self.__dimensions.height * global.__gooey_manager_active.getScale();
				if (sprite_exists(self.__sprite)) draw_sprite_stretched_ext(self.__sprite, self.__image, _x, _y, _width, _height, self.__image_blend, self.__image_alpha);				
				if (self.__debug_draw) draw_rectangle_color(_x, _y, _x+_width, _y+_height, c_gray, c_gray, c_gray, c_gray, true);
			}
			/*self.__generalBuiltInBehaviors = method(self, __builtInBehavior);
			self.__builtInBehavior = function() {
				if (self.__events_fired[UI_EVENT.LEFT_CLICK]) 	self.__callbacks[UI_EVENT.LEFT_CLICK]();				
			}*/
		#endregion
		
		self.__register();
		return self;
	}
	
#endregion
	