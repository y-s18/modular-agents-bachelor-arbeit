{begin namespace(priv_explore, local)}
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