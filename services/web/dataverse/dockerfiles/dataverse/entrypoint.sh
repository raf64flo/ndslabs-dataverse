#!/bin/bash

#
# Entrypoint script for DataVerse web application. This 
# script will wait for required services (Rserve, Postgres, Solr)
# before initializing the Glassfish server.
#

set -e

TIMEOUT=30

echo "Using Rserve at $RSERVE_SERVICE_HOST:$RSERVE_SERVICE_PORT"
echo "Using Solr at $SOLR_SERVICE_HOST:$SOLR_SERVICE_PORT"
echo "Using Postgres at $POSTGRES_SERVICE_HOST:$POSTGRES_SERVICE_PORT"

if [ -n "$RSERVE_SERVICE_HOST" ]; then
	RSERVE_HOST=$RSERVE_SERVICE_HOST
elif [ -z "$RSERVE_HOST" ]; then
	RSERVE_HOST="localhost"
fi
export RSERVE_HOST

if [ -n "$RSERVE_SERVICE_PORT" ]; then
	RSERVE_PORT=$RSERVE_SERVICE_PORT
elif [ -z "$RSERVE_PORT" ]; then
	RSERVE_PORT="6311"
fi
export RSERVE_PORT


if ncat $RSERVE_HOST $RSERVE_PORT -w $TIMEOUT --send-only < /dev/null ; then 
	echo Rserve running; 
else
	echo Required service Rserve not running on $RSERVE_HOST $RSERVE_PORT;
        exit 1 
fi


# postgres
if [ -n "$POSTGRES_SERVICE_HOST" ]; then
	POSTGRES_HOST=$POSTGRES_SERVICE_HOST
elif [ -z "$POSTGRES_HOST" ]; then
	POSTGRES_HOST="localhost"
fi
export POSTGRES_HOST

if [ -n "$POSTGRES_SERVICE_PORT" ]; then
	POSTGRES_PORT=$POSTGRES_SERVICE_PORT
else
	POSTGRES_PORT=5432
fi 
export POSTGRES_PORT

if ncat $POSTGRES_HOST $POSTGRES_PORT -w $TIMEOUT --send-only < /dev/null ; then 
	echo Postgres running; 
else
	echo Required service Postgres not running on $POSTGRES_HOST $POSTGRES_PORT;
        exit 1 
fi

# solr
if [ -n "$SOLR_SERVICE_HOST" ]; then
	SOLR_HOST=$SOLR_SERVICE_HOST
elif [ -z "$SOLR_HOST" ]; then
	SOLR_HOST="localhost"
fi
export SOLR_HOST

if [ -n "$SOLR_SERVICE_PORT" ]; then
	SOLR_PORT=$SOLR_SERVICE_PORT
else
	SOLR_PORT=8983
fi 
export SOLR_PORT

if ncat $SOLR_HOST $SOLR_PORT -w $TIMEOUT --send-only < /dev/null ; then 
	echo Solr running; 
else
	echo Required service Solr not running on $SOLR_HOST $SOLR_PORT;
        exit 1 
fi

cd ~/dvinstall
./start-dataverse

# TODO: Need a way to foreground glassfish without redeploying war. 
#       In the meantime, a simple loop to monitor the glassfish process
while (ps -ef | grep glassfish | grep -v grep > /dev/null ) ; do sleep 5; done
