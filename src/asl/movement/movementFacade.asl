{ include("movementAdapter.asl", movementFacade_movementAdapter) }

+!moveToLocation(CurrPositionX, CurrPositionY, DestinationX, DestinationY)
    <-  !movementFacade_movementAdapter::moveOneStepTowardsDestination(CurrPositionX, CurrPositionY, 
                                                                        DestinationX, DestinationY);
        ?default::export_RsltDirection(Direction);
        if(not (CurrPositionX=DestinationX & CurrPositionY=DestinationY)){move(Direction);}
    .
+!moveRandomly
    <-  !movementFacade_movementAdapter::moveOneRandomStep;
        ?default::export_RsltDirection(Direction);
        move(Direction);
    .