#!/bin/bash

mkdir -p ~/.irods
cat << EOF > ~/.irods/irods_environment.json
{
    "irods_host": "$IRODS_ADDRESS",
    "irods_port": $IRODS_PORT,
    "irods_user_name": "$IRODS_USER",
    "irods_zone_name": "$IRODS_ZONE"
}
EOF

iinit $IRODS_PASSWORD

/usr/sbin/crond
echo "irsync -r /usr/local/glassfish4/glassfish/domains/domain1/files/ i:dataverse" > /irsync.sh
chmod +x /irsync.sh
echo "*/5 * * * * /irsync.sh >> /irsync.log" | crontab
