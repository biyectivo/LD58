event_inherited();
self.stats = {
	speed: Game.waves.chaser_speed[Game.current_wave],
};
self.position = new vector(self.x, self.y);
self.velocity = new vector_zero();
self.steering_forces = new vector_zero();
self.max_speed = self.stats.speed;
self.max_force = 0.1;
self.path = undefined;


#region State Machine

	self.fsm = new StateMachine()

	self.fsm.add("Pathfind", {
		enter: function() {
			
		},
		step: function() {
			live_auto_call;
			
			var _tilemap = layer_tilemap_get_id(layer_get_id("lyr_Tile_Collision"));
			var _collisionables = [cls_Collisionable, _tilemap];
			
			self.path = path_add();
			mp_grid_path(Game.grid, self.path, self.x, self.y, obj_Player.x, obj_Player.y, true);
			var _target_x = path_get_point_x(self.path, 1);
			var _target_y = path_get_point_y(self.path, 1);
			
			self.steering_forces.add(seek_force(_target_x, _target_y));
			//self.steering_forces.add(arrive_force(_x, _y, 100));
			self.steering_forces.add(separation_force(obj_Chaser, 48));
			
			self.velocity.add(self.steering_forces);
			self.velocity.limit_magnitude(self.stats.speed);
			
			self.position.add(self.velocity);
			self.x = self.position.x;
			self.y = self.position.y;
			
			self.steering_forces.set(0, 0);
			
			path_delete(self.path);
			
			var _angle = point_direction(self.x, self.y, obj_Player.x, obj_Player.y);
			if (_angle > 100 && _angle < 260)		self.image_xscale = -1;
			else if (_angle > 280 || _angle < 80)	self.image_xscale = 1;
		},
		leave: function() {
			
		}
	});

	//self.fsm.add("Distribute", {
	//	enter: function() {},
	//	step: function() {
	//	},
	//	leave: function() {			
	//	}
	//});
	
	//self.fsm.add_transition("Pathfind", "Distribute", function() {
	//	return false;
	//	var _d = infinity;
	//	with (obj_Chaser) {
	//		if (self.id != other.id) {
	//			if (point_distance(self.x, self.y, other.x, other.y) < _d)	_d = point_distance(self.x, self.y, other.x, other.y);
	//		}
	//	}
	//	return point_distance(self.x, self.y, obj_Player.x, obj_Player.y) > 48 && _d < 24;
	//});
	
	//self.fsm.add_transition("Distribute", "Pathfind", function() {
	//	return true;
	//});
	
	self.fsm.init("Pathfind");

#endregion


self.light = new BulbLight(Lighting.renderer, spr_Light, 0, self.x, self.y);
self.light.xscale = 0.15;
self.light.yscale = 0.15;
self.light.blend = #aaaaaa;