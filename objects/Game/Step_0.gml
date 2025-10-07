live_auto_call;

//if (keyboard_check_pressed(ord("R"))) __game_restart();
self.fsm.step();
self.fsm.transition();
//show_debug_overlay(true);
if (InputPressed(INPUT_VERB.MUSIC)) {
	self.options.audio.music = !self.options.audio.music;
	if (self.options.audio.music) {
		audio_resume_all();
	}
	else {
		audio_pause_all();
	}
}

if (InputPressed(INPUT_VERB.SOUNDS)) {
	self.options.audio.sounds = !self.options.audio.sounds;
	if (self.options.audio.sounds) {
		
	}
	else {
		
	}
}


if (InputPressed(INPUT_VERB.FULLSCREEN)) {
	self.options.video.fullscreen = !self.options.video.fullscreen;
	window_set_fullscreen(self.options.video.fullscreen);
	
}

switch(room) {
	case room_Init:
		break;
	case room_Menus:
		
		break;
	default:
		
		break;
}