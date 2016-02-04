#!/bin/bash

TIMEOUT=30

if [ -n "$DATAVERSE_SERVICE_HOST" ]; then
        DATAVERSE_HOST=$DATAVERSE_SERVICE_HOST
else
        DATAVERSE_HOST="localhost"
fi

if [ -n "$DATAVERSE_SERVICE_PORT" ]; then
        DATAVERSE_PORT=$DATAVERSE_SERVICE_PORT
else
        DATAVERSE_PORT=8080
fi

if [ -n "$TWORAVENS_SERVICE_HOST" ]; then
        TWORAVENS_HOST=$TWORAVENS_SERVICE_HOST
else
        TWORAVENS_HOST="localhost"
fi

DATAVERSE_URL="$DATAVERSE_HOST:$DATAVERSE_PORT"
export DATAVERSE_URL;

TWORAVENS_URL="$TWORAVENS_HOST:80"
export TWORAVENS_URL;


echo $DATAVERSE_URL
echo $TWORAVENS_URL

if ncat $DATAVERSE_HOST $DATAVERSE_PORT -w $TIMEOUT --send-only < /dev/null ; then
        echo DataVerse running;
	curl -X PUT -d http://$TWORAVENS_URL/dataexplore/gui.html http://$DATAVERSE_URL/api/admin/settings/:TwoRavensUrl
else
        echo Unable to register TwoRavens through DataVerse API
	curl -X PUT -d http://$TWORAVENS_URL/dataexplore/gui.html http://$DATAVERSE_URL/api/admin/settings/:TwoRavensUrl
fi

# Configure TwoRavens to use DataVerse (and DataVerse to use TwoRavens)
#my $DATAVERSE_URL = $ENV{'DATAVERSE_URL'};
#my $RAPACHEURL = $ENV{'TWORAVENS_URL'};
/start-tworavens
httpd -DFOREGROUND
