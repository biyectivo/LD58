var _tilemap = layer_tilemap_get_id(layer_get_id("lyr_Tile_Collision"));
var _collisionables = [cls_Collisionable, _tilemap];

do {
	var _x = irandom_range(64, room_width-64);
	var _y = irandom_range(64, room_height-64);
}
until(!place_meeting(_x, _y, _collisionables) && point_distance(_x, _y, obj_Player.x, obj_Player.y) > 128)

instance_create_layer(_x, _y, "lyr_Player", obj_Miner);
Game.target_score = Game.game_data.total_score + 500;
instance_create_layer(self.x, self.y, "lyr_Score", obj_Score_Shown, {score_value: 500});
self.light.Destroy();
Achoo.get_stat("OrbsCollected").increment_value();
Achoo.save_stats("stats.dat");
if (Game.options.audio.sounds) audio_play_sound(snd_Collect, 50, false);
instance_destroy();