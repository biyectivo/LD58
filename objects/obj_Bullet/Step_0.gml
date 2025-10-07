live_auto_call;
if (Game.fsm.get_current_state_name() == "Paused") exit;


var _dx = lengthdir_x(self.move_speed, self.image_angle);
var _dy = lengthdir_y(self.move_speed, self.image_angle);

self.x += _dx;
self.y += _dy;

var _tilemap = layer_tilemap_get_id(layer_get_id("lyr_Tile_Collision"));
var _collisionables = [cls_Collisionable, _tilemap];
			
if (place_meeting(self.x, self.y, _collisionables) || self.x < 0 || self.x > room_width || self.y < 0 || self.y > room_height) {
	instance_destroy();
}

if (place_meeting(self.x, self.y, obj_Player)) {
	if (Game.fsm.get_current_state_name() != "Lost") {
		Camera.shake(60, 2);
		Game.fsm.trigger("Lost");
		obj_Player.fsm.trigger("Die");
	}
	instance_destroy();
}