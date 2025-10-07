live_auto_call;

switch(room) {
	case room_Init:
		break;
	case room_Menus:
		draw_surface(application_surface, 0, 0);
		break;
	default:
		if (surface_exists(Lighting.surface))  self.fullscreen_fx.renderer.DrawInFullscreen(Lighting.surface);
		break;
}
