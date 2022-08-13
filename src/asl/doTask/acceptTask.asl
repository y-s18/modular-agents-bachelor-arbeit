currTasksAvailable(listLength, []).
getTasksListLength(TasksList, TasksListLength)
    :-  .findall(task(Task,StepLimit,REQs), default::task(Task,StepLimit,_,REQs)[source(percept)], TasksList) 
        & .length(TasksList, TasksListLength).


// plan for finding all tasks on BB then pass the list length as a parameter to acceptTask
+!findallTasks
    : getTasksListLength(TasksList, TasksListLength)
    <-  -+currTasksAvailable(TasksListLength, TasksList);
    .



+!acceptTask(TaskToAccept)
    : not default::task(_,_,_,_)[source(percept)]
    <-  .print("There no task available!");
        accept(T);
        /*this accept action is programmed to fail so that it can be 
          handled from !doTask with lastActionResult(failed_target)*/
    .

//acceptTask will have list length in the context, one for single block and one for multi block
+!acceptTask(TaskToAccept)
    : default::task(TaskToAccept,StepLimit,_,REQs)[source(percept)] //ask for a task after finding all tasks and communicating with the team agents
    <-  -+acceptedTaskInfo(TaskToAccept,StepLimit,REQs);
        .length(REQs,REQs_LEN);
        if(REQs_LEN=1){
            ?acceptedTaskInfo(_,_,[req(BlockFormX, BlockFormY, Disp)]);
            -+currRequiredDisp(Disp, BlockFormX, BlockFormY);
            -+multiBlockTask(false);
        }elif(REQs_LEN=2){
            ?default::task(TaskToAccept,_,_,[req(BlockFormX1, BlockFormY1, Dispenser1), req(BlockFormX2, BlockFormY2, Dispenser2)])[source(percept)];
            //add -+currRequiredDisp(Disp, BlockFormX, BlockFormY) for the accepter.
            //and send the info of the second Disp to the helper.
            -+multiBlockTask(true);
        }                       
        accept(TaskToAccept);
    .