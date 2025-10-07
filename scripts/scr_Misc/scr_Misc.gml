//#macro game_restart __game_restart

function __game_restart() {
	with(all) {
		if (!persistent) {
			instance_destroy();	
		}
	}
	
	instance_destroy(Game);
	instance_destroy(Achoo);
	time_source_destroy(time_source_game, true);
	global.animatron_animations = {};
	
	audio_stop_all();
	draw_texture_flush();
	
	room_goto(room_first);
}


function file_save(_struct, _filename, _overwrite=false) {
	try {
		if ((file_exists(_filename) && _overwrite) || !file_exists(_filename)) {
			var _buffer = buffer_create(1, buffer_grow, 1);
			var _json = json_stringify(_struct, true);
			buffer_write(_buffer, buffer_string, _json);
			buffer_save(_buffer, _filename);
			buffer_delete(_buffer);
			return true;
		}
		else {
			show_debug_message($"WARNING: Not saved, file {_filename} already exists");
			return false;
		}
	}
	catch (_exception) {
		show_debug_message($"WARNING: Could not save data in {_filename}");
		return false;
	}
}

function file_load(_filename) {
	try {
		if (file_exists(_filename)) {
			var _buffer = buffer_load(_filename);
			var _string = buffer_read(_buffer, buffer_string);
			var _struct = json_parse(_string);
			buffer_delete(_buffer);
			return _struct;
		}
		else {
			show_debug_message($"WARNING: Not loaded, file {_filename} does not exist");
		}
	}
	catch (_exception) {
		show_debug_message($"WARNING: Could not load data from file {_filename}");	
	}
}