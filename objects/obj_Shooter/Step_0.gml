live_auto_call;
if (Game.fsm.get_current_state_name() == "Paused") exit;
self.fsm.step();
self.fsm.transition();


self.light.x=self.x;
self.light.y=self.y;