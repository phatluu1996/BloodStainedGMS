enum ENEMY_STATE{
	ENABLE,
	DISABLE,
	DEAD,
	OUTSIDE_VIEW
}

//Physics
hp = 0;
hpLimit = 0;
damage = 1;
runSpd = 1.5;
jumpSpd = 5.25;
hsp = 0;
vsp = 0;
depth = 1;

//State
isBlock = false;
isAttack = false;
isHit = false;

state = ENEMY_STATE.ENABLE;
action = "";