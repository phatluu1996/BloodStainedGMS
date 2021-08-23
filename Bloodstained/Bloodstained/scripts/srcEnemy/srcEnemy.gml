function draw_enemy(){
	if(isHit){
		shader_set(shd_hit_flash);
		draw_self();
	    shader_reset();
	}else{
		draw_self();
	}
}

function enenmyHit(){
	if(isHit){
		isHit--;
	}
}

function EnemyStepEvent(){
	switch (state) {
	    case ENEMY_STATE.ENABLE:
	        if(inside_view()){
				switch (object_index) {
				    case objLizardMan:
				        LizardManStepEvent();
				        break;
				    default:
				        // code here
				        break;
				}
			}else{
				x = xstart;
				y = ystart;
				visible = false;
				state = ENEMY_STATE.DISABLE
			}
	        break;
			
		case ENEMY_STATE.DISABLE:
		case ENEMY_STATE.DEAD:
		    x = xstart;
			y = ystart;
			visible = false;
	        if(!inside_view()){
				state = ENEMY_STATE.OUTSIDE_VIEW;
			}
	        break;
			
		case ENEMY_STATE.OUTSIDE_VIEW:
	        if(inside_view()){
				instance_create_depth(xstart, ystart, depth, object_index);	
				instance_destroy();
			}
	        break;
	    default:
	        // code here
	        break;
	}
}

function LizardManStepEvent(){
	switch (action) {
		case LIZARDMAN_ACTION.IDLE:			
			if(collision_rectangle(bbox_left - 80, bbox_top, bbox_right + 80, bbox_bottom, objPrtPlayer, false, true) >= 0){
				action = LIZARDMAN_ACTION.ATTACK;
				image_index = 0;							
			}
			turn_to_player();
			sprite_index = enemy_lizard_man_idle;	
			break;
		
	    case LIZARDMAN_ACTION.ATTACK:			
			sprite_index = enemy_lizard_man_attack;	
			if(image_index >= 6){
				hsp = image_xscale * 3;	
			}
			if(animation_end_ext(enemy_lizard_man_attack, image_index, image_speed)){
				timer0 = 6 * abs(x - xstart)/3;
				hsp = 0;
				action = LIZARDMAN_ACTION.BACK;	
			}
			break;
			
		case LIZARDMAN_ACTION.BLOCK:
			sprite_index = enemy_lizard_man_block;
			isBlock = true;						
			turn_to_player();
			if(animation_end_ext(enemy_lizard_man_block, image_index, image_speed)){
				image_index = image_number - 1;
				timer0++;
				if(timer0 >= room_speed / 2){
					timer0 = 0;
					isBlock = false;
					action = LIZARDMAN_ACTION.IDLE;
				}
			}
			break;
			
		case LIZARDMAN_ACTION.BACK:
			timer0--;
			hsp = -image_xscale * 0.5;
			if(timer0 <= 0){
				x = xstart;
				timer0 = 0;
				action = LIZARDMAN_ACTION.BLOCK;
				hsp = 0;
			}
			sprite_index = enemy_lizard_man_move;
			break;
			
		case LIZARDMAN_ACTION.WAIT:
			sprite_index = enemy_lizard_man_idle;	
			timer0++;
			if(timer0 >= room_speed / 2){
				timer0 = 0;
				action = LIZARDMAN_ACTION.IDLE;
			}
			break;
	   
	}
	enenmyHit();
	horizone_collision();
	x+=hsp;
	vertical_collision();
	y+=vsp;
}



