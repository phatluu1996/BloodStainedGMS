function hachi_sprite(sprite_1, sprite_2){
	if(key_attack && !isAttack){
		isAttack = true;
		image_index = 0;
	}
		
	if(isAttack){
		sprite_index = sprite_2;
		if(animation_end()){
			isAttack = false;
		}
	}else{
		sprite_index = sprite_1;
	}
}