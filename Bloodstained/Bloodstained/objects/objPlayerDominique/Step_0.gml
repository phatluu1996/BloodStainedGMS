//Input: keyboard input 
key_left = keyboard_check(vk_left); // check if  left keyboard is hold
key_right = keyboard_check(vk_right);// check if right keyboard is hold 
key_down = keyboard_check(vk_down);// check if down keyboard is hold 
key_jump = keyboard_check(vk_space);// check if up keyboard is hold 


//State machine
switch (state) {
    case DOMINIQUE_STATE.IDLE:
        // code here
		if((key_left || key_right) && !place_meeting(x + (key_right - key_left),y,objPrtCollisionCube) ){
			state = DOMINIQUE_STATE.RUN;
		}
		
		if(key_down){
			state = DOMINIQUE_STATE.CROUCH;
			
		}
		
		if(key_jump){
			vsp = -JumpSpd;
			state = DOMINIQUE_STATE.JUMP;
		}
		sprite_index = player_dominique_idle; // action idle of dominique
        break;
	case DOMINIQUE_STATE.RUN:
	
	
		hsp = (key_right - key_left * runSpd);// caculate run
		
		if(!place_meeting(x,y + 1,objPrtCollisionCube)){
			state = DOMINIQUE_STATE.FALL;
		}
			
		
		if(!(key_left || key_right)||place_meeting(x + hsp,y,objPrtCollisionCube)){
			state = DOMINIQUE_STATE.IDLE;
		}
		
		 if(key_down){
			state = DOMINIQUE_STATE.CROUCH;
			hsp = 0;
		}
		
		if(key_left){
			image_xscale = -1
		}else if(key_right){
			image_xscale = 1
		}
		
		if(key_jump){
			vsp = -JumpSpd;
			state = DOMINIQUE_STATE.JUMP;
		}
		
		
		sprite_index = player_dominique_run; // action run of dominique
        break;
		
	case DOMINIQUE_STATE.JUMP:
		hsp = (key_right - key_left * runSpd);
		vsp += gravSpd;
		if(!key_jump || vsp >= 0){
			state =	DOMINIQUE_STATE.FALL;
			vsp = 0;
		}
		if(key_left){
			image_xscale = -1
		}else if(key_right){
			image_xscale = 1
		}
		sprite_index = player_dominique_jump; 
        break;
		
	case DOMINIQUE_STATE.FALL:
		hsp = (key_right - key_left * runSpd);
		vsp += gravSpd;
		
		if(place_meeting(x,y + vsp,objPrtCollisionCube)){
				state = hsp != 0?DOMINIQUE_STATE.RUN:DOMINIQUE_STATE.IDLE;
		}
		if(key_left){
			image_xscale = -1
		}else if(key_right){
			image_xscale = 1
		}
        sprite_index = player_dominique_fall;
        break;
		
	case DOMINIQUE_STATE.CROUCH:
		sprite_index = player_dominique_crouch;
		
		if(!key_down && (key_left || key_right)){
			state = DOMINIQUE_STATE.RUN;
		}else if(!key_down){
			state =  DOMINIQUE_STATE.IDLE;
		}
        break;
		
        // code here
        break;
}


//Collision (Va cham)
if(place_meeting(x,y + vsp,objPrtCollisionCube)){
	 while(!place_meeting(x,y + sign(vsp),objPrtCollisionCube)){
		 y+= sign(vsp);
	}
	 vsp = 0;
}

if(place_meeting(x + hsp,y ,objPrtCollisionCube)){
	 while(!place_meeting(x + sign(hsp) ,y,objPrtCollisionCube)){
		 x+= sign(hsp);
	}
	 hsp = 0;
}


//Update coordiate x,y
x+=hsp; 
y+=vsp;
