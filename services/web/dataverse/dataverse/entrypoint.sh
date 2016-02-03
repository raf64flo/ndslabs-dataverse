#!/bin/bash
set -e


if [ -n "$RSERVE_PORT_6311_TCP_ADDR" ]; then
	RSERVE_HOST=$RSERVE_PORT_6311_TCP_ADDR
elif [ -z "$RSERVE_HOST" ]; then
	RSERVE_HOST="localhost"
fi
export RSERVE_HOST

if [ -n "$RSERVE_PORT_6311_TCP_PORT" ]; then
	RSERVE_PORT=$RSERVE_PORT_6311_TCP_PORT
elif [ -z "$RSERVE_PORT" ]; then
	RSERVE_PORT="6311"
fi
export RSERVE_PORT

# postgres
if [ -n "$POSTGRES_PORT_5432_TCP_ADDR" ]; then
	POSTGRES_HOST=$POSTGRES_PORT_5432_TCP_ADDR
elif [ -z "$POSTGRES_HOST" ]; then
	POSTGRES_HOST="localhost"
fi
export POSTGRES_HOST

if [ -n "$POSTGRES_PORT_5432_TCP_PORT" ]; then
	POSTGRES_PORT=$POSTGRES_PORT_5432_TCP_PORT
else
	POSTGRES_PORT=5432
fi 
export POSTGRES_PORT

cd ~/dvinstall
./start-dataverse

# For Docker, run glassfish verbose to foreground
#/usr/local/glassfish4/bin/asadmin stop-domain domain1
#/usr/local/glassfish4/bin/asadmin start-domain --verbose domain1
while (ps -ef | grep glassfish | grep -v grep) ; do sleep 5; done
