self.explosion_radius = 96;

self.light = new BulbLight(Lighting.renderer, spr_Light, 0, self.x, self.y);
self.light.xscale = 0.15;
self.light.yscale = 0.15;
self.light.blend = c_red;

self.am = new SpriteManager();
self.am.add_state("Idle", "", self.sprite_index, 0, 1);
self.am.add_state("BlinkSlow", "", self.sprite_index, 1, 2, 10,,true);
self.am.add_state("BlinkFast", "", self.sprite_index, 1, 2, 2,,true);
self.am.add_state("Explode", "", self.sprite_index, 0, 1);

self.am.set("Idle", "");

self.fsm = new StateMachine();

self.fsm.add("Idle", {
	enter: function() {
		self.am.set(self.fsm.get_current_state_name(), "");
		self.light.visible = false;
	},
	step:  function() {},
	leave: function() {},
});
self.fsm.add("BlinkSlow", {
	enter: function() {
		self.am.set(self.fsm.get_current_state_name(), "");
		self.prev_image_index = self.image_index;
	},
	step:  function() {
		self.light.visible = self.image_index == 1;
		if (self.image_index == 1 && self.prev_image_index == 0) if (Game.options.audio.sounds) audio_play_sound(snd_Beep, 50, false);
		self.prev_image_index = self.image_index;
	},
	leave: function() {},
});
self.fsm.add("BlinkFast", {
	enter: function() {
		self.am.set(self.fsm.get_current_state_name(), "");
		if (self.image_index == 1 && self.prev_image_index == 0) if (Game.options.audio.sounds) audio_play_sound(snd_Beep, 50, false);
		self.prev_image_index = self.image_index;
	},
	step:  function() {
		self.light.visible = self.image_index == 1;
		if (self.image_index == 1) if (Game.options.audio.sounds) audio_play_sound(snd_Beep, 50, false);
		
	},
	leave: function() {},
});
self.fsm.add("Explode", {
	enter: function() {
		self.am.set(self.fsm.get_current_state_name(), "");
		self.light.Destroy();
		part_emitter_region(Game.ps, self.pe_mine, self.x-8, self.x+8, self.y-8, self.y+8, ps_shape_ellipse, ps_distr_gaussian);
		part_emitter_burst(Game.ps, self.pe_mine, self.part_mine_explode, 50);
		self.visible = false;
		if (self.image_index == 1) if (Game.options.audio.sounds) audio_play_sound(snd_Beep, 50, false);

		if (Game.options.audio.sounds) audio_play_sound(snd_Explode, 50, false);
	},
	step:  function() {
		if (self.fsm.get_state_timer() >= 20) {
			instance_destroy();
		}
		else {
			if (collision_circle(self.x, self.y, self.explosion_radius, obj_Player, true, false)) {
				Camera.shake(60, 6);
				Game.fsm.trigger("Lost");
				obj_Player.fsm.trigger("Die");
			}
		}
	},
	leave: function() {},
});

self.fsm.add_transition("Idle", "BlinkSlow", function() {
	return place_meeting(self.x, self.y, obj_Player) && obj_Player.fsm.get_current_state_name() != "Die";
});

self.fsm.add_transition("BlinkSlow", "BlinkFast", function() {
	return self.fsm.get_state_timer() == 30;
});

self.fsm.add_transition("BlinkFast", "Explode", function() {
	return self.fsm.get_state_timer() == 20;
});

self.fsm.init("Idle");



//Explosion
self.part_mine_explode = part_type_create();
part_type_shape(self.part_mine_explode, pt_shape_explosion);
part_type_size(self.part_mine_explode, 1, 1, 0, 0);
part_type_scale(self.part_mine_explode, 1, 1);
part_type_speed(self.part_mine_explode, 3, 5, 0, 0);
part_type_direction(self.part_mine_explode, 0, 360, 0, 0);
part_type_gravity(self.part_mine_explode, 0, 270);
part_type_orientation(self.part_mine_explode, 0, 0, 0, 0, false);
part_type_colour3(self.part_mine_explode, $0000FF, $007FFF, $07F2FF);
part_type_alpha3(self.part_mine_explode, 1, 0.5, 0.2);
part_type_blend(self.part_mine_explode, false);
part_type_life(self.part_mine_explode, 20, 30);

self.pe_mine = part_emitter_create(Game.ps);

