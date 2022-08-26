
{ include("explore/exploreFacade.asl", explore) }
{ include("movement/movementFacade.asl", move) }
{ include("doTask/doTask.asl", agent_doTask) }
{ include("init.asl")}
{ include("communication/communication.asl", comm)}
// thing(-17,0,taskboard,"").
// thing(16,0,taskboard,"").
// thing(13,-5,taskboard,"").
// thing(-19,-4,taskboard,"").
// thing(28,35,taskboard,"").
// thing(1,29,taskboard,"").
// thing(42,-4,dispenser,b1).
// counter(0).
// #### agent ####

// +step(X)
// 	<-	?position(AgentPosX, AgentPosY);
// 		!exploreFacade_exploreAdapter::searchFor(thing(_,_,taskboard,_), AgentPosX, AgentPosY);
// 		!agent_doTask::checkForTaskboard;
// 	.
+step(0) <-	?name(MyName); ?team(MyTeam); !assignAgentNumber(MyName); !broadcastMyInfo(MyName,MyTeam); skip;.
+step(1) <- ?team(MyTeam); !saveMyTeamAgentNames(MyTeam); skip;.
+step(X)
	: default::export_exploredListTaskboard(List) & List=[] 
	| not  default::export_exploredListTaskboard(_)
	<-	?position(AgentPosX, AgentPosY);
		// if(thing(_,_,dispenser,b1)[source(self)] & counter(1)){
		// 	-thing(_,_,dispenser,b1)[source(self)];
		// }
		// ?counter(Count);
		// -+counter(Count+1);
		!explore::doSpiralExplore(AgentPosX, AgentPosY);
		// !agent_exploreFacade::doRandomExplore(AgentPosX, AgentPosY);
		
		// !exploreFacade_exploreAdapter::searchFor(thing(_,_,taskboard,_), AgentPosX, AgentPosY);
		// !agent_doTask::checkForTaskboard(AgentPosX, AgentPosY);
	.
+step(X)
	: default::export_exploredListTaskboard(List) & List\==[]
	<-	?position(AgentPosX, AgentPosY);

		!agent_doTask::doTask(AgentPosX, AgentPosY);

	.



// +step(X)
// 	: isExploring(false)
// 	<-	// Start moving towards the found taskboard.
// 	.
// +step(0)
// 	<-	!agent_movement::assignPlanIds(m1St2Dest, m1RandSt);
// 		!agent_movement::grantAccess(m1St2Dest);
// 		.
// +step(X)
// 	<-	?position(AgentPosX, AgentPosY);
// 		!agent_movement::moveOneStepTowardsDestination(AgentPosX, AgentPosY, 25, 25);
// 		// !agent_movementAdapter::moveOneStepTowardsDestination(AgentPosX, AgentPosY, 25, 25);
// 	.


// +step(X) 
// 	<-	 !agent_INCL_movementFacade::moveRandomly;
// 	.

// +step(X)
// 	<-	?position(AgentPosX, AgentPosY);
// 		!moveOneStepTowardsDestination(AgentPosX, AgentPosY, 25, 25);
// 		// !agent_INCL_exploreFacade::doSpiralExplore(AgentPosX, AgentPosY);
// 		// !agent_INCL_exploreFacade::doRandomExplore(AgentPosX, AgentPosY);
// 	.