function animation_end(){
	return image_index + image_speed >= image_number - 1;	
}

function animation_end_ext(argument0, argument1, argument2){
	/// @description animation_end(sprite_index,image_index, rate)
	/// @param {real} <sprite_index> The index of the sprite being animated
	/// @param {real} <image_index> The current frame value
	/// @param {real} <rate> -See Below-
	///     The rate of change in frames per step if not
	///     using built in image_index/image_speed.  
	///     Don't use if you don't think you need this.  You probably don't.
 
	//returns true if the animation will loop this step.
 
	//Script courtesy of PixellatedPope & Minty Python from the GameMaker subreddit discord 
	//https://www.reddit.com/r/gamemaker/wiki/discord
 
	var _sprite=sprite_index;
	var _image=image_index;
	if(argument_count > 0)   _sprite=argument0;
	if(argument_count > 1)  _image=argument1;
	var _type=sprite_get_speed_type(sprite_index);
	var _spd=sprite_get_speed(sprite_index)*image_speed;
	if(_type == spritespeed_framespersecond)
	    _spd = _spd/room_speed;
	if(argument_count > 2) _spd=argument2;
	return _image+_spd >= sprite_get_number(_sprite);
}

function draw_hp_bar(){
	camera_x = camera_get_view_x(view_camera[0]);
	camera_y = camera_get_view_y(view_camera[0]) + 8;
	draw_sprite(ui_player_hp_bar_head, 0, camera_x + 8, camera_y);
	for (var i = 0; i <= hpLimit; ++i) {
	    draw_sprite(ui_player_hp_bar_body, 0, camera_x + 16 + i * 2, camera_y + 2);
		if(i <= hp){
			draw_sprite(ui_player_hp_unit, 0, camera_x + 16 + i * 2, camera_y + 3);
		}else{
			draw_sprite(ui_player_hp_loss_unit, 0, camera_x + 16 + i * 2, camera_y + 3);
		}
	}	
	draw_sprite(ui_player_hp_bar_tail, 0, camera_x + 15 + (hpLimit + 1) * 2, camera_y + 1);
}

function draw_mp_bar(){
	camera_x = camera_get_view_x(view_camera[0]);
	camera_y = camera_get_view_y(view_camera[0]) + 16;
	draw_sprite(ui_player_hp_bar_head, 0, camera_x + 8, camera_y);
	for (var i = 0; i <= mpLimit; ++i) {
	    draw_sprite(ui_player_hp_bar_body, 0, camera_x + 16 + i * 2, camera_y + 2);
		if(i <= mp){
			draw_sprite(ui_player_mp_unit, 0, camera_x + 16 + i * 2, camera_y + 3);
		}else{
			draw_sprite(ui_player_mp_loss_unit, 0, camera_x + 16 + i * 2, camera_y + 3);
		}
	}	
	draw_sprite(ui_player_hp_bar_tail, 0, camera_x + 15 + (mpLimit + 1) * 2, camera_y + 1);
}

function inside_view(){
	return (bbox_right > camera_get_view_x(view_camera[0])) && (bbox_left < camera_get_view_x(view_camera[0]) + camera_get_view_width(view_camera[0])) && (bbox_bottom > camera_get_view_y(view_camera[0])) && (bbox_top < camera_get_view_y(view_camera[0]) + camera_get_view_height(view_camera[0]))
}

function wave(from, to, duration, offset){
	//Wave(from, to, duration, offset)
 
	// Returns a value that will wave back and forth between [from-to] over [duration] seconds
	// Examples
	//      image_angle = Wave(-45,45,1,0)  -> rock back and forth 90 degrees in a second
	//      x = Wave(-10,10,0.25,0)         -> move left and right quickly
 
	// Or here is a fun one! Make an object be all squishy!! ^u^
	//      image_xscale = Wave(0.5, 2.0, 1.0, 0.0)
	//      image_yscale = Wave(2.0, 0.5, 1.0, 0.0)
 
	a4 = (to - from) * 0.5;
	return from + a4 + sin((((current_time * 0.001) + duration * offset) / duration) * (pi*2)) * a4;	
}

function horizone_collision(){
	if(place_meeting(x + hsp, y, objPrtCollisionCube)){ //Check at object + vsp in y axis in the next frame
		while(!place_meeting(x + sign(hsp), y, objPrtCollisionCube)){
			x+=sign(hsp);
		}
		hsp = 0;
	}
}

function vertical_collision(){
	if(place_meeting(x, y + vsp, objPrtCollisionCube)){ //Check at object + vsp in y axis in the next frame
		while(!place_meeting(x, y + sign(vsp), objPrtCollisionCube)){
			y+=sign(vsp);
		}
		vsp = 0;
	}
}

function turn_to_player(){
	if(objPrtPlayer.x >	x){
		image_xscale = 1;	
	}else{
		image_xscale = -1;	
	}
}

function draw_player(){
	draw_mp_bar();
	draw_hp_bar();
	if(isHit){
		shader_set(shd_hit_flash);		
		draw_self();
	    shader_reset();
	}else{
		draw_self();	
	}
}

function create_box_attack_collision_effect(_sprite, obj){
	if(instance_exists(obj)){
		with obj {	
			var xs = ds_list_create();
			var ys =  ds_list_create();
			for (var i = bbox_top; i <= bbox_top + sprite_height; ++i) {
			    //for (var j = obj.bbox_left; j <= obj.bbox_left + obj.sprite_width; ++j) {
				//    if(collision_point(j, i, objPrtPlayerWeapon, true, false) >= 0){
				//		ds_list_add(xs, j);
				//		ds_list_add(ys, i);
				//	}
				//}
				var point = collision_line_first(bbox_left-1,i, bbox_left + sprite_width+1, i, objPrtPlayerWeapon, true, true);
				if(point[0] >= 0){
					ds_list_add(xs, point[1]);
					ds_list_add(ys, point[2]);
				}
			}
	
			var firstX = ds_list_find_value(xs, 0);
			var firstY = ds_list_find_value(ys, 0);
			var lastY = ds_list_find_value(ys, ds_list_size(ys)-1);
			if(ds_list_size(xs) > 0 && ds_list_size(ys)){
				if(!isBlock){
					create_attack_impact_effect(firstX, (firstY + lastY)/2);
				}else{
					create_attack_block_effect(firstX, (firstY + lastY)/2);
				}
			}
		}
	}
}

function collision_line_first(x1, y1, x2, y2, obj, prec, notme){
	/// @function               collision_line_first(x1, y1, x2, y2, obj, prec, notme)
	/// @param  {real}  x1      The X coordinate to start the line check from
	/// @param  {real}  y1      The Y coordinate to start the line check from
	/// @param  {real}  x2      The X coordinate to end the line check at
	/// @param  {real}  y2      The Y coordinate to end the line check at
	/// @param  {id}    obj     The object index to check for a collision with
	/// @param  {bool}  prec    Whether to use precise collision checking or not
	/// @param  {bool}  notme   Whether to exclude the calling instance from the check or not

	/// @description                This script works the same as the collision_line function/action   
	///                         only it will return the ID of the first instance found to be in 
	///                         collision as well as the X/Y position of the actual collision point.
	///                         This information is returned as an array where:
	///
	///                             [0] = Instance ID of the found instance, or -1 if none are found
	///                             [1] = The x position of the collision
	///                             [2] = The y position of the collision
	///

	// Declare internals
	var dx = 0;
	var dy = 0;
	var return_array = array_create(3, -1);

	// Get the first hit
	var first_instance = collision_line(x1, y1, x2, y2, obj, prec, notme);

	// If hit find the exact hit
	if instance_exists(first_instance)
	    {
	    // Get x and y segment lengths
	    dx = x2 - x1;
	    dy = y2 - y1;
	    // Perform check while distances are greater or equal to 1
	    while (abs(dx) >= 1 or abs(dy) >= 1)
	        {
	        // Divide the modifier distance by 2 every iteration
	        dx /= 2;
	        dy /= 2;
	        // Check the new collision line modified by pulling back the end of the hit line by half the distance each loop.
	        var new_instance = collision_line(x1, y1, x2 - dx, y2 - dy, obj, prec, notme);
	        // If we still hit the instance we didn't move back far enough to get outside of it.
	        if (new_instance != noone)
	            {
	            //set the found instance to what we hit, and pull back the line end by the current modifier
	            first_instance = new_instance;
	            x2 -= dx;
	            y2 -= dy;
	            }
	        }
	    }
	else first_instance = -1;

	// Set return array
	return_array[0] = first_instance;
	return_array[1] = x2 - dx;
	return_array[2] = y2 - (dy * 2);

	return return_array;	
}



