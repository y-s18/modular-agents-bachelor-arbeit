{begin namespace(priv_explore, local)}
spiralStepRange(-1). //4
stepRangeMultiplicator(1). //1
multiplicatorMaximum(-1). //6
spiralLineDirection(ne). 
// endpointCoordinates(-1,-1).
{end}

+!searchFor(Something)
    <- .findall(Something, Something, SmthList);
        !priv_explore::updateSearchRsltList(SmthList);
        ?priv_explore::searchRsltList(TMP_List);
        -+export_SearchRsltList(TMP_List);
    .

{begin namespace(priv_explore, local)}
+!updateSearchRsltList(SmthList)
    : SmthList = []
    <-  -+searchRsltList([]);
        .print("No Updates"); 
    .
+!updateSearchRsltList(SmthList)
    : SmthList \== []
    <-  -+searchRsltList(SmthList);.
{end}
//plan name to be changed
+!spiralMovement(AgentPosX, AgentPosY, SpiralStepRange, MultiplicatorMaximum)
    <-  !setUp(AgentPosX, AgentPosY, SpiralStepRange, MultiplicatorMaximum);
        ?spiralLineDirection(Direction);
        !calculateSpiralLineEndpoint(Direction);
        ?spiralLineEndpoint(X_Endpoint, Y_Endpoint);
        !correctCoordinatesPOI(X_Endpoint, Y_Endpoint);
        ?correctedCoordinatesPOI(CorrectedEndpointX, CorrectedEndpointY);
        -+export_EndpointCoordinates(CorrectedEndpointX, CorrectedEndpointY);
    .

+!setUp(AgentPosX, AgentPosY, SpiralStepRange, MultiplicatorMaximum)
    : stepRangeMultiplicator(StepRangeMultiplicator)
    <-  -+priv_explore::spiralStepRange(SpiralStepRange);
        -+priv_explore::multiplicatorMaximum(MultiplicatorMaximum);
        -+agentPosition(AgentPosX, AgentPosY);
        if(StepRangeMultiplicator>MultiplicatorMaximum){ -+stepRangeMultiplicator(1);}
    .

+!calculateSpiralLineEndpoint(ne)
    : agentPosition(AgentPosX, AgentPosY) & spiralStepRange(SpiralStepRange) & stepRangeMultiplicator(StepRangeMultiplicator)
    <-  -+spiralLineEndpoint(AgentPosX+SpiralStepRange*StepRangeMultiplicator,
                             AgentPosY-SpiralStepRange*StepRangeMultiplicator);
        -+stepRangeMultiplicator(StepRangeMultiplicator+1);
    .
+!calculateSpiralLineEndpoint(se)
    : agentPosition(AgentPosX, AgentPosY) & spiralStepRange(SpiralStepRange) & stepRangeMultiplicator(StepRangeMultiplicator)
    <-  -+spiralLineEndpoint(AgentPosX+SpiralStepRange*StepRangeMultiplicator,
                             AgentPosY+SpiralStepRange*StepRangeMultiplicator);
    .
+!calculateSpiralLineEndpoint(sw)
    : agentPosition(AgentPosX, AgentPosY) & spiralStepRange(SpiralStepRange) & stepRangeMultiplicator(StepRangeMultiplicator)
    <-  -+spiralLineEndpoint(AgentPosX-SpiralStepRange*StepRangeMultiplicator,
                             AgentPosY+SpiralStepRange*StepRangeMultiplicator);
        -+stepRangeMultiplicator(StepRangeMultiplicator+1);
    .
+!calculateSpiralLineEndpoint(nw)
    : agentPosition(AgentPosX, AgentPosY) & spiralStepRange(SpiralStepRange) & stepRangeMultiplicator(StepRangeMultiplicator)
    <-  -+spiralLineEndpoint(AgentPosX-SpiralStepRange*StepRangeMultiplicator,
                             AgentPosY-SpiralStepRange*StepRangeMultiplicator);
    .

//to be removed
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
