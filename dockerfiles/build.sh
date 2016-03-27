docker build -t ndslabs/dataverse:latest -f dataverse/Dockerfile dataverse
docker build -t ndslabs/dataverse-solr:latest -f solr/Dockerfile solr
docker build -t ndslabs/dataverse-rserve:latest -f rserve/Dockerfile rserve
docker build -t ndslabs/tworavens:latest -f tworavens/Dockerfile tworavens
docker build -t ndslabs/dataverse-icat:latest -f icat/Dockerfile icat
