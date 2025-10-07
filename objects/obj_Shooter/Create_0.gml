event_inherited();
self.stats = {
	speed: Game.waves.shooter_speed[Game.current_wave],
	shoot_range: Game.waves.shooter_range[Game.current_wave],
	shoot_rate: Game.waves.shooter_rate[Game.current_wave],
};


self.path = undefined;


#region State Machine

	self.fsm = new StateMachine()

	self.fsm.add("Pathfind", {
		enter: function() {
			self.image_index = 0;
		},
		step: function() {
			
			self.path = path_add();
			mp_grid_path(Game.grid, self.path, self.x, self.y, obj_Player.x, obj_Player.y, true);
			path_start(self.path, self.stats.speed, path_action_stop, false);
			
			var _angle = point_direction(self.x, self.y, obj_Player.x, obj_Player.y);
			self.image_angle = _angle;
		},
		leave: function() {
			
		}
	});
	
	self.fsm.add("Shoot", {
		enter: function() {
			path_delete(self.path);
			self.ts = time_source_create(time_source_game, self.stats.shoot_rate, time_source_units_frames, function() {
				if (obj_Player.fsm.get_current_state_name() != "Die") {
					instance_create_layer(self.x, self.y, "lyr_Player", obj_Bullet);
				}
			}, [], -1, time_source_expire_nearest);
			time_source_start(self.ts);
		},
		step: function() {
			var _angle = point_direction(self.x, self.y, obj_Player.x, obj_Player.y);
			self.image_angle = _angle;
		},
		leave: function() {
			if (time_source_exists(self.ts)) time_source_destroy(self.ts);			
		}
	});
	
	self.fsm.add_transition("Pathfind", "Shoot", function() {
		return distance_to_object(obj_Player) < self.stats.shoot_range && obj_Player.fsm.get_current_state_name() != "Die";
	});
	
	self.fsm.add_transition("Shoot", "Pathfind", function() {
		return distance_to_object(obj_Player) > self.stats.shoot_range*1.2;
	});
	
	
	self.fsm.init("Pathfind");

#endregion


self.light = new BulbLight(Lighting.renderer, spr_Light, 0, self.x, self.y);
self.light.xscale = 0.15;
self.light.yscale = 0.15;
self.light.blend = c_lime;