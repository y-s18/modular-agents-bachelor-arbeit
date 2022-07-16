{ include("helperModules/coordinatesCorrector.asl", explore_INCL_coordinatesCorrector) }

{begin namespace(priv_explore, local)}
spiralStepRange(-1). //4
stepRangeMultiplicator(1). //1
multiplicatorMaximum(-1). //6
spiralLineDirection(ne). 
endpointCoordinates(-1,-1).
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
    <-  -+searchRsltList([]);.
+!updateSearchRsltList(SmthList)
    : SmthList \== []
    <-  -+searchRsltList(SmthList);.
{end}

+!calculateNextSpiralLine(AgentPosX, AgentPosY, SpiralStepRange, MultiplicatorMaximum)
    <-  !priv_explore::setUp(AgentPosX, AgentPosY, SpiralStepRange, MultiplicatorMaximum);
        ?priv_explore::spiralLineDirection(Direction);
        !priv_explore::calculateSpiralLineEndpoint(Direction);
        ?priv_explore::spiralLineEndpoint(X_Endpoint, Y_Endpoint);
        // .include("helperModules/coordinatesCorrector.asl", explore_INCL_coordinatesCorrector);
        !explore_INCL_coordinatesCorrector::correctCoordinatesPOI(X_Endpoint, Y_Endpoint);
        //TBD: change ? to -
        ?explore_INCL_coordinatesCorrector::correctedCoordinatesPOI(CorrectedEndpointX, CorrectedEndpointY);
        -+priv_explore::endpointCoordinates(CorrectedEndpointX, CorrectedEndpointY);
        -+export_EndpointCoordinates(CorrectedEndpointX, CorrectedEndpointY);
    .

{begin namespace(priv_explore, local)}
+!setUp(AgentPosX, AgentPosY, SpiralStepRange, MultiplicatorMaximum)
    : stepRangeMultiplicator(StepRangeMultiplicator) & endpointCoordinates(X_Endpoint, Y_Endpoint)
    & not (AgentPosX=X_Endpoint & AgentPosY=Y_Endpoint)
    <-  -+priv_explore::spiralStepRange(SpiralStepRange);
        -+priv_explore::multiplicatorMaximum(MultiplicatorMaximum);
        -+agentPosition(AgentPosX, AgentPosY);
        if(StepRangeMultiplicator>MultiplicatorMaximum){ -+stepRangeMultiplicator(1);}
    .
+!setUp(AgentPosX, AgentPosY, SpiralStepRange, MultiplicatorMaximum)
    : stepRangeMultiplicator(StepRangeMultiplicator) & endpointCoordinates(X_Endpoint, Y_Endpoint)
    & (AgentPosX=X_Endpoint & AgentPosY=Y_Endpoint)
    <-  -+priv_explore::spiralStepRange(SpiralStepRange);
        -+priv_explore::multiplicatorMaximum(MultiplicatorMaximum);
        -+agentPosition(AgentPosX, AgentPosY);
        if(StepRangeMultiplicator>MultiplicatorMaximum){ -+stepRangeMultiplicator(1);}
        !updateNextLineDirection;
    .
+!updateNextLineDirection
    : spiralLineDirection(ne) <- -+spiralLineDirection(se);.
+!updateNextLineDirection
    : spiralLineDirection(se) <- -+spiralLineDirection(sw);.
+!updateNextLineDirection
    : spiralLineDirection(sw) <- -+spiralLineDirection(nw);.
+!updateNextLineDirection
    : spiralLineDirection(nw) <- -+spiralLineDirection(ne);.

+!calculateSpiralLineEndpoint(_)
    : agentPosition(AgentPosX, AgentPosY) & spiralStepRange(SpiralStepRange) 
    & stepRangeMultiplicator(StepRangeMultiplicator) & endpointCoordinates(X_Endpoint,Y_Endpoint) 
    & (X_Endpoint \== -1 & Y_Endpoint \== -1) & not (AgentPosX=X_Endpoint & AgentPosY=Y_Endpoint)
    <-  .print("Agent did not reach the previous endpoint! No endpoint update!");
    .
+!calculateSpiralLineEndpoint(ne) //for first time call.
    : agentPosition(AgentPosX, AgentPosY) & spiralStepRange(SpiralStepRange) 
    & stepRangeMultiplicator(StepRangeMultiplicator) & endpointCoordinates(-1,-1) 
    <-  -+spiralLineEndpoint(AgentPosX+SpiralStepRange*StepRangeMultiplicator,
                             AgentPosY-SpiralStepRange*StepRangeMultiplicator);
        -+stepRangeMultiplicator(StepRangeMultiplicator+1);
    .
+!calculateSpiralLineEndpoint(ne)
    : agentPosition(AgentPosX, AgentPosY) & spiralStepRange(SpiralStepRange) 
    & stepRangeMultiplicator(StepRangeMultiplicator) & endpointCoordinates(X_Endpoint,Y_Endpoint) 
    & (AgentPosX=X_Endpoint & AgentPosY=Y_Endpoint)
    <-  -+spiralLineEndpoint(AgentPosX+SpiralStepRange*StepRangeMultiplicator,
                             AgentPosY-SpiralStepRange*StepRangeMultiplicator);
        -+stepRangeMultiplicator(StepRangeMultiplicator+1);
    .
+!calculateSpiralLineEndpoint(se)
    : agentPosition(AgentPosX, AgentPosY) & spiralStepRange(SpiralStepRange) 
    & stepRangeMultiplicator(StepRangeMultiplicator) & endpointCoordinates(X_Endpoint,Y_Endpoint) 
    & (AgentPosX=X_Endpoint & AgentPosY=Y_Endpoint)
    <-  -+spiralLineEndpoint(AgentPosX+SpiralStepRange*StepRangeMultiplicator,
                             AgentPosY+SpiralStepRange*StepRangeMultiplicator);
    .
+!calculateSpiralLineEndpoint(sw)
    : agentPosition(AgentPosX, AgentPosY) & spiralStepRange(SpiralStepRange) 
    & stepRangeMultiplicator(StepRangeMultiplicator) & endpointCoordinates(X_Endpoint,Y_Endpoint) 
    & (AgentPosX=X_Endpoint & AgentPosY=Y_Endpoint)    
    <-  -+spiralLineEndpoint(AgentPosX-SpiralStepRange*StepRangeMultiplicator,
                             AgentPosY+SpiralStepRange*StepRangeMultiplicator);
        -+stepRangeMultiplicator(StepRangeMultiplicator+1);
    .
+!calculateSpiralLineEndpoint(nw)
    : agentPosition(AgentPosX, AgentPosY) & spiralStepRange(SpiralStepRange) 
    & stepRangeMultiplicator(StepRangeMultiplicator) & endpointCoordinates(X_Endpoint,Y_Endpoint) 
    & (AgentPosX=X_Endpoint & AgentPosY=Y_Endpoint)
    <-  -+spiralLineEndpoint(AgentPosX-SpiralStepRange*StepRangeMultiplicator,
                             AgentPosY-SpiralStepRange*StepRangeMultiplicator);
    .
{end}
