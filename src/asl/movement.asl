
/* Initial beliefs and rules */
{begin namespace(priv_movement, local)}
init_MapSize(50).
prm_CurrPositionX(-1).
prm_CurrPositionY(-1).
prm_DestinationX(-1).
prm_DestinationY(-1).
rslt_StepCoordinates(-1,-1).

/* Plans */

+!calculateStepCoordinates(PRM_CurrPositionX, PRM_CurrPositionY, PRM_DestinationX, PRM_DestinationY)
	<- TMP_DistanceXAxis=math.abs(PRM_DestinationX-PRM_CurrPositionX);
		TMP_DistanceYAxis=math.abs(PRM_DestinationY-PRM_CurrPositionY);
		-+prm_CurrPositionX(PRM_CurrPositionX); -+prm_CurrPositionY(PRM_CurrPositionY);
		-+prm_DestinationX(PRM_DestinationX); -+prm_DestinationY(PRM_DestinationY);
		!chooseStepAxis(TMP_DistanceXAxis, TMP_DistanceYAxis);
	.
+!chooseStepAxis(PRM_DistanceXAxis, PRM_DistanceYAxis)
	: PRM_DistanceXAxis >= PRM_DistanceYAxis
	<- ?prm_CurrPositionX(TMP_CurrPositionX); ?prm_DestinationX(TMP_DestinationX);
	!chooseStepDirectionOnXAxis(PRM_DistanceXAxis, TMP_CurrPositionX, TMP_DestinationX);
	.
+!chooseStepDirectionOnXAxis(PRM_DistanceXAxis, PRM_CurrPositionX, PRM_DestinationX)
	: init_MapSize(TMP_MapSize) & (PRM_DistanceXAxis > (TMP_MapSize/2)-1)
	<- -+rslt_StepCoordinates(-(PRM_DestinationX-PRM_CurrPositionX)/PRM_DistanceXAxis , 0)
	.
+!chooseStepDirectionOnXAxis(PRM_DistanceXAxis, PRM_CurrPositionX, PRM_DestinationX)
	: init_MapSize(TMP_MapSize) & (PRM_DistanceXAxis <= (TMP_MapSize/2)-1)
	<- -+rslt_StepCoordinates((PRM_DestinationX-PRM_CurrPositionX)/PRM_DistanceXAxis ,0)
	.
+!chooseStepAxis(PRM_DistanceXAxis, PRM_DistanceYAxis)
	: PRM_DistanceXAxis < PRM_DistanceYAxis
	<- ?prm_CurrPositionY(TMP_CurrPositionY); ?prm_DestinationY(TMP_DestinationY);
	!chooseStepDirectionOnYAxis(PRM_DistanceYAxis, TMP_CurrPositionY, TMP_DestinationY);
	.
+!chooseStepDirectionOnYAxis(PRM_DistanceYAxis, PRM_CurrPositionY, PRM_DestinationY)
	: init_MapSize(TMP_MapSize) & (PRM_DistanceYAxis > (TMP_MapSize/2)-1)
	<- -+rslt_StepCoordinates(0, -(PRM_DestinationY-PRM_CurrPositionY)/PRM_DistanceYAxis)
	.
+!chooseStepDirectionOnYAxis(PRM_DistanceYAxis, PRM_CurrPositionY, PRM_DestinationY)
	: init_MapSize(TMP_MapSize) & (PRM_DistanceYAxis <= (TMP_MapSize/2)-1)
	<- -+rslt_StepCoordinates(0, (PRM_DestinationY-PRM_CurrPositionY)/PRM_DistanceYAxis)
	.
{end}

+!moveOneStepTowardsDestination(PRM_CurrPositionX, PRM_CurrPositionY, PRM_DestinationX, PRM_DestinationY)
	: not (PRM_CurrPositionX=PRM_DestinationX & PRM_CurrPositionY=PRM_DestinationY)
	<- !priv_movement::calculateStepCoordinates(PRM_CurrPositionX, PRM_CurrPositionY, PRM_DestinationX, PRM_DestinationY);
		?priv_movement::rslt_StepCoordinates(RSLT_X,RSLT_Y);
		-+export_rslt(RSLT_X,RSLT_Y);
		.
+!moveOneStepTowardsDestination(PRM_CurrPositionX, PRM_CurrPositionY, PRM_DestinationX, PRM_DestinationY)
	: (PRM_CurrPositionX=PRM_DestinationX & PRM_CurrPositionY=PRM_DestinationY)
	<- .print("---------------> ", arrived_at(PRM_DestinationX,PRM_DestinationY));.



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

