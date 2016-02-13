#!/bin/bash
#!/bin/bash


set -e

if [ "$1" = 'tworavens' ]; then

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

  if ncat $EXTERNAL_IP $DATAVERSE_PORT -w $TIMEOUT --send-only < /dev/null ; then
    echo Glassfish running;

    # We need a better way to handle creation-order dependencies, but for now
    # poll the Dataverse instance until the webapp responds
    i=0;
    while [ "$(curl -Is $DATAVERSE_URL/resources/images/dataverseproject_logo.jpg | grep "^HTTP" | cut -f2 -d' ')" != "200" ]; do
      echo "Waiting for Dataverse..."
      sleep 10
  
      if [ $i -eq 10 ] ; then
         echo "Error: timeout waiting for Dataverse to start"
         exit 1;
         break;
      fi

      i=$(($i+1))
    done

    echo "Dataverse running"
    curl -X PUT -d $TWORAVENS_URL/dataexplore/gui.html $DATAVERSE_URL/api/admin/settings/:TwoRavensUrl
    # Configure TwoRavens to use DataVerse (and DataVerse to use TwoRavens)
    echo "Starting TwoRavens"
    /start-tworavens
    httpd -DFOREGROUND

  else
    echo Error: Dataverse is not running
    exit 1;
  fi
else
    exec "$@"
fi


