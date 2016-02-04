#!/bin/bash

DATAVERSE_URL="$DATAVERSE_SERVICE_HOST:$DATAVERSE_SERVICE_PORT"
export DATAVERSE_URL;

TWORAVENS_URL="$RSERVE_SERVICE_HOST:80"
export TWORAVENS_URL;

curl -X PUT -d http://$DATAVERSE_URL/dataexplore/gui.html http://$TWORAVENS_URL/api/admin/settings/:TwoRavensUrl

# Configure TwoRavens to use DataVerse (and DataVerse to use TwoRavens)
#my $DATAVERSE_URL = $ENV{'DATAVERSE_URL'};
#my $RAPACHEURL = $ENV{'TWORAVENS_URL'};
/start-tworavens

# Start RServe, foregrounded
R CMD Rserve.dbg --vanilla
