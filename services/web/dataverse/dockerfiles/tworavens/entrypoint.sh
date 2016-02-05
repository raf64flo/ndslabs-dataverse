#!/bin/bash
#!/bin/bash

TIMEOUT=30

EXTERNAL_IP=$(curl http://api.ipify.org)

DATAVERSE_PORT=30000
TWORAVENS_PORT=30001
DATAVERSE_URL="http://$EXTERNAL_IP:$DATAVERSE_PORT"
export DATAVERSE_URL;

TWORAVENS_URL="http://$EXTERNAL_IP:$TWORAVENS_PORT"
export TWORAVENS_URL;

echo $DATAVERSE_URL
echo $TWORAVENS_URL

# Both DataVerse and TwoRavens need the external address/port for 
# each other.  Ports assumed via NodePort (DataVerse = 30000, TwoRavens = 30001)
if ncat $EXTERNAL_IP $DATAVERSE_PORT -w $TIMEOUT --send-only < /dev/null ; then
        echo DataVerse running;
	curl -X PUT -d $TWORAVENS_URL/dataexplore/gui.html $DATAVERSE_URL/api/admin/settings/:TwoRavensUrl
else
        echo Unable to register TwoRavens through DataVerse API
	curl -X PUT -d $TWORAVENS_URL/dataexplore/gui.html $DATAVERSE_URL/api/admin/settings/:TwoRavensUrl
fi

# Configure TwoRavens to use DataVerse (and DataVerse to use TwoRavens)
/start-tworavens
httpd -DFOREGROUND
