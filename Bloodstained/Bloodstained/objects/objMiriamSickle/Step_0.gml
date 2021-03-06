timer++;
if(timer > room_speed/2 && !isBack){
	hsp *= -1.5;
	isBack = true;
	ds_list_clear(enemyList);
}

var collideEnemy = ds_list_create();
var count = instance_place_list(x, y, objPrtEnemy, collideEnemy, false);
for (var i = 0; i < count; ++i) {
	
    var enemy = ds_list_find_value(collideEnemy, i);	
	if(ds_list_find_index(enemyList, enemy) == -1){
		var impact = true;
		if(!enemy.isBlock){
			enemy.isHit = true;			
		}else{
			impact = false;
		}
		create_box_attack_collision_effect(sprite_index, enemy);	
		ds_list_add(enemyList, enemy);
	}
}

x+=hsp;
y+=vsp;
