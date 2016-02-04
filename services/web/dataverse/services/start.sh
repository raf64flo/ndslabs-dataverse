kubectl create -f solr-svc.yaml
kubectl create -f dataverse-svc.yaml
kubectl create -f postgres-svc.yaml
kubectl create -f rserve-svc.yaml

kubectl create -f rserve-rc.yaml
kubectl create -f solr-rc.yaml
kubectl create -f postgres-rc.yaml

sleep(30)

kubectl create -f dataverse-rc.yaml
