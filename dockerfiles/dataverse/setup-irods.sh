#!/bin/bash

mkdir -p ~/.irods
cat << EOF > ~/.irods/irods_environment.json
{
    "irods_host": "$DVICAT_PORT_1247_TCP_ADDR",
    "irods_port": $DVICAT_PORT_1247_TCP_PORT,
    "irods_user_name": "$PRESERVATION_USER",
    "irods_zone_name": "$RODS_ZONE"
}
EOF

iinit $PRESERVATION_PASSWORD

/usr/sbin/crond
echo "irsync -r /usr/local/glassfish4/glassfish/domains/domain1/files/ i:dvn_preservation/" > /irsync.sh
chmod +x /irsync.sh
echo "*/5 * * * * /irsync.sh >> /irsync.log" | crontab
