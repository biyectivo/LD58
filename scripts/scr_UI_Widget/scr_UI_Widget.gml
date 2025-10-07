/// @feather ignore all
#region Parent Structs
	function None() {}
	
	#region	__UIDimensions
		/// @struct					__UIDimensions(_offset_x, _offset_y, _width, _height,  _id, _relative_to=UI_DEFAULT_ANCHOR_POINT, _parent=noone, _inherit_width=false, _inherit_height=false)
		/// @description			Private struct that represents the position and size of a particular Widget<br>
		///							Apart from the specified offset_x and offset_y, the resulting struct will also have:<br>
		///							`x`			x coordinate of the `TOP_LEFT` corner of the widget, relative to `SCREEN` (**absolute** coordinates). These will be used to draw the widget on screen and perform the event handling checks.<br>
		///							`y`			y coordinate of the `TOP_LEFT` corner of the widget, relative to `SCREEN` (**absolute** coordinates). These will be used to draw the widget on screen and perform the event handling checks.<br>
		///							`x_parent`	x coordinate of the `TOP_LEFT` corner of the widget, relative to `PARENT` (**relative** coordinates). These will be used to draw the widget inside other widgets which have the `clipContents` property enabled (e.g. scrollable panels or other scrollable areas).<br>
		///							`y_parent`	y coordinate of the `TOP_LEFT` corner of the widget, relative to `PARENT` (**relative** coordinates). These will be used to draw the widget inside other widgets which have the `clipContents` property enabled (e.g. scrollable panels or other scrollable areas).
		///	@param					{Real}		_offset_x			Amount of horizontal pixels to move, starting from the `_relative_to` corner, to set the x position. Can be negative as well.
		///															This is NOT the x position of the top left corner (except if `_relative_to` is `TOP_LEFT`), but rather the x position of the corresponding corner.
		///	@param					{Real}		_offset_y			Amount of vertical pixels to move, starting from the `_relative_to` corner, to set the y position. Can be negative as well.
		///															This is NOT the y position of the top corner (except if `_relative_to` is `TOP_LEFT`), but rather the y position of the corresponding corner.
		///	@param					{Real}		_width				Width of widget
		///	@param					{Real}		_height				Height of widget
		///	@param					{UIWidget}	_id					ID of the corresponing widget
		///	@param					{Enum}		[_relative_to]		Relative to, according to `UI_RELATIVE_TO` enum
		///	@param					{UIWidget}	[_parent]			Reference to the parent, or noone		
		///	@param					{UIWidget}	[_inherit_width]	Whether the widget inherits its width from its parent
		///	@param					{UIWidget}	[_inherit_height]	Whether the widget inherits its height from its parent
		function __UIDimensions(_offset_x, _offset_y, _width, _height, _id, _relative_to=UI_DEFAULT_ANCHOR_POINT, _parent=noone, _inherit_width=false, _inherit_height=false) constructor {
			self.widget_id = _id;
			self.relative_to = _relative_to;
			self.offset_x = _offset_x;
			self.offset_y = _offset_y;
			self.width = _width;
			self.height = _height;
			self.inherit_width = _inherit_width;
			self.inherit_height = _inherit_height;
			self.parent = noone;
		
			// These values are ALWAYS the coordinates of the top-left corner, irrespective of the relative_to value
			self.x = 0;
			self.y = 0;
			self.relative_x = 0;
			self.relative_y = 0;
		
			/// @method			calculateCoordinates()
			/// @description	computes the relative and absolute coordinates, according to the set parent		
			self.calculateCoordinates = function() {
				// Get parent x,y SCREEN TOP-LEFT coordinates and width,height (if no parent, use GUI size)
				var _parent_x = 0;
				var _parent_y = 0;
				var _parent_w = display_get_gui_width();
				var _parent_h = display_get_gui_height();
				if (self.parent != noone) {
					_parent_x = self.parent.__dimensions.x;
					_parent_y = self.parent.__dimensions.y;
					_parent_w = self.parent.__dimensions.width;
					_parent_h = self.parent.__dimensions.height;
				}
				// Inherit width/height
				if (self.inherit_width)		self.width = _parent_w;
				if (self.inherit_height)	self.height = _parent_h;
				// Calculate the starting point
				var _starting_point_x = _parent_x;
				var _starting_point_y = _parent_y;
				if (self.relative_to == UI_RELATIVE_TO.TOP_CENTER || self.relative_to == UI_RELATIVE_TO.MIDDLE_CENTER || self.relative_to == UI_RELATIVE_TO.BOTTOM_CENTER) {
					_starting_point_x += _parent_w/2;
				}
				else if (self.relative_to == UI_RELATIVE_TO.TOP_RIGHT || self.relative_to == UI_RELATIVE_TO.MIDDLE_RIGHT || self.relative_to == UI_RELATIVE_TO.BOTTOM_RIGHT) {
					_starting_point_x += _parent_w;
				}
				if (self.relative_to == UI_RELATIVE_TO.MIDDLE_LEFT || self.relative_to == UI_RELATIVE_TO.MIDDLE_CENTER || self.relative_to == UI_RELATIVE_TO.MIDDLE_RIGHT) {
					_starting_point_y += _parent_h/2;
				}
				else if (self.relative_to == UI_RELATIVE_TO.BOTTOM_LEFT || self.relative_to == UI_RELATIVE_TO.BOTTOM_CENTER || self.relative_to == UI_RELATIVE_TO.BOTTOM_RIGHT) {
					_starting_point_y += _parent_h;
				}
				// Calculate anchor point
				var _anchor_point_x = _starting_point_x + self.offset_x;
				var _anchor_point_y = _starting_point_y + self.offset_y;
				// Calculate widget TOP_LEFT SCREEN x,y coordinates (absolute)
				self.x = _anchor_point_x;
				self.y = _anchor_point_y;
				if (self.relative_to == UI_RELATIVE_TO.TOP_CENTER || self.relative_to == UI_RELATIVE_TO.MIDDLE_CENTER || self.relative_to == UI_RELATIVE_TO.BOTTOM_CENTER) {
					self.x -= self.width/2;
				}
				else if (self.relative_to == UI_RELATIVE_TO.TOP_RIGHT || self.relative_to == UI_RELATIVE_TO.MIDDLE_RIGHT || self.relative_to == UI_RELATIVE_TO.BOTTOM_RIGHT) {
					self.x -= self.width;
				}
				if (self.relative_to == UI_RELATIVE_TO.MIDDLE_LEFT || self.relative_to == UI_RELATIVE_TO.MIDDLE_CENTER || self.relative_to == UI_RELATIVE_TO.MIDDLE_RIGHT) {
					self.y -= self.height/2;
				}
				else if (self.relative_to == UI_RELATIVE_TO.BOTTOM_LEFT || self.relative_to == UI_RELATIVE_TO.BOTTOM_CENTER || self.relative_to == UI_RELATIVE_TO.BOTTOM_RIGHT) {
					self.y -= self.height;
				}
				// Calculate widget RELATIVE x,y coordinates (relative to parent)
				self.relative_x = self.x - _parent_x;
				self.relative_y = self.y - _parent_y;			
			}
		
		
			/// @method					setParent(_parent)
			/// @description			sets the parent of the UIDimensions struct, so coordinates can be calculated taking that parent into account.<br>
			///							Coordinates are automatically updated when set - i.e. [`calculateCoordinates()`](#__UIDimensions.calculateCoordinates) is automatically called.
			/// @param					{UIWidget}	_parent		the reference to the UIWidget		
			self.setParent = function(_parent) {
				self.parent = _parent;
				// Update screen and relative coordinates with new parent
				self.calculateCoordinates();
			}
		
			/// @method					set(_offset_x = undefined, _offset_y = undefined, _width = undefined, _height = undefined, _relative_to=undefined)
			/// @description			sets the values for the struct, with optional parameters
			///	@param					{Real}		[_offset_x]		Amount of horizontal pixels to move, starting from the `_relative_to` corner, to set the x position. Can be negative as well.
			///														This is NOT the x position of the top left corner (except if `_relative_to` is `TOP_LEFT`), but rather the x position of the corresponding corner.
			///	@param					{Real}		[_offset_y]		Amount of vertical pixels to move, starting from the `_relative_to` corner, to set the y position. Can be negative as well.
			///														This is NOT the y position of the top corner (except if `_relative_to` is `TOP_LEFT`), but rather the y position of the corresponding corner.
			///	@param					{Real}		[_width]		Width of widget
			///	@param					{Real}		[_height]		Height of widget				
			///	@param					{Enum}		[_parent]		Sets the anchor relative to which coordinates are calculated.
			self.set = function(_offset_x = undefined, _offset_y = undefined, _width = undefined, _height = undefined, _relative_to = undefined) {
				self.offset_x = _offset_x ?? self.offset_x;
				self.offset_y = _offset_y ?? self.offset_y;
				self.relative_to = _relative_to ?? self.relative_to;
				self.width = _width ?? self.width;
				self.height = _height ?? self.height;
				// Update screen and relative coordinates with new parent
				self.calculateCoordinates();
			}
			
			self.setScrollOffsetH = function(_signed_amount) {
				self.offset_x = self.offset_x + _signed_amount;
				// Update screen and relative coordinates with scroll
				self.calculateCoordinates();
			}
			self.setScrollOffsetV = function(_signed_amount) {
				self.offset_y = self.offset_y + _signed_amount;
				// Update screen and relative coordinates with scroll
				self.calculateCoordinates();
			}
			
			self.toString = function() {
				var _rel;
				switch (self.relative_to) {
					case UI_RELATIVE_TO.TOP_LEFT:		_rel = "top left";			break;
					case UI_RELATIVE_TO.TOP_CENTER:		_rel = "top center";		break;
					case UI_RELATIVE_TO.TOP_RIGHT:		_rel = "top right";			break;
					case UI_RELATIVE_TO.MIDDLE_LEFT:	_rel = "middle left";		break;
					case UI_RELATIVE_TO.MIDDLE_CENTER:	_rel = "middle center";		break;
					case UI_RELATIVE_TO.MIDDLE_RIGHT:	_rel = "middle right";		break;
					case UI_RELATIVE_TO.BOTTOM_LEFT:	_rel = "bottom left";		break;
					case UI_RELATIVE_TO.BOTTOM_CENTER:	_rel = "bottom center";		break;
					case UI_RELATIVE_TO.BOTTOM_RIGHT:	_rel = "bottom right";		break;
					default:							_rel = "UNKNOWN";			break;
				}
				return self.widget_id.__ID + ": (x,y)=("+string(self.x)+", "+string(self.y)+") relative to "+_rel+"  width="+string(self.width)+" height="+string(self.height)+" x2="+string(self.x+self.width)+" y2="+string(self.y+self.height)+
				" offset provided: "+string(self.offset_x)+","+string(self.offset_y)+
				"\nparent: "+(self.parent != noone ? self.parent.__ID + " ("+(string(self.parent.__dimensions.x)+", "+string(self.parent.__dimensions.y)+")   width="+string(self.parent.__dimensions.width)+" height="+string(self.parent.__dimensions.height))+" x2="+string(self.parent.__dimensions.x+self.parent.__dimensions.width)+" y2="+string(self.parent.__dimensions.y+self.parent.__dimensions.height) : "no parent");
			}
			
			// Set parent (and calculate screen/relative coordinates) on creation
			self.setParent(_parent);
		}	
	
	#endregion
	
	#region __UIWidget
	
		/// @constructor	UIWidget(_id, _offset_x, _offset_y, _width, _height, _sprite, _relative_to=UI_DEFAULT_ANCHOR_POINT)
		/// @description	The base class for all ofhter widgets. Should be treated as an
		///					uninstantiable class / template.
		/// @param	{String}				_id					The widget's string ID by which it will be referred as.
		/// @param	{Real}					_offset_x			The x offset position relative to its parent, according to the _relative_to parameter
		/// @param	{Real}					_offset_y			The y offset position relative to its parent, according to the _relative_to parameter
		/// @param	{Real}					_width				The width of the widget
		/// @param	{Real}					_height				The height of the widget
		/// @param	{Asset.GMSprite}		_sprite				The sprite asset to use for rendering
		/// @param	{Enum}					[_relative_to]		Anchor position from which to calculate offset, from the UI_RELATIVE enum (default: TOP_LEFT)
		/// @return	{UIWidget}				self
		function __UIWidget(_id, _offset_x, _offset_y, _width, _height, _sprite, _relative_to=UI_DEFAULT_ANCHOR_POINT) constructor {
			// Check if UI object exists, if not create it
			__auto_create_ui_object();
			
			#region Private variables
				self.__ID = _id;
				self.__type = -1;
				self.__dimensions = new __UIDimensions(_offset_x, _offset_y, _width, _height, self, _relative_to, noone, false, false);
				self.__sprite = _sprite;
				self.__image = 0;
				self.__image_alpha = 1;
				self.__image_blend = c_white;				
				self.__events_fired_last = array_create(GOOEY_NUM_CALLBACKS, false);
				self.__events_fired = array_create(GOOEY_NUM_CALLBACKS, false);
				self.__callbacks = array_create(GOOEY_NUM_CALLBACKS, None);
				self.__parent = noone;
				self.__children = [];
				//self.__builtInBehavior = None;			
				self.__visible = true;
				self.__enabled = true;
				self.__draggable = false;
				self.__resizable = false;
				self.__resize_border_width = 0;
				self.__drag_bar_height = self.__dimensions.height;
				self.__clips_content = false;
				self.__surface_id = noone;
				self.__min_width = 1;
				self.__min_height = 1;
				self.__user_data = {};
				self.__binding = undefined;
				self.__cumulative_horizontal_scroll_offset = [0];
				self.__cumulative_vertical_scroll_offset = [0];
				self.__pre_render_callback = None;
				self.__post_render_callback = None;
				
				self.__on_destroy_callback = None;
				
				#region Individual drill-through capability for events
					self.__drill_through_left_click = UI_DRILL_THROUGH_LEFT_CLICK;	
					self.__drill_through_left_hold=  UI_DRILL_THROUGH_LEFT_HOLD;
					self.__drill_through_left_release = UI_DRILL_THROUGH_LEFT_RELEASE;
					self.__drill_through_middle_click = UI_DRILL_THROUGH_MIDDLE_CLICK;	
					self.__drill_through_middle_hold = UI_DRILL_THROUGH_MIDDLE_HOLD;
					self.__drill_through_middle_release = UI_DRILL_THROUGH_MIDDLE_RELEASE;
					self.__drill_through_right_click = UI_DRILL_THROUGH_RIGHT_CLICK;
					self.__drill_through_right_hold = UI_DRILL_THROUGH_RIGHT_HOLD;
					self.__drill_through_right_release = UI_DRILL_THROUGH_RIGHT_RELEASE;
					self.__drill_through_mouse_enter = UI_DRILL_THROUGH_MOUSE_ENTER;
					self.__drill_through_mouse_exit = UI_DRILL_THROUGH_MOUSE_EXIT;
					self.__drill_through_mouse_over = UI_DRILL_THROUGH_MOUSE_OVER;
					self.__drill_through_mouse_wheel_up = UI_DRILL_THROUGH_MOUSE_WHEEL_UP;
					self.__drill_through_mouse_wheel_down = UI_DRILL_THROUGH_MOUSE_WHEEL_DOWN;
				#endregion
			#endregion
			#region Setters/Getters
				/// @method				getID()
				/// @description		Getter for the widget's string ID
				/// @returns			{string} The widget's string ID
				self.getID = function()					{ return self.__ID; }
			
				/// @method				getType()
				/// @description		Getter for the widget's type
				/// @returns			{Enum}	The widget's type, according to the UI_TYPE enum			
				self.getType = function()					{ return self.__type; }
			
				/// @method				getDimensions()
				/// @description		Gets the UIDimensions object for this widget
				/// @returns			{UIDimensions}	The dimensions object. See [`UIDimensions`](#__UIDimensions).
				self.getDimensions = function()			{ return self.__dimensions; }
			
				/// @method						setDimensions()
				/// @description				Sets the UIDimensions object for this widget, with optional parameters.
				/// @param	{Real}				[_offset_x]			The x offset position relative to its parent, according to the _relative_to parameter
				/// @param	{Real}				[_offset_y]			The y offset position relative to its parent, according to the _relative_to parameter
				/// @param	{Real}				[_width]			The width of the widget
				/// @param	{Real}				[_height]			The height of the widget			
				/// @param	{Enum}				[_relative_to]		Anchor position from which to calculate offset, from the UI_RELATIVE enum (default: TOP_LEFT)
				/// @param	{UIWidget}			[_parent]			Parent Widget reference
				/// @return						{UIWidget}	self
				self.setDimensions = function(_offset_x = undefined, _offset_y = undefined, _width = undefined, _height = undefined, _relative_to = undefined, _parent = undefined)	{
					self.__dimensions.set(_offset_x, _offset_y, _width, _height, _relative_to, _parent);					
					self.__updateChildrenPositions();
					return self;
				}
				
				/// @method				getInheritWidth()
				/// @description		Gets whether the widget inherits its width from its parent.
				/// @returns			{Bool}	Whether the widget inherits its width from its parent
				self.getInheritWidth = function()						{ return self.__dimensions.inherit_width; }
				
				/// @method				setInheritWidth(_inherit_width)
				/// @description		Sets whether the widget inherits its width from its parent.
				/// @param				{Bool}	_inherit_width	Whether the widget inherits its width from its parent
				/// @return				{UIWidget}	self
				self.setInheritWidth = function(_inherit_width) { 
					self.__dimensions.inherit_width = _inherit_width; 
					self.__dimensions.calculateCoordinates();
					self.__updateChildrenPositions();
					return self;
				}
				
				/// @method				getInheritHeight()
				/// @description		Gets whether the widget inherits its height from its parent.
				/// @returns			{Bool}	Whether the widget inherits its height from its parent
				self.getInheritHeight = function()					{ return self.__dimensions.inherit_height; }
				
				/// @method				setInheritHeight(_inherit_height)
				/// @description		Sets whether the widget inherits its height from its parent.
				/// @param				{Bool}	_inherit_height Whether the widget inherits its height from its parent
				/// @return				{UIWidget}	self
				self.setInheritHeight = function(_inherit_height)	{ 
					self.__dimensions.inherit_height = _inherit_height;
					self.__dimensions.calculateCoordinates();
					self.__updateChildrenPositions();
					return self;
				}
				
				/// @method				getSprite(_sprite)
				/// @description		Get the sprite ID to be rendered
				/// @return				{Asset.GMSprite}	The sprite ID
				self.getSprite = function()				{ return self.__sprite; }
			
				/// @method				setSprite(_sprite)
				/// @description		Sets the sprite to be rendered
				/// @param				{Asset.GMSprite}	_sprite		The sprite ID
				/// @return				{UIWidget}	self
				self.setSprite = function(_sprite)		{ self.__sprite = _sprite; return self; }
			
				/// @method				getImage()
				/// @description		Gets the image index of the Widget
				/// @return				{Real}	The image index of the Widget
				self.getImage = function()				{ return self.__image_; }
			
				/// @method				setImage(_image)
				/// @description		Sets the image index of the Widget
				/// @param				{Real}	_image	The image index
				/// @return				{UIWidget}	self
				self.setImage = function(_image)			{ self.__image = _image; return self; }
				
				/// @method				getImageBlend()
				/// @description		Gets the image blend of the Widget's sprite
				/// @return				{Constant.Color}	The image blend
				self.getImageBlend = function()			{ return self.__image_blend; }
			
				/// @method				setImageBlend(_color)
				/// @description		Sets the image blend of the Widget
				/// @param				{Constant.Color}	_color	The image blend
				/// @return				{UIWidget}	self
				self.setImageBlend = function(_color)		{ self.__image_blend = _color; return self; }
				
				/// @method				getImageAlpha()
				/// @description		Gets the image alpha of the Widget's sprite
				/// @return				{Real}	The image alpha
				self.getImageAlpha = function()			{ return self.__image_alpha; }
			
				/// @method				setImageAlpha(_color)
				/// @description		Sets the image alpha of the Widget
				/// @param				{Real}	_alpha	The image alpha
				/// @return				{UIWidget}	self
				self.setImageAlpha = function(_alpha)		{ self.__image_alpha = _alpha; return self; }
				
				/// @method				getCallback(_callback_type)
				/// @description		Gets the callback function for a specific callback type, according to the `UI_EVENT` enum
				/// @param				{Enum}	_callback_type	The callback type
				/// @return				{Function}	the callback function
				self.getCallback = function(_callback_type)				{ return self.__callbacks[_callback_type]; }
			
				/// @method				setCallback(_callback_type, _callback)
				/// @description		Sets a callback function for a specific event
				/// @param				{Enum}	_callback_type	The callback type, according to `UI_EVENT` enum
				/// @param				{Function}	_callback	The callback function to assign
				/// @return				{UIWidget}	self
				self.setCallback = function(_callback_type, _callback)	{ 
					if (is_callable(_callback)) {
						self.__callbacks[_callback_type] = is_method(_callback) ? _callback : method(undefined, _callback);
					}
					return self;
				}
			
				/// @method				getParent()
				/// @description		Gets the parent reference of the Widget (also a Widget)			
				/// @return				{UIWidget}	the parent reference
				self.getParent = function()				{ return self.__parent; }
			
				/// @method				getContainingPanel()
				/// @description		Gets the reference of the Panel containing this Widget. If this Widget is a Panel, it will return itself.
				/// @return				{UIPanel}	the parent reference
				self.getContainingPanel = function() {
					if (self.__type == UI_TYPE.PANEL)	return self;
					else if (self.__parent.__type == UI_TYPE.PANEL)	return self.__parent;
					else return self.__parent.getContainingPanel();
				}
				
				/// @method				getContainingTab()
				/// @description		Gets the index number of the tab of the Panel containing this Widget. <br>
				///						If this Widget is a common widget, it will return -1.<br>
				///						If this Widget is a Panel, it will return undefined;
				/// @return				{Real}	the tab number
				self.getContainingTab = function() {					
					if (self.__type == UI_TYPE.PANEL)	return undefined;
					else {
						var _parent_widget = self.__parent;
						var _target_widget = self;
						while (_parent_widget.__type != UI_TYPE.PANEL) {
							_parent_widget = _parent_widget.__parent;
							_target_widget = _target_widget.__parent;
						}
						var _i=0, _n=array_length(_parent_widget.__tabs); 
						var _found = false;
						while (_i<_n && !_found) {
							var _j=0, _m=array_length(_parent_widget.__tabs[_i]);
							while (_j<_m && !_found) {
								_found = (_parent_widget.__tabs[_i][_j] == _target_widget);
								if (!_found) _j++;
							}
							if (!_found) _i++; 
						}
						if (!_found) { // Must be common controls, return -1 - but calculate it anyway
							var _k=0; 
							var _o=array_length(_parent_widget.__common_widgets);
							var _found_common = false;
							while (_k<_o && !_found_common) {
								_found_common = (_parent_widget.__common_widgets[_k] == _target_widget);
								if (!_found_common) _k++;
							}
							if (_found_common)	return -1;
							else throw("ERROR: Something REALLY weird happened, the specified control isn't anywhere. Run far, far away");
						}
						else {
							return _i;
						}
					}
				}
			
				/// @method				setParent(_parent_id)
				/// @description		Sets the parent of the Widget. Also calls the `setParent()` method of the corresponding `UIDimensions` struct to recalculate coordinates.
				/// @param				{UIWidget}	_parent_id	The reference to the parent Widget
				/// @return				{UIWidget}	self
				self.setParent = function(_parent_id)		{ 
					self.__parent = _parent_id;
					self.__dimensions.setParent(_parent_id);
					return self;
				}
			
				/// @method				getChildren([_tab=<current tab>])
				/// @description		Gets the array containing all children of this Widget
				/// @param				{Real}	[_tab]				Tab to get the controls from. <br>
				///													If _tab is a nonnegative number, it will get the children from the specified tab.<br>
				///													If _tab is -1, it will return the common widgets instead.<br>
				///													If _tab is omitted, it will default to the current tab (or ignored, in case of non-tabbed widgets).
				/// @return				{Array<UIWidget>}	the array of children Widget references
				self.getChildren = function(_tab=self.__type == UI_TYPE.PANEL ? self.__current_tab : 0) {
					if (self.__type == UI_TYPE.PANEL && _tab != -1)			return self.__tabs[_tab];
					else if (self.__type == UI_TYPE.PANEL && _tab == -1)	return self.__common_widgets;
					else													return self.__children;
				}
			
				/// @method				setChildren(_children, [_tab=<current tab>])
				/// @description		Sets the children Widgets to a new array of Widget references
				/// @param				{Array<UIWidget>}	_children	The array containing the references of the children Widgets
				/// @param				{Real}				[_tab]		Tab to set the controls for. <br>
				///														If _tab is a nonnegative number, it will set the children of the specified tab.<br>
				///														If _tab is -1, it will set the common widgets instead.<br>
				///														If _tab is omitted, it will default to the current tab (or ignored, in case of non-tabbed widgets).				
				/// @return				{UIWidget}	self
				self.setChildren = function(_children, _tab = self.__type == UI_TYPE.PANEL ? self.__current_tab : 0) {
					if (self.__type == UI_TYPE.PANEL && _tab != -1)			self.__tabs[_tab] = _children;
					else if (self.__type == UI_TYPE.PANEL && _tab == -1)	self.__common_widgets = _children;
					else													self.__children = _children; 
					return self;
				}
			
				/// @method				getVisible()
				/// @description		Gets the visible state of a Widget
				/// @return				{Bool}	whether the Widget is visible or not
				self.getVisible = function()				{ return self.__visible; }
			
				/// @method				setVisible(_visible)
				/// @description		Sets the visible state of a Widget
				/// @param				{Bool}	_visible	Whether to set visibility to true or false			
				/// @return				{UIWidget}	self
				self.setVisible = function(_visible)		{
					self.__visible = _visible; 
					for (var _i=0, _n=array_length(self.__children); _i<_n; _i++) {
						self.__children[_i].setVisible(_visible);
					}
					return self;
				}
			
				/// @method				getEnabled()
				/// @description		Gets the enabled state of a Widget
				/// @return				{Bool}	whether the Widget is enabled or not
				self.getEnabled = function()				{ return self.__enabled; }
			
				/// @method				setEnabled(_enabled)
				/// @description		Sets the enabled state of a Widget
				/// @param				{Bool}	_enabled	Whether to set enabled to true or false			
				/// @return				{UIWidget}	self			
				self.setEnabled = function(_enabled)		{
					self.__enabled = _enabled;
					for (var _i=0, _n=array_length(self.__children); _i<_n; _i++) {
						self.__children[_i].setEnabled(_enabled);
					}
					return self;
				}
			
				/// @method				getDraggable()
				/// @description		Gets the draggable state of a Widget
				/// @return				{Bool}	whether the Widget is draggable or not
				self.getDraggable = function()			{ return self.__draggable; }
			
				/// @method				setDraggable(_draggable)
				/// @description		Sets the draggable state of a Widget
				/// @param				{Bool}	_draggable	Whether to set draggable to true or false			
				/// @return				{UIWidget}	self
				self.setDraggable = function(_draggable)	{ self.__draggable = _draggable; return self; }
			
				/// @method				getResizable()
				/// @description		Gets the resizable state of a Widget
				/// @return				{Bool}	whether the Widget is resizable or not
				self.getResizable = function()			{ return self.__resizable; }
			
				/// @method				setResizable(_resizable)
				/// @description		Sets the resizable state of a Widget
				/// @param				{Bool}	_resizable	Whether to set resizable to true or false			
				/// @return				{UIWidget}	self
				self.setResizable = function(_resizable)	{ self.__resizable = _resizable; return self; }
								
				/// @method				getResizeBorderWidth()
				/// @description		Gets the width of the border of a Widget that enables resizing
				/// @return				{Real}	the width of the border in px
				self.getResizeBorderWidth = function()		{ return self.__resize_border_width; }
			
				/// @method				setResizeBorderWidth(_resizable)
				/// @description		Sets the resizable state of a Widget
				/// @param				{Real}	_border_width	The width of the border in px
				/// @return				{UIWidget}	self
				self.setResizeBorderWidth = function(_border_width)		{ self.__resize_border_width = _border_width; return self; }
			
				/// @method				getClipsContent()
				/// @description		Gets the Widget's masking/clipping state
				/// @return				{Bool}	Whether the widget clips its content or not.
				self.getClipsContent = function()			{ return self.__clips_content; }
			
				/// @method				setClipsContent(_clips)
				/// @description		Sets the Widget's masking/clipping state.<br>
				///						Note this method automatically creates/frees the corresponding surfaces.
				/// @param				{Bool}	_clips	Whether the widget clips its content or not.
				/// @return				{UIWidget}	self
				self.setClipsContent = function(_clips) {
					self.__clips_content = _clips;
					if (_clips) {
						if (!surface_exists(self.__surface_id))	self.__surface_id = surface_create(display_get_gui_width(), display_get_gui_height());
					}
					else {
						if (surface_exists(self.__surface_id))	surface_free(self.__surface_id);
						self.__surface_id = noone;
					}
					return self;
				}	
				
				/// @method				getUserData(_name)
				/// @description		Gets the user data element named `_name`.
				/// @param				{String}	_name	the name of the data element
				/// @return				{String}	The user data value for the specified name, or an empty string if it doesn't exist
				self.getUserData = function(_name) {
					if (variable_struct_exists(self.__user_data, _name)) {
						return variable_struct_get(self.__user_data, _name);
					}
					else {
						global.__gooey_manager_active.__logMessage("Cannot find data element with name '"+_name+"' in widget '"+self.__ID+"'", UI_MESSAGE_LEVEL.INFO);
						return undefined;
					}
				}
				
				/// @method				setUserData(_name, _value)
				/// @description		Sets the user data element named `_name`.
				/// @param				{String}	_name	the name of the data element
				/// @param				{Any}		_value	the value to set
				/// @return				{UIWidget}	self
				self.setUserData = function(_name, _value) {
					variable_struct_set(self.__user_data, _name, _value);
					return self;
				}
				
				/// @method				getBinding()
				/// @description		Returns the previously defined object instance or struct variable/method binding.
				/// @return				{Struct}	A struct containing the object or struct ID and the variable or function name that is bound.
				self.getBinding = function() {
					return self.__binding;
				}
				
				/// @method				setBinding(_name, _object_or_struct_ref, _variable_name)
				/// @description		Defines the binding for the defined object or struct reference and the corresponding variable or method name.<br>
				///						The handle of the binding itself is dependent on the specific Widget.
				/// @param				{Struct||Instance.ID}	_object_or_struct_ref		the object or struct reference
				/// @param				{String}				_variable_or_function_name	the name of the variable or method to bind
				/// @return				{UIWidget}	self
				self.setBinding = function(_object_or_struct_ref, _variable_or_method_name) {
					self.__binding = { struct_or_object: _object_or_struct_ref, variable_or_method_name: _variable_or_method_name};
					return self;
				}
				
				/// @method				clearBinding()
				/// @description		Unsets/clears the data binding.
				/// @return				{UIWidget}	self
				self.clearBinding = function() {
					self.__binding = undefined;
					return self;
				}
				
				/// @method				getPreRenderCallback()
				/// @description		Gets the pre-render callback function set.<br>
				///						NOTE: The pre-render event will run regardless of whether the control is visible/enabled.
				/// @return				{Function}	the callback function
				self.getPreRenderCallback = function()				{ return self.__pre_render_callback; }
			
				/// @method				setPreRenderCallback(_function)
				/// @description		Sets a callback function for pre-render.<br>
				///						NOTE: The pre-render event will run regardless of whether the control is visible/enabled.
				/// @param				{Function}	_function	The callback function to assign
				/// @return				{UIWidget}	self
				self.setPreRenderCallback = function(_function)	{ self.__pre_render_callback = _function; return self; }
				
				/// @method				getPostRenderCallback()
				/// @description		Gets the post-render callback function set.<br>
				///						NOTE: The pre-render event will run regardless of whether the control is visible/enabled.
				/// @return				{Function}	the callback function
				self.getPostRenderCallback = function()				{ return self.__post_render_callback; }
			
				/// @method				setPostRenderCallback(_function)
				/// @description		Sets a callback function for post-render.<br>
				///						NOTE: The pre-render event will run regardless of whether the control is visible/enabled.
				/// @param				{Function}	_function	The callback function to assign
				/// @return				{UIWidget}	self
				self.setPostRenderCallback = function(_function)	{ self.__post_render_callback = _function; return self; }
				
				
				/// @method			getDrillThroughLeftClick()
				/// @description	Gets whether this widget allows for drilling through for the left click event (by default, the widget will use the appropriate macro variable in the configuration script)
				/// @return	{Bool}	the value of __drill_through_left_click
				self.getDrillThroughLeftClick = function() {
					return self.__drill_through_left_click;
				}

				/// @method			setDrillThroughLeftClick(___drill_through_left_click)
				/// @description	Sets whether this widget allows for drilling through for the left click event (by default, the widget will use the appropriate macro variable in the configuration script)
				/// @param	{Bool}	___drill_through_left_click	the value to set
				/// @return	{Struct}	self
				self.setDrillThroughLeftClick = function(___drill_through_left_click) {
					self.__drill_through_left_click = ___drill_through_left_click;
					return self;
				}

				/// @method			getDrillThroughLeftHold()
				/// @description	Gets whether this widget allows for drilling through for the left hold event (by default, the widget will use the appropriate macro variable in the configuration script)
				/// @return	{Bool}	the value of __drill_through_left_hold
				self.getDrillThroughLeftHold = function() {
					return self.__drill_through_left_hold;
				}

				/// @method			setDrillThroughLeftHold(___drill_through_left_hold)
				/// @description	Sets whether this widget allows for drilling through for the left hold event (by default, the widget will use the appropriate macro variable in the configuration script)
				/// @param	{Bool}	___drill_through_left_hold	the value to set
				/// @return	{Struct}	self
				self.setDrillThroughLeftHold = function(___drill_through_left_hold) {
					self.__drill_through_left_hold = ___drill_through_left_hold;
					return self;
				}

				/// @method			getDrillThroughLeftRelease()
				/// @description	Gets whether this widget allows for drilling through for the left release event (by default, the widget will use the appropriate macro variable in the configuration script)
				/// @return	{Bool}	the value of __drill_through_left_release
				self.getDrillThroughLeftRelease = function() {
					return self.__drill_through_left_release;
				}

				/// @method			setDrillThroughLeftRelease(___drill_through_left_release)
				/// @description	Sets whether this widget allows for drilling through for the left release event (by default, the widget will use the appropriate macro variable in the configuration script)
				/// @param	{Bool}	___drill_through_left_release	the value to set
				/// @return	{Struct}	self
				self.setDrillThroughLeftRelease = function(___drill_through_left_release) {
					self.__drill_through_left_release = ___drill_through_left_release;
					return self;
				}

				/// @method			getDrillThroughMiddleClick()
				/// @description	Gets whether this widget allows for drilling through for the middle click event (by default, the widget will use the appropriate macro variable in the configuration script)
				/// @return	{Bool}	the value of __drill_through_middle_click
				self.getDrillThroughMiddleClick = function() {
					return self.__drill_through_middle_click;
				}

				/// @method			setDrillThroughMiddleClick(___drill_through_middle_click)
				/// @description	Sets whether this widget allows for drilling through for the middle click event (by default, the widget will use the appropriate macro variable in the configuration script)
				/// @param	{Bool}	___drill_through_middle_click	the value to set
				/// @return	{Struct}	self
				self.setDrillThroughMiddleClick = function(___drill_through_middle_click) {
					self.__drill_through_middle_click = ___drill_through_middle_click;
					return self;
				}

				/// @method			getDrillThroughMiddleHold()
				/// @description	Gets whether this widget allows for drilling through for the middle hold event (by default, the widget will use the appropriate macro variable in the configuration script)
				/// @return	{Bool}	the value of __drill_through_middle_hold
				self.getDrillThroughMiddleHold = function() {
					return self.__drill_through_middle_hold;
				}

				/// @method			setDrillThroughMiddleHold(___drill_through_middle_hold)
				/// @description	Sets whether this widget allows for drilling through for the middle hold event (by default, the widget will use the appropriate macro variable in the configuration script)
				/// @param	{Bool}	___drill_through_middle_hold	the value to set
				/// @return	{Struct}	self
				self.setDrillThroughMiddleHold = function(___drill_through_middle_hold) {
					self.__drill_through_middle_hold = ___drill_through_middle_hold;
					return self;
				}

				/// @method			getDrillThroughMiddleRelease()
				/// @description	Gets whether this widget allows for drilling through for the middle release event (by default, the widget will use the appropriate macro variable in the configuration script)
				/// @return	{Bool}	the value of __drill_through_middle_release
				self.getDrillThroughMiddleRelease = function() {
					return self.__drill_through_middle_release;
				}

				/// @method			setDrillThroughMiddleRelease(___drill_through_middle_release)
				/// @description	Sets whether this widget allows for drilling through for the middle release event (by default, the widget will use the appropriate macro variable in the configuration script)
				/// @param	{Bool}	___drill_through_middle_release	the value to set
				/// @return	{Struct}	self
				self.setDrillThroughMiddleRelease = function(___drill_through_middle_release) {
					self.__drill_through_middle_release = ___drill_through_middle_release;
					return self;
				}

				/// @method			getDrillThroughRightClick()
				/// @description	Gets whether this widget allows for drilling through for the right click event (by default, the widget will use the appropriate macro variable in the configuration script)
				/// @return	{Bool}	the value of __drill_through_right_click
				self.getDrillThroughRightClick = function() {
					return self.__drill_through_right_click;
				}

				/// @method			setDrillThroughRightClick(___drill_through_right_click)
				/// @description	Sets whether this widget allows for drilling through for the right click event (by default, the widget will use the appropriate macro variable in the configuration script)
				/// @param	{Bool}	___drill_through_right_click	the value to set
				/// @return	{Struct}	self
				self.setDrillThroughRightClick = function(___drill_through_right_click) {
					self.__drill_through_right_click = ___drill_through_right_click;
					return self;
				}

				/// @method			getDrillThroughRightHold()
				/// @description	Gets whether this widget allows for drilling through for the right hold event (by default, the widget will use the appropriate macro variable in the configuration script)
				/// @return	{Bool}	the value of __drill_through_right_hold
				self.getDrillThroughRightHold = function() {
					return self.__drill_through_right_hold;
				}

				/// @method			setDrillThroughRightHold(___drill_through_right_hold)
				/// @description	Sets whether this widget allows for drilling through for the right hold event (by default, the widget will use the appropriate macro variable in the configuration script)
				/// @param	{Bool}	___drill_through_right_hold	the value to set
				/// @return	{Struct}	self
				self.setDrillThroughRightHold = function(___drill_through_right_hold) {
					self.__drill_through_right_hold = ___drill_through_right_hold;
					return self;
				}

				/// @method			getDrillThroughRightRelease()
				/// @description	Gets whether this widget allows for drilling through for the right release event (by default, the widget will use the appropriate macro variable in the configuration script)
				/// @return	{Bool}	the value of __drill_through_right_release
				self.getDrillThroughRightRelease = function() {
					return self.__drill_through_right_release;
				}

				/// @method			setDrillThroughRightRelease(___drill_through_right_release)
				/// @description	Sets whether this widget allows for drilling through for the right release event (by default, the widget will use the appropriate macro variable in the configuration script)
				/// @param	{Bool}	___drill_through_right_release	the value to set
				/// @return	{Struct}	self
				self.setDrillThroughRightRelease = function(___drill_through_right_release) {
					self.__drill_through_right_release = ___drill_through_right_release;
					return self;
				}

				/// @method			getDrillThroughMouseEnter()
				/// @description	Gets whether this widget allows for drilling through for the mouse enter event (by default, the widget will use the appropriate macro variable in the configuration script)
				/// @return	{Bool}	the value of __drill_through_mouse_enter
				self.getDrillThroughMouseEnter = function() {
					return self.__drill_through_mouse_enter;
				}

				/// @method			setDrillThroughMouseEnter(___drill_through_mouse_enter)
				/// @description	Sets whether this widget allows for drilling through for the mouse enter event (by default, the widget will use the appropriate macro variable in the configuration script)
				/// @param	{Bool}	___drill_through_mouse_enter	the value to set
				/// @return	{Struct}	self
				self.setDrillThroughMouseEnter = function(___drill_through_mouse_enter) {
					self.__drill_through_mouse_enter = ___drill_through_mouse_enter;
					return self;
				}

				/// @method			getDrillThroughMouseExit()
				/// @description	Gets whether this widget allows for drilling through for the mouse exit event (by default, the widget will use the appropriate macro variable in the configuration script)
				/// @return	{Bool}	the value of __drill_through_mouse_exit
				self.getDrillThroughMouseExit = function() {
					return self.__drill_through_mouse_exit;
				}

				/// @method			setDrillThroughMouseExit(___drill_through_mouse_exit)
				/// @description	Sets whether this widget allows for drilling through for the mouse exit event (by default, the widget will use the appropriate macro variable in the configuration script)
				/// @param	{Bool}	___drill_through_mouse_exit	the value to set
				/// @return	{Struct}	self
				self.setDrillThroughMouseExit = function(___drill_through_mouse_exit) {
					self.__drill_through_mouse_exit = ___drill_through_mouse_exit;
					return self;
				}

				/// @method			getDrillThroughMouseOver()
				/// @description	Gets whether this widget allows for drilling through for the mouse over event (by default, the widget will use the appropriate macro variable in the configuration script)
				/// @return	{Bool}	the value of __drill_through_mouse_over
				self.getDrillThroughMouseOver = function() {
					return self.__drill_through_mouse_over;
				}

				/// @method			setDrillThroughMouseOver(___drill_through_mouse_over)
				/// @description	Sets whether this widget allows for drilling through for the mouse over event (by default, the widget will use the appropriate macro variable in the configuration script)
				/// @param	{Bool}	___drill_through_mouse_over	the value to set
				/// @return	{Struct}	self
				self.setDrillThroughMouseOver = function(___drill_through_mouse_over) {
					self.__drill_through_mouse_over = ___drill_through_mouse_over;
					return self;
				}

				/// @method			getDrillThroughMouseWheelUp()
				/// @description	Gets whether this widget allows for drilling through for the mouse wheel up event (by default, the widget will use the appropriate macro variable in the configuration script)
				/// @return	{Bool}	the value of __drill_through_mouse_wheel_up
				self.getDrillThroughMouseWheelUp = function() {
					return self.__drill_through_mouse_wheel_up;
				}

				/// @method			setDrillThroughMouseWheelUp(___drill_through_mouse_wheel_up)
				/// @description	Sets whether this widget allows for drilling through for the mouse wheel up event (by default, the widget will use the appropriate macro variable in the configuration script)
				/// @param	{Bool}	___drill_through_mouse_wheel_up	the value to set
				/// @return	{Struct}	self
				self.setDrillThroughMouseWheelUp = function(___drill_through_mouse_wheel_up) {
					self.__drill_through_mouse_wheel_up = ___drill_through_mouse_wheel_up;
					return self;
				}

				/// @method			getDrillThroughMouseWheelDown()
				/// @description	Gets whether this widget allows for drilling through for the mouse wheel down event (by default, the widget will use the appropriate macro variable in the configuration script)
				/// @return	{Bool}	the value of __drill_through_mouse_wheel_down
				self.getDrillThroughMouseWheelDown = function() {
					return self.__drill_through_mouse_wheel_down;
				}

				/// @method			setDrillThroughMouseWheelDown(___drill_through_mouse_wheel_down)
				/// @description	Sets whether this widget allows for drilling through for the mouse wheel down event (by default, the widget will use the appropriate macro variable in the configuration script)
				/// @param	{Bool}	___drill_through_mouse_wheel_down	the value to set
				/// @return	{Struct}	self
				self.setDrillThroughMouseWheelDown = function(___drill_through_mouse_wheel_down) {
					self.__drill_through_mouse_wheel_down = ___drill_through_mouse_wheel_down;
					return self;
				}

				/// @method			setMinWidth(_min_width)
				/// @description	Sets a minimum width for the widget. Reset it with _min_width <= 0
				/// @param			{Real}	_min_width	the minimum width in pixels
				/// @return			{Struct}	self
				self.setMinWidth = function(_min_width) {
					if (self.__type == UI_TYPE.PANEL)	self.__min_width = max(1, _min_width); // only implemented for panels
					return self;
				}
				
				/// @method			setMinHeight(_min_height)
				/// @description	Sets a minimum height for the widget. Reset it with _min_height <= 0
				/// @param			{Real}	_min_height	the minimum height in pixels
				/// @return			{Struct}	self
				self.setMinHeight = function(_min_height) {
					if (self.__type == UI_TYPE.PANEL)	self.__min_height = max(1, _min_height); // only implemented for panels
					return self;
				}
				
				/// @method				getOnDestroyCallback()
				/// @description		Gets the on-destroy callback function set.
				/// @return				{Function}	the callback function
				self.getOnDestroyCallback = function()				{ return self.__on_destroy_callback; }
			
				/// @method				setOnDestroyCallback(_function)
				/// @description		Sets a callback function for on-destroy.
				/// @param				{Function}	_function	The callback function to assign
				/// @return				{UIWidget}	self
				self.setOnDestroyCallback = function(_function)	{ self.__on_destroy_callback = _function; return self; }
				
				
				
			#endregion
			#region Methods
			
				#region Private
					
					// Write a value to a bound variable
					self.__updateBoundVariable = function(_value) {
						if (!is_undefined(self.__binding)) {
							var _struct_or_object_name = self.__binding.struct_or_object;
							var _variable = self.__binding.variable_or_method_name;
							if (is_struct(_struct_or_object_name)) {
								if (is_method(variable_struct_get(_struct_or_object_name, _variable)))			throw(string($"ERROR: when trying to update bound variable from struct {_struct_or_object_name} variable {_variable} - variable is a method"));
								variable_struct_set(_struct_or_object_name, _variable, _value);
							}
							else if (variable_instance_exists(_struct_or_object_name, _variable)) {
								if (is_method(variable_instance_get(_struct_or_object_name, _variable)))		throw(string($"ERROR: when trying to update bound variable from instance {_struct_or_object_name} variable {_variable} - variable is a method"));
								variable_instance_set(_struct_or_object_name, _variable, _value);
							}
							else {
								global.__gooey_manager_active.__logMessage("Cannot find object instance or struct ("+string(_struct_or_object_name)+") and/or corresponding variable or method ("+_variable+"), previously bound in widget '"+self.__ID+"', returning undefined", UI_MESSAGE_LEVEL.INFO);
								return undefined;
							}
						}
						else {
							//global.__gooey_manager_active.__logMessage("Binding is undefined in widget '"+self.__ID+"', returning undefined", UI_MESSAGE_LEVEL.WARNING);
							return undefined;
						}
						
					}
					
					// Get the value of the bound variable or function					
					self.__updateBinding = function() {
						if (!is_undefined(self.__binding)) {
							var _struct_or_object_name = self.__binding.struct_or_object;
							var _variable = self.__binding.variable_or_method_name;
							if (is_struct(_struct_or_object_name))			return variable_struct_get(_struct_or_object_name, _variable);
							else if (instance_exists(_struct_or_object_name)) && variable_instance_exists(_struct_or_object_name, _variable) {
								return variable_instance_get(_struct_or_object_name, _variable);
							}
							else {
								global.__gooey_manager_active.__logMessage("Cannot find object instance or struct ("+string(_struct_or_object_name)+") and/or corresponding variable or method ("+_variable+"), previously bound in widget '"+self.__ID+"', returning undefined", UI_MESSAGE_LEVEL.INFO);
								return undefined;
							}
						}
						else {
							//global.__gooey_manager_active.__logMessage("Binding is undefined in widget '"+self.__ID+"', returning undefined", UI_MESSAGE_LEVEL.WARNING);
							return undefined;
						}
						
					}
					
					self.__register = function() {
						//if (variable_global_exists("__gooey_manager_active")) global.__gooey_manager_active.__register(self);
						if (variable_global_exists("__gooey_manager_active")) global.__gooey_manager_active.__register(self);
						else throw("ERROR: UI manager object is not imported. Drag the UI manager object to your first room and make sure it's created before any other objects using UI, with Instance Creation Order.");
					}
			
					self.__updateChildrenPositions = function() {
						
						if (self.__type == UI_TYPE.PANEL) {
							for (var _j=0, _m=array_length(self.__tabs); _j<_m; _j++) {
								for (var _i=0, _n=array_length(self.__tabs[_j]); _i<_n; _i++) {
									self.__tabs[_j][_i].__dimensions.calculateCoordinates();
									self.__tabs[_j][_i].__updateChildrenPositions();
								}
							}
							// Update common widgets as well
							for (var _i=0, _n=array_length(self.__common_widgets); _i<_n; _i++) {
								self.__common_widgets[_i].__dimensions.calculateCoordinates();
								self.__common_widgets[_i].__updateChildrenPositions();
							}	
						}
						else {
							for (var _i=0, _n=array_length(self.__children); _i<_n; _i++) {
								self.__children[_i].__dimensions.calculateCoordinates();								
								self.__children[_i].__updateChildrenPositions();							
							}
							if (self.__type == UI_TYPE.GRID) self.__updateGridDimensions();
						}
					}
			
					self.__render = function() {
						// Pre-render
						
						// Update widget value with bound variable
						if (!is_undefined(self.__binding)) {
							var _value = self.__updateBinding();					
							if (!is_undefined(_value))	{
								if (is_method(_value))	 _value = _value();
								switch(self.__type) {
									case UI_TYPE.BUTTON:
									case UI_TYPE.TEXT:
									case UI_TYPE.TEXTBOX:
										_value = string(_value);
										self.__text = _value;
										break;
									case UI_TYPE.CHECKBOX:
										if (!is_bool(_value))	throw(string($"ERROR: trying to assign non-boolean value from bound variable to checkbox {self.__ID}"));
										self.__value = _value;
										break;
									case UI_TYPE.DROPDOWN:
									case UI_TYPE.OPTION_GROUP:									
										if (!is_real(_value))	throw(string($"ERROR: trying to assign non-numeric value from bound variable to option group/dropdown/spinner {self.__ID}"));
										self.__index =  _value;
										break;
									case UI_TYPE.SPINNER:
										if (!is_real(_value))	throw(string($"ERROR: trying to assign non-numeric value from bound variable to option group/dropdown/spinner {self.__ID}"));
										self.__index =  _value;
										break;
									case UI_TYPE.PROGRESSBAR:
									case UI_TYPE.SLIDER:
										if (!is_real(_value))	throw(string($"ERROR: trying to assign non-numeric value from bound variable to progressbar/slider {self.__ID}"));
										self.__value =  _value;
										break;
								}
								
							}
						}
						self.__pre_render_callback();
						
						if (self.__visible) {							
							// Draw this widget
							self.__draw();
							
							if (self.__clips_content) {
								if (!surface_exists(self.__surface_id)) self.__surface_id = surface_create(display_get_gui_width(), display_get_gui_height());
								surface_set_target(self.__surface_id);
								draw_clear_alpha(c_black, 0);
								//var _scissor = gpu_get_scissor();
								// Fix application of GPU scissor when GUI resolution is different than window resolution
								//var _w_factor = (os_type == os_operagx ? surface_get_width(application_surface) : window_get_width())/display_get_gui_width();
								//var _h_factor = (os_type == os_operagx ? surface_get_height(application_surface) : window_get_height())/display_get_gui_height();
								//var _x = self.__dimensions.x * _w_factor;
								//var _y = self.__dimensions.y * _h_factor;
								//var _w = self.__dimensions.width * global.__gooey_manager_active.getScale() * _w_factor;
								//var _h = self.__dimensions.height * global.__gooey_manager_active.getScale() * _h_factor;
								//show_debug_message($"{_x} {_y} {_w} {_h} / window {window_get_width()} {window_get_height()} / surface {surface_get_width(application_surface)} {surface_get_height(application_surface)} / GUI {display_get_gui_width()} {display_get_gui_height()} (fs = {window_get_fullscreen()} {window_get_borderless_fullscreen()})");
								//gpu_set_scissor(_x, _y, _w, _h);
							}
										
							// Render children
							for (var _i=0, _n=array_length(self.__children); _i<_n; _i++)	self.__children[_i].__render();
							// Render common items
							if (self.__type == UI_TYPE.PANEL) {
								for (var _i=0, _n=array_length(self.__common_widgets); _i<_n; _i++)	self.__common_widgets[_i].__render();
							}
					
							if (self.__clips_content) {						
								surface_reset_target();
								// The surface needs to be drawn with screen coords
								draw_surface_part(self.__surface_id, self.__dimensions.x, self.__dimensions.y, self.__dimensions.width * global.__gooey_manager_active.getScale(), self.__dimensions.height * global.__gooey_manager_active.getScale(), self.__dimensions.x, self.__dimensions.y);
								//gpu_set_scissor(_scissor);
							}
						}
						
						// Post-render
						self.__post_render_callback();
					}
			
					self.__processMouseover = function() {
						if (self.__visible && self.__enabled) {
							var _clips_contents = false;
							var _current_parent = self.__parent;
							while (_current_parent != noone) {
								_clips_contents = _clips_contents || _current_parent.getClipsContent();
								_current_parent = _current_parent.getParent();
							}
							
							if (self.__parent != noone && self.__parent.__type != UI_TYPE.PANEL && _clips_contents && self.__type != UI_TYPE.TEXT && self.__type != UI_TYPE.DROPDOWN) {
								var _x0 = self.__dimensions.x;
								var _y0 = self.__dimensions.y;
								var _x1 = self.__dimensions.x + self.__dimensions.width;
								var _y1 = self.__dimensions.y + self.__dimensions.height;
								var _current_parent = self.__parent;
								while (_current_parent != noone) {
									var _dim_parent = _current_parent.getDimensions();
									_x0 = max(_x0, _dim_parent.x);
									_y0 = max(_y0, _dim_parent.y);
									_x1 = min(_x1, _dim_parent.x + _dim_parent.width);
									_y1 = min(_y1, _dim_parent.y + _dim_parent.height);
									_current_parent = _current_parent.getParent();
								}
								if (_x0 < _x1 && _y0 < _y1)		self.__events_fired[UI_EVENT.MOUSE_OVER] = point_in_rectangle(device_mouse_x_to_gui(global.__gooey_manager_active.getMouseDevice()), device_mouse_y_to_gui(global.__gooey_manager_active.getMouseDevice()), _x0, _y0, _x1, _y1);
							}
							else if (self.__type == UI_TYPE.DROPDOWN) {
								var _x0 = self.__dimensions.x;
								var _y0 = self.__dimensions.y;
								var _x1 = self.__dimensions.x + self.__dimensions.width;
								var _y1 = self.__dimensions.y + self.__current_total_height;
								var _current_parent = self.__parent;
								while (_current_parent != noone) {
									var _dim_parent = _current_parent.getDimensions();
									_x0 = max(_x0, _dim_parent.x);
									_y0 = max(_y0, _dim_parent.y);
									if (self.getContainingPanel().getClipsContent()) {
										_x1 = min(_x1, _dim_parent.x + _dim_parent.width);
										_y1 = min(_y1, _dim_parent.y + _dim_parent.height);
									}
									_current_parent = _current_parent.getParent();
								}
								if (_x0 < _x1 && _y0 < _y1)		self.__events_fired[UI_EVENT.MOUSE_OVER] = point_in_rectangle(device_mouse_x_to_gui(global.__gooey_manager_active.getMouseDevice()), device_mouse_y_to_gui(global.__gooey_manager_active.getMouseDevice()), _x0, _y0, _x1, _y1);
							}
							else if (self.__type == UI_TYPE.TEXT) {
								var _text = self.getText();
								var _s = scribble(_text);
								var _bbox = _s.get_bbox(self.__dimensions.x, self.__dimensions.y);								
								self.__events_fired[UI_EVENT.MOUSE_OVER] = point_in_rectangle(device_mouse_x_to_gui(global.__gooey_manager_active.getMouseDevice()), device_mouse_y_to_gui(global.__gooey_manager_active.getMouseDevice()), _bbox.left, _bbox.top, _bbox.right, _bbox.bottom);
							}
							else {
								self.__events_fired[UI_EVENT.MOUSE_OVER] = point_in_rectangle(device_mouse_x_to_gui(global.__gooey_manager_active.getMouseDevice()), device_mouse_y_to_gui(global.__gooey_manager_active.getMouseDevice()), self.__dimensions.x, self.__dimensions.y, self.__dimensions.x + self.__dimensions.width * global.__gooey_manager_active.getScale(), self.__dimensions.y + self.__dimensions.height * global.__gooey_manager_active.getScale());
							}
						}
					}
					
					self.__clearEvents = function(_clear_enter_exit=true) {
						for (var _i=0; _i<GOOEY_NUM_CALLBACKS; _i++)	{
							if (_clear_enter_exit || !_clear_enter_exit && _i != UI_EVENT.MOUSE_ENTER && _i != UI_EVENT.MOUSE_EXIT) self.__events_fired[_i] = false;
						}
					}
				
					self.__processEvents = function() {
						array_copy(self.__events_fired_last, 0, self.__events_fired, 0, GOOEY_NUM_CALLBACKS);
						
						self.__clearEvents();
						
						if (self.__visible && self.__enabled) {
							self.__processMouseover();
							self.__events_fired[UI_EVENT.LEFT_CLICK] = self.__events_fired[UI_EVENT.MOUSE_OVER] && device_mouse_check_button_pressed(global.__gooey_manager_active.getMouseDevice(), mb_left);
							self.__events_fired[UI_EVENT.MIDDLE_CLICK] = self.__events_fired[UI_EVENT.MOUSE_OVER] && device_mouse_check_button_pressed(global.__gooey_manager_active.getMouseDevice(), mb_middle);
							self.__events_fired[UI_EVENT.RIGHT_CLICK] = self.__events_fired[UI_EVENT.MOUSE_OVER] && device_mouse_check_button_pressed(global.__gooey_manager_active.getMouseDevice(), mb_right);
							self.__events_fired[UI_EVENT.LEFT_HOLD] = self.__events_fired[UI_EVENT.MOUSE_OVER] && device_mouse_check_button(global.__gooey_manager_active.getMouseDevice(), mb_left);
							self.__events_fired[UI_EVENT.MIDDLE_HOLD] = self.__events_fired[UI_EVENT.MOUSE_OVER] && device_mouse_check_button(global.__gooey_manager_active.getMouseDevice(), mb_middle);
							self.__events_fired[UI_EVENT.RIGHT_HOLD] = self.__events_fired[UI_EVENT.MOUSE_OVER] && device_mouse_check_button(global.__gooey_manager_active.getMouseDevice(), mb_right);
							self.__events_fired[UI_EVENT.LEFT_RELEASE] = self.__events_fired[UI_EVENT.MOUSE_OVER] && device_mouse_check_button_released(global.__gooey_manager_active.getMouseDevice(), mb_left);
							self.__events_fired[UI_EVENT.MIDDLE_RELEASE] = self.__events_fired[UI_EVENT.MOUSE_OVER] && device_mouse_check_button_released(global.__gooey_manager_active.getMouseDevice(), mb_middle);
							self.__events_fired[UI_EVENT.RIGHT_RELEASE] = self.__events_fired[UI_EVENT.MOUSE_OVER] && device_mouse_check_button_released(global.__gooey_manager_active.getMouseDevice(), mb_right);
							self.__events_fired[UI_EVENT.MOUSE_ENTER] = !self.__events_fired_last[UI_EVENT.MOUSE_OVER] && self.__events_fired[UI_EVENT.MOUSE_OVER];
							self.__events_fired[UI_EVENT.MOUSE_EXIT] = self.__events_fired_last[UI_EVENT.MOUSE_OVER] && !self.__events_fired[UI_EVENT.MOUSE_OVER];
							self.__events_fired[UI_EVENT.MOUSE_WHEEL_UP] = self.__events_fired[UI_EVENT.MOUSE_OVER] && mouse_wheel_up();
							self.__events_fired[UI_EVENT.MOUSE_WHEEL_DOWN] = self.__events_fired[UI_EVENT.MOUSE_OVER] && mouse_wheel_down();
							
							
							// Calculate 3x3 "grid" on the panel, based off on screen coords, that will determine what drag action is fired (move or resize)
							var _w = self.__resize_border_width * global.__gooey_manager_active.getScale();					
							var _x0 = self.__dimensions.x;
							var _x1 = _x0 + _w;
							var _x3 = self.__dimensions.x + self.__dimensions.width * global.__gooey_manager_active.getScale();
							var _x2 = _x3 - _w;
							var _y0 = self.__dimensions.y;
							var _y1 = _y0 + _w;
							var _y3 = self.__dimensions.y + self.__dimensions.height * global.__gooey_manager_active.getScale();
							var _y2 = _y3 - _w;
					
							// Determine mouse cursors for mouseover
							if (self.__events_fired[UI_EVENT.MOUSE_OVER]) {
								var _y1drag = self.__drag_bar_height == self.__dimensions.height ? _y2 : _y1 + self.__drag_bar_height;								
								if		(self.__resizable && point_in_rectangle(device_mouse_x_to_gui(global.__gooey_manager_active.getMouseDevice()), device_mouse_y_to_gui(global.__gooey_manager_active.getMouseDevice()), _x0, _y0, _x1, _y1))		global.__gooey_manager_active.__setUICursor(UI_CURSOR_SIZE_NWSE);
								else if (self.__resizable && point_in_rectangle(device_mouse_x_to_gui(global.__gooey_manager_active.getMouseDevice()), device_mouse_y_to_gui(global.__gooey_manager_active.getMouseDevice()), _x2, _y0, _x3, _y1))		global.__gooey_manager_active.__setUICursor(UI_CURSOR_SIZE_NESW);
								else if (self.__resizable && point_in_rectangle(device_mouse_x_to_gui(global.__gooey_manager_active.getMouseDevice()), device_mouse_y_to_gui(global.__gooey_manager_active.getMouseDevice()), _x0, _y2, _x1, _y3))		global.__gooey_manager_active.__setUICursor(UI_CURSOR_SIZE_NESW);
								else if (self.__resizable && point_in_rectangle(device_mouse_x_to_gui(global.__gooey_manager_active.getMouseDevice()), device_mouse_y_to_gui(global.__gooey_manager_active.getMouseDevice()), _x2, _y2, _x3, _y3))		global.__gooey_manager_active.__setUICursor(UI_CURSOR_SIZE_NWSE);
								else if (self.__resizable && point_in_rectangle(device_mouse_x_to_gui(global.__gooey_manager_active.getMouseDevice()), device_mouse_y_to_gui(global.__gooey_manager_active.getMouseDevice()), _x0, _y0, _x3, _y1))		global.__gooey_manager_active.__setUICursor(UI_CURSOR_SIZE_NS);
								else if (self.__resizable && point_in_rectangle(device_mouse_x_to_gui(global.__gooey_manager_active.getMouseDevice()), device_mouse_y_to_gui(global.__gooey_manager_active.getMouseDevice()), _x2, _y0, _x3, _y3))		global.__gooey_manager_active.__setUICursor(UI_CURSOR_SIZE_WE);
								else if (self.__resizable && point_in_rectangle(device_mouse_x_to_gui(global.__gooey_manager_active.getMouseDevice()), device_mouse_y_to_gui(global.__gooey_manager_active.getMouseDevice()), _x0, _y2, _x3, _y3))		global.__gooey_manager_active.__setUICursor(UI_CURSOR_SIZE_NS);
								else if (self.__resizable && point_in_rectangle(device_mouse_x_to_gui(global.__gooey_manager_active.getMouseDevice()), device_mouse_y_to_gui(global.__gooey_manager_active.getMouseDevice()), _x0, _y0, _x1, _y3))		global.__gooey_manager_active.__setUICursor(UI_CURSOR_SIZE_WE);
								else if (((self.__type == UI_TYPE.PANEL && self.__movable) || (self.__type != UI_TYPE.PANEL && self.__draggable)) && point_in_rectangle(device_mouse_x_to_gui(global.__gooey_manager_active.getMouseDevice()), device_mouse_y_to_gui(global.__gooey_manager_active.getMouseDevice()), _x1, _y1, _x2, _y1drag))	{
									var _cursor = (device_mouse_check_button(global.__gooey_manager_active.getMouseDevice(), mb_left)) ? UI_CURSOR_DRAG : UI_CURSOR_INTERACT;
									global.__gooey_manager_active.__setUICursor(_cursor);									
								}
							}
					
							if (self.__isDragStart())	{
								// Determine drag actions for left hold
								var _y1drag = self.__drag_bar_height == self.__dimensions.height ? _y2 : _y1 + self.__drag_bar_height;								
								if (point_in_rectangle(global.__gooey_manager_active.__drag_data.__drag_mouse_delta_x, global.__gooey_manager_active.__drag_data.__drag_mouse_delta_y, _x0, _y0, _x1, _y1))			global.__gooey_manager_active.__drag_data.__drag_action = UI_RESIZE_DRAG.RESIZE_NW; 
								else if (point_in_rectangle(global.__gooey_manager_active.__drag_data.__drag_mouse_delta_x, global.__gooey_manager_active.__drag_data.__drag_mouse_delta_y, _x2, _y0, _x3, _y1))		global.__gooey_manager_active.__drag_data.__drag_action = UI_RESIZE_DRAG.RESIZE_NE; 
								else if (point_in_rectangle(global.__gooey_manager_active.__drag_data.__drag_mouse_delta_x, global.__gooey_manager_active.__drag_data.__drag_mouse_delta_y, _x0, _y2, _x1, _y3))		global.__gooey_manager_active.__drag_data.__drag_action = UI_RESIZE_DRAG.RESIZE_SW; 
								else if (point_in_rectangle(global.__gooey_manager_active.__drag_data.__drag_mouse_delta_x, global.__gooey_manager_active.__drag_data.__drag_mouse_delta_y, _x2, _y2, _x3, _y3))		global.__gooey_manager_active.__drag_data.__drag_action = UI_RESIZE_DRAG.RESIZE_SE; 
								else if (point_in_rectangle(global.__gooey_manager_active.__drag_data.__drag_mouse_delta_x, global.__gooey_manager_active.__drag_data.__drag_mouse_delta_y, _x0, _y0, _x3, _y1))		global.__gooey_manager_active.__drag_data.__drag_action = UI_RESIZE_DRAG.RESIZE_N;	 
								else if (point_in_rectangle(global.__gooey_manager_active.__drag_data.__drag_mouse_delta_x, global.__gooey_manager_active.__drag_data.__drag_mouse_delta_y, _x2, _y0, _x3, _y3))		global.__gooey_manager_active.__drag_data.__drag_action = UI_RESIZE_DRAG.RESIZE_E;	 
								else if (point_in_rectangle(global.__gooey_manager_active.__drag_data.__drag_mouse_delta_x, global.__gooey_manager_active.__drag_data.__drag_mouse_delta_y, _x0, _y2, _x3, _y3))		global.__gooey_manager_active.__drag_data.__drag_action = UI_RESIZE_DRAG.RESIZE_S;	 
								else if (point_in_rectangle(global.__gooey_manager_active.__drag_data.__drag_mouse_delta_x, global.__gooey_manager_active.__drag_data.__drag_mouse_delta_y, _x0, _y0, _x1, _y3))		global.__gooey_manager_active.__drag_data.__drag_action = UI_RESIZE_DRAG.RESIZE_W;	 
								else if (point_in_rectangle(global.__gooey_manager_active.__drag_data.__drag_mouse_delta_x, global.__gooey_manager_active.__drag_data.__drag_mouse_delta_y, _x1, _y1, _x2, _y1drag))	global.__gooey_manager_active.__drag_data.__drag_action = UI_RESIZE_DRAG.DRAG;
								else 	global.__gooey_manager_active.__drag_data.__drag_action = UI_RESIZE_DRAG.NONE;								
							}
														
						}
					}
					
					self.__dragCondition = function() { return true; }
					
					self.__dragStart = function() {
						if (self.__type == UI_TYPE.PANEL)	global.__gooey_manager_active.setFocusedPanel(self.__ID);
						global.__gooey_manager_active.__currentlyDraggedWidget = self;								
						global.__gooey_manager_active.__drag_data.__drag_start_x = self.__dimensions.x;
						global.__gooey_manager_active.__drag_data.__drag_start_y = self.__dimensions.y;
						global.__gooey_manager_active.__drag_data.__drag_start_width = self.__dimensions.width;
						global.__gooey_manager_active.__drag_data.__drag_start_height = self.__dimensions.height;
						global.__gooey_manager_active.__drag_data.__drag_mouse_delta_x = device_mouse_x_to_gui(global.__gooey_manager_active.getMouseDevice());
						global.__gooey_manager_active.__drag_data.__drag_mouse_delta_y = device_mouse_y_to_gui(global.__gooey_manager_active.getMouseDevice());						
					}
					
					self.__isDragStart = function() {
						if (global.__gooey_manager_active.__currentlyDraggedWidget == noone && self.__draggable && self.__events_fired[UI_EVENT.LEFT_HOLD] && self.__dragCondition())	{							
							self.__dragStart();
							return true;
						}
						else return false;
					}
					
					self.__isDragEnd = function() {
						if (global.__gooey_manager_active.__currentlyDraggedWidget == self && device_mouse_check_button_released(global.__gooey_manager_active.getMouseDevice(), mb_left)) {								
							global.__gooey_manager_active.__currentlyDraggedWidget = noone;
							global.__gooey_manager_active.__drag_data.__drag_start_x = -1;
							global.__gooey_manager_active.__drag_data.__drag_start_y = -1;
							global.__gooey_manager_active.__drag_data.__drag_start_width = -1;
							global.__gooey_manager_active.__drag_data.__drag_start_height = -1;
							global.__gooey_manager_active.__drag_data.__drag_mouse_delta_x = -1;
							global.__gooey_manager_active.__drag_data.__drag_mouse_delta_y = -1;
							global.__gooey_manager_active.__drag_data.__drag_action = -1;
							global.__gooey_manager_active.__drag_data.__drag_specific_start_x = -1;
							global.__gooey_manager_active.__drag_data.__drag_specific_start_y = -1;
							global.__gooey_manager_active.__drag_data.__drag_specific_start_width = -1;
							global.__gooey_manager_active.__drag_data.__drag_specific_start_height = -1;
							//global.__gooey_manager_active.__setUICursor(UI_CURSOR_DEFAULT);
							return true;
						}
						else return false;
					}
					
					self.__builtInBehavior = function(_process_array = array_create(GOOEY_NUM_CALLBACKS, true)) {
						if (_process_array[UI_EVENT.MOUSE_OVER] && self.__events_fired[UI_EVENT.MOUSE_OVER]) 				{
							if (self.__callbacks[UI_EVENT.MOUSE_OVER] == None && self.__drill_through_mouse_over)	{
								var _widget = self.__parent;
								var _found = false;
								while (_widget != noone && !_found) {
									_found = _widget.__callbacks[UI_EVENT.MOUSE_OVER] != None;
									if (!_found) _widget = _widget.__parent;
								}
								if (_found) _widget.__callbacks[UI_EVENT.MOUSE_OVER]();
							}
							else self.__callbacks[UI_EVENT.MOUSE_OVER]();
						}
						if (_process_array[UI_EVENT.LEFT_CLICK] && self.__events_fired[UI_EVENT.LEFT_CLICK]) 				{
							if (self.__callbacks[UI_EVENT.LEFT_CLICK] == None && self.__drill_through_left_click)	{
								var _widget = self.__parent;
								var _found = false;
								while (_widget != noone && !_found) {
									_found = _widget.__callbacks[UI_EVENT.LEFT_CLICK] != None;
									if (!_found) _widget = _widget.__parent;
								}
								if (_found) _widget.__callbacks[UI_EVENT.LEFT_CLICK]();
							}
							else self.__callbacks[UI_EVENT.LEFT_CLICK]();
						}
						if (_process_array[UI_EVENT.MIDDLE_CLICK] && self.__events_fired[UI_EVENT.MIDDLE_CLICK]) 			{
							if (self.__callbacks[UI_EVENT.MIDDLE_CLICK] == None && self.__drill_through_middle_click)	{
								var _widget = self.__parent;
								var _found = false;
								while (_widget != noone && !_found) {
									_found = _widget.__callbacks[UI_EVENT.MIDDLE_CLICK] != None;
									if (!_found) _widget = _widget.__parent;
								}
								if (_found) _widget.__callbacks[UI_EVENT.MIDDLE_CLICK]();
							}
							else self.__callbacks[UI_EVENT.MIDDLE_CLICK]();
						}
						if (_process_array[UI_EVENT.RIGHT_CLICK] && self.__events_fired[UI_EVENT.RIGHT_CLICK]) 				{
							if (self.__callbacks[UI_EVENT.RIGHT_CLICK] == None && self.__drill_through_right_click)	{
								var _widget = self.__parent;
								var _found = false;
								while (_widget != noone && !_found) {
									_found = _widget.__callbacks[UI_EVENT.RIGHT_CLICK] != None;
									if (!_found) _widget = _widget.__parent;
								}
								if (_found) _widget.__callbacks[UI_EVENT.RIGHT_CLICK]();
							}
							else self.__callbacks[UI_EVENT.RIGHT_CLICK]();
						}
						if (_process_array[UI_EVENT.LEFT_HOLD] && self.__events_fired[UI_EVENT.LEFT_HOLD]) 					{
							if (self.__callbacks[UI_EVENT.LEFT_HOLD] == None && self.__drill_through_left_hold)	{
								var _widget = self.__parent;
								var _found = false;
								while (_widget != noone && !_found) {
									_found = _widget.__callbacks[UI_EVENT.LEFT_HOLD] != None;
									if (!_found) _widget = _widget.__parent;
								}
								if (_found) _widget.__callbacks[UI_EVENT.LEFT_HOLD]();
							}
							else self.__callbacks[UI_EVENT.LEFT_HOLD]();
						}
						if (_process_array[UI_EVENT.MIDDLE_HOLD] && self.__events_fired[UI_EVENT.MIDDLE_HOLD]) 				{
							if (self.__callbacks[UI_EVENT.MIDDLE_HOLD] == None && self.__drill_through_middle_hold)	{
								var _widget = self.__parent;
								var _found = false;
								while (_widget != noone && !_found) {
									_found = _widget.__callbacks[UI_EVENT.MIDDLE_HOLD] != None;
									if (!_found) _widget = _widget.__parent;
								}
								if (_found) _widget.__callbacks[UI_EVENT.MIDDLE_HOLD]();
							}
							else self.__callbacks[UI_EVENT.MIDDLE_HOLD]();
						}
						if (_process_array[UI_EVENT.RIGHT_HOLD] && self.__events_fired[UI_EVENT.RIGHT_HOLD]) 				{
							if (self.__callbacks[UI_EVENT.RIGHT_HOLD] == None && self.__drill_through_right_hold)	{
								var _widget = self.__parent;
								var _found = false;
								while (_widget != noone && !_found) {
									_found = _widget.__callbacks[UI_EVENT.RIGHT_HOLD] != None;
									if (!_found) _widget = _widget.__parent;
								}
								if (_found) _widget.__callbacks[UI_EVENT.RIGHT_HOLD]();
							}
							else self.__callbacks[UI_EVENT.RIGHT_HOLD]();
						}
						if (_process_array[UI_EVENT.LEFT_RELEASE] && self.__events_fired[UI_EVENT.LEFT_RELEASE]) 			{
							if (self.__callbacks[UI_EVENT.LEFT_RELEASE] == None && self.__drill_through_left_release)	{
								var _widget = self.__parent;
								var _found = false;
								while (_widget != noone && !_found) {
									_found = _widget.__callbacks[UI_EVENT.LEFT_RELEASE] != None;
									if (!_found) _widget = _widget.__parent;
								}
								if (_found) _widget.__callbacks[UI_EVENT.LEFT_RELEASE]();
							}
							else self.__callbacks[UI_EVENT.LEFT_RELEASE]();
						}
						if (_process_array[UI_EVENT.MIDDLE_RELEASE] && self.__events_fired[UI_EVENT.MIDDLE_RELEASE])		{
							if (self.__callbacks[UI_EVENT.MIDDLE_RELEASE] == None && self.__drill_through_middle_release)	{
								var _widget = self.__parent;
								var _found = false;
								while (_widget != noone && !_found) {
									_found = _widget.__callbacks[UI_EVENT.MIDDLE_RELEASE] != None;
									if (!_found) _widget = _widget.__parent;
								}
								if (_found) _widget.__callbacks[UI_EVENT.MIDDLE_RELEASE]();
							}
							else self.__callbacks[UI_EVENT.MIDDLE_RELEASE]();
						}
						if (_process_array[UI_EVENT.RIGHT_RELEASE] && self.__events_fired[UI_EVENT.RIGHT_RELEASE]) 			{
							if (self.__callbacks[UI_EVENT.RIGHT_RELEASE] == None && self.__drill_through_right_release)	{
								var _widget = self.__parent;
								var _found = false;
								while (_widget != noone && !_found) {
									_found = _widget.__callbacks[UI_EVENT.RIGHT_RELEASE] != None;
									if (!_found) _widget = _widget.__parent;
								}
								if (_found) _widget.__callbacks[UI_EVENT.RIGHT_RELEASE]();
							}
							else self.__callbacks[UI_EVENT.RIGHT_RELEASE]();
						}
						if (_process_array[UI_EVENT.MOUSE_ENTER] && self.__events_fired[UI_EVENT.MOUSE_ENTER]) 				{
							if (self.__callbacks[UI_EVENT.MOUSE_ENTER] == None && self.__drill_through_mouse_enter)	{
								var _widget = self.__parent;
								var _found = false;
								while (_widget != noone && !_found) {
									_found = _widget.__callbacks[UI_EVENT.MOUSE_ENTER] != None;
									if (!_found) _widget = _widget.__parent;
								}
								if (_found) _widget.__callbacks[UI_EVENT.MOUSE_ENTER]();
							}
							else self.__callbacks[UI_EVENT.MOUSE_ENTER]();
						}
						if (_process_array[UI_EVENT.MOUSE_EXIT] && self.__events_fired[UI_EVENT.MOUSE_EXIT]) 				{
							if (self.__callbacks[UI_EVENT.MOUSE_EXIT] == None && self.__drill_through_mouse_exit)	{
								var _widget = self.__parent;
								var _found = false;
								while (_widget != noone && !_found) {
									_found = _widget.__callbacks[UI_EVENT.MOUSE_EXIT] != None;
									if (!_found) _widget = _widget.__parent;
								}
								if (_found) _widget.__callbacks[UI_EVENT.MOUSE_EXIT]();
							}
							else self.__callbacks[UI_EVENT.MOUSE_EXIT]();
						}
						if (_process_array[UI_EVENT.MOUSE_WHEEL_UP] && self.__events_fired[UI_EVENT.MOUSE_WHEEL_UP]) 		{
							if (self.__callbacks[UI_EVENT.MOUSE_WHEEL_UP] == None && self.__drill_through_mouse_wheel_up)	{
								var _widget = self.__parent;
								var _found = false;
								while (_widget != noone && !_found) {
									_found = _widget.__callbacks[UI_EVENT.MOUSE_WHEEL_UP] != None;
									if (!_found) _widget = _widget.__parent;
								}
								if (_found) _widget.__callbacks[UI_EVENT.MOUSE_WHEEL_UP]();
							}
							else self.__callbacks[UI_EVENT.MOUSE_WHEEL_UP]();
						}
						if (_process_array[UI_EVENT.MOUSE_WHEEL_DOWN] && self.__events_fired[UI_EVENT.MOUSE_WHEEL_DOWN])	{
							if (self.__callbacks[UI_EVENT.MOUSE_WHEEL_DOWN] == None && self.__drill_through_mouse_wheel_down)	{
								var _widget = self.__parent;
								var _found = false;
								while (_widget != noone && !_found) {
									_found = _widget.__callbacks[UI_EVENT.MOUSE_WHEEL_DOWN] != None;
									if (!_found) _widget = _widget.__parent;
								}
								if (_found) _widget.__callbacks[UI_EVENT.MOUSE_WHEEL_DOWN]();
							}
							else self.__callbacks[UI_EVENT.MOUSE_WHEEL_DOWN]();
						}
						// Handle Value Changed event on the UI object
					}	
					
					self.__drag = function() {}
					
				#endregion
			
				/// @method				scroll(_orientation, _sign, [_amount = UI_SCROLL_SPEED])
				/// @description		Scrolls the content of this widget in a particular direction (horizontal/vertical) and sign (negative/positive)
				/// @param				{Enum}	_orientation	the direction to scroll, as in `UI_ORIENTATION`.
				/// @param				{Real}	_sign			the sign (-1 or 1)
				/// @param				{Real}	_amount			the amount to scroll, by default `UI_SCROLL_SPEED`
				/// @return				{UIWidget}	self
				self.scroll = function(_orientation, _sign, _amount = UI_SCROLL_SPEED) {
					var _s = _sign >= 0 ? 1 : -1;
					var _tab = self.__type == UI_TYPE.PANEL ? self.getCurrentTab() : 0;
					if (_orientation == UI_ORIENTATION.HORIZONTAL) {
						self.__cumulative_horizontal_scroll_offset[_tab] += _s * _amount;
						for (var _i=0, _n=array_length(self.__children); _i<_n; _i++) {							
							self.__children[_i].__dimensions.setScrollOffsetH(_s * _amount);
							self.__children[_i].__updateChildrenPositions();
						}
					}
					else {
						self.__cumulative_vertical_scroll_offset[_tab] += _s * _amount;
						for (var _i=0, _n=array_length(self.__children); _i<_n; _i++) {
							self.__children[_i].__dimensions.setScrollOffsetV(_s * _amount);
							self.__children[_i].__updateChildrenPositions();
						}
					}
				}
				
				/// @method				getScrollOffset(_orientation, _value)
				/// @description		Gets the cumulative scroll offset to a particular number
				/// @param				{Enum}	_orientation	whether to set the horizontal or vertical offset
				/// @return				{Real}	the cumulative scroll offset
				self.getScrollOffset = function(_orientation) {
					var _tab = self.__type == UI_TYPE.PANEL ? self.getCurrentTab() : 0;
					return _orientation == UI_ORIENTATION.HORIZONTAL ? self.__cumulative_horizontal_scroll_offset[_tab] : self.__cumulative_vertical_scroll_offset[_tab];
				}
				
				/// @method				setScrollOffset(_orientation, _value)
				/// @description		Sets the scroll offset to a particular number
				/// @param				{Enum}	_orientation	whether to set the horizontal or vertical offset
				/// @param				{Real}	_value			the value to set				
				/// @return				{UIWidget}	self
				self.setScrollOffset = function(_orientation, _value) {
					var _tab = self.__type == UI_TYPE.PANEL ? self.getCurrentTab() : 0;
					var _current_offset = _orientation == UI_ORIENTATION.HORIZONTAL ? self.__cumulative_horizontal_scroll_offset[_tab] : self.__cumulative_vertical_scroll_offset[_tab];
					var _amount = abs(_value - _current_offset);
					var _sign = sign(_value - _current_offset);
					self.scroll(_orientation, _sign, _amount);			
				}
				
				/// @method				resetScroll(_direction)
				/// @description		Resets the scrolling offset to 0 in the indicated direction
				/// @param				{Enum}	_direction	the direction to scroll, as in `UI_ORIENTATION`.				
				/// @return				{UIWidget}	self
				self.resetScroll = function(_direction) {
					var _tab = self.__type == UI_TYPE.PANEL ? self.getCurrentTab() : 0;
					var _cum = _direction == UI_ORIENTATION.HORIZONTAL ? self.__cumulative_horizontal_scroll_offset[_tab] : self.__cumulative_vertical_scroll_offset[_tab];
					self.scroll(_direction, -sign(_cum), abs(_cum));
				}
					
				/// @method				add(_id, [_tab = <current_tab>])
				/// @description		Adds a children Widget to this Widget
				/// @param				{UIWidget}	_id 	The reference to the children Widget to add
				/// @param				{Real}	[_tab]				Tab to get the controls from. <br>
				///													If _tab is a nonnegative number, it will add the children to the specified tab.<br>
				///													If _tab is -1, it will add the children to the common widgets instead.<br>
				///													If _tab is omitted, it will default to the current tab (or ignored, in case of non-tabbed widgets).				
				/// @return				{UIWidget}	The added children Widget. *Note that this does NOT return the current Widget's reference, but rather the children's reference*. This is by design to be able to use `with` in conjunction with this method.
				self.add = function(_id, _tab = self.__type == UI_TYPE.PANEL ? self.__current_tab : 0) {
					if (_id.__type == UI_TYPE.PANEL)	throw("ERROR: Cannot add a Panel to another widget");
					if (self.__type == UI_TYPE.PANEL && (_tab >= array_length(self.__tabs) || _tab < -1))	throw($"ERROR: Tab index {_tab} out of bounds for panel '{self.__ID}' (tab index must be between 0 and {array_length(self.__tabs)-1} or -1 [common widgets area])");
					_id.__parent = self;
					_id.__dimensions.setParent(self);
					if (self.__type == UI_TYPE.PANEL && _tab != -1)			array_push(self.__tabs[_tab], _id);					
					else if (self.__type == UI_TYPE.PANEL && _tab == -1)	array_push(self.__common_widgets, _id);
					else array_push(self.__children, _id);
					
					if (_id.__type == UI_TYPE.GRID) {
						_id.__updateGridDimensions();
					}
					_id.__updateChildrenPositions();
					return _id;
				}
			
				/// @method				remove(_ID)
				/// @description		Removes a Widget from the list of children Widget. *Note that this does NOT destroy the Widget*.
				/// @param				{String}	_ID 	The string ID of the children Widget to delete
				/// @param				{Real}	[_tab]				Tab to remove the control from. <br>
				///													If _tab is a nonnegative number, it will add the children to the specified tab.<br>
				///													If _tab is -1, it will add the children to the common widgets instead.<br>
				///													If _tab is omitted, it will default to the current tab (or ignored, in case of non-tabbed widgets).				
				/// @return				{Bool}				Whether the Widget was found (and removed from the list of children) or not.<br>
				///											NOTE: If tab was specified, it will return `false` if the control was not found on the specified tab, regardless of whether it exists on other tabs, or on the common widget-
				self.remove = function(_ID, _tab = self.__type == UI_TYPE.PANEL ? self.__current_tab : 0) {
					var _array;
					if (self.__type == UI_TYPE.PANEL && _tab != -1)			_array = self.__tabs[_tab];
					else if (self.__type == UI_TYPE.PANEL && _tab == -1)	_array = self.__common_widgets;
					else													_array = self.__children;
					
					var _i=0; 
					var _n = array_length(_array);
					var _found = false;
					while (_i<_n && !_found) {
						if (_array[_i].__ID == _ID) {
							array_delete(_array, _i, 1);
							_found = true;						
						}
						else {
							_i++
						}					
					}
					return _found;
				}
			
			
				/// @method				getDescendants()
				/// @description		Gets an array containing all descendants (children, grandchildren etc.) of this Widget.<br>
				///						If widget is a Panel, gets all descendants of the current tab, including common widgets for a Panel
				/// @return				{Array<UIWidget>}	the array of descendant Widget references
				self.getDescendants = function() {
					var _n_children = array_length(self.getChildren());					
					//var _a = array_create(_n_children + _n_common);					
					var _a = [];
					array_copy(_a, 0, self.getChildren(), 0, _n_children); 

					var _n = array_length(_a);
					if (_n > 0) {						
						for (var _i=0; _i<_n; _i++) {
							var _b = _a[_i].getDescendants();				
							var _m = array_length(_b);
							for (var _j=0; _j<_m; _j++)			array_push(_a, _b[_j]);
						}
					}
					
					// Copy common widgets at the end in order to give them preference						
					if (self.__type == UI_TYPE.PANEL) {
						var _n_common = array_length(self.getChildren(-1));
						var _common = self.getChildren(-1);
						for (var _i=0; _i<_n_common; _i++)	array_push(_a, _common[_i]);
							
						// Descendants of common widgets 
						for (var _i=0; _i<_n_common; _i++) {
							var _b = _common[_i].getDescendants();				
							var _m = array_length(_b);
							for (var _j=0; _j<_m; _j++)		array_push(_a, _b[_j]);
						}
					}
						
					return _a;
				
				}
			
				/// @method				destroy()
				/// @description		Destroys the current widget	and all its children (recursively)
				self.destroy = function() {
					global.__gooey_manager_active.__logMessage("Destroying widget with ID '"+self.__ID+"' from containing Panel '"+self.getContainingPanel().__ID+"' on tab "+string(self.getContainingTab()), UI_MESSAGE_LEVEL.INFO);
					
					self.__on_destroy_callback();
					
					// Delete surface
					if (surface_exists(self.__surface_id))	surface_free(self.__surface_id);
					
					if (self.__type == UI_TYPE.PANEL) {						
						for (var _i=0, _n=array_length(self.__tabs); _i<_n; _i++) {
							for (var _m=array_length(self.__tabs[_i]), _j=_m-1; _j>=0; _j--) {
								self.__tabs[_i][_j].destroy();
							}
						}
						// Destroy common widgets too
						for (var _n=array_length(self.__common_widgets), _i=_n-1; _i>=0; _i--) {
							self.__common_widgets[_i].destroy();
						}
						self.__close_button = undefined;
						self.__tab_button_control = undefined;
						
						global.__gooey_manager_active.__destroy_widget(self);
						global.__gooey_manager_active.__currentlyHoveredPanel = noone;
						
						if (self.__modal) {
							var _n = array_length(global.__gooey_manager_active.__panels);
							for (var _i=0; _i<_n; _i++) {
								if (global.__gooey_manager_active.__panels[_i].__ID != self.__ID) {
									global.__gooey_manager_active.__panels[_i].setEnabled(true);
								}
							}
						}
					}
					else {						
						// Delete children
						for (var _n=array_length(self.__children), _i=_n-1; _i>=0; _i--) {
							self.__children[_i].destroy();						
						}
						// Remove from parent panel						
						if (self.__parent.__type == UI_TYPE.PANEL) {
							var _t = self.getContainingTab();
							self.__parent.remove(self.__ID, _t);
						}
						else {
							self.__parent.remove(self.__ID);
						}
						global.__gooey_manager_active.__destroy_widget(self);
					}					
					self.__children = [];					
					global.__gooey_manager_active.__currentlyDraggedWidget = noone;
				}		
				
				/// @method				getChildrenBoundingBoxAbsolute()
				/// @description		Gets the dimensions of the minimum bounding rectangle that contains all chidren in the current tab, *relative to the screen*. <br>
				///						Does not consider common elements.
				/// @return				{Struct}	the screen dimensions (x, y, width and height) for the minimum bounding box
				self.getChildrenBoundingBoxAbsolute = function(_tab=self.__type == UI_TYPE.PANEL ? self.__current_tab : 0) {
					var _min_y=99999999;
					var _max_y=-99999999;
					var _min_x=99999999;
					var _max_x=-99999999;
					var _array = self.getChildren(_tab);
					for (var _i=0; _i<array_length(_array); _i++) {
						var _child = _array[_i];
						var _dim = _child.getDimensions();
						// Temporary (:D) fix for text width/height being 0
						var _this_w = _child.__type == UI_TYPE.TEXT ? UI_TEXT_RENDERER(_child.getText()).get_width() : _dim.width;
						var _this_h = _child.__type == UI_TYPE.TEXT ? UI_TEXT_RENDERER(_child.getText()).get_height() : _dim.height;
						_min_y = min(_min_y, _dim.y);
						_max_y = max(_max_y, _dim.y+_this_h);
						_min_x = min(_min_x, _dim.x);
						_max_x = max(_max_x, _dim.x+_this_w);
					}
					var _w = _max_x - _min_x;
					var _h = _max_y - _min_y;
					return {x: _min_x, y: _min_y, width: _w, height: _h};						
				}
				
				/// @method				getChildrenBoundingBoxRelative()
				/// @description		Gets the dimensions of the minimum bounding rectangle that contains all chidren in the current tab, *relative to its container coordinates*. <br>
				///						Does not consider common elements.
				/// @return				{Struct}	the parent-based dimensions (x, y, width and height) for the minimum bounding box
				self.getChildrenBoundingBoxRelative = function(_tab=self.__type == UI_TYPE.PANEL ? self.__current_tab : 0) {
					var _min_y=99999999;
					var _max_y=-99999999;
					var _min_x=99999999;
					var _max_x=-99999999;
					var _array = self.getChildren(_tab);
					for (var _i=0; _i<array_length(_array); _i++) {
						var _child = _array[_i];
						var _dim = _child.getDimensions();
						// Temporary (:D) fix for text width/height being 0
						var _this_w = _child.__type == UI_TYPE.TEXT ? UI_TEXT_RENDERER(_child.getText()).get_width() : _dim.width;
						var _this_h = _child.__type == UI_TYPE.TEXT ? UI_TEXT_RENDERER(_child.getText()).get_height() : _dim.height;
						_min_y = min(_min_y, _dim.relative_y);
						_max_y = max(_max_y, _dim.relative_y+_this_h);
						_min_x = min(_min_x, _dim.relative_x);
						_max_x = max(_max_x, _dim.relative_x+_this_w);
					}
					var _w = _max_x - _min_x;
					var _h = _max_y - _min_y;
					return {x: _min_x, y: _min_y, width: _w, height: _h};						
				}
			
			#endregion		
		}
	
	#endregion
	
#endregion
