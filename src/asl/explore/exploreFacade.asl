// { include("explore.asl", exploreFacade_INCL_explore) }
{ include("exploreAdapter.asl", exploreFacade_INCL_exploreAdapter) }
{ include("movement/movementAdapter.asl", exploreFacade_INCL_movementAdapter) }

//doRandomExplore   /   doSpiralExplore
//exploreUsingRandomMovement     /   exploreUsingSpiralMovement

+!doSpiralExplore(AgentPosX, AgentPosY)
    <-  //Aufrufen über das schon inkludierte exploreAdapter-Modul.
        !exploreAdapter_INCL_explore::calculateNextSpiralLine(AgentPosX, AgentPosY, 4, 6);
		?exploreAdapter_INCL_explore::export_EndpointCoordinates(X_Endpoint, Y_Endpoint);
        //Beim Einschalten: explore muss inkludiert werden.
        // !exploreFacade_INCL_explore::calculateNextSpiralLine(AgentPosX, AgentPosY, 4, 6); 
        // ?exploreFacade_INCL_explore::export_EndpointCoordinates(X_Endpoint, Y_Endpoint);

        !exploreFacade_INCL_movementAdapter::moveOneStepTowardsDestination(AgentPosX,AgentPosY, 
                                                                        X_Endpoint, Y_Endpoint);
		?exploreFacade_INCL_movementAdapter::export_RsltDirection(Direction);
        !exploreFacade_INCL_exploreAdapter::searchFor(thing(_,_,dispenser,b0), AgentPosX, AgentPosY);
		!exploreFacade_INCL_exploreAdapter::searchFor(thing(_,_,dispenser,b1), AgentPosX, AgentPosY);
        !exploreFacade_INCL_exploreAdapter::searchFor(thing(_,_,taskboard,_), AgentPosX, AgentPosY);
        !exploreFacade_INCL_exploreAdapter::searchFor(goal(_,_), AgentPosX, AgentPosY);

		move(Direction);
    .
