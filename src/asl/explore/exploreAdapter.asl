{ include("explore.asl", exploreAdapter_INCL_explore) }

{begin namespace(priv_exploreAdapter, local)}
{end}
exploredListB0([]).
exploredListB1([]).
exploredListGoal([]).
exploredListTaskboard([]).

+!setUp
    <- ?exploreAdapter_INCL_explore::export_SearchRsltList(ImportedList);
        -+listToBeProcessed(ImportedList);
        .nth(0, ImportedList, FirstElement);
        -+elementToBeChecked(FirstElement);
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
            ?correctedCoordinatesPOI(X_PositionB0,Y_PositionB0);
            ?exploredListB0(ExploredListB0);
            if( not .member(b0(X_PositionB0,Y_PositionB0), ExploredListB0) ){
                .concat(ExploredListB0, [b0(X_PositionB0,Y_PositionB0)], TMP_List);
                -+exploredListB0(TMP_List);
            }
        }
    .
//+!processImportedList(b1)
//+!processImportedList(goal)
//+!processImportedList(taskboard)
+!calculatePositionPOI(POI_X, POI_Y)
    <-  ?position(AgentPosX, AgentPosY);
        X_PositionPOI = AgentPosX + POI_X;
        Y_PositionPOI = AgentPosY + POI_Y;
        !correctCoordinatesPOI(X_PositionPOI,Y_PositionPOI);
    .
+!correctCoordinatesPOI(POI_X, POI_Y)
    <-  !correctPOI_X(POI_X);
        !correctPOI_Y(POI_Y);
        -correctedPOI_X(CorrectedPOI_X);
        -correctedPOI_Y(CorrectedPOI_Y);
        -+correctedCoordinatesPOI(CorrectedPOI_X, CorrectedPOI_Y);
    .

+!correctPOI_X(POI_X): POI_X>=0 & POI_X<=49 <- +correctedPOI_X(POI_X);.
+!correctPOI_X(POI_X): POI_X>49 <- +correctedPOI_X(POI_X-50);.
+!correctPOI_X(POI_X): POI_X<0 <- +correctedPOI_X(POI_X+50);.

+!correctPOI_Y(POI_Y): POI_Y>=0 & POI_Y<=49 <- +correctedPOI_Y(POI_Y);.
+!correctPOI_Y(POI_Y): POI_Y>49 <- +correctedPOI_Y(POI_Y-50);.
+!correctPOI_Y(POI_Y): POI_Y<0 <- +correctedPOI_Y(POI_Y+50);.

+!startProcessing
    <-  !setUp;
        ?elementToBeChecked(Element);
        !checkElementsType(Element);
        ?elementType(ElementType);
        !processImportedList(ElementType);
    .
