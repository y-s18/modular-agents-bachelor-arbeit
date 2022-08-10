+!broadcastMyInfo(MyName, MyTeam) <- .broadcast(tell, myInfoIs(MyName, MyTeam));.

+!assignAgentNumber(AgentName): AgentName=agentA1 <- +myAgentNum(1);.
+!assignAgentNumber(AgentName): AgentName=agentA2 <- +myAgentNum(2);.
+!assignAgentNumber(AgentName): AgentName=agentA3 <- +myAgentNum(3);.
+!assignAgentNumber(AgentName): AgentName=agentA4 <- +myAgentNum(4);.
+!assignAgentNumber(AgentName): AgentName=agentA5 <- +myAgentNum(5);.
+!assignAgentNumber(AgentName): AgentName=agentA6 <- +myAgentNum(6);.
+!assignAgentNumber(AgentName): AgentName=agentA7 <- +myAgentNum(7);.
+!assignAgentNumber(AgentName): AgentName=agentA8 <- +myAgentNum(8);.
+!assignAgentNumber(AgentName): AgentName=agentA9 <- +myAgentNum(9);.
+!assignAgentNumber(AgentName): AgentName=agentA10 <- +myAgentNum(10);.
+!assignAgentNumber(AgentName): AgentName=agentA11 <- +myAgentNum(11);.
+!assignAgentNumber(AgentName): AgentName=agentA12 <- +myAgentNum(12);.
+!assignAgentNumber(AgentName): AgentName=agentA13 <- +myAgentNum(13);.
+!assignAgentNumber(AgentName): AgentName=agentA14 <- +myAgentNum(14);.
+!assignAgentNumber(AgentName): AgentName=agentA15 <- +myAgentNum(15);.

+!saveMyTeamAgentNames(MyTeam) 
    <-  .findall(agent(AgentName),myInfoIs(AgentName,MyTeam),AgentsList); 
        -+myTeamAgentsList(AgentsList);
        .abolish(myInfoIs(_,_));
    .