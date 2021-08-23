var collideEnemy = ds_list_create();
var count = instance_place_list(x, y, objPrtEnemy, collideEnemy, false);
for (var i = 0; i < count; ++i) {
    var enemy = ds_list_find_value(collideEnemy, i);
	if(ds_list_find_index(enemyList, enemy) == -1 && !enemy.isBlock){
		enemy.isHit = true;
		ds_list_add(enemyList, enemy);
	}
}


