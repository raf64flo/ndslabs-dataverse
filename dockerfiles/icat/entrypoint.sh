#!/bin/bash

set -e

if [ "$1" = 'icat' ]; then
    # generate configuration responses
    /opt/irods/genresp.sh /opt/irods/setup_responses

    if [ -n "$RODS_ZONE" ]; then 
       sed -i "3s/.*/$RODS_ZONE/" /opt/irods/setup_responses
    else
       RODS_ZONE=`sed "3q;d" /opt/irods/setup_responses`
    fi 

    # set up the iCAT database
    service postgresql start
    /opt/irods/setupdb.sh /opt/irods/setup_responses

    # set up iRODS
    /opt/irods/config.sh /opt/irods/setup_responses

    sed -i 's/"irodsHost:".*/"irods_hods": "localhost"/' /var/lib/irods/.irods/irods_environment.json

    /opt/dataverse/setup-irods.sh

    # this script must end with a persistent foreground process
    sleep infinity

else
    exec "$@"
fi
