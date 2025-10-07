//Cleanse
self.part_type_enemy_die = part_type_create();
part_type_shape(self.part_type_enemy_die, pt_shape_smoke);
part_type_size(self.part_type_enemy_die, 1, 1.2, 0, 0);
part_type_scale(self.part_type_enemy_die, 1, 1);
part_type_speed(self.part_type_enemy_die, 3, 5, 0, 1);
part_type_direction(self.part_type_enemy_die, 80, 100, 0, 0);
part_type_gravity(self.part_type_enemy_die, 0, 270);
part_type_orientation(self.part_type_enemy_die, 0, 0, 0, 0, false);
part_type_colour3(self.part_type_enemy_die, #eeeeee, #aaaaaa, #666666);
part_type_alpha3(self.part_type_enemy_die, 0.812, 0.698, 0.729);
part_type_blend(self.part_type_enemy_die, false);
part_type_life(self.part_type_enemy_die, 30, 50);


self.pe_enemy = part_emitter_create(Game.ps);