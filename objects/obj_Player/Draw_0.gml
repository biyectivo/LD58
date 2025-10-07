live_auto_call;

var _d = self.y_offset_draw/10 * 2;
draw_set_alpha(0.6);
draw_ellipse_color(self.x-8+_d, self.bbox_bottom-2, self.x+6-_d, self.bbox_bottom+4, #333333, #333333, false);
draw_set_alpha(1);
draw_sprite_ext(self.sprite_index, self.image_index, self.x, self.y-self.y_offset_draw, self.image_xscale, self.image_yscale, self.image_angle, self.image_blend, self.image_alpha);

//draw_set_alpha(0.5);
//draw_rectangle_color(self.bbox_left, self.bbox_top, self.bbox_right, self.bbox_bottom, c_red, c_red, c_red, c_red, false);
//draw_set_alpha(1);