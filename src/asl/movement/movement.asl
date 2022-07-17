
{begin namespace(priv_movement, local)}
init_MapSize(50, 50). //50x50
currPositionX(-1).
currPositionY(-1).
destinationX(-1).
destinationY(-1).
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
	<-	-+currPositionX(CurrPositionX); -+currPositionY(CurrPositionY);
		-+destinationX(DestinationX); -+destinationY(DestinationY);
	.
+!calculateStepCoordinates
	<- 	?currPositionX(CurrPositionX); ?currPositionY(CurrPositionY);
		?destinationX(DestinationX); ?destinationY(DestinationY);
		DistanceXAxis=math.abs(DestinationX-CurrPositionX);
		DistanceYAxis=math.abs(DestinationY-CurrPositionY);
		!chooseStepAxis(DistanceXAxis, DistanceYAxis);
	.
+!chooseStepAxis(DistanceXAxis, DistanceYAxis)
	: DistanceXAxis >= DistanceYAxis
	<-	?currPositionX(CurrPositionX); ?destinationX(DestinationX);
		!chooseStepDirectionOnXAxis(DistanceXAxis, CurrPositionX, DestinationX);
	.
+!chooseStepDirectionOnXAxis(DistanceXAxis, CurrPositionX, DestinationX)
	: init_MapSize(TMP_X,_) & (DistanceXAxis > (TMP_X/2)-1)
	<-	-+rslt_StepCoordinates(-(DestinationX-CurrPositionX)/DistanceXAxis , 0)
	.
+!chooseStepDirectionOnXAxis(DistanceXAxis, CurrPositionX, DestinationX)
	: init_MapSize(TMP_X,_) & (DistanceXAxis <= (TMP_X/2)-1)
	<-	-+rslt_StepCoordinates((DestinationX-CurrPositionX)/DistanceXAxis ,0)
	.
+!chooseStepAxis(DistanceXAxis, DistanceYAxis)
	: DistanceXAxis < DistanceYAxis
	<-	?currPositionY(CurrPositionY); ?destinationY(DestinationY);
		!chooseStepDirectionOnYAxis(DistanceYAxis, CurrPositionY, DestinationY);
	.
+!chooseStepDirectionOnYAxis(DistanceYAxis, CurrPositionY, DestinationY)
	: init_MapSize(_,TMP_Y) & (DistanceYAxis > (TMP_Y/2)-1)
	<-	-+rslt_StepCoordinates(0, -(DestinationY-CurrPositionY)/DistanceYAxis)
	.
+!chooseStepDirectionOnYAxis(DistanceYAxis, CurrPositionY, DestinationY)
	: init_MapSize(_,TMP_Y) & (DistanceYAxis <= (TMP_Y/2)-1)
	<-	-+rslt_StepCoordinates(0, (DestinationY-CurrPositionY)/DistanceYAxis)
	.
{end}
