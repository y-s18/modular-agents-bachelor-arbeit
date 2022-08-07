{include("movement/movementFacade.asl", doTask_movementFacade)}
{include("helperModules/POIsComparison.asl", doTask_POIsComparison)}
{include("acceptTask.asl", beliefBase_doTask)}
{include("getBlock.asl", beliefBase_doTask)}
{include("submitTask.asl", beliefBase_doTask)}
{include("explore/exploreFacade.asl", doTask_exploreFacade)}

distanceRule1(AgentPosX,AgentPosY,DestinationX,DestinationY) :- 
    ((math.abs(AgentPosX-DestinationX)>24 & DistX=50-math.abs(AgentPosX-DestinationX)) 
        | (math.abs(AgentPosX-DestinationX)<=24 & DistX=math.abs(AgentPosX-DestinationX)))
    & ((math.abs(AgentPosY-DestinationY)>24 & DistY=50-math.abs(AgentPosY-DestinationY)) 
        | (math.abs(AgentPosY-DestinationY)<=24 & DistY=math.abs(AgentPosY-DestinationY)))
    & DistX+DistY>2 .
distanceRule2(AgentPosX,AgentPosY,DestinationX,DestinationY) :- 
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
checkingTB(true).
movingToPOI(poi, false).
exploringMissingPOIs(missingPOI, false).
executedAction(actionName, false).
agentState(state, false).
{end}

+!doTask(AgentPosX, AgentPosY)
    : priv_doTask::checkingTB(true)
    <-  -+priv_doTask::agentPosition(AgentPosX, AgentPosY);
        !checkForTaskboard;
        -+priv_doTask::checkingTB(false);
        -+priv_doTask::movingToPOI(taskboard, true);
        !doTask(AgentPosX,AgentPosY);
    .
+!checkForTaskboard //add searchFor while moving towards TB,Goal,Disp
    <-  ?priv_doTask::agentPosition(AgentPosX, AgentPosY);
        ?exploreFacade_exploreAdapter::export_exploredListTaskboard(List);
        ?priv_doTask::currTaskboard(CurrTB_X, CurrTB_Y);
        !doTask_POIsComparison::findClosestPOI(AgentPosX, AgentPosY, CurrTB_X, CurrTB_Y, List, tb);
        ?doTask_POIsComparison::export_CurrPOI(CurrPOI_X, CurrPOI_Y);
        -+priv_doTask::currTaskboard(CurrPOI_X, CurrPOI_Y);
    .
+!doTask(AgentPosX, AgentPosY)
    : priv_doTask::movingToPOI(taskboard, true) & priv_doTask::currTaskboard(CurrTB_X,CurrTB_Y) 
    // & not (AgentPosX=CurrTB_X & AgentPosY=CurrTB_Y) 
    // Calculation to be corrected
    // & (math.abs((AgentPosX+AgentPosY)-(CurrTB_X+CurrTB_Y))>2)
    & distanceRule1(AgentPosX,AgentPosY,CurrTB_X,CurrTB_Y)
    <-  -+priv_doTask::agentPosition(AgentPosX, AgentPosY);
        !moveToTaskboard;
    .
+!moveToTaskboard
    <-  ?priv_doTask::agentPosition(AgentPosX, AgentPosY);
        ?priv_doTask::currTaskboard(CurrTB_X, CurrTB_Y);
        !doTask_movementFacade::moveToLocation(AgentPosX,AgentPosY,CurrTB_X,CurrTB_Y);
    .
+!doTask(AgentPosX, AgentPosY)
    : priv_doTask::movingToPOI(taskboard, true) & priv_doTask::currTaskboard(CurrTB_X,CurrTB_Y) 
    // & (AgentPosX=CurrTB_X & AgentPosY=CurrTB_Y)
    // Calculation to be corrected
    // & (math.abs((AgentPosX+AgentPosY)-(CurrTB_X+CurrTB_Y))<=2)
    & distanceRule2(AgentPosX,AgentPosY,CurrTB_X,CurrTB_Y)
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
        !checkForDispenser;
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
+!checkForDispenser
    : beliefBase_doTask::multiBlockTask(false) & beliefBase_doTask::currRequiredDisp(b0,_,_)
    & exploreFacade_exploreAdapter::export_exploredListB0(List) & List\==[]
    <-  ?priv_doTask::agentPosition(AgentPosX, AgentPosY);
        ?priv_doTask::currB0(CurrB0_X,CurrB0_Y);
        !doTask_POIsComparison::findClosestPOI(AgentPosX, AgentPosY, CurrB0_X, CurrB0_Y, List, b0);
        ?doTask_POIsComparison::export_CurrPOI(CurrPOI_X, CurrPOI_Y);
        -+priv_doTask::currB0(CurrPOI_X, CurrPOI_Y);
        -+priv_doTask::movingToPOI(dispenser, true);
    .
+!checkForDispenser
    : beliefBase_doTask::multiBlockTask(false) & beliefBase_doTask::currRequiredDisp(b0,_,_)
    & exploreFacade_exploreAdapter::export_exploredListB0(List) & List=[]
    <-  ?priv_doTask::agentPosition(AgentPosX, AgentPosY);
        -+priv_doTask::exploringMissingPOIs(b0, true);
    .
+!doTask(AgentPosX, AgentPosY)
    : priv_doTask::exploringMissingPOIs(b0,true) & exploreFacade_exploreAdapter::export_exploredListB0(List) & List\==[]
    & beliefBase_doTask::multiBlockTask(false)
    <-  -+priv_doTask::agentPosition(AgentPosX,AgentPosY);
        -+priv_doTask::exploringMissingPOIs(b0,false);
        !checkForDispenser;
        !doTask(AgentPosX, AgentPosY);
    .
+!doTask(AgentPosX, AgentPosY)
    : priv_doTask::exploringMissingPOIs(b0, true) & exploreFacade_exploreAdapter::export_exploredListB0(List) & List=[]
    & beliefBase_doTask::multiBlockTask(false)
    <-  -+priv_doTask::agentPosition(AgentPosX, AgentPosY);
        !doTask_exploreFacade::doSpiralExplore(AgentPosX, AgentPosY);
    .
+!checkForDispenser
    : beliefBase_doTask::multiBlockTask(false) & beliefBase_doTask::currRequiredDisp(b1,_,_)
    & exploreFacade_exploreAdapter::export_exploredListB1(List) & List\==[]
    <-  ?priv_doTask::agentPosition(AgentPosX, AgentPosY);
        ?priv_doTask::currB1(CurrB1_X, CurrB1_Y);
        !doTask_POIsComparison::findClosestPOI(AgentPosX, AgentPosY, CurrB1_X, CurrB1_Y, List, b1);
        ?doTask_POIsComparison::export_CurrPOI(CurrPOI_X, CurrPOI_Y);
        -+priv_doTask::currB1(CurrPOI_X, CurrPOI_Y);
        -+priv_doTask::movingToPOI(dispenser, true);
    .
+!checkForDispenser
    : beliefBase_doTask::multiBlockTask(false) & beliefBase_doTask::currRequiredDisp(b1,_,_)
    & exploreFacade_exploreAdapter::export_exploredListB1(List) & List=[]
    <-  ?priv_doTask::agentPosition(AgentPosX, AgentPosY);
        -+priv_doTask::exploringMissingPOIs(b1, true);
    .
+!doTask(AgentPosX, AgentPosY)
    : priv_doTask::exploringMissingPOIs(b1,true) & exploreFacade_exploreAdapter::export_exploredListB1(List) & List\==[]
    & beliefBase_doTask::multiBlockTask(false)
    <-  -+priv_doTask::agentPosition(AgentPosX,AgentPosY);
        -+priv_doTask::exploringMissingPOIs(b1,false);
        !checkForDispenser;
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
        !moveToDisp;
        //3. calculation for the taskboard/range from TB
    .
+!moveToDisp
    : beliefBase_doTask::currRequiredDisp(b0,BlockFormX,BlockFormY)
    <-  ?priv_doTask::agentPosition(AgentPosX, AgentPosY);
        ?priv_doTask::currB0(CurrB0_X, CurrB0_Y);
        !doTask_movementFacade::moveToLocation(AgentPosX,AgentPosY, CurrB0_X-BlockFormX, CurrB0_Y-BlockFormY);
    .
+!doTask(AgentPosX, AgentPosY)
    : priv_doTask::movingToPOI(dispenser, true) & beliefBase_doTask::currRequiredDisp(b1,BlockFormX,BlockFormY)
    & priv_doTask::currB1(CurrB1_X, CurrB1_Y) & not (AgentPosX=CurrB1_X-BlockFormX & AgentPosY=CurrB1_Y-BlockFormY)
    <-  -+priv_doTask::agentPosition(AgentPosX, AgentPosY);
        !moveToDisp;
        //3. calculation for the taskboard/range from TB
    .
+!moveToDisp
    : beliefBase_doTask::currRequiredDisp(b1,BlockFormX,BlockFormY)
    <-  ?priv_doTask::agentPosition(AgentPosX, AgentPosY);
        ?priv_doTask::currB1(CurrB1_X, CurrB1_Y);
        !doTask_movementFacade::moveToLocation(AgentPosX,AgentPosY, CurrB1_X-BlockFormX, CurrB1_Y-BlockFormY);
    .
+!doTask(AgentPosX, AgentPosY)
    : priv_doTask::movingToPOI(dispenser, true) & beliefBase_doTask::currRequiredDisp(b0,BlockFormX,BlockFormY)
    & priv_doTask::currB0(CurrB0_X, CurrB0_Y) & (AgentPosX=CurrB0_X-BlockFormX & AgentPosY=CurrB0_Y-BlockFormY)
    <-  -+priv_doTask::agentPosition(AgentPosX, AgentPosY);
        -+priv_doTask::movingToPOI(dispenser, false);
        -+priv_doTask::agentState(requesting, true);
        !doTask(AgentPosX, AgentPosY);
        //3. calculation for the taskboard/range from TB
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
    : (default::lastAction(request) & default::lastActionResult(success))
    & priv_doTask::executedAction(request,true)
    <-  -+priv_doTask::agentPosition(AgentPosX, AgentPosY);
        -+priv_doTask::executedAction(request,false);
        -+priv_doTask::agentState(attaching, true);
        !doTask(AgentPosX, AgentPosY);
    .
//request failed plan
+!doTask(AgentPosX, AgentPosY)
    : priv_doTask::agentState(attaching, true)
    <-  -+priv_doTask::agentPosition(AgentPosX, AgentPosY);
        -+priv_doTask::agentState(attaching, false);
        -+priv_doTask::executedAction(attach,true);
        !beliefBase_doTask::attachToBlock;
    .
+!doTask(AgentPosX, AgentPosY)
    : (default::lastAction(attach) & default::lastActionResult(success))
    & priv_doTask::executedAction(attach,true)
    <-  -+priv_doTask::agentPosition(AgentPosX, AgentPosY);
        -+priv_doTask::executedAction(attach,false);
        !checkForGoal;
        !doTask(AgentPosX, AgentPosY);
    .
+!checkForGoal
    : exploreFacade_exploreAdapter::export_exploredListGoal(List) & List\==[]
    <-  ?priv_doTask::agentPosition(AgentPosX, AgentPosY);
        // ?exploreFacade_exploreAdapter::export_exploredListGoal(List); //already in the context
        ?priv_doTask::currGoal(CurrGoal_X, CurrGoal_Y);
        !doTask_POIsComparison::findClosestPOI(AgentPosX,AgentPosY,CurrGoal_X,CurrGoal_Y,List,gl);
        ?doTask_POIsComparison::export_CurrPOI(CurrPOI_X,CurrPOI_Y);
        -+priv_doTask::currGoal(CurrPOI_X,CurrPOI_Y);
        -+priv_doTask::movingToPOI(goal, true);
    .
+!checkForGoal
    : exploreFacade_exploreAdapter::export_exploredListGoal(List) & List=[] 
    <-  ?priv_doTask::agentPosition(AgentPosX, AgentPosY);
        -+priv_doTask::exploringMissingPOIs(goal, true);
    .
+!doTask(AgentPosX, AgentPosY)
    : priv_doTask::exploringMissingPOIs(goal, true) & exploreFacade_exploreAdapter::export_exploredListGoal(List) & List\==[]
    <-  -+priv_doTask::agentPosition(AgentPosX, AgentPosY);
        -+priv_doTask::exploringMissingPOIs(goal,false);
        !checkForGoal;
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
        !moveToGoal;
    .
+!moveToGoal
    <-  ?priv_doTask::agentPosition(AgentPosX, AgentPosY);
        ?priv_doTask::currGoal(CurrGoal_X, CurrGoal_Y);
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
        -+priv_doTask::agentState(submitting, false);
        ?beliefBase_doTask::acceptedTaskInfo(Task,_,_);
        !beliefBase_doTask::submitTask(Task);
    .