{ include("movement.asl", movementAdapter_INCL_movement) }

{begin namespace(priv_movementAdapter, local)}
direction(s, 0,  1). 
direction(n, 0, -1). 
direction(w,-1,  0). 
direction(e, 1,  0).
rsltDirection(-1).
{end}

+!moveOneStepTowardsDestination(CurrPositionX, CurrPositionY, DestinationX, DestinationY)
    : not (CurrPositionX=DestinationX & CurrPositionY=DestinationY)
    <-  !movementAdapter_INCL_movement::moveOneStepTowardsDestination(CurrPositionX, CurrPositionY, DestinationX, DestinationY);
        ?movementAdapter_INCL_movement::export_RsltStepCoordinates(RSLT_X,RSLT_Y);
        !priv_movementAdapter::convertStepCoordinatesToDirection(RSLT_X,RSLT_Y);
        ?priv_movementAdapter::rsltDirection(RsltDirection);
        -+export_RsltDirection(RsltDirection);
    .

+!moveOneStepTowardsDestination(CurrPositionX, CurrPositionY, DestinationX, DestinationY)
	: (CurrPositionX=DestinationX & CurrPositionY=DestinationY)
	<- .print("---------------> ", arrived_at(DestinationX,DestinationY));.
    
{begin namespace(priv_movementAdapter, local)}
+!convertStepCoordinatesToDirection(RsltDestinationX, RsltDestinationY)
    <- ?priv_movementAdapter::direction(RsltDirection, RsltDestinationX, RsltDestinationY);
        -+rsltDirection(RsltDirection);
    .
{end}