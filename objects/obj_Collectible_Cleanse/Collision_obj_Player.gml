Game.target_score = Game.game_data.total_score + 10000;
Game.type_collected = obj_Collectible_Cleanse;

self.light.Destroy();
with (cls_Enemy) {
	event_perform(ev_other, ev_user0);
}

instance_create_layer(self.x, self.y, "lyr_Score", obj_Score_Shown, {score_value: 10000});
Camera.shake(30, 6);
Achoo.get_stat("OrbsCollected").increment_value();
Achoo.save_stats("stats.dat");
if (Game.options.audio.sounds) audio_play_sound(snd_Cleanse, 50, false);

instance_destroy();