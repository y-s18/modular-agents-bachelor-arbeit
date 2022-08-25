

+!broadcastToAllAgents(Message)
    <-  .broadcast(tell, receivedMsg(Message));
    .
+!sendToAgent(AgentName, Message)
    <-  .send(AgentName, tell, Message);
    .
+default::receivedMsg(Msg)[source(AgentName)]
    : Msg=didYouAcceptThisTask(AskedTask, AgentNum)
    <-  +default::getTasksAskedAboutList(Returned_List);
        +debug___________________belief("After +default::getTasksAskedAboutList, Returned_List: ", Returned_List);
        +default::executeStoreReceivedTaskName(AskedTask, Returned_List);
        ?default::myAgentNum(MyAgentNum);
        +default::getLatestTaskAskedAbout(Returned_Task);
        +debug___________________belief("After +default::getLatestTaskAskedAbout, Returned_Task: ", Returned_Task);
        +default::executeAnswerReceivedQuestion(Returned_Task, AskedTask, MyAgentNum,AgentNum, AgentName);
        
        // ?priv_doTask::tasksAskedAboutList(ListBeforeUpdate);
        // !storeReceivedTaskName(AskedTask, Returned_List);
        // ?default::myAgentNum(MyAgentNum);
        // ?priv_doTask::latestTaskAskedAbout(LatestTask);
        // !answerReceivedQuestion(LatestTask, AskedTask, MyAgentNum, AgentNum, AgentName);
        +debug___________________Question(receivedMsg(Msg)[source(AgentName)]);
        .abolish(default::receivedMsg(Msg)[source(AgentName)]);
    .
// +default::receivedMsg(Msg)[source(AgentName)]
//     : Msg=
//     <-  
//     .