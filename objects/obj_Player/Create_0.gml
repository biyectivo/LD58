live_auto_call;

self.stats = {
	move_acceleration: 0.15,
	move_deceleration: 0.20,
	max_speed: 3,
	current_speed: 0,
	current_angle: 0,
	dash_speed: 9,
	dash_duration: 15,
	dash_cooldown: 60,
};

self.light = new BulbLight(Lighting.renderer, spr_Light, 0, self.x, self.y);
self.light.xscale = 0.5;
self.light.yscale = 0.5;

self.y_offset_draw = 0;
animation_add("Idle Bop", self, "y_offset_draw", 10, 60, curve_Normal, true);

self.can_dash = true;

self.move = function(_dash=false) {
    var _len = 0;
	if (!_dash) {
		var _h = InputCheck(INPUT_VERB.RIGHT) - InputCheck(INPUT_VERB.LEFT);
	    var _v = InputCheck(INPUT_VERB.DOWN) - InputCheck(INPUT_VERB.UP);

	    // Normalize input vector (avoid sqrt cost if possible)
	    var _len = sqrt(_h*_h + _v*_v);
	    if (_len > 0) {
	        _h /= _len;
	        _v /= _len;

	        if (_h != 0 || _v != 0)	self.stats.current_angle = point_direction(self.x, self.y, self.x + _h, self.y + _v) // Only update direction if input exists        
	    }
	}

    // Accelerate toward max speed
    if (_dash) {
			self.stats.current_speed = self.stats.dash_speed;
	}
	else if (_len > 0)	{		
			self.stats.current_speed = clamp(self.stats.current_speed + self.stats.move_acceleration, 0, self.stats.max_speed);
	}
    else	self.stats.current_speed = clamp(self.stats.current_speed - self.stats.move_deceleration, 0, self.stats.max_speed);
    
    // Calculate movement vector
    var dx = lengthdir_x(self.stats.current_speed, self.stats.current_angle);
    var dy = lengthdir_y(self.stats.current_speed, self.stats.current_angle);

    // Collision handling
    var _tilemap = layer_tilemap_get_id(layer_get_id("lyr_Tile_Collision"));
    var _collisionables = [cls_Collisionable, _tilemap];

    // Horizontal
    if (dx != 0) {
        if (place_meeting(self.x + dx, self.y, _collisionables)) {
            while (!place_meeting(self.x + sign(dx)*0.1, self.y, _collisionables)) {
                self.x += sign(dx)*0.1;
            }
			self.stats.current_speed = 0;
        }
		else {
            self.x += dx;
        }
    }

    // Vertical
    if (dy != 0) {
        if (place_meeting(self.x, self.y + dy, _collisionables)) {
            while (!place_meeting(self.x, self.y + sign(dy) * 0.1, _collisionables)) {
                self.y += sign(dy) * 0.1;				
            }
			self.stats.current_speed = 0;
        }
		else {
            self.y += dy;
        }
    }
	
	self.light.x = self.x;
	self.light.y = self.y;
}

self.update_facing = function() {
	if (self.stats.current_angle > 90 && self.stats.current_angle < 270)		self.image_xscale = -1;
	else if (self.stats.current_angle > 270 || self.stats.current_angle < 90)	self.image_xscale = 1;
}

#region State Machine

	self.fsm = new StateMachine()
	
	self.fsm.add("Idle", {
		enter: function() {
			self.image_angle = 0;
			self.image_index = 0;
			self.image_speed = 0;
			animation_start("Idle Bop");
		},
		step: function() {
			self.move();
			self.update_facing();
		},
		leave: function() {
			self.y_offset_draw = 0;
			animation_stop("Idle Bop");
		}
	});

	self.fsm.add("Move", {
		enter: function() {
			self.image_angle = 0;
			self.image_index = 0;
			self.image_speed = 1;
		},
		step: function() {
			if (self.fsm.get_state_timer() % 10 == 0) {
				part_emitter_region(Game.ps, self.pe_player, self.x-5, self.x+5, self.bbox_bottom-2, self.bbox_bottom, ps_shape_ellipse, ps_distr_gaussian);
				part_emitter_burst(Game.ps, self.pe_player, self.part_player_walk, 1);
			}
			self.move();
			self.update_facing();
		},
		leave: function() {			
		}
	});
	
	self.fsm.add("Dash", {
		enter: function() {
			self.image_index = 0;
			self.image_speed = 0;
			self.can_dash = false;
			call_later(self.stats.dash_cooldown, time_source_units_frames, function() {
				self.can_dash = true;
			}, false);
			
			part_type_direction(self.part_player_dash, self.stats.current_angle+180-15, self.stats.current_angle+180+15, 0, false);
			
			if (Game.options.audio.sounds) audio_play_sound(snd_Dash, 50, false);
		},
		step: function() {			
			part_emitter_region(Game.ps, self.pe_player, self.x-5, self.x+5, self.bbox_bottom-5, self.bbox_bottom, ps_shape_ellipse, ps_distr_gaussian);
			part_emitter_burst(Game.ps, self.pe_player, self.part_player_dash, 3);
			self.move(true);
			self.update_facing();			
			self.image_angle += self.stats.current_angle > 90 && self.stats.current_angle < 270 ? 20 : -20;
		},
		leave: function() {			
		}
	});
	
	self.fsm.add("Die", {
		enter: function() {
			self.image_index = 0;
			self.image_speed = 0;
			part_emitter_region(Game.ps, self.pe_player, self.x-32, self.x+32, self.y-32, self.y+32, ps_shape_ellipse, ps_distr_gaussian);
			part_emitter_burst(Game.ps, self.pe_player, self.part_player_death, 100);
			self.visible = false;
			if (Game.options.audio.sounds) audio_play_sound(snd_Shatter, 50, false);
		},
		step: function() {
			
		},
		leave: function() {			
		}
	});	

	self.fsm.add_transition("Idle", "Move", function() {
		return InputCheck(INPUT_VERB.UP) || InputCheck(INPUT_VERB.DOWN) || InputCheck(INPUT_VERB.LEFT) || InputCheck(INPUT_VERB.RIGHT);
	});
	
	self.fsm.add_transition("Move", "Dash", function() {
		return self.can_dash && InputPressed(INPUT_VERB.DASH);
	});
	
	self.fsm.add_transition("Dash", "Idle", function() {
		return self.fsm.get_state_timer() >= self.stats.dash_duration;
	});

	self.fsm.add_transition("Move", "Idle", function() {
		return !(InputCheck(INPUT_VERB.UP) || InputCheck(INPUT_VERB.DOWN) || InputCheck(INPUT_VERB.LEFT) || InputCheck(INPUT_VERB.RIGHT));
	});
	
	self.fsm.init("Idle");

#endregion


#region Particles

	//Emitter
	self.part_player_death = part_type_create();
	part_type_shape(self.part_player_death, pt_shape_disk);
	part_type_size(self.part_player_death, 0.05, 0.15, 0, 0);
	part_type_scale(self.part_player_death, 1, 1);
	part_type_speed(self.part_player_death, 2, 5, 0, 0);
	part_type_direction(self.part_player_death, 0, 360, 0, 0);
	part_type_gravity(self.part_player_death, 0.1, 270);
	part_type_orientation(self.part_player_death, 0, 0, 0, 0, false);
	part_type_colour3(self.part_player_death, $FFFFFF, $FFFFFF, $FFFFFF);
	part_type_alpha3(self.part_player_death, 1, 0.75, 0.10);
	part_type_blend(self.part_player_death, true);
	part_type_life(self.part_player_death, 30, 70);

	self.pe_player = part_emitter_create(Game.ps);

	
	//Walk
	self.part_player_walk = part_type_create();
	part_type_shape(self.part_player_walk, pt_shape_cloud);
	part_type_size(self.part_player_walk, 0.2, 0.2, 0, 0);
	part_type_scale(self.part_player_walk, 1, 1);
	part_type_speed(self.part_player_walk, 0.5, 0.9, 0, 0);
	part_type_direction(self.part_player_walk, 20, 160, 0, 0);
	part_type_gravity(self.part_player_walk, 0, 270);
	part_type_orientation(self.part_player_walk, 0, 0, 0, 0, false);
	part_type_colour3(self.part_player_walk, $FFFFFF, $FFFFFF, $FFFFFF);
	part_type_alpha3(self.part_player_walk, 0.5, 0.2, 0.05);
	part_type_blend(self.part_player_walk, false);
	part_type_life(self.part_player_walk, 10, 15);

	//Dash
	self.part_player_dash = part_type_create();
	part_type_shape(self.part_player_dash, pt_shape_pixel);
	part_type_size(self.part_player_dash, 0.5, 1, 0, 0);
	part_type_scale(self.part_player_dash, 1, 1);
	part_type_speed(self.part_player_dash, 4, 5, 0, 0);
	part_type_direction(self.part_player_dash, 170, 190, 0, 0);
	part_type_gravity(self.part_player_dash, 0, 270);
	part_type_orientation(self.part_player_dash, 0, 0, 0, 0, false);
	part_type_colour3(self.part_player_dash, $FFFFFF, $FFEFCC, $FFE5F1);
	part_type_alpha3(self.part_player_dash, 1, 1, 1);
	part_type_blend(self.part_player_dash, true);
	part_type_life(self.part_player_dash, 5, 10);

	
#endregion