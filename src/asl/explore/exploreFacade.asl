// { include("explore.asl", exploreFacade_INCL_explore) }
// { include("movement/movementAdapter.asl", exploreFacade_INCL_movementAdapter) }
{ include("exploreAdapter.asl", exploreFacade_INCL_exploreAdapter) }
{ include("movement/movementFacade.asl", exploreFacade_INCL_movementFacade) }
{begin namespace(priv_exploreFacade, local)}
activatePlan(false).
{end}

+!doSpiralExplore(AgentPosX, AgentPosY)
    <-  -+priv_exploreFacade::activatePlan(true);
        !searchForPOIs(AgentPosX, AgentPosY);
        -+priv_exploreFacade::activatePlan(false);
        !exploreFacade_INCL_exploreAdapter::calculateNextSpiralLine(AgentPosX, AgentPosY, 4, 6);
		?exploreFacade_INCL_exploreAdapter::export_EndpointCoordinates(X_Endpoint, Y_Endpoint);
        !exploreFacade_INCL_movementFacade::moveToLocation(AgentPosX, AgentPosY, X_Endpoint, Y_Endpoint);
    .
+!searchForPOIs(AgentPosX, AgentPosY)
    : priv_exploreFacade::activatePlan(true)
    <-  !exploreFacade_INCL_exploreAdapter::searchFor(thing(_,_,dispenser,b0), AgentPosX, AgentPosY);
		!exploreFacade_INCL_exploreAdapter::searchFor(thing(_,_,dispenser,b1), AgentPosX, AgentPosY);
        !exploreFacade_INCL_exploreAdapter::searchFor(thing(_,_,taskboard,_), AgentPosX, AgentPosY);
        !exploreFacade_INCL_exploreAdapter::searchFor(goal(_,_), AgentPosX, AgentPosY);
    .
-!searchForPOIs(AgentPosX, AgentPosY)
    <-  .print("\n############\nPLAN FAILED: !searchForPOIs can not be called from outside the module\n############\n");.

// +!doSpiralExplore(AgentPosX, AgentPosY)
//     <-  !exploreFacade_INCL_exploreAdapter::searchFor(thing(_,_,dispenser,b0), AgentPosX, AgentPosY);
// 		!exploreFacade_INCL_exploreAdapter::searchFor(thing(_,_,dispenser,b1), AgentPosX, AgentPosY);
//         !exploreFacade_INCL_exploreAdapter::searchFor(thing(_,_,taskboard,_), AgentPosX, AgentPosY);
//         !exploreFacade_INCL_exploreAdapter::searchFor(goal(_,_), AgentPosX, AgentPosY);

//         //Aufrufen über das schon inkludierte exploreAdapter-Modul. exploreAdapter -> explore.
//         !exploreAdapter_INCL_explore::calculateNextSpiralLine(AgentPosX, AgentPosY, 4, 6);
// 		   ?exploreAdapter_INCL_explore::export_EndpointCoordinates(X_Endpoint, Y_Endpoint);

//         !exploreFacade_INCL_movementFacade::moveToLocation(AgentPosX, AgentPosY, X_Endpoint, Y_Endpoint);
//     .

// +!doRandomExplore(AgentPosX, AgentPosY)
//     <-  !exploreFacade_INCL_exploreAdapter::searchFor(thing(_,_,dispenser,b0), AgentPosX, AgentPosY);
// 		!exploreFacade_INCL_exploreAdapter::searchFor(thing(_,_,dispenser,b1), AgentPosX, AgentPosY);
//         !exploreFacade_INCL_exploreAdapter::searchFor(thing(_,_,taskboard,_), AgentPosX, AgentPosY);
//         !exploreFacade_INCL_exploreAdapter::searchFor(goal(_,_), AgentPosX, AgentPosY);
//         !exploreFacade_INCL_movementFacade::moveRandomly;
//     .
