{ include("movementAdapter.asl", movementFacade_movementAdapter) }

+!moveToLocation(CurrPositionX, CurrPositionY, DestinationX, DestinationY)
    <-  !movementFacade_movementAdapter::moveOneStepTowardsDestination(CurrPositionX, CurrPositionY, 
                                                                        DestinationX, DestinationY);
        ?movementFacade_movementAdapter::export_RsltDirection(Direction);
        if(not (CurrPositionX=DestinationX & CurrPositionY=DestinationY)){move(Direction);}
    .
+!moveRandomly
    <-  !movementFacade_movementAdapter::moveOneRandomStep;
        ?movementFacade_movementAdapter::export_RsltDirection(Direction);
        move(Direction);
    .