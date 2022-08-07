{begin namespace(priv_getBlock, local)}
direction(s, 0,  1). 
direction(n, 0, -1). 
direction(w,-1,  0). 
direction(e, 1,  0).
requestAttachDir("").
{end}


+!requestBlock(BlockFormX, BlockFormY)
    <-  ?priv_getBlock::direction(RequestDir, BlockFormX, BlockFormY);
        -+priv_getBlock::requestAttachDir(RequestDir);
        request(RequestDir);
    .

+!attachToBlock
    <-  ?priv_getBlock::requestAttachDir(AttachDir);
        attach(AttachDir);
    .