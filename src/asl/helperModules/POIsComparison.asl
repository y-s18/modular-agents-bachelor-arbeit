{begin namespace(priv_POIsComparison, local)}
{end}

+!findClosestPOI(AgentPosX, AgentPosY, CurrPOI_X, CurrPOI_Y, List, POI_Type)
    <-  !priv_POIsComparison::setUpBeliefs(AgentPosX, AgentPosY, CurrPOI_X, CurrPOI_Y);
        .length(List, LIST_LEN);
        !priv_POIsComparison::comparePOIs(0, List, LIST_LEN, POI_Type);
        ?priv_POIsComparison::currPOI(RsltPOI_X, RsltPOI_Y);
        -+export_CurrPOI(RsltPOI_X, RsltPOI_Y);
    .

{begin namespace(priv_POIsComparison, local)}
+!setUpBeliefs(AgentPosX, AgentPosY, CurrPOI_X, CurrPOI_Y)
    <-  -+priv_POIsComparison::agentPosition(AgentPosX,AgentPosY);
        -+priv_POIsComparison::currPOI(CurrPOI_X, CurrPOI_Y);
    .
+!comparePOIs(Counter, LIST, LIST_LEN, POI_Type)
    : Counter <= LIST_LEN-1
    <-  ?priv_POIsComparison::agentPosition(AgentPosX,AgentPosY);
        ?priv_POIsComparison::currPOI(CurrPOI_X, CurrPOI_Y);

        if(POI_Type=b0){.nth(Counter,LIST,b0(TmpPOI_X, TmpPOI_Y));}
        elif(POI_Type=b1){.nth(Counter,LIST,b1(TmpPOI_X, TmpPOI_Y));}
        elif(POI_Type=tb){.nth(Counter,LIST,taskboard(TmpPOI_X, TmpPOI_Y));}
        elif(POI_Type=gl){.nth(Counter,LIST,goal(TmpPOI_X, TmpPOI_Y));}

        if(math.abs(CurrPOI_X-AgentPosX)>24){CURR_DIST_X=math.abs(50-math.abs(CurrPOI_X-AgentPosX));}
        else {CURR_DIST_X=math.abs(CurrPOI_X-AgentPosX);}
        if(math.abs(CurrPOI_Y-AgentPosY)>24){CURR_DIST_Y=math.abs(50-math.abs(CurrPOI_Y-AgentPosY));}
        else {CURR_DIST_Y=math.abs(CurrPOI_Y-AgentPosY);}
        CURR_DIST=CURR_DIST_X+CURR_DIST_Y;

        if(math.abs(TmpPOI_X-AgentPosX)>24){TMP_DIST_X=math.abs(50-math.abs(TmpPOI_X-AgentPosX));}
        else {TMP_DIST_X=math.abs(TmpPOI_X-AgentPosX);}
        if(math.abs(TmpPOI_Y-AgentPosY)>24){TMP_DIST_Y=math.abs(50-math.abs(TmpPOI_Y-AgentPosY));}
        else {TMP_DIST_Y=math.abs(TmpPOI_Y-AgentPosY);}
        TMP_DIST=TMP_DIST_X+TMP_DIST_Y;

        if(TMP_DIST<CURR_DIST){-+priv_POIsComparison::currPOI(TmpPOI_X,TmpPOI_Y);}
        else{-+priv_POIsComparison::currPOI(CurrPOI_X,CurrPOI_Y);}

        !comparePOIs(Counter+1, LIST, LIST_LEN, POI_Type);
    .
+!comparePOIs(COUNTER, LIST, LIST_LEN, POI_Type)
    : COUNTER > LIST_LEN-1
    <-  .print("Finished comparing!")
    .
+!comparePOIs(0, LIST, 0, POI_Type)
    <-  ?priv_POIsComparison::currPOI(CurrPOI_X, CurrPOI_Y); 
        -+priv_POIsComparison::currPOI(CurrPOI_X, CurrPOI_Y);
    .
{end}
