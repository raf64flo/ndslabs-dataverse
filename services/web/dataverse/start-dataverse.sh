#!/bin/bash

start_rc_wait ()
{
 echo ""
 echo Starting controller $1

 if ! kubectl get rc | grep "^$1"; then
   echo "Creating rc for $1"
   kubectl create -f $2
 fi

 sleep 5
 pod=`kubectl get pods | grep "^$1" | awk '{print $1}'`

 status=`kubectl get pod/$pod -o go-template="{{range .status.conditions}}{{if eq .type \"Ready\" }}{{.status}}{{end}}{{end}}"`
 if [ "$status" != 'True' ]; then

   i=0
   while [ "$status" != 'True' ]; do
       echo "Waiting for $1 (Ready=$status)"
       status=`kubectl get pod/$pod -o go-template="{{range .status.conditions}}{{if eq .type \"Ready\" }}{{.status}}{{end}}{{end}}"`
       sleep 10
       ((i++))
       if [ $i == 30 ]; then
           echo "Problem starting $1"
           exit 1
       fi
   done
 fi
 echo "Service $1 (Ready=$status)"

 echo ""
}

kubectl create -f services/postgres-svc.yaml
kubectl create -f services/solr-svc.yaml
kubectl create -f services/rserve-svc.yaml
kubectl create -f services/dataverse-svc.yaml
kubectl create -f services/tworavens-svc.yaml

start_rc_wait "solr" "controllers/solr-rc.yaml" 
start_rc_wait "postgres" "controllers/postgres-rc.yaml" 
start_rc_wait "rserve" "controllers/rserve-rc.yaml" 
start_rc_wait "tworavens" "controllers/tworavens-rc.yaml"
start_rc_wait "dataverse" "controllers/dataverse-rc.yaml" 

sleep 5
kubectl get pods
kubectl get rc
kubectl get services


dataversePort=`kubectl describe service dataverse  | grep "^NodePort" | awk '{print $3}' | cut -f1 -d"/"`
twoRavensPort=`kubectl describe service tworavens  | grep "^NodePort" | awk '{print $3}' | cut -f1 -d"/"`
echo "It will take ~1 minute for DataVerse to start, "
echo "Then you should be able to access your DataVerse instance on <Node IP>:$dataversePort"

kubectl logs -f `kubectl get pods | grep "^dataverse" | cut -f1 -d' '`
