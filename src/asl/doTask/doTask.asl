{include("movement/movementFacade.asl", doTask_movementFacade)}
{include("helperModules/POIsComparison.asl", doTask_POIsComparison)}
{include("acceptTask.asl", beliefBase_doTask)}
{include("getBlock.asl", beliefBase_doTask)}
{include("submitTask.asl", beliefBase_doTask)}
{include("explore/exploreFacade.asl", doTask_exploreFacade)}

outsideTaskboardRange(AgentPosX,AgentPosY,DestinationX,DestinationY) :- 
    ((math.abs(AgentPosX-DestinationX)>24 & DistX=50-math.abs(AgentPosX-DestinationX)) 
        | (math.abs(AgentPosX-DestinationX)<=24 & DistX=math.abs(AgentPosX-DestinationX)))
    & ((math.abs(AgentPosY-DestinationY)>24 & DistY=50-math.abs(AgentPosY-DestinationY)) 
        | (math.abs(AgentPosY-DestinationY)<=24 & DistY=math.abs(AgentPosY-DestinationY)))
    & DistX+DistY>2 .
insideTaskboardRange(AgentPosX,AgentPosY,DestinationX,DestinationY) :- 
    ((math.abs(AgentPosX-DestinationX)>24 & DistX=50-math.abs(AgentPosX-DestinationX)) 
        | (math.abs(AgentPosX-DestinationX)<=24 & DistX=math.abs(AgentPosX-DestinationX)))
    & ((math.abs(AgentPosY-DestinationY)>24 & DistY=50-math.abs(AgentPosY-DestinationY)) 
        | (math.abs(AgentPosY-DestinationY)<=24 & DistY=math.abs(AgentPosY-DestinationY)))
    & DistX+DistY<=2 .
    
{begin namespace(priv_doTask, local)}
agentPosition(-1,-1).
currTaskboard(999, 999).
currGoal(999, 999).
currB0(999, 999).
currB1(999, 999).
movingToPOI(poi, false). //poi={taskboard, b0, b1, goal}
exploringMissingPOIs(missingPOI, false). //missingPOI={b0, b1, goal}
executedAction(actionName, false). //actionName={accept, request, attach, submit}
agentState(checkingTaskboard, true). // state={checkingTaskboard, accepting, requesting, attaching, submitting}
{end}

+!doTask(AgentPosX, AgentPosY)
    : priv_doTask::agentState(checkingTaskboard, true)
    <-  -+priv_doTask::agentPosition(AgentPosX, AgentPosY);
        -+priv_doTask::agentState(checkingTaskboard, false);
        !checkForTaskboard(AgentPosX, AgentPosY);
        !doTask(AgentPosX,AgentPosY);
    .
+!checkForTaskboard(AgentPosX, AgentPosY) //add searchFor while moving towards TB,Goal,Disp
    <-  ?exploreFacade_exploreAdapter::export_exploredListTaskboard(List);
        ?priv_doTask::currTaskboard(CurrTB_X, CurrTB_Y);
        !doTask_POIsComparison::findClosestPOI(AgentPosX, AgentPosY, CurrTB_X, CurrTB_Y, List, tb);
        ?doTask_POIsComparison::export_CurrPOI(CurrPOI_X, CurrPOI_Y);
        -+priv_doTask::currTaskboard(CurrPOI_X, CurrPOI_Y);
        -+priv_doTask::movingToPOI(taskboard, true);
    .
+!doTask(AgentPosX, AgentPosY)
    : priv_doTask::movingToPOI(taskboard, true) & priv_doTask::currTaskboard(CurrTB_X,CurrTB_Y) 
    & outsideTaskboardRange(AgentPosX,AgentPosY,CurrTB_X,CurrTB_Y)
    <-  -+priv_doTask::agentPosition(AgentPosX, AgentPosY);
        !doTask_exploreFacade::searchForPOIs(AgentPosX, AgentPosY);
        !checkForTaskboard(AgentPosX, AgentPosY);
        !moveToTaskboard(AgentPosX, AgentPosY);
    .
+!moveToTaskboard(AgentPosX, AgentPosY)
    <-  ?priv_doTask::currTaskboard(CurrTB_X, CurrTB_Y);
        !doTask_movementFacade::moveToLocation(AgentPosX,AgentPosY,CurrTB_X,CurrTB_Y);
    .
+!doTask(AgentPosX, AgentPosY)
    : priv_doTask::movingToPOI(taskboard, true) & priv_doTask::currTaskboard(CurrTB_X,CurrTB_Y) 
    & insideTaskboardRange(AgentPosX,AgentPosY,CurrTB_X,CurrTB_Y)
    <-  -+priv_doTask::agentPosition(AgentPosX, AgentPosY);
        -+priv_doTask::movingToPOI(taskboard, false);
        -+priv_doTask::agentState(accepting, true);
        !doTask(AgentPosX,AgentPosY);
    .
+!doTask(AgentPosX, AgentPosY)
    : priv_doTask::agentState(accepting, true)
    <-  -+priv_doTask::agentPosition(AgentPosX, AgentPosY);
        -+priv_doTask::agentState(accepting, false);
        -+priv_doTask::executedAction(accept,true);
        !beliefBase_doTask::acceptTask;
    .
+!doTask(AgentPosX, AgentPosY)
    : (default::lastAction(accept) & default::lastActionResult(success))
    & priv_doTask::executedAction(accept,true)
    <-  -+priv_doTask::agentPosition(AgentPosX, AgentPosY);
        -+priv_doTask::executedAction(accept,false);
        !checkForDispenser(AgentPosX, AgentPosY);
        !doTask(AgentPosX,AgentPosY);
    .
+!doTask(AgentPosX, AgentPosY)
    : (default::lastAction(accept) & default::lastActionResult(failed_target))
    & priv_doTask::executedAction(accept,true)
    <-  -+priv_doTask::agentPosition(AgentPosX, AgentPosY);
        -+priv_doTask::executedAction(accept,false);
        -+priv_doTask::agentState(accepting, true);
        !doTask(AgentPosX, AgentPosY);
    .
+!checkForDispenser(AgentPosX, AgentPosY)
    : beliefBase_doTask::multiBlockTask(false) & beliefBase_doTask::currRequiredDisp(b0,_,_)
    & exploreFacade_exploreAdapter::export_exploredListB0(List) & List\==[]
    <-  ?priv_doTask::currB0(CurrB0_X,CurrB0_Y);
        !doTask_POIsComparison::findClosestPOI(AgentPosX, AgentPosY, CurrB0_X, CurrB0_Y, List, b0);
        ?doTask_POIsComparison::export_CurrPOI(CurrPOI_X, CurrPOI_Y);
        -+priv_doTask::currB0(CurrPOI_X, CurrPOI_Y);
        -+priv_doTask::movingToPOI(dispenser, true);
    .
+!checkForDispenser(AgentPosX, AgentPosY)
    : beliefBase_doTask::multiBlockTask(false) & beliefBase_doTask::currRequiredDisp(b0,_,_)
    & exploreFacade_exploreAdapter::export_exploredListB0(List) & List=[]
    <-  -+priv_doTask::exploringMissingPOIs(b0, true);
    .
+!doTask(AgentPosX, AgentPosY)
    : priv_doTask::exploringMissingPOIs(b0,true) & exploreFacade_exploreAdapter::export_exploredListB0(List) & List\==[]
    & beliefBase_doTask::multiBlockTask(false)
    <-  -+priv_doTask::agentPosition(AgentPosX,AgentPosY);
        -+priv_doTask::exploringMissingPOIs(b0,false);
        !checkForDispenser(AgentPosX, AgentPosY);
        !doTask(AgentPosX, AgentPosY);
    .
+!doTask(AgentPosX, AgentPosY)
    : priv_doTask::exploringMissingPOIs(b0, true) & exploreFacade_exploreAdapter::export_exploredListB0(List) & List=[]
    & beliefBase_doTask::multiBlockTask(false)
    <-  -+priv_doTask::agentPosition(AgentPosX, AgentPosY);
        !doTask_exploreFacade::doSpiralExplore(AgentPosX, AgentPosY);
    .
+!checkForDispenser(AgentPosX, AgentPosY)
    : beliefBase_doTask::multiBlockTask(false) & beliefBase_doTask::currRequiredDisp(b1,_,_)
    & exploreFacade_exploreAdapter::export_exploredListB1(List) & List\==[]
    <-  ?priv_doTask::currB1(CurrB1_X, CurrB1_Y);
        !doTask_POIsComparison::findClosestPOI(AgentPosX, AgentPosY, CurrB1_X, CurrB1_Y, List, b1);
        ?doTask_POIsComparison::export_CurrPOI(CurrPOI_X, CurrPOI_Y);
        -+priv_doTask::currB1(CurrPOI_X, CurrPOI_Y);
        -+priv_doTask::movingToPOI(dispenser, true);
    .
+!checkForDispenser(AgentPosX, AgentPosY)
    : beliefBase_doTask::multiBlockTask(false) & beliefBase_doTask::currRequiredDisp(b1,_,_)
    & exploreFacade_exploreAdapter::export_exploredListB1(List) & List=[]
    <-  -+priv_doTask::exploringMissingPOIs(b1, true);
    .
+!doTask(AgentPosX, AgentPosY)
    : priv_doTask::exploringMissingPOIs(b1,true) & exploreFacade_exploreAdapter::export_exploredListB1(List) & List\==[]
    & beliefBase_doTask::multiBlockTask(false)
    <-  -+priv_doTask::agentPosition(AgentPosX,AgentPosY);
        -+priv_doTask::exploringMissingPOIs(b1,false);
        !checkForDispenser(AgentPosX, AgentPosY);
        !doTask(AgentPosX, AgentPosY);
    .
+!doTask(AgentPosX, AgentPosY)
    : priv_doTask::exploringMissingPOIs(b1, true) & exploreFacade_exploreAdapter::export_exploredListB1(List) & List=[]
    & beliefBase_doTask::multiBlockTask(false)
    <-  -+priv_doTask::agentPosition(AgentPosX, AgentPosY);
        !doTask_exploreFacade::doSpiralExplore(AgentPosX, AgentPosY);
    .
+!doTask(AgentPosX, AgentPosY)
    : priv_doTask::movingToPOI(dispenser, true) & beliefBase_doTask::currRequiredDisp(b0,BlockFormX,BlockFormY)
    & priv_doTask::currB0(CurrB0_X, CurrB0_Y) & not (AgentPosX=CurrB0_X-BlockFormX & AgentPosY=CurrB0_Y-BlockFormY)
    <-  -+priv_doTask::agentPosition(AgentPosX, AgentPosY);
        !doTask_exploreFacade::searchForPOIs(AgentPosX, AgentPosY);
        !moveToDisp(AgentPosX, AgentPosY);
    .
+!moveToDisp(AgentPosX, AgentPosY)
    : beliefBase_doTask::currRequiredDisp(b0,BlockFormX,BlockFormY)
    <-  ?priv_doTask::currB0(CurrB0_X, CurrB0_Y);
        !doTask_movementFacade::moveToLocation(AgentPosX,AgentPosY, CurrB0_X-BlockFormX, CurrB0_Y-BlockFormY);
    .
+!doTask(AgentPosX, AgentPosY)
    : priv_doTask::movingToPOI(dispenser, true) & beliefBase_doTask::currRequiredDisp(b1,BlockFormX,BlockFormY)
    & priv_doTask::currB1(CurrB1_X, CurrB1_Y) & not (AgentPosX=CurrB1_X-BlockFormX & AgentPosY=CurrB1_Y-BlockFormY)
    <-  -+priv_doTask::agentPosition(AgentPosX, AgentPosY);
        !doTask_exploreFacade::searchForPOIs(AgentPosX, AgentPosY);
        !moveToDisp(AgentPosX, AgentPosY);
    .
+!moveToDisp(AgentPosX, AgentPosY)
    : beliefBase_doTask::currRequiredDisp(b1,BlockFormX,BlockFormY)
    <-  ?priv_doTask::currB1(CurrB1_X, CurrB1_Y);
        !doTask_movementFacade::moveToLocation(AgentPosX,AgentPosY, CurrB1_X-BlockFormX, CurrB1_Y-BlockFormY);
    .
+!doTask(AgentPosX, AgentPosY)
    : priv_doTask::movingToPOI(dispenser, true) & beliefBase_doTask::currRequiredDisp(b0,BlockFormX,BlockFormY)
    & priv_doTask::currB0(CurrB0_X, CurrB0_Y) & (AgentPosX=CurrB0_X-BlockFormX & AgentPosY=CurrB0_Y-BlockFormY)
    <-  -+priv_doTask::agentPosition(AgentPosX, AgentPosY);
        -+priv_doTask::movingToPOI(dispenser, false);
        -+priv_doTask::agentState(requesting, true);
        !doTask(AgentPosX, AgentPosY);
    .
+!doTask(AgentPosX, AgentPosY)
    : priv_doTask::movingToPOI(dispenser, true) & beliefBase_doTask::currRequiredDisp(b1,BlockFormX,BlockFormY)
    & priv_doTask::currB1(CurrB1_X, CurrB1_Y) & (AgentPosX=CurrB1_X-BlockFormX & AgentPosY=CurrB1_Y-BlockFormY)
    <-  -+priv_doTask::agentPosition(AgentPosX, AgentPosY);
        -+priv_doTask::movingToPOI(dispenser, false);
        -+priv_doTask::agentState(requesting, true);
        !doTask(AgentPosX, AgentPosY);
    .
+!doTask(AgentPosX, AgentPosY)
    : priv_doTask::agentState(requesting, true)
    <-  -+priv_doTask::agentPosition(AgentPosX, AgentPosY);
        -+priv_doTask::agentState(requesting, false);
        -+priv_doTask::executedAction(request,true);
        !beliefBase_doTask::requestBlock(BlockFormX,BlockFormY);
    .
+!doTask(AgentPosX, AgentPosY)
    : priv_doTask::executedAction(request,true)
    & (default::lastAction(request) & default::lastActionResult(success))
    <-  -+priv_doTask::agentPosition(AgentPosX, AgentPosY);
        -+priv_doTask::executedAction(request,false);
        -+priv_doTask::agentState(attaching, true);
        !doTask(AgentPosX, AgentPosY);
    .
+!doTask(AgentPosX, AgentPosY)
    : priv_doTask::executedAction(request,true) & (default::lastAction(request) 
    & (default::lastActionResult(failed_parameter) | default::lastActionResult(failed_target))) 
    //failed_parameter should not occur based on our implementation
    <-  -+priv_doTask::agentPosition(AgentPosX, AgentPosY);
        -+priv_doTask::executedAction(request,false);
        ?beliefBase_doTask::currRequiredDisp(Disp,_,_);
        !deleteWrongDispPosition(Disp);
        !checkForDispenser(AgentPosX,AgentPosY);
        !doTask(AgentPosX,AgentPosY);
    .
+!deleteWrongDispPosition(b0)
    <-  ?priv_doTask::currB0(CurrDispX, CurrDispY); 
        ?exploreFacade_exploreAdapter::export_exploredListB0(List);
        if(.member(b0(CurrDispX, CurrDispY), List)){
            .delete(b0(CurrDispX, CurrDispY), List, ListAfterDeletion);
            !exploreFacade_exploreAdapter::updateExploredList(b0, ListAfterDeletion);
            -+priv_doTask::currB0(999,999);
        }
    .
+!deleteWrongDispPosition(b1)
    <-  ?priv_doTask::currB1(CurrDispX, CurrDispY); 
        ?exploreFacade_exploreAdapter::export_exploredListB1(List);
        if(.member(b1(CurrDispX, CurrDispY), List)){
            .delete(b1(CurrDispX, CurrDispY), List, ListAfterDeletion);
            !exploreFacade_exploreAdapter::updateExploredList(b1, ListAfterDeletion);
            -+priv_doTask::currB1(999,999);
        }
    .
//another scenario: if agent attached to a block & tries to request a new block(attached block on Disp) -> failed_blocked
+!doTask(AgentPosX, AgentPosY)
    : priv_doTask::executedAction(request,true)
    & (default::lastAction(request) & default::lastActionResult(failed_blocked))
    <-  -+priv_doTask::agentPosition(AgentPosX, AgentPosY);
        -+priv_doTask::executedAction(request,false);
        -+priv_doTask::agentState(requesting,true);
        !doTask(AgentPosX, AgentPosY);
    .
+!doTask(AgentPosX, AgentPosY)
    : priv_doTask::agentState(attaching, true)
    <-  -+priv_doTask::agentPosition(AgentPosX, AgentPosY);
        -+priv_doTask::agentState(attaching, false);
        -+priv_doTask::executedAction(attach,true);
        !beliefBase_doTask::attachToBlock;
    .
+!doTask(AgentPosX, AgentPosY)
    : priv_doTask::executedAction(attach,true) & (default::lastAction(attach) 
    & (default::lastActionResult(failed_parameter) | default::lastActionResult(failed_target)))
    //failed_parameter should not occur based on our implementation
    <-  -+priv_doTask::agentPosition(AgentPosX, AgentPosY);
        -+priv_doTask::executedAction(attach,false);
        -+priv_doTask::agentState(requesting,true);
        !doTask(AgentPosX, AgentPosY);
    .
//attach failed failure code scenario to be optimized
+!doTask(AgentPosX, AgentPosY)
    : priv_doTask::executedAction(attach,true) & (default::lastAction(attach) 
    & default::lastActionResult(failed))
    <-  -+priv_doTask::agentPosition(AgentPosX, AgentPosY);
        -+priv_doTask::executedAction(attach,false);
        -+priv_doTask::agentState(requesting,true);
        !doTask(AgentPosX, AgentPosY);
    .
+!doTask(AgentPosX, AgentPosY)
    : priv_doTask::executedAction(attach,true)
    & (default::lastAction(attach) & default::lastActionResult(success))
    <-  -+priv_doTask::agentPosition(AgentPosX, AgentPosY);
        -+priv_doTask::executedAction(attach,false);
        !checkForGoal(AgentPosX, AgentPosY);
        !doTask(AgentPosX, AgentPosY);
    .
+!checkForGoal(AgentPosX, AgentPosY)
    : exploreFacade_exploreAdapter::export_exploredListGoal(List) & List\==[]
    <-  ?priv_doTask::currGoal(CurrGoal_X, CurrGoal_Y);
        !doTask_POIsComparison::findClosestPOI(AgentPosX,AgentPosY,CurrGoal_X,CurrGoal_Y,List,gl);
        ?doTask_POIsComparison::export_CurrPOI(CurrPOI_X,CurrPOI_Y);
        -+priv_doTask::currGoal(CurrPOI_X,CurrPOI_Y);
        -+priv_doTask::movingToPOI(goal, true);
    .
+!checkForGoal(AgentPosX, AgentPosY)
    : exploreFacade_exploreAdapter::export_exploredListGoal(List) & List=[] 
    <-  -+priv_doTask::exploringMissingPOIs(goal, true);
    .
+!doTask(AgentPosX, AgentPosY)
    : priv_doTask::exploringMissingPOIs(goal, true) & exploreFacade_exploreAdapter::export_exploredListGoal(List) & List\==[]
    <-  -+priv_doTask::agentPosition(AgentPosX, AgentPosY);
        -+priv_doTask::exploringMissingPOIs(goal,false);
        !checkForGoal(AgentPosX, AgentPosY);
        !doTask(AgentPosX,AgentPosY);
    .
+!doTask(AgentPosX, AgentPosY)
    : priv_doTask::exploringMissingPOIs(goal, true) & exploreFacade_exploreAdapter::export_exploredListGoal(List) & List=[]
    <-  -+priv_doTask::agentPosition(AgentPosX, AgentPosY);
        !doTask_exploreFacade::doSpiralExplore(AgentPosX, AgentPosY);
    .
+!doTask(AgentPosX, AgentPosY)
    : priv_doTask::movingToPOI(goal, true) & priv_doTask::currGoal(CurrGoal_X, CurrGoal_Y)
    & not (AgentPosX=CurrGoal_X & AgentPosY=CurrGoal_Y)
    <-  -+priv_doTask::agentPosition(AgentPosX, AgentPosY);
        !doTask_exploreFacade::searchForPOIs(AgentPosX, AgentPosY);
        !moveToGoal(AgentPosX, AgentPosY);
    .
+!moveToGoal(AgentPosX, AgentPosY)
    <-  ?priv_doTask::currGoal(CurrGoal_X, CurrGoal_Y);
        !doTask_movementFacade::moveToLocation(AgentPosX,AgentPosY, CurrGoal_X, CurrGoal_Y);
    .
+!doTask(AgentPosX, AgentPosY)
    : priv_doTask::movingToPOI(goal, true) & priv_doTask::currGoal(CurrGoal_X, CurrGoal_Y)
    & (AgentPosX=CurrGoal_X & AgentPosY=CurrGoal_Y)
    <-  -+priv_doTask::agentPosition(AgentPosX, AgentPosY);
        -+priv_doTask::movingToPOI(goal, false);
        -+priv_doTask::agentState(submitting, true);
        !doTask(AgentPosX,AgentPosY);
    .
+!doTask(AgentPosX, AgentPosY)
    : priv_doTask::agentState(submitting, true)
    <-  -+priv_doTask::agentPosition(AgentPosX,AgentPosY);
        -+priv_doTask::agentState(submitting,false);
        -+priv_doTask::executedAction(submit,true);
        ?beliefBase_doTask::acceptedTaskInfo(Task,_,_);
        !beliefBase_doTask::submitTask(Task);
    .
+!doTask(AgentPosX, AgentPosY)
    : priv_doTask::executedAction(submit,true)
    & (default::lastAction(submit) & default::lastActionResult(success))
    <-  -+priv_doTask::agentPosition(AgentPosX, AgentPosY);
        -+priv_doTask::executedAction(submit,false);
        -+priv_doTask::agentState(checkingTaskboard, true);
        !doTask(AgentPosX, AgentPosY);
    .
//failed submit scenario to be implemented. current scenario is to explore so that the agent does not stop working.
+!doTask(AgentPosX, AgentPosY)
    : priv_doTask::executedAction(submit,true)
    & (default::lastAction(submit) & (default::lastActionResult(failed) | default::lastActionResult(failed_target)))
    <-  -+priv_doTask::agentPosition(AgentPosX, AgentPosY);
        -+priv_doTask::executedAction(submit,false);
        -+priv_doTask::agentState(failedSubmitExplore,true);
        !doTask(AgentPosX,AgentPosY);
    .
//failed submit scenario to be implemented. current scenario is to explore so that the agent does not stop working.
+!doTask(AgentPosX, AgentPosY)
    : priv_doTask::agentState(failedSubmitExplore,true)
    <-  -+priv_doTask::agentPosition(AgentPosX, AgentPosY);
        !doTask_exploreFacade::doSpiralExplore(AgentPosX, AgentPosY);
    .