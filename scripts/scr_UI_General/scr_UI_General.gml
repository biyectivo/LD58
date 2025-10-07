/// @feather ignore all
#region Helper Enums and Macros
	#macro UI_TEXT_RENDERER		scribble
	#macro GOOEY_NUM_CALLBACKS	15
	#macro UI_LIBRARY_NAME		"gooey"
	#macro UI_LIBRARY_VERSION	"2025.9.0"
	#macro UI_SCROLL_SPEED		5
	
	enum UI_MESSAGE_LEVEL {
		INFO,
		WARNING,
		ERROR,
		NOTICE
	}
	enum UI_EVENT {
		MOUSE_OVER,
		LEFT_CLICK,
		MIDDLE_CLICK,
		RIGHT_CLICK,
		LEFT_HOLD,
		MIDDLE_HOLD,
		RIGHT_HOLD,
		LEFT_RELEASE,
		MIDDLE_RELEASE,
		RIGHT_RELEASE,
		MOUSE_ENTER,		
		MOUSE_EXIT,
		MOUSE_WHEEL_UP,
		MOUSE_WHEEL_DOWN,
		
		VALUE_CHANGED
	}	
	enum UI_TYPE {
		PANEL,
		BUTTON,
		GROUP,
		TEXT,
		CHECKBOX,
		SLIDER,
		TEXTBOX,
		OPTION_GROUP,
		DROPDOWN,
		SPINNER,
		PROGRESSBAR,
		CANVAS,
		SPRITE,
		GRID
	}
	enum UI_RESIZE_DRAG {
		NONE,
		DRAG,
		RESIZE_NW,
		RESIZE_N,
		RESIZE_NE,
		RESIZE_W,
		RESIZE_E,
		RESIZE_SW,
		RESIZE_S,
		RESIZE_SE
	}	
	enum UI_RELATIVE_TO {
		TOP_LEFT,
		TOP_CENTER,
		TOP_RIGHT,
		MIDDLE_LEFT,
		MIDDLE_CENTER,
		MIDDLE_RIGHT,
		BOTTOM_LEFT,
		BOTTOM_CENTER,
		BOTTOM_RIGHT
	}
	enum UI_ORIENTATION {
		HORIZONTAL,
		VERTICAL
	}
	enum UI_PROGRESSBAR_RENDER_BEHAVIOR {
		REVEAL,
		STRETCH,
		REPEAT
	}
	enum UI_TAB_SIZE_BEHAVIOR {
		SPRITE,
		SPECIFIC,
		MAX
	}
#endregion

#region Utility

	/// @function					sprite_scale(_sprite, _image, _scale_x, _scale_y = _scale_x, _replicate_nineslice=true)
	/// @description				scales an existing sprite frame by the specified scale and returns a new scaled sprite
	/// @param	{Asset.GMSprite}	_sprite		the sprite to scale
	/// @param	{Real}				_image		the image of the sprite to scale
	/// @param	{Real}				_scale_x	the x scale
	/// @param	{Real}				[_scale_y]	the y scale, by default equal to the x scale
	/// @param	{Boolean}			[_replicate_nineslice]	whether to replicate the nine-slice parameters of the original sprite, true by default (it will scale the slice positions accordingly)
	/// @return	{Asset.GMSprite}	the new scaled sprite
	function sprite_scale(_sprite, _image, _scale_x, _scale_y = _scale_x, _replicate_nineslice=true) {
		var _w = sprite_exists(_sprite) ? sprite_get_width(_sprite) : 0;
		var _h = sprite_exists(_sprite) ? sprite_get_height(_sprite) : 0;
		var _s = surface_create(_w * _scale_x, _h * _scale_y);
		surface_set_target(_s);
		draw_clear_alpha(c_black, 0);
		if (sprite_exists(_sprite)) draw_sprite_ext(_sprite, _image, 0, 0, _scale_x, _scale_y, 0, c_white, 1);
		surface_reset_target();
		var _spr = sprite_create_from_surface(_s, 0, 0, _w * _scale_x, _h * _scale_y, false, false, sprite_get_xoffset(_sprite) * _scale_x, sprite_get_yoffset(_sprite) * _scale_y);
		// Add scaled nine-slice properties
		if (_replicate_nineslice) {
			var _nineslice = sprite_get_nineslice(_sprite);
			_nineslice.left *= _scale_x;
			_nineslice.right *= _scale_x;
			_nineslice.top *= _scale_y;
			_nineslice.bottom *= _scale_y;
			sprite_set_nineslice(_spr, _nineslice);
		}
		var _off_x = sprite_get_xoffset(_sprite);
		var _off_y = sprite_get_yoffset(_sprite);
		sprite_set_offset(_spr, _off_x, _off_y);
		surface_free(_s);
		return _spr;
	}

	/// @function					room_x_to_gui(_x)
	/// @description				returns the GUI coordinate corresponding to the specified room x posiition
	/// @param	{Real}				_x				the room x
	/// @param	{ID}				[_camera]		the camera ID, by default, the active camera
	/// @return	{Real}				the GUI x coordinate
	function room_x_to_gui(_x, _camera = camera_get_active()) {
		return (_x-camera_get_view_x(_camera)) * display_get_gui_width() / camera_get_view_width(_camera);
	}
	
	/// @function					room_y_to_gui(_y)
	/// @description				returns the GUI coordinate corresponding to the specified room y posiition
	/// @param	{Real}				_y		the room y
	/// @param	{ID}				[_camera]		the camera ID, by default, the active camera
	/// @return	{Real}				the GUI y coordinate
	function room_y_to_gui(_y, _camera = camera_get_active()) {
		return (_y-camera_get_view_y(_camera)) * display_get_gui_height() / camera_get_view_height(_camera);
	}


#endregion

#region GM Text Renderer
	
	function text_renderer(_text) constructor {
		self.text = _text;
		self.draw = function(_x, _y) {
			draw_text(_x, _y, self.text);
			return self;
		}
		self.get_text = function() {
			return self.text;
		}
		self.get_width = function() {
			return string_width(self.text);
		}
		self.get_height = function() {
			return string_height(self.text);
		}
		self.get_left = function(_x) {
			return draw_get_halign() == fa_left ? _x : (draw_get_halign() == fa_right ? _x - self.get_width() : _x - self.get_width()/2);
		}
		self.get_right = function(_x) {
			return draw_get_halign() == fa_right ? _x : (draw_get_halign() == fa_left ? _x - self.get_width() : _x + self.get_width()/2);
		}
		self.get_top = function(_y) {
			return draw_get_valign() == fa_top ? _y : (draw_get_valign() == fa_bottom ? _y - self.get_height() : _y - self.get_height()/2);
		}
		self.get_bottom = function(_y) {
			return draw_get_valign() == fa_bottom ? _y : (draw_get_valign() == fa_top ? _y - self.get_height() : _y + self.get_height()/2);
		}
		return self;
	}

#endregion

