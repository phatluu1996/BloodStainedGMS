enum PLAYER_STATE{
	IDLE,
	RUN,
	JUMP,
	FALL,
	CROUCH
}
depth = 0;
hp = 0;
hpLimit = 0;
mp = 0;
mpLimit = 0;
life = 2;
runSpd = 1.5;
JumpSpd = 5.25;
gravSpd = 0.25;
hsp = 0;
vsp = 0;
state = PLAYER_STATE.IDLE;
isHit = false;
isInvincible = false;
hitTimer = 0;
invinTimer = 0;


