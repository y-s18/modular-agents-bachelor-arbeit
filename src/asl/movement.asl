
/* Initial beliefs and rules */
{begin namespace(priv_movement, local)}
init_MapSize(50).
currPositionX(-1).
currPositionY(-1).
destinationX(-1).
destinationY(-1).
rslt_StepCoordinates(-1,-1).

/* Plans */

+!calculateStepCoordinates(CurrPositionX, CurrPositionY, DestinationX, DestinationY)
	<- DistanceXAxis=math.abs(DestinationX-CurrPositionX);
		DistanceYAxis=math.abs(DestinationY-CurrPositionY);
		-+currPositionX(CurrPositionX); -+currPositionY(CurrPositionY);
		-+destinationX(DestinationX); -+destinationY(DestinationY);
		!chooseStepAxis(DistanceXAxis, DistanceYAxis);
	.
+!chooseStepAxis(DistanceXAxis, DistanceYAxis)
	: DistanceXAxis >= DistanceYAxis
	<- ?currPositionX(CurrPositionX); ?destinationX(DestinationX);
	!chooseStepDirectionOnXAxis(DistanceXAxis, CurrPositionX, DestinationX);
	.
+!chooseStepDirectionOnXAxis(DistanceXAxis, CurrPositionX, DestinationX)
	: init_MapSize(TMP_MapSize) & (DistanceXAxis > (TMP_MapSize/2)-1)
	<- -+rslt_StepCoordinates(-(DestinationX-CurrPositionX)/DistanceXAxis , 0)
	.
+!chooseStepDirectionOnXAxis(DistanceXAxis, CurrPositionX, DestinationX)
	: init_MapSize(TMP_MapSize) & (DistanceXAxis <= (TMP_MapSize/2)-1)
	<- -+rslt_StepCoordinates((DestinationX-CurrPositionX)/DistanceXAxis ,0)
	.
+!chooseStepAxis(DistanceXAxis, DistanceYAxis)
	: DistanceXAxis < DistanceYAxis
	<- ?currPositionY(CurrPositionY); ?destinationY(DestinationY);
	!chooseStepDirectionOnYAxis(DistanceYAxis, CurrPositionY, DestinationY);
	.
+!chooseStepDirectionOnYAxis(DistanceYAxis, CurrPositionY, DestinationY)
	: init_MapSize(TMP_MapSize) & (DistanceYAxis > (TMP_MapSize/2)-1)
	<- -+rslt_StepCoordinates(0, -(DestinationY-CurrPositionY)/DistanceYAxis)
	.
+!chooseStepDirectionOnYAxis(DistanceYAxis, CurrPositionY, DestinationY)
	: init_MapSize(TMP_MapSize) & (DistanceYAxis <= (TMP_MapSize/2)-1)
	<- -+rslt_StepCoordinates(0, (DestinationY-CurrPositionY)/DistanceYAxis)
	.
{end}

+!moveOneStepTowardsDestination(CurrPositionX, CurrPositionY, DestinationX, DestinationY)
	: not (CurrPositionX=DestinationX & CurrPositionY=DestinationY)
	<- !priv_movement::calculateStepCoordinates(CurrPositionX, CurrPositionY, DestinationX, DestinationY);
		?priv_movement::rslt_StepCoordinates(RSLT_X,RSLT_Y);
		-+export_rslt(RSLT_X,RSLT_Y);
		.
+!moveOneStepTowardsDestination(CurrPositionX, CurrPositionY, DestinationX, DestinationY)
	: (CurrPositionX=DestinationX & CurrPositionY=DestinationY)
	<- .print("---------------> ", arrived_at(DestinationX,DestinationY));.



// hello(0).
// {begin namespace(priv_movement,local)}
// randomNum(0).
// chosenDir("").

// /* Plans */

// +!generateRandomNum <- .random(NUM);
// 	-+priv_movement::randomNum(NUM);
// 	.
// +!chooseDirection: priv_movement::randomNum(NUM) & NUM <=0.25 <- 
// 	-+priv_movement::chosenDir(n);
// 	.
// +!chooseDirection: priv_movement::randomNum(NUM) & (NUM > 0.25 & NUM <= 0.50) <- 
// 	-+priv_movement::chosenDir(s);
// 	.
// +!chooseDirection: priv_movement::randomNum(NUM) & (NUM > 0.50 & NUM <= 0.75) <- 
// 	-+priv_movement::chosenDir(w);
// 	.
// +!chooseDirection: priv_movement::randomNum(NUM) & (NUM > 0.75 & NUM <= 1.00) <- 
// 	-+priv_movement::chosenDir(e);
// 	.
// {end}

// +!goTo <- !priv_movement::generateRandomNum;
// 	!priv_movement::chooseDirection;
// 	?priv_movement::chosenDir(D);
// 	move(D);
// 	.

