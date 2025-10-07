live_auto_call;

randomize();
self.seed = irandom_range(1, 99999999999);
random_set_seed(self.seed);
show_debug_message($"Seed: {self.seed}");

self.grid = undefined;


#region Options
	self.selected_menu_option = 0;
	self.achievements_offset = 0;
	
	self.options = { // Defaults
		game: {
		},
		audio: {
			sounds: true,
			music: true,
			sound_volume: 1.0,
			music_volume: 0.8,
		},
		video: {
			fullscreen: false,
		},
	};

	if (file_exists("options.dat"))		self.options = file_load("options.dat");
	else								file_save(self.options, "options.dat");

#endregion

#region Animation Manager Variables

	self.am_variables = {
		alpha_fade_rectangle: 1,
		x_title: -1000,
		x_achievement: 600,
	};

#endregion

#region State Machine

	self.fsm = new StateMachine(); 
	
	self.fsm.add("Splash Screen", {
		enter: function() {
			#region Animation set up
				animation_add("alpha_fade_in", self.am_variables, "alpha_fade_rectangle", 0, 30, curve_Linear);
				animation_add("title_slide_in", self.am_variables, "x_title", display_get_gui_width()/2, 60, curve_BackInv);
				animation_add("title_slide_out", self.am_variables, "x_title", 3*display_get_gui_width()/2, 60, curve_Back);
				animation_add("alpha_fade_out", self.am_variables, "alpha_fade_rectangle", 1, 30, curve_Linear,,,[
					{time: 1, callback: function() { Game.fsm.trigger("Title Screen"); } }
				]);
				
				animation_add_after("alpha_fade_in", "title_slide_in");
				animation_add_after("title_slide_in", "title_slide_out", 60);
				animation_add_after("title_slide_out", "alpha_fade_out");
				
				animation_start("alpha_fade_in");
				
			#endregion

		},
		step: function() {
			if (InputPressed(INPUT_VERB.ACCEPT)) {
				animation_stop_all();
				self.fsm.trigger("Title Screen");
			}				
			
		},
		GUI: function() {
			scribble($"[fa_center][fa_middle]a game by [spr_manta_ray] manta ray").draw(self.am_variables.x_title, display_get_gui_height()/2);
			draw_set_alpha(self.am_variables.alpha_fade_rectangle);
			draw_rectangle_color(0, 0, display_get_gui_width(), display_get_gui_height(), c_black, c_black, c_black, c_black, false);
			draw_set_alpha(1);
		},
		leave: function() {}
	});
	self.fsm.add("Title Screen", {
		enter: function() {
			layer_set_visible(layer_get_id("lyr_Effect_Water"), false);
			if (self.options.audio.music) {
				if (audio_is_playing(snd_Music)) audio_stop_sound(snd_Music);
				if (!audio_is_playing(snd_Intro)) audio_play_sound(snd_Intro, 100, true);
			}
		},
		step: function() {
			var _txt = ["Play", "Stats & Achievements", "Quit"];
			var _n = os_type == os_windows ? 3 : 2;
			if (InputPressed(INPUT_VERB.DOWN)) {
				self.selected_menu_option = (self.selected_menu_option+1) % _n;
				if (Game.options.audio.sounds) audio_play_sound(snd_Click, 50, false);
			}
			if (InputPressed(INPUT_VERB.UP)) {
				self.selected_menu_option = (self.selected_menu_option-1);
				if (self.selected_menu_option == -1) self.selected_menu_option = _n-1;
				if (Game.options.audio.sounds) audio_play_sound(snd_Click, 50, false);
			}
			if (InputPressed(INPUT_VERB.ACCEPT)) {				
				switch(self.selected_menu_option) {
					case 0:
						self.start_level();
						self.fsm.trigger("Playing");
						break;
					case 1:
						self.fsm.trigger("Achievements Screen");
						self.selected_menu_option = 0;
						self.achievements_offset = 0;
						break;
					case 2:
						game_end();
				}
				if (Game.options.audio.sounds) audio_play_sound(snd_Select, 50, false);
			}
		},
		GUI: function() {
			scribble($"[fnt_Arcade_Solid][fa_center][fa_middle][scale,40][alpha,0.2][spr_Player]").draw(display_get_gui_width()/2, display_get_gui_height()/2);
			scribble($"[fnt_Arcade_Solid][fa_center][fa_middle][scale,1.2][shake][rainbow]GREEDY COLLECTOR").draw(display_get_gui_width()/2, display_get_gui_height()/2-400);
		
			var _w = 800;
			var _h = 200;
			var _x = (display_get_gui_width()-_w)/2;
			var _y = (display_get_gui_height()-_h)/2-100;
		
			var _txt = ["Play", "Stats & Achievements", "Quit"];
			var _n = os_type == os_windows ? 3 : 2;
			for (var _i=0; _i<_n; _i++) {
				var _color = self.selected_menu_option == _i ? #6666ff : #111111;
				var _txt_color = self.selected_menu_option == _i ? "[c_white]" : "[c_gray]";
			
				var _spacing = 30;
				draw_set_alpha(0.6);
				draw_rectangle_color(_x, _y+_i*_h+_i*_spacing, _x+_w, _y+_i*_h+_i*_spacing+_h, _color, _color, _color, _color, false);
				draw_set_alpha(1);
				draw_rectangle_color(_x, _y+_i*_h+_i*_spacing, _x+_w, _y+_i*_h+_i*_spacing+_h, _color, _color, _color, _color, true);
			
				scribble($"[fnt_Arcade_Solid][fa_center][fa_middle][scale,0.6]{_txt_color}{_txt[_i]}").draw(_x+_w/2, _y+_i*_h+_i*_spacing + _h/2);
			
			}
			scribble($"[fnt_Arcade_Solid][fa_center][fa_middle][scale,0.2][#cccccc]Toggle: [[F] Fullscreen  [[M] Music   [[K] Sounds").draw(display_get_gui_width()/2, display_get_gui_height()-50);
		
		},
		leave: function() {			
		}
	});
	self.fsm.add("Achievements Screen", {
		enter: function() {
			
		},
		step: function() {
			
			if (InputLongPressed(INPUT_VERB.CLEAR,, 60)) {
				// Load from file
				if (file_exists("default_achievements.dat")) Achoo.load_achievements("default_achievements.dat");
				if (file_exists("default_stats.dat")) Achoo.load_stats("default_stats.dat");
				if (Game.options.audio.sounds) audio_play_sound(snd_Select, 50, false);
				Achoo.save_achievements("achievements.dat");
				Achoo.save_stats("stats.dat");	
			}
			
			if (InputPressed(INPUT_VERB.ACCEPT)) {				
				self.fsm.trigger("Title Screen");
				if (Game.options.audio.sounds) audio_play_sound(snd_Select, 50, false);
			}
		},
		GUI: function() {
			scribble($"[fnt_Arcade_Solid][fa_center][fa_middle][scale,1]STATS & ACHIEVEMENTS").draw(display_get_gui_width()/2, display_get_gui_height()/2-400);
			
			scribble($"[fnt_Arcade_Solid][fa_center][fa_middle][scale,0.5][rainbow]HIGH SCORE: {Achoo.get_stat("HighScore").get_value()}\n{Achoo.get_stat("HighScore").get_date_updated() != -1 ? date_datetime_string( Achoo.get_stat("HighScore").get_date_updated() ) : ""}").draw(display_get_gui_width()/2, display_get_gui_height()/2-300);
			
			var _n=array_length(Achoo.get_all_achievements());
			var _cnt = 0;
			for (var _i=0; _i<_n; _i++) {
				var _ach = Achoo.get_all_achievements()[_i];
				if (_ach.is_achieved()) _cnt++;
			}
			
			scribble($"[fnt_Arcade_Solid][fa_center][fa_middle][scale,0.3]ACHIEVEMENTS ({_cnt}/{_n}): USE [[UP] AND [[DOWN] TO SCROLL").draw(display_get_gui_width()/2, display_get_gui_height()/2-200);
					
			var _scissors = gpu_get_scissor();
					
			var _w = 800;
			var _h = 400;
			var _x =  (display_get_gui_width()-_w)/2;
			var _y =  display_get_gui_height()/2;
			
			
			
			draw_rectangle_color(_x-100, _y-150, _x-100+_w+200, _y-100+_h+100, c_gray, c_gray, c_gray, c_gray, true);
			gpu_set_scissor(_x-100, _y-150, _w+100, _h+100);
			
			var _spacing = 80;
			for (var _i=0; _i<_n; _i++) {
				
				var _ach = Achoo.get_all_achievements()[_i];
				scribble($"[fnt_Arcade_Solid][fa_left][fa_middle][scale,0.2][c_gray]{_i+1} > {_ach.get_title()}").draw(display_get_gui_width()/2-100, display_get_gui_height()/2-200+(_i+1)*_spacing-self.achievements_offset);
				scribble($"[fnt_Arcade_Solid][fa_left][fa_middle][scale,0.2]{_ach.get_description()}").draw(display_get_gui_width()/2-100, display_get_gui_height()/2-200+(_i+1)*_spacing + 20-self.achievements_offset);
				
				if (_ach.is_achieved()) scribble($"[fnt_Arcade_Solid][fa_right][fa_middle][spr_Checkmark]").draw(display_get_gui_width()/2-150, display_get_gui_height()/2-200+(_i+1)*_spacing+10-self.achievements_offset);
			}
			
			
			gpu_set_scissor(_scissors.x, _scissors.y, _scissors.w, _scissors.h);
			
			if (InputCheck(INPUT_VERB.DOWN))	self.achievements_offset = min(self.achievements_offset+5, _spacing*_n-_h);
			if (InputCheck(INPUT_VERB.UP))		self.achievements_offset = max(0, self.achievements_offset-5);			
			
			var _fmt = "[fnt_Arcade_Solid][fa_center][fa_middle][c_white][blink][scale,0.3]";
			scribble($"{_fmt}PRESS [[ENTER] TO RETURN OR HOLD [[C] TO CLEAR STATS & ACHIEVEMENTS").draw(display_get_gui_width()/2, display_get_gui_height()-100);
			
		},
		leave: function() {}
	});
	self.fsm.add("Playing", {
		enter: function() {
			if (self.options.audio.music) {
				if (audio_is_playing(snd_Intro)) audio_stop_sound(snd_Intro);
				if (!audio_is_playing(snd_Music)) audio_play_sound(snd_Music, 100, true);
			}
		},
		step: function() {
			var _old_wave = self.current_wave;
			if (InputPressed(INPUT_VERB.PAUSE)) self.fsm.trigger("Paused");
			self.t++;
			var _num_waves = array_length(self.waves.score_threshold);
			var _i=0;
			var _found = false;
			while (!_found && _i<_num_waves) {
				_found = (self.game_data.total_score < self.waves.score_threshold[_i]);
				if (!_found) _i++;
			}
			if (!_found) _i = _num_waves-1;
			self.current_wave = _i;
			
			if (keyboard_check_pressed(ord("9"))) {
				self.game_data.total_score = self.waves.score_threshold[self.current_wave]+1;
				show_debug_message(self.current_wave);
			}
			if (keyboard_check_pressed(ord("8"))) {
				self.game_data.total_score = max(0, self.waves.score_threshold[self.current_wave]-1);
				show_debug_message(self.current_wave);
			}

			
		},
		GUI: function() {
			var _x1 = display_get_gui_width()-480;
			var _y1 = 20
			var _x2 = display_get_gui_width()-530;
			var _y2 = 20;
			var _x3 = display_get_gui_width()-480;
			var _y3 = 110;
		
			var _color = #aa0000;
			draw_set_alpha(0.9);
			draw_triangle_color(_x1, _y1, _x2, _y2, _x3, _y3, _color,  _color,  _color, false);
			draw_triangle_color(_x1, _y1, _x2, _y2, _x3, _y3, _color,  _color,  _color, true);
			draw_rectangle_color(_x3, _y2, display_get_gui_width(), _y3, _color, _color, _color, _color, false);
			var _fmt = "[fnt_Arcade_Interlaced][c_white][fa_right][fa_middle][scale,0.3]";		
			scribble($"{_fmt}{self.levels[$ self.current_level_group][self.current_level].name}").draw(display_get_gui_width()-30, _y2+(_y3-_y2)/4);
			var _fmt = "[fnt_Arcade_Solid][c_white][fa_right][fa_middle][scale,0.5]";
			scribble($"{_fmt}{self.game_data.total_score}").draw(display_get_gui_width()-30, _y2+(_y3-_y2)*3/4-10);
			
			draw_set_alpha(1);
		
			var _x1 = display_get_gui_width()-480+self.am_variables.x_achievement;
			var _y1 = display_get_gui_height()-150;
			var _x2 = display_get_gui_width()-530+self.am_variables.x_achievement;
			var _y2 = display_get_gui_height()-150;
			var _x3 = display_get_gui_width()-480+self.am_variables.x_achievement;
			var _y3 = display_get_gui_height()-50;
		
			var _color = #aa0000;
			draw_triangle_color(_x1, _y1, _x2, _y2, _x3, _y3, _color,  _color,  _color, false);
			draw_triangle_color(_x1, _y1, _x2, _y2, _x3, _y3, _color,  _color,  _color, true);
			draw_rectangle_color(_x3, _y2, display_get_gui_width(), _y3, _color, _color, _color, _color, false);
			var _fmt = "[fnt_Arcade_Solid][#aaaaaa][fa_right][fa_middle][scale,0.22]";		
			scribble($"{_fmt}NEW ACHIEVEMENT UNLOCKED").draw(display_get_gui_width()-30+self.am_variables.x_achievement, _y2+(_y3-_y2)/4-5);
			var _fmt = "[fnt_Arcade_Solid][c_white][fa_right][fa_middle][scale,0.3]";
			scribble($"{_fmt}{self.achievement_text}").wrap(450).draw(display_get_gui_width()-30+self.am_variables.x_achievement, _y2+(_y3-_y2)*3/4-15);
		
		},
		leave: function() {}
	});
	self.fsm.add("Paused", {
		enter: function() {
			animation_pause_all();
			time_source_pause(time_source_game);
			with (cls_Enemy) self.path_speed = 0;
			
		},
		step: function() {
			if (InputPressed(INPUT_VERB.PAUSE)) self.fsm.trigger("Playing");
		},
		GUI: function() {
			var _x1 = display_get_gui_width()-800;
			var _y1 = 20
			var _x2 = display_get_gui_width()-880;
			var _y2 = 20;
			var _x3 = display_get_gui_width()-800;
			var _y3 = 110;
		
			var _color = #333333;
			draw_set_alpha(0.9);
			draw_triangle_color(_x1, _y1, _x2, _y2, _x3, _y3, _color,  _color,  _color, false);
			draw_triangle_color(_x1, _y1, _x2, _y2, _x3, _y3, _color,  _color,  _color, true);
			draw_rectangle_color(_x3, _y2, display_get_gui_width(), _y3, _color, _color, _color, _color, false);
			var _fmt = "[fnt_Arcade_Interlaced][c_white][fa_right][fa_middle][scale,0.3]";		
			scribble($"{_fmt}GAME PAUSED").draw(display_get_gui_width()-30, _y2+(_y3-_y2)/4);
			var _fmt = "[fnt_Arcade_Solid][c_white][fa_right][fa_middle][scale,0.3]";
			scribble($"{_fmt}PRESS [[P], [[ESC] OR [[SELECT] TO RESUME").draw(display_get_gui_width()-30, _y2+(_y3-_y2)*3/4-10);
			draw_set_alpha(1);
		},
		leave: function() {
			time_source_resume(time_source_game);
			animation_resume_all();
			with (obj_Chaser) self.path_speed = self.stats.speed;
			with (obj_Miner) self.path_speed = self.stats.speed;
			with (obj_Shooter) self.path_speed = self.stats.speed;
			with (obj_Dasher) self.path_speed = self.fsm.get_current_state_name() == "Dash" ? self.stats.dash_speed : self.stats.speed;
			
		}
	});
	self.fsm.add("Won", {
		enter: function() {},
		step: function() {},
		GUI: function() {},
		leave: function() {}
		
	});
	self.fsm.add("Lost", {
		enter: function() {},
		step: function() {
			
		},
		GUI: function() {},
		leave: function() {}
	});
	self.fsm.add("Lost_Screen", {
		enter: function() {
			if (Achoo.get_stat("HighScore").get_value() < self.game_data.total_score) {
				Achoo.get_stat("HighScore").set_value(self.game_data.total_score);
				if (Game.options.audio.sounds) audio_play_sound(snd_HighScore, 50, false);
				Achoo.save_stats("stats.dat");
			}
		},
		step: function() {
			
			if (InputPressed(INPUT_VERB.ACCEPT))	{
				self.start_level();
				self.fsm.trigger("Playing");
			}
			
			if (InputPressed(INPUT_VERB.PAUSE))	{
				time_source_destroy(time_source_game, true);
				self.fsm.trigger("Title Screen");
				room_goto(room_Menus);
			}
		},
		GUI: function() {
			var _w = 800;
			var _h = 800;
			var _x = (display_get_gui_width()-_w)/2;
			var _y = (display_get_gui_height()-_h)/2;
			
			draw_set_alpha(0.9);
			var _color = #222222;			
			draw_rectangle_color(_x, _y, _x+_w, _y+_h, _color, _color, _color, _color, false);
			draw_set_alpha(1);
			
			var _color = #333333;
			draw_rectangle_color(_x, _y, _x+_w, _y+_h, _color, _color, _color, _color, true);
			
			var _fmt = "[fnt_Arcade_Solid][fa_center][fa_middle][c_white][scale,0.5]";
			scribble($"{_fmt}Your greed ended here.").draw(display_get_gui_width()/2, _y + 100);
			
			var _fmt = "[fnt_Arcade_Interlaced][fa_center][fa_middle][#cccccc][scale,0.3]";
			scribble($"{_fmt}FINAL SCORE").draw(display_get_gui_width()/2, _y + 300);
			
			var _fmt = "[fnt_Arcade_Solid][fa_center][fa_middle][c_yellow][scale,0.85]";
			
			scribble($"{_fmt}{self.game_data.total_score}").draw(display_get_gui_width()/2, _y + 350);
			
			
			if (Achoo.get_stat("HighScore").get_value() == self.game_data.total_score) {
			//if (1==1) {
				var _fmt = "[fnt_Arcade_Interlaced][fa_center][fa_middle][rainbow][scale,0.3]";
				scribble($"{_fmt}NEW HIGH SCORE!!!").draw(display_get_gui_width()/2, _y + 400);
			}
			else {
				var _fmt = "[fnt_Arcade_Interlaced][fa_center][fa_middle][scale,0.3][#888888]";
				scribble($"{_fmt}HIGH SCORE: {Achoo.get_stat("HighScore").get_value()}").draw(display_get_gui_width()/2, _y + 400);
			}
			
			
			var _fmt = "[fnt_Arcade_Solid][fa_center][fa_middle][c_white][blink][scale,0.3]";
			scribble($"{_fmt}PRESS [[START] or [[ENTER] TO TRY AGAIN\nPRESS [[ESC] OR [[SELECT] FOR MAIN MENU").draw(display_get_gui_width()/2, _y+_h -100);
			
		},
		leave: function() {}
	});
	self.fsm.add_transition("Lost", "Lost_Screen", function() {
		return self.fsm.get_state_timer() >= 90;
	});
	
	self.fsm.init("Splash Screen");

#endregion


#region PPFX

	application_surface_draw_enable(false);

	var _effects = [
		new FX_Vignette(true,1,0.6,,,c_red),
	];

	self.fullscreen_fx = {
		renderer: new PPFX_Renderer(),
		main_profile: new PPFX_Profile("Fullscreen_Profile", _effects),
	};
	
	var _effects = [
		new FX_Bloom(true,,,,1),		
	];
	
	self.bloom_fx = {
		renderer: new PPFX_Renderer(),
		main_profile: new PPFX_Profile("Layer_Bloom_Profile", _effects),
	};

	self.bloom_fx.renderer.ProfileLoad(self.bloom_fx.main_profile);
	
#endregion

#region Levels

	function Level(_name) constructor {
		self.name = _name;
	}

	self.levels = {};
	self.levels[$ "Tutorial"] = [];
	self.levels[$ "Endless"] = [];
	
	array_push(self.levels[$ "Tutorial"], new Level("Tutorial"));
	array_push(self.levels[$ "Endless"], new Level("Endless Mode"));
	
	self.current_level_group = "Endless";
	self.current_level = 0;
	self.t = 0;
	
	self.orbs = [obj_Collectible_Chaser, obj_Collectible_Dasher, obj_Collectible_Miner, obj_Collectible_Shooter];
	self.waves = {
		score_threshold: [2000, 12000, 25000, 40000, 60000, 90000, 120000],
		probability: [ [1,0,0,0], [0.75,0.25,0,0], [0.6,0.2,0.15,0.05], [0.4,0.2,0.3,0.1], [0.4,0.2,0.2,0.2], [0.3,0.2,0.25,0.25], [0.25,0.25,0.25,0.25] ],
		cleanse_orb_enemy_threshold: [7, 10, 15, 20, 20, 25, 30],
		chaser_speed: [1, 2, 2.25, 2.5, 3, 3.5, 4],
		dasher_speed: [1.5, 2, 2.5, 3, 3.5, 4, 4.5],
		dasher_dash_speed: [4, 4.5, 5, 5.5, 6, 6.5, 7],
		miner_speed: [1, 1, 1, 1, 2, 2, 2.5],
		miner_mine_rate: [60*4, 60*3.5, 60*3, 60*3, 60*2.5, 60*2.5, 60*2],
		shooter_speed: [1,1,1,2,2,3,3],
		shooter_range: [128,128,128,192,192,256,256],
		shooter_rate: [60, 60, 60, 45, 45, 30, 30],
		
	};
	
	self.current_wave = 0;
	
#endregion


self.game_data = { // Data that needs to be saved and loaded
	total_score: 0,
};

self.type_collected = undefined;


#region Achievments
	
	self.achievement_text = "";
	
	self.init_achievement_animation = function(_achievement) {
		self.am_variables.x_achievement = 600;
		animation_add("Achievement_Animation_In", Game.am_variables, "x_achievement", 0, 120, curve_Expo);
		animation_add("Achievement_Animation_Out", Game.am_variables, "x_achievement", 600, 120, curve_ExpoInv);
		animation_add_after("Achievement_Animation_In", "Achievement_Animation_Out", 60*3);
		self.achievement_text = _achievement.get_description();
		animation_start("Achievement_Animation_In");
		
		if (Game.options.audio.sounds) audio_play_sound(snd_Achievement, 50, false);
		Achoo.save_achievements("achievements.dat");
	}
	
	new Achievement(, function() { return Game.game_data.total_score >= 100; }, "Noob Collector", "Collect your first orb",,,,,self.init_achievement_animation);
	new Achievement(, function() { return Game.game_data.total_score >= 15000; }, "Actually played the game", "Score 15,000 points in a run",,,,,self.init_achievement_animation);
	new Achievement(, function() { return Game.game_data.total_score >= 10000; }, "Apprentice Collector", "Score 10,000 points in a game session",,,,,self.init_achievement_animation);
	new Achievement(, function() { return Game.game_data.total_score >= 50000; }, "Journeyman Collector", "Score 50,000 points in a game session",,,,,self.init_achievement_animation);
	new Achievement(, function() { return Game.game_data.total_score >= 100000; }, "Master Collector", "Score 100,000 points in a game session",,,,,self.init_achievement_animation);
	new Achievement(, function() { return Game.game_data.total_score >= 200000; }, "Game Junkie", "Score 200,000 points in a game session",,,,,self.init_achievement_animation);
	new Achievement(, function() { return instance_number(obj_Dasher) >= 1; }, "Speed Demon", "Discover the Dasher shadow",,,,,self.init_achievement_animation);
	new Achievement(, function() { return instance_number(obj_Miner) >= 1; }, "Tricky Bastard", "Discover the Miner shadow",,,,,self.init_achievement_animation);
	new Achievement(, function() { return instance_number(obj_Shooter) >= 1; }, "OP", "Discover the Shooter shadow",,,,,self.init_achievement_animation);
	new Stat("OrbsCollected", 0, "Historical orbs collected");
	new Achievement(, function() { return Achoo.get_stat("OrbsCollected").get_value() >= 10; }, "LD Jammer", "Pick up 10 orbs all-time",,,,,self.init_achievement_animation);
	new Achievement(, function() { return Achoo.get_stat("OrbsCollected").get_value() >= 50; }, "Gobbler", "Pick up 50 orbs all-time",,,,,self.init_achievement_animation);
	new Achievement(, function() { return Achoo.get_stat("OrbsCollected").get_value() >= 100; }, "Devourer", "Pick up 100 orbs all-time",,,,,self.init_achievement_animation);
	new Achievement(, function() { return Achoo.get_stat("OrbsCollected").get_value() >= 200; }, "Greedy", "Pick up 200 orbs all-time",,,,,self.init_achievement_animation);
	new Achievement(, function() { return Achoo.get_stat("OrbsCollected").get_value() >= 1000; }, "Addict", "Pick up 1000 orbs all-time",,,,,self.init_achievement_animation);
	new Stat("HighScore", 0, "High score");
	
	// Create backup for clear
	if (file_exists("default_achievements.dat")) file_delete("default_achievements.dat");
	Achoo.save_achievements("default_achievements.dat");
	if (file_exists("default_stats.dat")) file_delete("default_stats.dat");
	Achoo.save_stats("default_stats.dat");
	
	
	// Load from file
	if (file_exists("achievements.dat")) Achoo.load_achievements("achievements.dat");
	if (file_exists("stats.dat")) Achoo.load_stats("stats.dat");
	
	
#endregion



self.start_level = function(_level_group = self.current_level_group, _level = self.current_level, _seed = undefined) {
	
	self.selected_menu_option = 0;
	
	var _room = asset_get_index(string($"room_Level_{_level_group}_{_level}"));
	room_goto(_room);
	
	if (_seed != undefined) random_set_seed(self.seed);
	
	call_later(1, time_source_units_frames, function() {
		self.t = 0;
		self.current_wave = 0;
		self.type_collected = undefined;
		
		var _camera_move_smoothness = Camera.move_smoothness;
		Camera.move_smoothness = 0;
		call_later(10, time_source_units_frames, method({_camera_move_smoothness}, function() {
			Camera.move_smoothness = _camera_move_smoothness;
		}), false);
		
		// Reinitialize game data
		self.game_data.total_score = 0;
	
		self.bloom_fx.renderer.LayerApply(layer_get_id("lyr_Instances"));
		
		instance_create_layer(room_width/2, room_height/2, "lyr_Player", obj_Player);
		layer_set_visible(layer_get_id("lyr_Tile_Collision"), false);
		
		// Pathfinding Grid
		try {
			mp_grid_destroy(self.grid);
		}
		catch (_exception) {}
		
		var _grid_size = 16;
		self.grid = mp_grid_create(0, 0, room_width div _grid_size, room_height div _grid_size, _grid_size, _grid_size);
		mp_grid_add_instances(self.grid, cls_Wall, true);
		var _tile_size = 16;
		for (var _col = 0; _col <= room_width div _tile_size; _col++) {
			for (var _row = 0; _row <= room_height div _tile_size; _row++) {
				if (tilemap_get_at_pixel(layer_tilemap_get_id(layer_get_id("lyr_Tile_Collision")), _tile_size*_col, _tile_size*_row) == 1) {
					mp_grid_add_cell(self.grid, _col, _row);
				}
			}
		}
		
		time_source_destroy(time_source_game, true);
		
		self.ts = time_source_create(time_source_game, 60*4, time_source_units_frames, function() {
			
			if (obj_Player.fsm.get_current_state_name() != "Die") {
			
				if (instance_number(cls_Collectible)<20) {
					do {
						var _x = irandom_range(64, room_width-64);
						var _y = irandom_range(64, room_height-64);
				
						var _id = instance_nearest(_x, _y, cls_Enemy);
					}
					until (!position_meeting(_x, _y, cls_Collisionable) && !collision_circle(_x, _y, 32, cls_Wall, false, false) && !position_meeting(_x, _y, cls_Collectible) & (_id == noone || point_distance(_x, _y, _id.x, _id.y) > 128));
			
				
					var _rnd_orb = array_random(Game.orbs, Game.waves.probability[Game.current_wave]);
					if (instance_number(cls_Enemy) >= Game.waves.cleanse_orb_enemy_threshold[Game.current_wave] && instance_number(obj_Collectible_Cleanse) == 0) _rnd_orb = obj_Collectible_Cleanse;
					instance_create_layer(_x, _y, "lyr_Instances", _rnd_orb);
				}
			
			}
			
		}, [], -1, time_source_expire_nearest);
		time_source_start(self.ts);
		
		self.target_score = 0;
		self.ts_target_score = time_source_create(time_source_game, 1, time_source_units_frames, function() {
			if (self.game_data.total_score < self.target_score) {
				self.game_data.total_score += self.type_collected != undefined ? 100 : 10;
			}
			else {
				self.target_score = 0;
				self.type_collected = undefined;
			}	
		}, [], -1, time_source_expire_nearest);
		
		time_source_start(self.ts_target_score);
		
	}, false);
};
	
scribble_font_set_default("fnt_Test");



#region Particle System

	//ps_Main
	self.ps = part_system_create();
	part_system_draw_order(self.ps, true);


	part_system_position(self.ps, 0, 0);
	


#endregion	


draw_set_circle_precision(64);