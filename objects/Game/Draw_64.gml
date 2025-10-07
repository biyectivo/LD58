live_auto_call;

switch(room) {
	case room_Init:
		break;
	case room_Menus:
		self.fsm.call("GUI");
		
		break;
	default:
		self.fsm.call("GUI");
		
		
		var _color = #222222;
		draw_set_alpha(0.9);
		var _w = 700;
		draw_rectangle_color(display_get_gui_width()/2-_w, display_get_gui_height()-50, display_get_gui_width()/2+_w, display_get_gui_height()-20, _color, _color, _color, _color, false);
		
		draw_set_alpha(1);
		var _fmt = "[fnt_Arcade_Interlaced][c_white][fa_center][fa_middle][scale,0.2]";		
		
		scribble($"{_fmt}[[WASD] or [[JOYSTICK] TO MOVE  /  [[SPACE] OR [[BUTTON] TO DASH  /  [[P], [[ESC] or [[SELECT] TO PAUSE").draw(display_get_gui_width()/2, display_get_gui_height()-35);
		
		
		break;
}