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

function miriam_sprite_ext(sprite_1, sprite_2, sprite_3, sprite_4){	
	if(!isAttack && !isSkill){
		if(key_attack){
			isAttack = true;	
			image_index = 0;
		}else if(key_skill && canSkill){
			isSkill = true;	
			image_index = 0;
		}		
	}		
		
	if(isAttack){
		sprite_index = sprite_2; //swicth animation to 'sprite_2'
		if(animation_end()){
			isAttack = false;	
		}
	}else if(isSkill){
		switch (skill) {
		    case MIRIAM_SKILL.SICKLE:
		        sprite_index = sprite_3;
		        break;
				
			case MIRIAM_SKILL.RAPIER:
				sprite_index = sprite_4;
				break;
		}
		
		if(animation_end()){
			isSkill = false;	
			if(skill == MIRIAM_SKILL.SICKLE){
				if(instance_number(objMiriamSickle) < 1){
					var sickle = instance_create_depth(x + image_xscale * 11, y - 16, depth - 1, objMiriamSickle);
					sickle.image_xscale = image_xscale;
					sickle.hsp = image_xscale * 3;
					sickle.player = id;
					canSkill = false;
				}
			}else if(skill == MIRIAM_SKILL.RAPIER){
				if(instance_number(objMiriamRapier) < 3){
					create_miriam_rapier(player_miriam_rapier_1, 0.81, 0.4, 4);
					create_miriam_rapier(player_miriam_rapier_2, 1, 1, 3);
					create_miriam_rapier(player_miriam_rapier_3, 0.4, 0.81, 4);
					canSkill = false;
				}
			}
		}
	}else{
		sprite_index = sprite_1; //swicth animation to 'sprite_1'
	}	
}

function create_miriam_rapier(_sprite, _hsp, _vsp, _offset){
	//#1 rapier
	var sickle = instance_create_depth(x + image_xscale * 9, y - 16, depth - 1, objMiriamRapier);
	sickle.sprite_index = _sprite;
	sickle.image_xscale = image_xscale;
	sickle.hsp = image_xscale * _hsp * _offset;
	sickle.vsp = -_vsp * _offset;
	sickle.player = id;	
}