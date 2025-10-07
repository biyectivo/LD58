self.am = new SpriteManager();
self.am.add_state("Idle", "", self.sprite_index, 0, 1);
self.am.add_state("Up", "", self.sprite_index, 0, 3, 15);
self.am.add_state("Down", "", self.sprite_index, 2, 3, 15,-1);

self.am.set("Idle", "");

self.fsm = new StateMachine();

self.fsm.add("Idle", {
	enter: function() {
		self.am.set(self.fsm.get_current_state_name(), "");
	},
	step:  function() {},
	leave: function() {},
});
self.fsm.add("Up", {
	enter: function() {
		self.am.set(self.fsm.get_current_state_name(), "");
	},
	step:  function() {
		if (place_meeting(self.x, self.y, obj_Player) && self.image_index == 2) {
			if (obj_Player.fsm.get_current_state_name() != "Die") {
				Camera.shake(60, 6);
				Game.fsm.trigger("Lost");
				obj_Player.fsm.trigger("Die");
			}
		}
	},
	leave: function() {},
});
self.fsm.add("Down", {
	enter: function() {
		self.am.set(self.fsm.get_current_state_name(), "");
	},
	step:  function() {
	},
	leave: function() {},
});

self.fsm.add_transition("Idle", "Up", function() {
	return place_meeting(self.x, self.y, obj_Player) && obj_Player.fsm.get_current_state_name() != "Die";
});

self.fsm.add_transition("Up", "Down", function() {
	return !place_meeting(self.x, self.y, obj_Player) && self.fsm.get_state_timer() == 30;
});

self.fsm.add_transition("Down", "Idle", function() {
	return self.fsm.get_state_timer() == 30;
});

self.fsm.init("Idle");


