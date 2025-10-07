live_auto_call;
if (Game.fsm.get_current_state_name() == "Paused") exit;

self.image_angle += 15;
self.image_xscale = self.scale;
self.image_yscale = self.scale;
