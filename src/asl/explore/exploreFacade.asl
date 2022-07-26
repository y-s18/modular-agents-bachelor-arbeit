// { include("explore.asl", exploreFacade_explore) }
// { include("movement/movementAdapter.asl", exploreFacade_movementAdapter) }
{ include("exploreAdapter.asl", exploreFacade_exploreAdapter) }
{ include("movement/movementFacade.asl", exploreFacade_movementFacade) }
{begin namespace(priv_exploreFacade, local)}
activatePlan(false).
{end}

+!doSpiralExplore(AgentPosX, AgentPosY)
    <-  -+priv_exploreFacade::activatePlan(true);
        !searchForPOIs(AgentPosX, AgentPosY);
        -+priv_exploreFacade::activatePlan(false);
        !exploreFacade_exploreAdapter::calculateNextSpiralLine(AgentPosX, AgentPosY, 4, 6);
		?exploreFacade_exploreAdapter::export_EndpointCoordinates(X_Endpoint, Y_Endpoint);
        !exploreFacade_movementFacade::moveToLocation(AgentPosX, AgentPosY, X_Endpoint, Y_Endpoint);
    .
+!doRandomExplore(AgentPosX, AgentPosY)
    <-  -+priv_exploreFacade::activatePlan(true);
        !searchForPOIs(AgentPosX, AgentPosY);
        -+priv_exploreFacade::activatePlan(false);
        !exploreFacade_movementFacade::moveRandomly;
    .
+!searchForPOIs(AgentPosX, AgentPosY)
    : priv_exploreFacade::activatePlan(true)
    <-  !exploreFacade_exploreAdapter::searchFor(thing(_,_,dispenser,b0), AgentPosX, AgentPosY);
		!exploreFacade_exploreAdapter::searchFor(thing(_,_,dispenser,b1), AgentPosX, AgentPosY);
        !exploreFacade_exploreAdapter::searchFor(thing(_,_,taskboard,_), AgentPosX, AgentPosY);
        !exploreFacade_exploreAdapter::searchFor(goal(_,_), AgentPosX, AgentPosY);
    .
-!searchForPOIs(AgentPosX, AgentPosY)
    <-  .print("\n############\nPLAN FAILED: !searchForPOIs can not be called from outside the module\n############\n");.


