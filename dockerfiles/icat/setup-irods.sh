#!/bin/bash

RODS_PASSWORD=`sed '14q;d' /opt/irods/setup_responses`

# Initialize the rods user environment
mkdir -p ~/.irods
cat << EOF > ~/.irods/irods_environment.json
{
    "irods_host": "localhost",
    "irods_port": 1247,
    "irods_user_name": "rods",
    "irods_zone_name": "$RODS_ZONE"
}
EOF
iinit $RODS_PASSWORD


# Update the rules files
sed -i "s/RODS_ZONE/$RODS_ZONE/g" /opt/dataverse/archive.r
sed -i "s/PRESERVATION_USER/$PRESERVATION_USER/g" /opt/dataverse/archive.r
sed -i "s/PRESERVATION_ZONE/$PRESERVATION_ZONE/g" /opt/dataverse/archive.r

sed -i "s/RODS_ZONE/$RODS_ZONE/g" /opt/dataverse/bitcurator.r
sed -i "s/PRESERVATION_USER/$PRESERVATION_USER/g" /opt/dataverse/bitcurator.r
sed -i "s/PRESERVATION_ZONE/$PRESERVATION_ZONE/g" /opt/dataverse/bitcurator.r
sed -i "s/CURATOR_EMAIL/$CURATOR_EMAIL/g" /opt/dataverse/bitcurator.r

sed -i "s/RODS_ZONE/$RODS_ZONE/g" /opt/dataverse/bitcurator_arg.r
sed -i "s/PRESERVATION_USER/$PRESERVATION_USER/g" /opt/dataverse/bitcurator_arg.r
sed -i "s/PRESERVATION_ZONE/$PRESERVATION_ZONE/g" /opt/dataverse/bitcurator_arg.r
sed -i "s/CURATOR_EMAIL/$CURATOR_EMAIL/g" /opt/dataverse/bitcurator_arg.r

sed -i "s/RODS_ZONE/$RODS_ZONE/g" /var/lib/irods/iRODS/server/bin/cmd/bcListSuspectedSensitive.sh

# Create the preservation user
iadmin mkuser $PRESERVATION_USER rodsuser
iadmin moduser $PRESERVATION_USER password $PRESERVATION_PASSWORD
iadmin mkzone $PRESERVATION_ZONE remote $PRESERVATION_SERVER_IP:$PRESERVATION_SERVER_PORT

mv ~/.irods ~/.irods.rods


# Initialize the preservation user environment
mkdir -p ~/.irods
cat << EOF > ~/.irods/irods_environment.json
{
    "irods_host": "localhost",
    "irods_port": 1247,
    "irods_user_name": "$PRESERVATION_USER",
    "irods_zone_name": "$RODS_ZONE"
}
EOF

iinit $PRESERVATION_PASSWORD

#mv ~/.irods ~/.irods.$PRESERVATION_USER

# Install bulk_extractor
cp /usr/local/bin/bulk_extractor /var/lib/irods/iRODS/server/bin/cmd

# Federate with the preservation server
cp /etc/irods/server_config.json /etc/irods/server_config.orig

curl --user admin:admin $PRESERVATION_SERVER_IP:8080/federation > /opt/dataverse/nds-dvn-federation.json
cat /etc/irods/server_config.orig | jq  --argfile fed /opt/dataverse/nds-dvn-federation.json  '.federation |= [$fed]' | jq '.re_rulebase_set |= . + [{"filename": "dataverse"}]' > /etc/irods/server_config.json
#cat /etc/irods/server_config.orig | jq  --argfile fed /opt/dataverse/nds-dvn-federation.json  '.federation |= [$fed]'  > /etc/irods/server_config.json
PRESERVATION_SERVER=`jq -r '.icat_host' /opt/dataverse/nds-dvn-federation.json`
echo "$PRESERVATION_SERVER_IP $PRESERVATION_SERVER" >> /etc/hosts


ZONE_NAME=`jq '.zone_name' /etc/irods/server_config.json`
ZONE_KEY=`jq '.zone_key' /etc/irods/server_config.json`
NEGOTIATION_KEY=`jq '.negotiation_key' /etc/irods/server_config.json`
IP_ADDRESS=`ifconfig eth0 | awk '/inet addr/{split($2,a,":"); print a[2]}'`

cat << EOF > /tmp/local_federation.json
{
   "user":"$PRESERVATION_USER",
   "icat_address":"$IP_ADDRESS",
   "federation" : {
        "icat_host":"$HOSTNAME",
        "zone_name":$ZONE_NAME,
        "negotiation_key":$NEGOTIATION_KEY,
        "zone_key":$ZONE_KEY
   }
}
EOF

echo "mailhub=$SMTP_SERVER:25" >> /etc/ssmtp/ssmtp.conf
echo "FromLineOverride=YES" >> /etc/ssmtp/ssmtp.conf


# register this instance with the preservation server
curl --user admin:admin -X POST -d @/tmp/local_federation.json $PRESERVATION_SERVER_IP:8080/federation


if [ -z "$CRON_FREQUENCY" ]; then
   CRON_FREQUENCY=5;
fi 

sed -i "s/CRON_FREQUENCY/$CRON_FREQUENCY/g" /opt/dataverse/bitcurator.r

echo "*/$CRON_FREQUENCY * * * * /opt/dataverse/archive.sh >> /archive.log" | crontab

cp /etc/irods/core.re /etc/irods/core.re.orig

sed -i "s#^acPostProcForPut.*#acPostProcForPut { ON(\$objPath like '/dvnZone/home/dataverse/dvn_preservation/\*') { writeLine('serverLog', 'acPostProcForPut \$objPath'); msiExecCmd('dvArchive.sh', '\$objPath', 'null', 'null','null',\*Junk); } }#g" /etc/irods/core.re

# Make sure rods user can write to dataverse collection
ichmod -r write rods /dvnZone/home/dataverse/
ichmod -r inherit /dvnZone/home/dataverse/
