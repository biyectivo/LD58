//Update the lights and shadows on the renderer
self.renderer.Update();

//Apply the lighting to the application surface
if (self.renderer != undefined) {
	self.renderer.SetCamera(view_camera[0]);
	self.renderer.Update();
	
	if (!surface_exists(self.surface)) {
		self.surface = surface_create(surface_get_width(application_surface), surface_get_height(application_surface));
		surface_set_target(self.surface);
		draw_clear_alpha(c_black, 0);		
		surface_reset_target();
	}
	surface_set_target(self.surface);
	draw_surface(application_surface, 0, 0);
	surface_reset_target();
	
	BulbApplyLightingToSurface(self.renderer, self.surface);
}