event_inherited();
enum MIRIAM_STATE{
	IDLE,
	RUN,
	JUMP,
	FALL,
	CROUCH,
	SLIDE,
	HIT
}

enum MIRIAM_SKILL{
	SICKLE,
	DAGGER,
	RAPIER,
	AXE
}

//Physics
hp = 10;
hpLimit = 10;
mp = 10;
mpLimit = 10;

//Timer
slideTimer = 0;


//boolean
isAttack = false;
isSkill = false;
canSkill = true;

//skill
skill = MIRIAM_SKILL.SICKLE;
