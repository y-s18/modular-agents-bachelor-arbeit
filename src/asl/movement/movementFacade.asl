{ include("movementAdapter.asl", movementFacade_INCL_movementAdapter) }

+!moveToLocation(CurrPositionX, CurrPositionY, DestinationX, DestinationY)
    <-  !movementFacade_INCL_movementAdapter::moveOneStepTowardsDestination(CurrPositionX, CurrPositionY, 
                                                                            DestinationX, DestinationY);
        ?movementFacade_INCL_movementAdapter::export_RsltDirection(Direction);
        if(not (CurrPositionX=DestinationX & CurrPositionY=DestinationY)){move(Direction);}
    .
+!moveRandomly
    <-  !movementFacade_INCL_movementAdapter::moveOneRandomStep;
        ?movementFacade_INCL_movementAdapter::export_RsltDirection(Direction);
        move(Direction);
    .