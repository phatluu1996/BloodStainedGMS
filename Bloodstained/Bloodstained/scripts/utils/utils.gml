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
	camera_y = camera_get_view_y(view_camera[0]);
	draw_sprite(ui_player_hp_bar_head, 0, camera_x + 8, camera_y + 8);
	for (var i = 0; i < hpLimit; ++i) {
	    draw_sprite(ui_player_hp_bar_body, 0, camera_x + 20 + i * 4, camera_y + 9);
		if(i <= hp){
			draw_sprite(ui_player_hp_unit, 0, camera_x + 20 + i * 4, camera_y + 10);
		}else{
			draw_sprite(ui_player_hp_loss_unit, 0, camera_x + 20 + i * 4, camera_y + 10);
		}
	}
	draw_sprite(ui_player_hp_bar_tail, 0, camera_x + 20 + hpLimit * 4, camera_y + 9);
}

function draw_mp_bar(){
	camera_x = camera_get_view_x(view_camera[0]);
	camera_y = camera_get_view_y(view_camera[0]);
	draw_sprite_ext(ui_player_hp_bar_tail, 0, camera_x + 21, camera_y + 18, -1, 1, 0, c_white, 1);
	for (var i = 0; i < mpLimit; ++i) {
	    draw_sprite(ui_player_hp_bar_body, 0, camera_x + 20 + i * 4, camera_y + 18);
		if(i <= mp){
			draw_sprite(ui_player_mp_unit, 0, camera_x + 20 + i * 4, camera_y + 19);
		}else{
			draw_sprite(ui_player_mp_loss_unit, 0, camera_x + 20 + i * 4, camera_y + 19);
		}
	}
	draw_sprite(ui_player_hp_bar_tail, 0, camera_x + 20 + hpLimit * 4, camera_y + 18);
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



