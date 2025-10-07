self.move_speed = 2;
self.target_x = obj_Player.x;
self.target_y = obj_Player.y;
var _angle = point_direction(self.x, self.y, self.target_x, self.target_y);
self.image_angle = _angle;

if (Game.options.audio.sounds) audio_play_sound(snd_Shoot, 50, false);