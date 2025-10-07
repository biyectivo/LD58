draw_self();
if (self.image_index == 1) {
	draw_set_alpha(0.3);
	draw_circle_color(self.x, self.y, self.explosion_radius, c_red, c_red, true);
	draw_set_alpha(1);
}