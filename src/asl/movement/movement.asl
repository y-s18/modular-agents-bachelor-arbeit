
{begin namespace(priv_movement, local)}
init_MapSize(50,50,overlap). //(50x50, {overlap,no_overlap})
currPosition(-1,-1).
destination(-1,-1).
rslt_StepCoordinates(-1,-1).
{end}

+!moveOneStepTowardsDestination(CurrPositionX, CurrPositionY, DestinationX, DestinationY)
	: not (CurrPositionX=DestinationX & CurrPositionY=DestinationY)
	<-	!priv_movement::updateBeliefsForCalculation(CurrPositionX, CurrPositionY, DestinationX, DestinationY);
		!priv_movement::calculateStepCoordinates;
		?priv_movement::rslt_StepCoordinates(RSLT_X,RSLT_Y);
		-+export_RsltStepCoordinates(RSLT_X,RSLT_Y);
	.
+!moveOneStepTowardsDestination(CurrPositionX, CurrPositionY, DestinationX, DestinationY)
	: (CurrPositionX=DestinationX & CurrPositionY=DestinationY)
	<-	!priv_movement::updateBeliefsForCalculation(CurrPositionX, CurrPositionY, DestinationX, DestinationY);
		.print("---------------> ", arrived_at(DestinationX,DestinationY));
	.

{begin namespace(priv_movement, local)}
+!updateBeliefsForCalculation(CurrPositionX, CurrPositionY, DestinationX, DestinationY)
	<-	-+currPosition(CurrPositionX,CurrPositionY);
		-+destination(DestinationX,DestinationY);
	.
+!calculateStepCoordinates
	<- 	?currPosition(CurrPositionX,CurrPositionY);
		?destination(DestinationX,DestinationY);
		DistanceXAxis=math.abs(DestinationX-CurrPositionX);
		DistanceYAxis=math.abs(DestinationY-CurrPositionY);
		!chooseStepAxis(DistanceXAxis, DistanceYAxis);
	.
+!chooseStepAxis(DistanceXAxis, DistanceYAxis)
	: DistanceXAxis >= DistanceYAxis
	<-	!chooseStepDirectionOnXAxis(DistanceXAxis);
	.
+!chooseStepDirectionOnXAxis(DistanceXAxis)
	: init_MapSize(TMP_X,_,overlap) & (DistanceXAxis > (TMP_X/2)-1)
	<-	?currPosition(CurrPositionX,_); 
		?destination(DestinationX,_);
		-+rslt_StepCoordinates(-(DestinationX-CurrPositionX)/DistanceXAxis , 0);
	.
+!chooseStepDirectionOnXAxis(DistanceXAxis)
	: (init_MapSize(TMP_X,_,overlap) & (DistanceXAxis <= (TMP_X/2)-1)) | init_MapSize(TMP_X,_,no_overlap)
	<-	?currPosition(CurrPositionX,_); 
		?destination(DestinationX,_);
		-+rslt_StepCoordinates((DestinationX-CurrPositionX)/DistanceXAxis ,0);
	.
+!chooseStepAxis(DistanceXAxis, DistanceYAxis)
	: DistanceXAxis < DistanceYAxis
	<-	!chooseStepDirectionOnYAxis(DistanceYAxis);
	.
+!chooseStepDirectionOnYAxis(DistanceYAxis)
	: init_MapSize(_,TMP_Y,overlap) & (DistanceYAxis > (TMP_Y/2)-1)
	<-	?currPosition(_,CurrPositionY); 
		?destination(_,DestinationY);
		-+rslt_StepCoordinates(0, -(DestinationY-CurrPositionY)/DistanceYAxis);
	.
+!chooseStepDirectionOnYAxis(DistanceYAxis)
	: (init_MapSize(_,TMP_Y,overlap) & (DistanceYAxis <= (TMP_Y/2)-1)) | init_MapSize(_,TMP_Y,no_overlap)
	<-	?currPosition(_,CurrPositionY); 
		?destination(_,DestinationY);
		-+rslt_StepCoordinates(0, (DestinationY-CurrPositionY)/DistanceYAxis);
	.
{end}

+!moveOneRandomStep
	<-	.random([1,2,3,4], RandomNum);
		!priv_movement::chooseRandomStepDirection(RandomNum);
		?priv_movement::rslt_StepCoordinates(RSLT_X,RSLT_Y);
		-+export_RsltStepCoordinates(RSLT_X,RSLT_Y);
	.

{begin namespace(priv_movement, local)}
+!chooseRandomStepDirection(1)
	<-	-+rslt_StepCoordinates(0, 1).
+!chooseRandomStepDirection(2)
	<-	-+rslt_StepCoordinates(0, -1).
+!chooseRandomStepDirection(3)
	<-	-+rslt_StepCoordinates(-1, 0).
+!chooseRandomStepDirection(4)
	<-	-+rslt_StepCoordinates(1, 0).
{end}
