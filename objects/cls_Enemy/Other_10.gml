self.visible = false;
part_emitter_region(Game.ps, self.pe_enemy, self.x-32, self.x+32, self.y-32, self.y+32, ps_shape_ellipse, ps_distr_linear);
part_emitter_burst(Game.ps, self.pe_enemy, self.part_type_enemy_die, 30);
call_later(60, time_source_units_frames, function() {
	instance_destroy();
}, false);