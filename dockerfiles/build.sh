docker build -t ndslabs/dataverse:4.2.3 -f dataverse/Dockerfile dataverse
docker build -t ndslabs/dataverse-solr:latest -f solr/Dockerfile solr
docker build -t ndslabs/dataverse-rserve:latest -f rserve/Dockerfile rserve
docker build -t ndslabs/tworavens:latest -f tworavens/Dockerfile tworavens
