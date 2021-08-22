//Input: keyboard input
//key_left = keyboard_check(vk_left); //check if left arrow key is hold
//key_right = keyboard_check(vk_right); //check if left arrow right is hold
//key_down = keyboard_check(vk_down); //check if left arrow down is hold
//key_jump = keyboard_check(vk_up);  //check if left arrow up is hold
key_left = keyboard_check(ord("A")); 
key_right = keyboard_check(ord("D"));
key_down = keyboard_check(ord("S")); 
key_jump = keyboard_check(ord("K")); 

key_attack = keyboard_check(ord("J")); 


//State machine
switch (state) {
    case MIRIAM_STATE.IDLE:
        if((key_left || key_right) && !place_meeting(x + (key_right - key_left), y, objMiriamCollisionCube)){ // if key left/right press and not hit wall
			state = MIRIAM_STATE.RUN;
		}				
		if(key_down){
			state = MIRIAM_STATE.CROUCH;
			mask_index = player_miriam_crouch_mask;
		}
		if(key_jump){
			vsp = -JumpSpd;	
			state = MIRIAM_STATE.JUMP;
		}
		
		if(!place_meeting(x, y + 1, objMiriamCollisionCube)){
			state = MIRIAM_STATE.FALL; // move to crouch state
		}
		
		if(key_attack && !isAttack){
			isAttack = true;	
		}
		
		if(isAttack){
			sprite_index = player_miriam_idle_whip_attack; //swicth animation to 'player_miriam_idle_whip_attack'
			if(animation_end()){
				isAttack = false;	
			}
		}else{
			sprite_index = player_miriam_idle; //swicth animation to 'player_miriam_idle'
		}	
        break;
		
	case MIRIAM_STATE.RUN:
		hsp = (key_right - key_left) * runSpd; //calculate hsp 
        if(!(key_left || key_right) || place_meeting(x + hsp, y, objMiriamCollisionCube)){// !(key_left || key_right) <=> !key_left && !key_right
			state = MIRIAM_STATE.IDLE;
		}	
		if(key_left){
			image_xscale = -1;
		}else if(key_right){
			image_xscale = 1;
		}		
		if(key_down){//if user pres keydown
			state = MIRIAM_STATE.CROUCH; // move to crouch state
			hsp = 0; //stop moving when moving to crouch state
		}		
		
		if(!place_meeting(x, y + 1, objMiriamCollisionCube)){
			state = MIRIAM_STATE.FALL; // move to crouch state
		}
		
		if(key_jump){
			vsp = -JumpSpd;	
			state = MIRIAM_STATE.JUMP;
		}
		sprite_index = player_miriam_run; //swicth animation to 'player_miriam_run'
        break;
		
	case MIRIAM_STATE.JUMP:
		if(key_left){
			image_xscale = -1;
		}else if(key_right){
			image_xscale = 1;
		}
		hsp = (key_right - key_left) * runSpd; //calculate hsp
        vsp += gravSpd;	//gravity force
		if(!key_jump || vsp >= 0){ //if user release jump key or vsp >= 0
			state = MIRIAM_STATE.FALL; // move to crouch state
			vsp = 0;
		}
		sprite_index = player_miriam_jump; //swicth animation to 'player_miriam_jump'
        break;
		
	case MIRIAM_STATE.FALL:
		if(key_left){
			image_xscale = -1;
		}else if(key_right){
			image_xscale = 1;
		}
		hsp = (key_right - key_left) * runSpd; //calculate hsp
        vsp += gravSpd; //gravity force
		if(place_meeting(x, y + vsp, objMiriamCollisionCube)){
			state = hsp != 0 ? MIRIAM_STATE.RUN : MIRIAM_STATE.IDLE;
		}
		sprite_index = player_miriam_fall; //swicth animation to 'player_miriam_fall'
        break;
		
	case MIRIAM_STATE.CROUCH:
        if(!key_down){ //if user release key down
			mask_index = player_miriam_idle_mask;
			if(key_left || key_right){ //if user press key left or key right then move to run state
				state = MIRIAM_STATE.RUN;
			}else{
				state = MIRIAM_STATE.IDLE; // otherwise move to idle state
			}
		}		
		
		if(key_jump){
			state = MIRIAM_STATE.SLIDE;		
			mask_index = player_miriam_slide_mask;
		}
		
		if(!place_meeting(x, y + 1, objMiriamCollisionCube)){
			state = MIRIAM_STATE.FALL; // move to crouch state
			mask_index = player_miriam_idle_mask;
		}
		
		sprite_index = player_miriam_crouch; //swicth animation to 'player_miriam_crouch'
        break;		
		
	case MIRIAM_STATE.SLIDE:
		hsp = image_xscale * runSpd * 2;
		slideTimer++;
		if(!place_meeting(x, floor(y) - 1, objMiriamCollisionCube)){
			if(slideTimer >= room_speed/4){
				if(key_down){
					state = MIRIAM_STATE.CROUCH;
					mask_index = player_miriam_crouch_mask;
				}else{
					state = MIRIAM_STATE.IDLE;
					mask_index = player_miriam_idle_mask;
				}
				slideTimer = 0;
				hsp = 0;
			}
		}
		
		if(!place_meeting(x, floor(y) + 1, objMiriamCollisionCube)){
			mask_index = player_miriam_idle_mask;
			state = MIRIAM_STATE.FALL; // move to crouch state
			slideTimer = 0;
			hsp = 0;
		}
		
		sprite_index = player_miriam_slide; //swicth animation to 'player_miriam_slide'
		break;
		
    default:        
        break;
}


//Damage



//Collision x
if(place_meeting(x + hsp, y, objMiriamCollisionCube)){ //Check at object + vsp in y axis in the next frame
	while(!place_meeting(x + sign(hsp), y, objMiriamCollisionCube)){
		x+=sign(hsp);
	}
	hsp = 0;
}

//Update coordiate x
x+=hsp; //Update horizonal speed

//Collision y
if(place_meeting(x, y + vsp, objMiriamCollisionCube)){ //Check at object + vsp in y axis in the next frame
	while(!place_meeting(x, y + sign(vsp), objMiriamCollisionCube)){
		y+=sign(vsp);
	}
	vsp = 0;
}
//Update coordiate y
y+=vsp; //Update vertical speed


