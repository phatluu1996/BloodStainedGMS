function animation_end(){
	return image_index + image_speed >= image_number - 1;
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


