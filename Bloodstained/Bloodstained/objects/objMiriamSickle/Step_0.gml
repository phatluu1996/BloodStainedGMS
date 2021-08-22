timer++;
if(timer > room_speed/2 && !isBack){
	hsp *= -1.5;
	isBack = true;
}
x+=hsp;
y+=vsp;
