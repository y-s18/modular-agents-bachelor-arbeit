/* Initial beliefs and rules */

hello(0).
{begin namespace(priv_movement,local)}
randomNum(0).
chosenDir("").

/* Plans */

+!generateRandomNum <- .random(NUM);
	-+priv_movement::randomNum(NUM);
	.
+!chooseDirection: priv_movement::randomNum(NUM) & NUM <=0.25 <- 
	-+priv_movement::chosenDir(n);
	.
+!chooseDirection: priv_movement::randomNum(NUM) & (NUM > 0.25 & NUM <= 0.50) <- 
	-+priv_movement::chosenDir(s);
	.
+!chooseDirection: priv_movement::randomNum(NUM) & (NUM > 0.50 & NUM <= 0.75) <- 
	-+priv_movement::chosenDir(w);
	.
+!chooseDirection: priv_movement::randomNum(NUM) & (NUM > 0.75 & NUM <= 1.00) <- 
	-+priv_movement::chosenDir(e);
	.
{end}

+!goTo <- !priv_movement::generateRandomNum;
	!priv_movement::chooseDirection;
	?priv_movement::chosenDir(D);
	move(D);
	.

