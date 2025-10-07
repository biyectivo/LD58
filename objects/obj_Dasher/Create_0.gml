event_inherited();
self.stats = {
	speed: Game.waves.dasher_speed[Game.current_wave],
	dash_speed: Game.waves.dasher_dash_speed[Game.current_wave],
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
		},
		leave: function() {
			
		}
	});
	
	self.fsm.add("Dash", {
		enter: function() {
			self.target_x = obj_Player.x;
			self.target_y = obj_Player.y;
			path_delete(self.path);
		},
		step: function() {
			if (self.fsm.get_state_timer() > 10) {
				var _tilemap = layer_tilemap_get_id(layer_get_id("lyr_Tile_Collision"));
				var _collisionables = [cls_Collisionable, _tilemap];
				
				var _angle = point_direction(self.x, self.y, self.target_x, self.target_y);
				var _dx = lengthdir_x(self.stats.dash_speed, _angle);
				var _dy = lengthdir_y(self.stats.dash_speed, _angle);
				// Horizontal
				if (_dx != 0) {
				    if (place_meeting(self.x + _dx, self.y, _collisionables)) {
				        while (!place_meeting(self.x + sign(_dx) * 0.1, self.y, _collisionables)) {
				            self.x += sign(_dx) * 0.1;
				        }
				    } else {
				        self.x += _dx;
				    }
				}

				// Vertical
				if (_dy != 0) {
				    if (place_meeting(self.x, self.y + _dy, _collisionables)) {
				        while (!place_meeting(self.x, self.y + sign(_dy) * 0.1, _collisionables)) {
				            self.y += sign(_dy) * 0.1;
				        }
				    } else {
				        self.y += _dy;
				    }
				}
				self.image_index = 0;
			}
			else {
				self.image_index = 1;
			}
		},
		leave: function() {
			
		}
	});
	
	self.fsm.add_transition("Pathfind", "Dash", function() {
		return distance_to_object(obj_Player) < 64;
	});
	
	self.fsm.add_transition("Dash", "Pathfind", function() {
		return self.fsm.get_state_timer() >= 60*2;
	});
	
	
	self.fsm.init("Pathfind");

#endregion


self.light = new BulbLight(Lighting.renderer, spr_Light, 0, self.x, self.y);
self.light.xscale = 0.15;
self.light.yscale = 0.15;
self.light.blend = #ff88dd;