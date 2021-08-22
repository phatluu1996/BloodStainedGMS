// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function dominique_strike(sprite_1,sprite_2){
		if(key_attack && !isAttack){
			isAttack = true;
			image_index = 0;
		}
	if(isAttack){
			sprite_index = sprite_1; // action idle of dominique
			if(animation_end()){
				isAttack = false;
			}
		}else{
			sprite_index = sprite_2; // action idle of dominique
		}
}	