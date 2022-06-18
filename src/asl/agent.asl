{ include("movement.asl", agent_INCL_movement) }
//{ include("s.asl", agent_INCL_s) }
/* Initial beliefs and rules */
//start(true).
//hello(0).
/* Initial goals */
!start.
/* Plans */

//+step(X) <- !agent_INCL_movement::goTo.

//+!start <: false {
//	+start(true) <- .print("Hello").
//}

//+!start {
//	<- .print("Hello").
//}

+!start  <- !print; +hello(0); +start(true); .print("Start: true").
	{
		+!print <- .print("Start: true from inside").
		+start(true) <- -+start(false); .print("Start: false").
		+hello(0) <- -+hello(100); .print("Hello value changed").
	}
