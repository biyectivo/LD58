/// @feather ignore all
#region UICanvas
	
	/// @constructor	UICanvas(_id, _x, _y, _width, _height, _surface, [_relative_to=UI_DEFAULT_ANCHOR_POINT])
	/// @extends		UIWidget
	/// @description	A Canvas widget, which lets you draw a custom drawn surface on a Panel. The surface will be streched to the values of `width` and `height`.<br>
	///					*WARNING: destroying the Canvas widget will NOT free the surface, you need to do that yourself to avoid a memory leak*<br>
	///					*WARNING: the widget itself does not handle recreating the surface if it's automatically destroyed by the target platform. You need to do that yourself.
	/// @param			{String}			_id				The Canvas's name, a unique string ID. If the specified name is taken, the Canvas will be renamed and a message will be displayed on the output log.
	/// @param			{Real}				_x				The x position of the Canvas, **relative to its parent**, according to the _relative_to parameter
	/// @param			{Real}				_y				The y position of the Canvas, **relative to its parent**, according to the _relative_to parameter		
	/// @param			{Real}				_width			The width of the Canvas, **relative to its parent**, according to the _relative_to parameter		
	/// @param			{Real}				_height			The height of the Canvas, **relative to its parent**, according to the _relative_to parameter		
	/// @param			{String}			_surface		The surface ID to draw
	/// @param			{Enum}				[_relative_to]	The position relative to which the Canvas will be drawn. By default, uses UI_DEFAULT_ANCHOR_POINT macro in the config (top left if not changed) <br>
	///														See the [UIWidget](#UIWidget) documentation for more info and valid values.
	/// @return			{UICanvas}							self
	function UICanvas(_id, _x, _y, _width, _height, _surface, _relative_to=UI_DEFAULT_ANCHOR_POINT) : __UIWidget(_id, _x, _y, _width, _height, -1, _relative_to) constructor {
		#region Private variables
			self.__type = UI_TYPE.CANVAS;
			self.__surface_id = _surface;				
		#endregion
		#region Setters/Getters
				
			/// @method				getSurface()
			/// @description		Gets the id of the surface bound to the Canvas
			///	@return				{Asset.GMSurface}	the surface id
			self.getSurface = function()				{ return self.__surface_id; }
			
			/// @method				setSurface(_surface)
			/// @description		Sets the surface bound to the Canvas
			/// @param				{Asset.GMSurface}	_surface	The surface id
			/// @return				{UICanvas}	self
			self.setSurface = function(_surface)			{ self.__surface_id = _surface; return self; }
			
		#endregion
		#region Methods
			self.__draw = function() {
				if (surface_exists(self.__surface_id)) {						
					draw_surface_stretched_ext(self.__surface_id, self.__dimensions.x, self.__dimensions.y, self.__dimensions.width * global.__gooey_manager_active.getScale(), self.__dimensions.height * global.__gooey_manager_active.getScale(), self.__image_blend, self.__image_alpha);
				}
				else {
					global.__gooey_manager_active.__logMessage("Surface bound to Canvas widget '"+self.__ID+"' does not exist.", UI_MESSAGE_LEVEL.WARNING);
				}
			}
			self.__generalBuiltInBehaviors = method(self, __builtInBehavior);
			self.__builtInBehavior = function() {
				var _arr = array_create(GOOEY_NUM_CALLBACKS, true);
				self.__generalBuiltInBehaviors(_arr);
			}
		#endregion
		
		self.__register();
		return self;
	}
	
#endregion
