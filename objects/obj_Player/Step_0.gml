live_auto_call;
if (Game.fsm.get_current_state_name() == "Paused") exit;

self.fsm.step();
self.fsm.transition();

//if (keyboard_check_pressed(vk_tab)) {
//		Game.fsm.trigger("Lost");
//	obj_Player.fsm.trigger("Die");
//}