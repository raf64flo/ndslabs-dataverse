kubectl create -f services/solr-svc.yaml
kubectl create -f services/postgres-svc.yaml
kubectl create -f services/rserve-svc.yaml
kubectl create -f services/dataverse-svc.yaml
kubectl create -f services/tworavens-svc.yaml

kubectl create -f controllers/rserve-rc.yaml
kubectl create -f controllers/solr-rc.yaml
kubectl create -f controllers/postgres-rc.yaml
kubectl create -f controllers/dataverse-rc.yaml
kubectl create -f controllers/tworavens-rc.yaml



dataversePort=`kubectl describe service dataverse  | grep "^NodePort" | awk '{print $3}' | cut -f1 -d"/"`
echo "It will take ~1 minute for DataVerse to start, "
echo "Then you should be able to access your DataVerse instance on <Node IP>:$dataversePort"

echo "kubectl logs `kubectl get pods | grep dataverse | cut -f1 -d' '`"
