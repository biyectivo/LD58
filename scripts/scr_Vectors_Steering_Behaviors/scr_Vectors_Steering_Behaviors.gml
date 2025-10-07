/// Vector Script Functions


//Main Vector Struct
function vector(_x, _y) constructor {
	x = _x;
	y = _y;
	
	static set = function(_x, _y) {
		x = _x;
		y = _y;
	}	
	
	static add = function(_vector) {
		gml_pragma("forceinline");
		x += _vector.x;
		y += _vector.y;
	}
	
	static subtract = function(_vector) {
		gml_pragma("forceinline");
		x -= _vector.x;
		y -= _vector.y;
	}
		
	static negate = function() {
		x = -x;
		y = -y;
	}
		
	static multiply = function(_scalar) {
		gml_pragma("forceinline");
		x *= _scalar;
		y *= _scalar;
	}
	
	static divide = function(_scalar) {
		x /= _scalar;
		y /= _scalar;
	}
      
	static get_magnitude = function() {
		gml_pragma("forceinline");
		return point_distance(0, 0, x, y);
    }
	
	static get_direction = function() {
		gml_pragma("forceinline");
		return point_direction(0, 0, x, y);
	}

	static normalize = function() {
		gml_pragma("forceinline");
		if ((x != 0) || (y != 0)) {
			var _factor = 1/sqrt((x * x) + (y * y));
			x = _factor * x;
			y = _factor * y;	
		}
	}
	
	static set_magnitude = function(_scalar) {
		gml_pragma("forceinline");
		normalize();
		multiply(_scalar);	
	}	
	
	static limit_magnitude = function(_limit) {
		gml_pragma("forceinline");
		if (get_magnitude() > _limit) {
			set_magnitude(_limit);
		}
	}

	static copy = function(_vector) {
		x = _vector.x;
		y = _vector.y;
	}

}

//Children/Extensions of the Main Vector Struct
function vector_zero() : vector() constructor {
    x = 0;
    y = 0;
}

function vector_random(_length = 1) : vector() constructor {
	var _dir = random(360);
    x = lengthdir_x(_length, _dir);
    y = lengthdir_y(_length, _dir);
}

function vector_lengthdir(_length, _dir) : vector() constructor {
    x = lengthdir_x(_length, _dir);
    y = lengthdir_y(_length, _dir);
}

//Vector Functions Don't Modify the Original Vector
function vector_copy(_vector) {
	return new vector(_vector.x, _vector.y);
}

function vector_subtract(_vector_a, _vector_b) {
	return new vector((_vector_a.x - _vector_b.x), (_vector_a.y - _vector_b.y));
}

/// Steering Behavior Script Functions

function apply_force(_force, _weight = 1) {
	gml_pragma("forceinline");
	_force.multiply(_weight);
	steering_forces.add(_force);
}

function seek_force(_x, _y) {	
	var _vec = new vector(_x, _y);
	_vec.subtract(position);
	_vec.set_magnitude(max_speed);
	_vec.subtract(velocity);
	_vec.limit_magnitude(max_force);
	return _vec;
}

function flee_force(_x, _y) {	
	var _vec = new vector(_x, _y);
	_vec.subtract(position);
	_vec.set_magnitude(max_speed);
	_vec.negate();
	_vec.subtract(velocity);
	_vec.limit_magnitude(max_force);
	return _vec;
}

function pursue_force(_inst) {
	var _vec = vector_copy(_inst.velocity);
	_vec.multiply(30);
	_vec.add(_inst.position);
	return seek_force(_vec.x, _vec.y);
}

function evade_force(_inst) {
	var _vec = vector_copy(_inst.velocity);
	_vec.multiply(30);
	_vec.add(_inst.position);
	return flee_force(_vec.x, _vec.y);
}

function arrive_force(_x, _y, _slowing_radius) {	
	var _vec = new vector(_x, _y);
	_vec.subtract(position);
	
	var _dist = _vec.get_magnitude();
	if (_dist > _slowing_radius) {
		_vec.set_magnitude(max_speed);	
	} else {
		_vec.set_magnitude(max_speed * (_dist/_slowing_radius));
	}

	_vec.subtract(velocity);
	_vec.limit_magnitude(max_force);
	return _vec;
}

function wander_force() {

	var _vec = vector_copy(velocity);
	_vec.set_magnitude(wander_distance);
	_vec.add(new vector_lengthdir(wander_power, image_angle + wander_angle));
	_vec.limit_magnitude(max_force);

	wander_angle +=  random_range(-wander_change, wander_change);

	return _vec;

}

function align_force(_obj = object_index, _max_dist = 200) {
	var _vec, _count;
	_vec = new vector_zero();
	_count = 0;
	
	with (_obj) {
		
		if (id == other.id) continue;
		if (point_distance(position.x, position.y, other.position.x, other.position.y) > _max_dist) continue;
		
		_vec.add(velocity);
		_count += 1;
	}
	
	if (_count > 0) {
		_vec.set_magnitude(max_force);
	}
	
	return _vec;

}

function cohesion_force(_obj = object_index, _max_dist = 200) {
	gml_pragma("forceinline");
	var _vec, _count;
	_vec = new vector_zero();
	_count = 0;
	
	with (_obj) {
		
		if (id == other.id) continue;
		if (point_distance(position.x, position.y, other.position.x, other.position.y) > _max_dist) continue;
		
		_vec.add(position);
		_count += 1;
	}
	
	if (_count > 0) {
		_vec.divide(_count);
		_vec = seek_force(_vec.x, _vec.y);
	}
	
	return _vec;

}

function separation_force(_obj = object_index, _max_dist = 200) {
	gml_pragma("forceinline");
	var _vec, _count, _vec_to;
	_vec = new vector_zero();
	_count = 0;
	
	with (_obj) {
		
		if (id == other.id) continue;
		if (point_distance(position.x, position.y, other.position.x, other.position.y) > _max_dist) continue;
		
		_vec_to = vector_subtract(other.position, position);
		var _dist = min(_vec_to.get_magnitude(), 200);
		var _scale = (1 - (_dist/200));
		_vec_to.multiply(_scale);
		_vec.add(_vec_to);
		_count += 1;
	}
	
	if (_count > 0) {
		_vec.set_magnitude(max_force);
	}
	
	return _vec;

}

function flocking_force(_obj = object_index, _align_dist = 200, _cohesion_dist = 200, _separation_dist = 200) {

	var _velocity_sum, _position_sum, _flee_sum, _a_count, _c_count, _s_count, _vec_to, _dist_to;
	_velocity_sum = new vector_zero();
	_position_sum = new vector_zero();
	_flee_sum = new vector_zero();
	_a_count = 0;
	_c_count = 0;
	_s_count = 0;
	
	
	with (_obj) {
		
		if (id == other.id) continue;
		

		_dist_to = point_distance(position.x, position.y, other.position.x, other.position.y);
		
		if (_dist_to < _align_dist) {
			_velocity_sum.add(velocity);
			_a_count += 1;
		}
		
		if (_dist_to < _cohesion_dist) {
			_position_sum.add(position);
			_c_count += 1;
		}
		
		if (_dist_to < _separation_dist) {
			_vec_to = vector_subtract(other.position, position);
			_vec_to.multiply(1 - (_dist_to/_separation_dist));
			_flee_sum.add(_vec_to);
			_s_count += 1;
		}
		
	}
	
	if (_a_count > 0) {
		_velocity_sum.set_magnitude(max_force);
	}
	if (_c_count > 0) {
		_position_sum.divide(_c_count);
		_position_sum = seek_force(_position_sum.x, _position_sum.y);
	}
	if (_s_count > 0) {
		_flee_sum.set_magnitude(max_force);
	}
	
	_velocity_sum.add(_position_sum);
	_velocity_sum.add(_flee_sum);

	return _velocity_sum;

}


function align_force_list(_array) {
	
	var _vec, _count;
	_vec = new vector_zero();
	_count = 0;
	
	for (var i = 0; i < array_length(_array); i += 1) {
		_vec.add(_array[i].velocity);
		_count += 1;	
	}


	if (_count > 0) {
		_vec.set_magnitude(max_force);
	}
	
	return _vec;

}

function cohesion_force_list(_array) {
	
	var _vec, _count;
	_vec = new vector_zero();
	_count = 0;
	
	for (var i = 0; i < array_length(_array); i += 1) {		
		_vec.add(_array[i].position);		
		_count += 1;
	}
	
	if (_count > 0) {
		_vec.divide(_count);
		_vec = seek_force(_vec.x, _vec.y);
	}
	
	return _vec;

}

function separation_force_list(_array) {
	
	var _vec, _count, _vec_to;
	_vec = new vector_zero();
	_count = 0;
	
	for (var i = 0; i < array_length(_array); i += 1) {		
		_vec_to = vector_subtract(position, _array[i].position);
		var _dist = min(_vec_to.get_magnitude(), 200);
		var _scale = (1 - (_dist/200));
		_vec_to.multiply(_scale);
		_vec.add(_vec_to);
		_count += 1;
	}
	
	if (_count > 0) {
		_vec.set_magnitude(max_force);
	}
	
	return _vec;

}

