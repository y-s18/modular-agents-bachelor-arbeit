{begin namespace(priv_explore, local)}

+!updateSearchRsltList(SmthList)
    : SmthList = []
    <- +debugBelief____________________Before(".print('No Updates');");
        .print("No Updates"); 
    .

+!updateSearchRsltList(SmthList)
    : SmthList \== []
    <- +debugBelief____________________Before("-+searchRsltList");
        -+searchRsltList(SmthList);
        +debugBelief____________________After("-+searchRsltList"); 
    .
{end}

+!searchFor(Something)
    <- .findall(Something, Something, SmthList);
        !priv_explore::updateSearchRsltList(SmthList);
        ?priv_explore::searchRsltList(TMP_List);
        -+export_SearchRsltList(TMP_List);
    .

// +!searchFor(Something)
//     : not Something
//     <-  +debugBelief____________________Params("Something = ", Something);
//         // .print("Hello");
//         .
