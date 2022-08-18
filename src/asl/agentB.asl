{include("explore/exploreFacade.asl", agent_exploreFacade) }
{include("doTask/doTask.asl", agent_doTask)}

+step(250)
    : name(agentA1)
    <-  ?step(X);
        +debug___________________belief(iAskedInStep,X);
        .broadcast(tell,didYouAcceptThisTask(task5, 1));
        skip;
    .
+step(X) 
    <-  ?position(AX, AY);
        if(not name(agentA1)){
            +debug___________________belief(imInExploreInStep,X);
        }
        !agent_exploreFacade::doSpiralExplore(AX,AY);
    .
