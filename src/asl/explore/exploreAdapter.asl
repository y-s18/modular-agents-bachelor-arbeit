{ include("helperModules/coordinatesCorrector.asl", exploreAdapter_coordinatesCorrector) }
{ include("explore.asl", exploreAdapter_explore) }

{begin namespace(priv_exploreAdapter, local)}
communicationNamespace(comm). // belief parameter is what the agent used to include communication module
exploredListB0([]).
exploredListB1([]).
exploredListGoal([]).
exploredListTaskboard([]).
activatePlan(false).

getListLength(List, Length) :- .length(List, Length).
{end}

+!updateExploredList(b0, UpdatedList)
    <-  -+priv_exploreAdapter::exploredListB0(UpdatedList);
        -+default::export_exploredListB0(UpdatedList);
    .
+!updateExploredList(b1, UpdatedList)
    <-  -+priv_exploreAdapter::exploredListB1(UpdatedList);
        -+default::export_exploredListB1(UpdatedList);
    .
+!updateExploredList(gl, UpdatedList)
    <-  -+priv_exploreAdapter::exploredListGoal(UpdatedList);
        -+default::export_exploredListGoal(UpdatedList);
    .
+!updateExploredList(tb, UpdatedList)
    <-  -+priv_exploreAdapter::exploredListTaskboard(UpdatedList);
        -+default::export_exploredListTaskboard(UpdatedList);
    .
+!calculateNextSpiralLine(AgentPosX, AgentPosY, SpiralStepRange, MultiplicatorMaximum)
    <-  !exploreAdapter_explore::calculateNextSpiralLine(AgentPosX, AgentPosY, SpiralStepRange, MultiplicatorMaximum);
        ?exploreAdapter_explore::export_EndpointCoordinates(CorrectedEndpointX, CorrectedEndpointY);
        -+default::export_EndpointCoordinates(CorrectedEndpointX, CorrectedEndpointY);
    .
+!searchFor(Something, AgentPosX, AgentPosY)
    <-  !exploreAdapter_explore::searchFor(Something);
        !priv_exploreAdapter::storePOIList(Something, OldPOIList);
        !priv_exploreAdapter::processExploredPOIs(AgentPosX, AgentPosY,Something);
        !priv_exploreAdapter::storePOIList(Something, NewPOIList);
        !priv_exploreAdapter::broadcastElementIfNewPOIExplored(OldPOIList,NewPOIList);
        -+priv_exploreAdapter::activatePlan(true);
        !exportPOIs;
        -+priv_exploreAdapter::activatePlan(false);
    .
{begin namespace(priv_exploreAdapter, local)}
+!storePOIList(Something, POIList)
    <-  !priv_exploreAdapter::checkElementsType(Something);
        ?priv_exploreAdapter::elementType(ElementType);
        !priv_exploreAdapter::getPOIList(ElementType, POIList);
    .
+!getPOIList(b0, POIList)
    <-  ?priv_exploreAdapter::exploredListB0(POIList);
    .
+!getPOIList(b1, POIList)
    <-  ?priv_exploreAdapter::exploredListB1(POIList);
    .
+!getPOIList(taskboard, POIList)
    <-  ?priv_exploreAdapter::exploredListTaskboard(POIList);
    .
+!getPOIList(goal, POIList)
    <-  ?priv_exploreAdapter::exploredListGoal(POIList);
    .
+!broadcastElementIfNewPOIExplored(OldPOIList, NewPOIList)
    : getListLength(OldPOIList, OldList_Len) & getListLength(NewPOIList, NewList_Len) & NewList_Len>OldList_Len
    <-  ?priv_exploreAdapter::communicationNamespace(CommNS);
        for(.range(I,OldList_Len,NewList_Len-1)){
            .nth(I,NewPOIList,POI);
            !CommNS::broadcastToAllAgents(POI);
        }
    .
+!broadcastElementIfNewPOIExplored(OldPOIList, NewPOIList)
    : getListLength(OldPOIList, OldList_Len) & getListLength(NewPOIList, NewList_Len) & NewList_Len=OldList_Len
    <-  .print("No new POIs! No need to broadcast!");
    .
+!processExploredPOIs(AgentPosX, AgentPosY, Something)
    : exploreAdapter_explore::export_SearchRsltList(ImportedList) & ImportedList \== []
    <-  !updateBeliefsForProcessing(AgentPosX,AgentPosY,Something);
        ?elementToBeChecked(Element);
        !checkElementsType(Element);
        ?elementType(ElementType);
        !processImportedList(ElementType);
    .
+!updateBeliefsForProcessing(AgentPosX, AgentPosY, Something)
    <-  ?exploreAdapter_explore::export_SearchRsltList(ImportedList);
        -+agentPosition(AgentPosX, AgentPosY);
        -+listToBeProcessed(ImportedList);
        -+elementToBeChecked(Something);
    .
+!checkElementsType(Element)
    : Element = thing(_,_,dispenser,b0)
    <-  -+elementType(b0);.
+!checkElementsType(Element)
    : Element = thing(_,_,dispenser,b1)
    <-  -+elementType(b1);.
+!checkElementsType(Element)
    : Element = thing(_,_,taskboard,_)
    <-  -+elementType(taskboard);.
+!checkElementsType(Element)
    : Element = goal(_,_)
    <-  -+elementType(goal);.

+!processImportedList(b0)
    <-  ?listToBeProcessed(ListToProcess);
        for( .member(thing(B0_X, B0_Y, dispenser, b0), ListToProcess)){
            !calculatePositionPOI(B0_X,B0_Y);
            ?exploreAdapter_coordinatesCorrector::correctedCoordinatesPOI(X_PositionB0,Y_PositionB0);
            ?exploredListB0(ExploredListB0);
            if( not .member(b0(X_PositionB0,Y_PositionB0), ExploredListB0) ){
                .concat(ExploredListB0, [b0(X_PositionB0,Y_PositionB0)], TMP_List);
                -+exploredListB0(TMP_List);
            }
        }
    .
+!processImportedList(b1)
    <-  ?listToBeProcessed(ListToProcess);
        for( .member(thing(B1_X, B1_Y, dispenser, b1), ListToProcess)){
            !calculatePositionPOI(B1_X,B1_Y);
            ?exploreAdapter_coordinatesCorrector::correctedCoordinatesPOI(X_PositionB1,Y_PositionB1);
            ?exploredListB1(ExploredListB1);
            if( not .member(b1(X_PositionB1,Y_PositionB1), ExploredListB1) ){
                .concat(ExploredListB1, [b1(X_PositionB1,Y_PositionB1)], TMP_List);
                -+exploredListB1(TMP_List);
            }
        }
    .
+!processImportedList(taskboard)
    <-  ?listToBeProcessed(ListToProcess);
        for( .member(thing(Taskboard_X, Taskboard_Y, taskboard,_), ListToProcess)){
            !calculatePositionPOI(Taskboard_X,Taskboard_Y);
            ?exploreAdapter_coordinatesCorrector::correctedCoordinatesPOI(X_PositionTaskboard,Y_PositionTaskboard);
            ?exploredListTaskboard(ExploredListTaskboard);
            if( not .member(taskboard(X_PositionTaskboard,Y_PositionTaskboard), ExploredListTaskboard) ){
                .concat(ExploredListTaskboard, [taskboard(X_PositionTaskboard,Y_PositionTaskboard)], TMP_List);
                -+exploredListTaskboard(TMP_List);
            }
        }
    .
+!processImportedList(goal)
    <-  ?listToBeProcessed(ListToProcess);
        for( .member(goal(Goal_X, Goal_Y), ListToProcess)){
            !calculatePositionPOI(Goal_X,Goal_Y);
            ?exploreAdapter_coordinatesCorrector::correctedCoordinatesPOI(X_PositionGoal,Y_PositionGoal);
            ?exploredListGoal(ExploredListGoal);
            if( not .member(goal(X_PositionGoal,Y_PositionGoal), ExploredListGoal) ){
                .concat(ExploredListGoal, [goal(X_PositionGoal,Y_PositionGoal)], TMP_List);
                -+exploredListGoal(TMP_List);
            }
        }
    .
+!calculatePositionPOI(POI_X, POI_Y)
    <-  ?agentPosition(AgentPosX, AgentPosY);
        X_PositionPOI = AgentPosX + POI_X;
        Y_PositionPOI = AgentPosY + POI_Y;
        !exploreAdapter_coordinatesCorrector::correctCoordinatesPOI(X_PositionPOI,Y_PositionPOI);
    .
{end}

+!exportPOIs
    : priv_exploreAdapter::activatePlan(true)
    <-  ?priv_exploreAdapter::exploredListB0(TMP_ListB0);
        ?priv_exploreAdapter::exploredListB1(TMP_ListB1);
        ?priv_exploreAdapter::exploredListGoal(TMP_ListGoal);
        ?priv_exploreAdapter::exploredListTaskboard(TMP_ListTaskboard);
        -+default::export_exploredListB0(TMP_ListB0);
        -+default::export_exploredListB1(TMP_ListB1);
        -+default::export_exploredListGoal(TMP_ListGoal);
        -+default::export_exploredListTaskboard(TMP_ListTaskboard);
    .
-!exportPOIs
    <-  .print("\n############\nPLAN FAILED: !exportPOIs can not be called from outside the module\n############\n");.

{begin namespace(priv_exploreAdapter, local)}
+!processExploredPOIs(AgentPosX, AgentPosY, Something)
    : exploreAdapter_explore::export_SearchRsltList(ImportedList) & ImportedList = []
    <-  .print("Empty list. No need for update");.
{end}

