{include("movement/movementFacade.asl", doTask_movementFacade)}
{include("helperModules/POIsComparison.asl", doTask_POIsComparison)}

{begin namespace(priv_doTask, local)}
currTaskboard(999, 999).
checkingTB(true).
moving(false).
accepting(false).
{end}

+!doTask(AgentPosX, AgentPosY)
    : priv_doTask::checkingTB(true)
    <-  -+priv_doTask::agentPosition(AgentPosX, AgentPosY);
        !checkForTaskboard;
        -+priv_doTask::checkingTB(false);
        -+priv_doTask::moving(true);
        skip;
    .
+!checkForTaskboard
    <-  ?priv_doTask::agentPosition(AgentPosX, AgentPosY);
        ?exploreFacade_exploreAdapter::export_exploredListTaskboard(List);
        ?priv_doTask::currTaskboard(CurrTB_X, CurrTB_Y);
        !doTask_POIsComparison::findClosestPOI(AgentPosX, AgentPosY, CurrTB_X, CurrTB_Y, List, tb);
        ?doTask_POIsComparison::export_CurrPOI(CurrPOI_X, CurrPOI_Y);
        -+priv_doTask::currTaskboard(CurrPOI_X, CurrPOI_Y);
        // .length(List, LIST_LEN);
        // !comparePOIs(0, List, LIST_LEN, tb);
    .
+!doTask(AgentPosX, AgentPosY)
    : priv_doTask::moving(true) & priv_doTask::currTaskboard(CurrTB_X,CurrTB_Y) 
    & not (AgentPosX=CurrTB_X & AgentPosY=CurrTB_Y)
    <-  -+priv_doTask::agentPosition(AgentPosX, AgentPosY);
        !moveToTaskboard;
    .
+!moveToTaskboard
    <-  ?priv_doTask::agentPosition(AgentPosX, AgentPosY);
        ?priv_doTask::currTaskboard(CurrTB_X, CurrTB_Y);
        !doTask_movementFacade::moveToLocation(AgentPosX,AgentPosY,CurrTB_X,CurrTB_Y);
    .
+!doTask(AgentPosX, AgentPosY)
    : priv_doTask::moving(true) & priv_doTask::currTaskboard(CurrTB_X,CurrTB_Y) 
    & (AgentPosX=CurrTB_X & AgentPosY=CurrTB_Y)
    <-  -+priv_doTask::agentPosition(AgentPosX, AgentPosY);
        -+priv_doTask::moving(false);
        -+priv_doTask::accepting(true);
        skip;
    .