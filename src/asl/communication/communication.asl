

+!broadcastToAllAgents(Message)
    <-  .broadcast(tell, Message);
    .
+!sendToAgent(AgentName, Message)
    <-  .send(AgentName, tell, Message);
    .
