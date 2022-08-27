{ include("helperModules/coordinatesCorrector.asl", explore_INCL_coordinatesCorrector) }

{begin namespace(priv_explore, local)}
spiralStepRange(-1). //4
stepRangeMultiplicator(1). //1
multiplicatorMaximum(-1). //6
spiralLineDirection(nw). 
endpointCoordinates(-1,-1).
randomInitialDirection(true).
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
    : priv_explore::randomInitialDirection(true)
    <-  -+priv_explore::randomInitialDirection(false);
        !priv_explore::chooseInitialExploreDirection;
        !calculateNextSpiralLine(AgentPosX, AgentPosY, SpiralStepRange, MultiplicatorMaximum);
    .
+!calculateNextSpiralLine(AgentPosX, AgentPosY, SpiralStepRange, MultiplicatorMaximum)
    : (priv_explore::endpointCoordinates(SavedEndpointX,SavedEndpointY) 
      & (AgentPosX=SavedEndpointX & AgentPosY=SavedEndpointY)) | priv_explore::endpointCoordinates(-1,-1)
      & priv_explore::randomInitialDirection(false)
    <-  !priv_explore::updateBeliefsForCalculation(AgentPosX,AgentPosY,SpiralStepRange,MultiplicatorMaximum);
        ?priv_explore::spiralLineDirection(Direction);
        !priv_explore::calculateSpiralLineEndpoint(Direction);
        ?priv_explore::spiralLineEndpoint(X_Endpoint, Y_Endpoint);
        !explore_INCL_coordinatesCorrector::correctCoordinatesPOI(X_Endpoint, Y_Endpoint);
        ?explore_INCL_coordinatesCorrector::correctedCoordinatesPOI(CorrectedEndpointX, CorrectedEndpointY);
        -+priv_explore::endpointCoordinates(CorrectedEndpointX, CorrectedEndpointY);
        -+export_EndpointCoordinates(CorrectedEndpointX, CorrectedEndpointY);
    .
+!calculateNextSpiralLine(AgentPosX, AgentPosY, SpiralStepRange, MultiplicatorMaximum)
    : priv_explore::endpointCoordinates(EndpointX,EndpointY) & not (AgentPosX=EndpointX & AgentPosY=EndpointY) 
    & priv_explore::randomInitialDirection(false)
    <-  !priv_explore::updateAgentPosition(AgentPosX, AgentPosY);.
    
{begin namespace(priv_explore, local)}
+!chooseInitialExploreDirection
	<-	.random([1,2,3,4], RandomNum);
		!priv_explore::chooseRandomSpiralLineDirection(RandomNum);
	.
+!chooseRandomSpiralLineDirection(1)
	<-	-+spiralLineDirection(ne);
    .
+!chooseRandomSpiralLineDirection(2)
	<-	-+spiralLineDirection(nw);
    .
+!chooseRandomSpiralLineDirection(3)
	<-	-+spiralLineDirection(se);
    .
+!chooseRandomSpiralLineDirection(4)
	<-	-+spiralLineDirection(sw);
    .
+!updateBeliefsForCalculation(AgentPosX, AgentPosY, SpiralStepRange, MultiplicatorMaximum)
    : stepRangeMultiplicator(StepRangeMultiplicator) 
    <-  -+priv_explore::spiralStepRange(SpiralStepRange);
        -+priv_explore::multiplicatorMaximum(MultiplicatorMaximum);
        !updateAgentPosition(AgentPosX, AgentPosY);
        if(StepRangeMultiplicator>MultiplicatorMaximum){ -+stepRangeMultiplicator(1);}
        !updateNextLineDirection;
    .
+!updateAgentPosition(AgentPosX, AgentPosY)
    <-  -+agentPosition(AgentPosX, AgentPosY);.

+!updateNextLineDirection
    : spiralLineDirection(ne) <- -+spiralLineDirection(se);.
+!updateNextLineDirection
    : spiralLineDirection(se) <- -+spiralLineDirection(sw);.
+!updateNextLineDirection
    : spiralLineDirection(sw) <- -+spiralLineDirection(nw);.
+!updateNextLineDirection
    : spiralLineDirection(nw) <- -+spiralLineDirection(ne);.

+!calculateSpiralLineEndpoint(ne)
    : agentPosition(AgentPosX, AgentPosY) & spiralStepRange(SpiralStepRange) 
    & stepRangeMultiplicator(StepRangeMultiplicator)
    <-  -+spiralLineEndpoint(AgentPosX+SpiralStepRange*StepRangeMultiplicator,
                             AgentPosY-SpiralStepRange*StepRangeMultiplicator);
        -+stepRangeMultiplicator(StepRangeMultiplicator+1);
    .
+!calculateSpiralLineEndpoint(se)
    : agentPosition(AgentPosX, AgentPosY) & spiralStepRange(SpiralStepRange) 
    & stepRangeMultiplicator(StepRangeMultiplicator)
    <-  -+spiralLineEndpoint(AgentPosX+SpiralStepRange*StepRangeMultiplicator,
                             AgentPosY+SpiralStepRange*StepRangeMultiplicator);
    .
+!calculateSpiralLineEndpoint(sw)
    : agentPosition(AgentPosX, AgentPosY) & spiralStepRange(SpiralStepRange) 
    & stepRangeMultiplicator(StepRangeMultiplicator)   
    <-  -+spiralLineEndpoint(AgentPosX-SpiralStepRange*StepRangeMultiplicator,
                             AgentPosY+SpiralStepRange*StepRangeMultiplicator);
        -+stepRangeMultiplicator(StepRangeMultiplicator+1);
    .
+!calculateSpiralLineEndpoint(nw)
    : agentPosition(AgentPosX, AgentPosY) & spiralStepRange(SpiralStepRange) 
    & stepRangeMultiplicator(StepRangeMultiplicator)
    <-  -+spiralLineEndpoint(AgentPosX-SpiralStepRange*StepRangeMultiplicator,
                             AgentPosY-SpiralStepRange*StepRangeMultiplicator);
    .
{end}
