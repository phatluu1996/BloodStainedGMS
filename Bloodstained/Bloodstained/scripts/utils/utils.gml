function animation_end(){
	return image_index + image_speed >= image_number - 1;
}

function miriam_sprite(sprite_1, sprite_2){
	if(key_attack && !isAttack){
		isAttack = true;	
		image_index = 0;
	}
		
	if(isAttack){
		sprite_index = sprite_2; //swicth animation to 'sprite_2'
		if(animation_end()){
			isAttack = false;	
		}
	}else{
		sprite_index = sprite_1; //swicth animation to 'sprite_1'
	}	
}