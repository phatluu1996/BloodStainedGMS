//Keyboard input
key_left = keyboard_check(ord("A")); //Check action press "A"
key_right = keyboard_check(ord("D")); //Check action press "D"
key_down = keyboard_check(ord("S")); //Check action press "S"
key_jump = keyboard_check(vk_space); //Check action press space_bar

//State machine
switch (state) {
    case HACHI_STATE.IDLE:
	
	//Check action
		if((key_left || key_right) && !place_meeting(x + (key_right - key_left), y, objHachiCollisionCube)){
			state = HACHI_STATE.RUN;
		}
				
		if(key_down){
			state = HACHI_STATE.CROUCH;
		}
		
		if(key_jump){
			vsp = -JumpSpd;
			state = HACHI_STATE.JUMP;
		}
		
	//Set sprite
		sprite_index = player_hachi_idle;
		
        break;
		
	case HACHI_STATE.RUN:
	
		hsp = (key_right - key_left)*runSpd;
		
	//Check action
		if(!(key_left || key_right)){
			state = HACHI_STATE.IDLE;
		}
		
		if(key_jump){
			vsp = -JumpSpd;
			state = HACHI_STATE.JUMP;
		}
		
		if(key_down){
			state = HACHI_STATE.CROUCH;
			hsp = 0;
		}
		
		if(place_meeting(x + hsp, y, objHachiCollisionCube)){
			state = HACHI_STATE.IDLE;
		}
		
		
		
		if(key_left){
			image_xscale = -1;
		}else if(key_right){
			image_xscale = 1;
		}
	
	//Set sprite
		sprite_index = player_hachi_run;
		
        break;
		
	case HACHI_STATE.CROUCH:
	
	//Check action
		if(!key_down){
			state = HACHI_STATE.IDLE;
		}else if(!key_down && (key_left || key_right)){
			state = HACHI_STATE.RUN;
		}
		
	//Set sprite	
		sprite_index = player_hachi_crouch;
		
        break;
		
	case HACHI_STATE.JUMP:
		vsp += gravSpd;
		
		if(key_left){
			image_xscale = -1;
		}else if(key_right){
			image_xscale = 1;
		}
		
		if(!key_jump || vsp >= 0){
			state = HACHI_STATE.FALL;
			vsp = 0;
		}
	
	//Set sprite
		sprite_index = player_hachi_jump;
		
        break;
		
	case HACHI_STATE.FALL:
		vsp += gravSpd;
		
		if(key_left){
			image_xscale = -1;
		}else if(key_right){
			image_xscale = 1;
		}
		
		if(place_meeting(x, y + vsp, objHachiCollisionCube)){
			state = hsp != 0 ? HACHI_STATE.RUN : HACHI_STATE.IDLE;
		}
	
	//Set sprite
		sprite_index = player_hachi_fall;
		
        break;
		
		
    default:
        break;
}


//Collistion

//Update X,Y
if(place_meeting(x + hsp, y, objHachiCollisionCube)){
	while(!place_meeting(x + sign(hsp), y, objHachiCollisionCube)){
		x += sign(hsp);
	}
	hsp = 0;
}
x += hsp;


if(place_meeting(x, y + vsp, objHachiCollisionCube)){
	while(!place_meeting(x, y + sign(vsp), objHachiCollisionCube)){
		y += sign(vsp);
	}
	vsp = 0;
}

y += vsp;