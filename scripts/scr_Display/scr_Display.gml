function gui_to_room_x(_gui_x, _camera_idx=0) {
	if (view_enabled) {
		var _camera = view_camera[_camera_idx];
		return _gui_x / display_get_gui_width() * camera_get_view_width(_camera) + camera_get_view_x(_camera);
	}
	else {
		return room_width * _gui_x / display_get_gui_width(); 
	}
}
function gui_to_room_y(_gui_y, _camera_idx=0) {
	if (view_enabled) {
		var _camera = view_camera[_camera_idx];
		return _gui_y / display_get_gui_height() * camera_get_view_height(_camera) + camera_get_view_y(_camera);
	}
	else {
		return room_height * _gui_y / display_get_gui_height();
	}
}
function room_to_gui_x(_room_x, _camera_idx=0) {
	if (view_enabled) {
		var _camera = view_camera[_camera_idx];
		return display_get_gui_width() * (_room_x - camera_get_view_x(_camera)) / camera_get_view_width(_camera);
	}
	else {
		return display_get_gui_width() * _room_x / room_width;
	}
}
function room_to_gui_y(_room_y, _camera_idx=0) {
	if (view_enabled) {
		var _camera = view_camera[_camera_idx];
		return display_get_gui_height() * (_room_y - camera_get_view_y(_camera)) / camera_get_view_height(_camera);
	}
	else {
		return display_get_gui_height() * _room_y / room_height;
	}
}