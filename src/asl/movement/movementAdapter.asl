{ include("movement/movement.asl", movementAdapter_movement) }

{begin namespace(priv_movementAdapter, local)}
direction(s, 0,  1). 
direction(n, 0, -1). 
direction(w,-1,  0). 
direction(e, 1,  0).
rsltDirection(-1).
{end}

+!moveOneStepTowardsDestination(CurrPositionX, CurrPositionY, DestinationX, DestinationY)
    <-  !movementAdapter_movement::moveOneStepTowardsDestination(CurrPositionX, CurrPositionY, DestinationX, DestinationY);
        ?movementAdapter_movement::export_RsltStepCoordinates(RSLT_X,RSLT_Y);
        !priv_movementAdapter::convertStepCoordinatesToDirection(RSLT_X,RSLT_Y);
        ?priv_movementAdapter::rsltDirection(RsltDirection);
        -+export_RsltDirection(RsltDirection);
    .
+!moveOneRandomStep
    <-  !movementAdapter_movement::moveOneRandomStep;
        ?movementAdapter_movement::export_RsltStepCoordinates(RSLT_X,RSLT_Y);
        !priv_movementAdapter::convertStepCoordinatesToDirection(RSLT_X,RSLT_Y);
        ?priv_movementAdapter::rsltDirection(RsltDirection);
        -+export_RsltDirection(RsltDirection);
    .
    
{begin namespace(priv_movementAdapter, local)}
+!convertStepCoordinatesToDirection(RsltDestinationX, RsltDestinationY)
    <-  ?priv_movementAdapter::direction(RsltDirection, RsltDestinationX, RsltDestinationY);
        -+rsltDirection(RsltDirection);
    .
{end}