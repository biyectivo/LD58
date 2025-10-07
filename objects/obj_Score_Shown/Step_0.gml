live_auto_call;

if (Game.fsm.get_current_state_name() == "Paused") exit;

self.t--;
if (self.t<0) instance_destroy();