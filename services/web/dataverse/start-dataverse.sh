#!/bin/bash

#
# Very basic function that waits for pods in a service to be
# in the "Running" state before returning.
#
start_service_wait ()
{
 echo Starting service $1

 if ! kubectl get services | grep "^$1"; then
   echo "Creating $1 service"
   kubectl create -f $3
 fi

 if ! kubectl get rc | grep "^$1"; then
   echo "Creating rc for $1"
   kubectl create -f $2
 fi

 status=`kubectl get pods | grep $1 | awk '{print $3}'`
 if [ "$status" != 'Running' ]; then

   i=0
   while [ "$status" != 'Running' ]; do
       echo "Waiting for $1 ($status)"
       status=`kubectl get pods | grep $1 | awk '{print $3}'`
       sleep 5
       ((i++))
       if [ $i == 5 ]; then
           echo "Problem starting $1"
           exit 1
       fi
   done
       echo "Service $1 $status"
 else
   echo "Service $1 $status"
 fi

 echo ""
}

start_service_wait "solr" "controllers/solr-rc.yaml" "services/solr-svc.yaml"
start_service_wait "postgres" "controllers/postgres-rc.yaml" "services/postgres-svc.yaml"
start_service_wait "rserve" "controllers/rserve-rc.yaml" "services/rserve-svc.yaml"
start_service_wait "dataverse" "controllers/dataverse-rc.yaml" "services/dataverse-svc.yaml"
start_service_wait "tworavens" "controllers/tworavens-rc.yaml" "services/tworavens-svc.yaml"

sleep 5
kubectl get pods
kubectl get rc
kubectl get services

#kubectl create -f services/solr-svc.yaml
#kubectl create -f services/postgres-svc.yaml
#kubectl create -f services/rserve-svc.yaml
#kubectl create -f services/dataverse-svc.yaml
#kubectl create -f services/tworavens-svc.yaml

#kubectl create -f controllers/rserve-rc.yaml
#kubectl create -f controllers/solr-rc.yaml
#kubectl create -f controllers/postgres-rc.yaml
#kubectl create -f controllers/dataverse-rc.yaml
#kubectl create -f controllers/tworavens-rc.yaml



dataversePort=`kubectl describe service dataverse  | grep "^NodePort" | awk '{print $3}' | cut -f1 -d"/"`
twoRavensPort=`kubectl describe service tworavens  | grep "^NodePort" | awk '{print $3}' | cut -f1 -d"/"`
echo "It will take ~1 minute for DataVerse to start, "
echo "Then you should be able to access your DataVerse instance on <Node IP>:$dataversePort"

kubectl logs `kubectl get pods | grep tworavens | cut -f1 -d' '`
