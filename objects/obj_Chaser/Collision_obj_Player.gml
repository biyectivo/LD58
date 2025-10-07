if (obj_Player.fsm.get_current_state_name() != "Die") {
	Camera.shake(60, 4);
	Game.fsm.trigger("Lost");
	obj_Player.fsm.trigger("Die");
}