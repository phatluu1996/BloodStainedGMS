//Input: keyboard input
//key_left = keyboard_check(vk_left); //check if left arrow key is hold
//key_right = keyboard_check(vk_right); //check if left arrow right is hold
//key_down = keyboard_check(vk_down); //check if left arrow down is hold
//key_jump = keyboard_check(vk_up);  //check if left arrow up is hold
key_left = keyboard_check(ord("A")); 
key_right = keyboard_check(ord("D"));
key_down = keyboard_check(ord("S")); 
key_jump = keyboard_check_pressed(ord("K")); 
key_jump_hold = keyboard_check(ord("K")); 

key_attack = keyboard_check_pressed(ord("J")); 
key_skill = keyboard_check_pressed(ord("U"));


//State machine
switch (state) {
    case MIRIAM_STATE.IDLE:
        if(!isAttack && (key_left || key_right) && !place_meeting(x + (key_right - key_left), y, objPrtCollisionCube)){ // if key left/right press and not hit wall
			state = MIRIAM_STATE.RUN;
		}				
		if(key_down && !key_jump_hold && !isAttack){
			state = MIRIAM_STATE.CROUCH;
			mask_index = player_miriam_crouch_mask;
		}
		if(key_jump){
			vsp = -JumpSpd;	
			state = MIRIAM_STATE.JUMP;
		}
		
		if(!place_meeting(x, y + 1, objPrtCollisionCube)){
			state = MIRIAM_STATE.FALL; // move to crouch state
		}
		
		
		miriam_sprite_ext(player_miriam_idle, player_miriam_idle_whip_attack, player_miriam_idle_sickle_attack, player_miriam_idle_rapier_attack);
        break;
		
	case MIRIAM_STATE.RUN:
		hsp = (key_right - key_left) * runSpd * (!isAttack); //calculate hsp 
        if(!(key_left || key_right) || place_meeting(x + hsp, y, objPrtCollisionCube)){// !(key_left || key_right) <=> !key_left && !key_right
			state = MIRIAM_STATE.IDLE;
		}	
		if(key_right - key_left != 0 && !isAttack){
			image_xscale = key_right - key_left; 	
		}
		if(key_down && !isAttack){//if user pres keydown
			state = MIRIAM_STATE.CROUCH; // move to crouch state
			hsp = 0; //stop moving when moving to crouch state
			mask_index = player_miriam_crouch_mask;
		}		
		
		if(!place_meeting(x, y + 1, objPrtCollisionCube)){
			state = MIRIAM_STATE.FALL; // move to crouch state
		}
		
		if(key_jump){
			vsp = -JumpSpd;	
			state = MIRIAM_STATE.JUMP;
		}
		
		miriam_sprite(player_miriam_run, player_miriam_idle_whip_attack);
        break;
		
	case MIRIAM_STATE.JUMP:
		if(key_right - key_left != 0 && !isAttack){
			image_xscale = key_right - key_left; 	
		}
		hsp = (key_right - key_left) * runSpd; //calculate hsp
        vsp += gravSpd;	//gravity force
		if(!key_jump_hold || vsp >= 0){ //if user release jump key or vsp >= 0
			state = MIRIAM_STATE.FALL; // move to crouch state
			vsp = 0;
		}
		miriam_sprite_ext(player_miriam_jump, player_miriam_air_whip_attack, player_miriam_air_sickle_attack, player_miriam_air_rapier_attack);
        break;
		
	case MIRIAM_STATE.FALL:
		if(key_right - key_left != 0 && !isAttack){
			image_xscale = key_right - key_left; 	
		}
		hsp = (key_right - key_left) * runSpd; //calculate hsp
        vsp += gravSpd; //gravity force
		if(place_meeting(x, y + vsp, objPrtCollisionCube)){
			state = hsp != 0 ? MIRIAM_STATE.RUN : MIRIAM_STATE.IDLE;
		}
		miriam_sprite_ext(player_miriam_fall, player_miriam_air_whip_attack, player_miriam_air_sickle_attack, player_miriam_air_rapier_attack);
        break;
		
	case MIRIAM_STATE.CROUCH:
		if(key_right - key_left != 0 && !isAttack){
			image_xscale = key_right - key_left; 	
		}
        if(!key_down){ //if user release key down
			mask_index = player_miriam_idle_mask;
			if(key_left || key_right){ //if user press key left or key right then move to run state
				state = MIRIAM_STATE.RUN;
			}else{
				state = MIRIAM_STATE.IDLE; // otherwise move to idle state
			}
		}		
		
		if(key_jump && !isAttack){
			state = MIRIAM_STATE.SLIDE;		
			mask_index = player_miriam_slide_mask;
		}
		
		if(!place_meeting(x, y + 1, objPrtCollisionCube)){
			state = MIRIAM_STATE.FALL; // move to crouch state
			mask_index = player_miriam_idle_mask;
		}
		
		miriam_sprite(player_miriam_crouch, player_miriam_crouch_whip_attack);
        break;		
		
	case MIRIAM_STATE.SLIDE:
		hsp = image_xscale * runSpd * 2;
		slideTimer++;
		if(!place_meeting(x, floor(y) - 1, objPrtCollisionCube)){
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
		
		if(!place_meeting(x, floor(y) + 1, objPrtCollisionCube)){
			mask_index = player_miriam_idle_mask;
			state = MIRIAM_STATE.FALL; // move to crouch state
			slideTimer = 0;
			hsp = 0;			
		}
		
		sprite_index = player_miriam_slide; //swicth animation to 'player_miriam_slide'
		break;
		
	case MIRIAM_STATE.HIT:
		hitTimer++;
		isHit = false;
		vsp += gravSpd;
		if(hitTimer >= room_speed / 2){
			hitTimer = 0;
			hsp = 0;
			if(place_meeting(x, y + 1, objPrtCollisionCube)){
				state = MIRIAM_STATE.IDLE;
			}else{
				state = MIRIAM_STATE.FALL;
			}
		}
		sprite_index = player_miriam_get_hit;
		break;
		
    default:        
        break;
}


//Damage
var enemy = instance_place(x, y, objPrtEnemy);
if(enemy >= 0 && state != MIRIAM_STATE.HIT && !isInvincible){
	isHit = true;
	isInvincible = true;
	isAttack = false;
	isSkill = false;
	state = MIRIAM_STATE.HIT;
	vsp = -3;
	hsp = -image_xscale * runSpd;
	hp -= enemy.damage;
	destroy_miriam_attack_box();
}

//Invincible
if(isInvincible){
	invinTimer++;
	switch (invinTimer/2 mod 3) {
	    case 0:
	        image_alpha = 0;
	        break;
			
		case 1:
	        image_alpha = 1;
	        break;
			
		case 2:
	        image_alpha = 0.5;
	        break;
	}
	if(invinTimer >= room_speed * 3 / 2){
		invinTimer = 0;
		isInvincible = false;
		image_alpha = 1;
	}
}

//Collision x
if(place_meeting(x + hsp, y, objPrtCollisionCube)){ //Check at object + vsp in y axis in the next frame
	while(!place_meeting(x + sign(hsp), y, objPrtCollisionCube)){
		x+=sign(hsp);
	}
	hsp = 0;
}

//Update coordiate x
x+=hsp; //Update horizonal speed

//Collision y
if(place_meeting(x, y + vsp, objPrtCollisionCube)){ //Check at object + vsp in y axis in the next frame
	while(!place_meeting(x, y + sign(vsp), objPrtCollisionCube)){
		y+=sign(vsp);
	}
	vsp = 0;
}
//Update coordiate y
y+=vsp; //Update vertical speed


