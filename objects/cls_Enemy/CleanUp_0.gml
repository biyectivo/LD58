if (part_type_exists(self.part_type_enemy_die)) part_type_destroy(self.part_type_enemy_die);
if (part_emitter_exists(Game.ps, self.pe_enemy)) part_emitter_destroy(Game.ps, self.pe_enemy);
self.light.Destroy();