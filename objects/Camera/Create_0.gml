view_camera[self.index] = camera_create();
view_enabled = true;
view_visible[self.index] = true;

self.display_aspect_ratio = display_get_width()/display_get_height();
self.aspect_ratio = self.use_display_aspect_ratio && os_browser == browser_not_a_browser ? self.display_aspect_ratio : self.custom_aspect_ratio;

self.__manual_x = 0;
self.__manual_y = 0;


if (self.adjust_width) {
	self.resolution_height = self.ideal_height;
	self.resolution_width = floor(self.resolution_height * self.aspect_ratio);
}
else if (self.adjust_height) {
	self.resolution_width = self.ideal_width;
	self.resolution_height = floor(self.resolution_width / self.aspect_ratio);
}
else {
	self.resolution_width = self.ideal_width;
	self.resolution_height = self.ideal_height;
}


if (self.resolution_width % 2 != 0)		self.resolution_width--;
if (self.resolution_height % 2 != 0)	self.resolution_height--;

self.move = function(_x, _y) {
	if (self.follow_target == noone || !instance_exists(self.follow_target)) {
		self.__manual_x = self.constrain_x_to_room ? clamp(_x, 0, room_width) : _x;
		self.__manual_y = self.constrain_y_to_room ? clamp(_y, 0, room_height) : _y;
	}	
}

self.get_position = function() {
	return {x: camera_get_view_x(view_camera[self.index]), y: camera_get_view_y(view_camera[self.index])};
}

self.shake_counter = 0;
self.shake_strength = 0;

self.shake = function(_time, _strength) {
	self.shake_counter = _time;
	self.shake_strength = _strength;
}

self.debug = function() {
	show_debug_message($"	Camera index: {self.index}, camera reference: {view_camera[self.index]}");
	show_debug_message($"	Camera dimensions: {camera_get_view_width(view_camera[self.index])} x {camera_get_view_height(view_camera[self.index])}");
	show_debug_message($"	Camera position: {camera_get_view_x(view_camera[self.index])},{camera_get_view_y(view_camera[self.index])}");
	show_debug_message($"	Camera following: {self.follow_target}");
	show_debug_message($"	Window size: {window_get_width()}x{window_get_height()}");
	show_debug_message($"	Fullscreen: {window_get_fullscreen()}");
	show_debug_message($"	Application Surface: enabled={application_surface_is_enabled()}, size: {surface_get_width(application_surface)}x{surface_get_height(application_surface)}  theoretical position (not considering manual draw): {application_get_position()[0]},{application_get_position()[1]}");
	show_debug_message($"	GUI size: {display_get_gui_width()}x{display_get_gui_height()}");
	show_debug_message($"	Display: {display_get_width()}x{display_get_height()} @ {display_get_frequency()}hz, {display_get_dpi_x()}x{display_get_dpi_y()} dpi");
	show_debug_message($"	Browser: Flag={os_browser != browser_not_a_browser} GX.Games={os_browser == browser_not_a_browser && os_type == os_operagx} size: {browser_width}x{browser_height}");
}

window_set_size(self.resolution_width*self.window_scale, self.resolution_height*self.window_scale);
surface_resize(application_surface, self.resolution_width*self.window_scale, self.resolution_height*self.window_scale);

if (self.custom_gui_width > 0 && self.custom_gui_height > 0) {
	display_set_gui_size(self.custom_gui_width, self.custom_gui_height);
}
else {
	display_set_gui_size(window_get_fullscreen() ? display_get_width() : self.resolution_width*self.gui_scale, window_get_fullscreen() ? display_get_height() : self.resolution_height*self.gui_scale);
}
window_center();