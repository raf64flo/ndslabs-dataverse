#!/bin/bash
TMPPATH=/tmp/bcworking
VAULTPATH=/var/lib/irods/Vault
ZONE=/RODS_ZONE
/usr/bin/find "$TMPPATH" \-type f \( -name pii.txt -or -name ccn.txt \) -size +0c |xargs grep "Filename:" |awk '{print $3}' |sed 's|'$VAULTPATH'|'$ZONE'|'
