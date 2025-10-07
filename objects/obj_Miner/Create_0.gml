event_inherited();
self.stats = {
	speed: Game.waves.miner_speed[Game.current_wave],
	mine_rate: Game.waves.miner_mine_rate[Game.current_wave]
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
			if (_angle > 100 && _angle < 260)		self.image_xscale = -1;
			else if (_angle > 280 || _angle < 80)	self.image_xscale = 1;
		},
		leave: function() {
			
		}
	});
	
	self.fsm.add("Plant_Mine", {
		enter: function() {
			path_delete(self.path);
		},
		step: function() {
			
		},
		leave: function() {
			
			do {
				var _x = irandom_range(self.x-64, self.x+64);
				var _y = irandom_range(self.y-64, self.y+64);
			}
			until (!position_meeting(_x, _y, cls_Collisionable) && !position_meeting(_x, _y, obj_Mine));
			
				
			instance_create_layer(_x, _y, "lyr_Hazards", obj_Mine);
				
		}
	});
	
	self.fsm.add_transition("Pathfind", "Plant_Mine", function() {
		return obj_Player.fsm.get_current_state_name() != "Die" && self.fsm.get_state_timer() > self.stats.mine_rate;
	});
	
	self.fsm.add_transition("Plant_Mine", "Pathfind", function() {
		return self.fsm.get_state_timer() >= 60*1;
	});
	
	
	self.fsm.init("Pathfind");

#endregion


self.light = new BulbLight(Lighting.renderer, spr_Light, 0, self.x, self.y);
self.light.xscale = 0.15;
self.light.yscale = 0.15;
self.light.blend = #3366dd;