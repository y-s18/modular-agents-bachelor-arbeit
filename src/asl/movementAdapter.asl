{begin namespace(priv_movementAdapter, local)}
direction(s, 0,  1). 
direction(n, 0, -1). 
direction(w,-1,  0). 
direction(e, 1,  0).
{end}

+!convertStepCoordinatesToDirection(RsltDestinationX, RsltDestinationY)
    <- ?priv_movementAdapter::direction(RsltDirection, RsltDestinationX, RsltDestinationY);
        -+export_RsltDirection(RsltDirection);
    .
