{begin namespace(priv_coordinatesCorrector, local)}
{end}

+!correctCoordinatesPOI(POI_X, POI_Y)
    <-  !priv_coordinatesCorrector::correctPOI_X(POI_X);
        !priv_coordinatesCorrector::correctPOI_Y(POI_Y);
        -priv_coordinatesCorrector::correctedPOI_X(CorrectedPOI_X);
        -priv_coordinatesCorrector::correctedPOI_Y(CorrectedPOI_Y);
        -+correctedCoordinatesPOI(CorrectedPOI_X, CorrectedPOI_Y);
    .

{begin namespace(priv_coordinatesCorrector, local)}
+!correctPOI_X(POI_X): POI_X>=0 & POI_X<=49 <- +correctedPOI_X(POI_X);.
+!correctPOI_X(POI_X): POI_X>49 <- +correctedPOI_X(POI_X-50);.
+!correctPOI_X(POI_X): POI_X<0 <- +correctedPOI_X(POI_X+50);.

+!correctPOI_Y(POI_Y): POI_Y>=0 & POI_Y<=49 <- +correctedPOI_Y(POI_Y);.
+!correctPOI_Y(POI_Y): POI_Y>49 <- +correctedPOI_Y(POI_Y-50);.
+!correctPOI_Y(POI_Y): POI_Y<0 <- +correctedPOI_Y(POI_Y+50);.
{end}