## Dataverse 4.2.3

This is a preliminary implementation of the [Dataverse](http://dataverse.org/) and [TwoRavens](http://datascience.iq.harvard.edu/about-tworavens) services in Docker for use with the NDS Labs system. Dataverse is a web-based application used for sharing, preserving, citing, exploring, and analyzying research data. 

This is a preliminary implementation of the [Dataverse installation process](http://guides.dataverse.org/en/latest/installation/). Dataverse itself is a Java-based web application deployed under the Glassfish application server. It requires installations of Postgres, Solr 4.6.0, and R/Rserve. Dataverse optionally integrates with TwoRavens -- a Javascript-based application that runs under Apache/rApache and requires R shared librares.

### Building Docker images
The dockerfiles subdirectory contains Dockerfiles and associated startup files (e.g., entrypoint.sh) for each of these services. Custom images have been created for each of the following:

* Dataverse webapp (ndslabs/dataverse): Glassfish 4.1 + Dataverse webapp
* R/Rserve (ndslabs/dataverse-rserve): R core, Rserve + required R packages
* Solr 4.6.0 (ndslabs/dataverse-solr): Solr 4.6.0 + Dataverse schema
* TwoRavens (ndslabs/tworavens): Apache httpd, rApache, R core, required R packages, TwoRavens application
* iRODS iCAT (ndslabs/dvicat): iCAT server with bitcurator bulk_extractor and custom archiving rules.

Postgres 9.3 is used from an official image. 


### Starting Dataverse under Docker


Start a standard postgres container:
```
docker run --name=postgres -d  postgres:9.3
```

Start a Solr 4.6 container for Dataverse:
```
docker run --name=solr -d ndslabs/dataverse-solr:latest
```

Start optional Rserve container:
```
docker run --name=rserve -d ndslabs/dataverse-rserve:latest
```

Start optional TwoRavens container:
```
docker run --name=tworavens -d ndslabs/dataverse-tworavens:latest
```

Start the preservation iRods server w/ federation listener:
```
docker run -e RODS_ZONE=fedZone E -p 1247:1247 -d  --name=icat-preservation ndslabs/irods-icat:latest
```

Start the Dataverse-local iRods server with custom rules:
```
docker run -e RODS_ZONE=dvnZone -e PRESERVATION_USER=dataverse -e PRESERVATION_ZONE=fedZone -e PRESERVATION_SERVER=<hostname of icat-preservation container> -e PRESERVATION_SERVER_PORT=1247 -e PRESERVATION_SERVER_IP=<IP of icat-preservation container> -e PRESERVATION_PASSWORD=test --name=dataverse-icat -d ndslabs/dataverse-icat:dev
```


Without iRods containers: Start dataverse using the "link" flag to specify the other containers. Environment variables are used to setup the DVN database, user, and password
```
docker run -p 8080:8080 -d --link solr:solr --link postgres:postgres --link rserve:rserve --link tworavens:tworavens -e "POSTGRES_DATABASE=dvndb" -e "POSTGRES_USER=dvnapp" -e "POSTGRES_PASSWORD=secret"  --name=dataverse  ndslabs/dataverse:4.2.3 dataverse
```

With iRods containers:
```
docker run -d -p 8080:8080 --link solr:solr --link postgres:postgres -e "POSTGRES_DATABASE=dvndb" -e "POSTGRES_USER=dvnapp" -e "POSTGRES_PASSWORD=secret" -e "RSERVE_USER=rserve" -e "RSERVE_PASSWORD=rserve" -e DVICAT_PORT_1247_TCP_PORT=1247  -e DVICAT_PORT_1247_TCP_ADDR=$DVICAT_IP -e PRESERVATION_USER=dataverse -e PRESERVATION_PASSWORD=test -e RODS_ZONE=dvnZone  -e  --name=dataverse  ndslabs/dataverse:latest dataverse
```


If you run "docker logs -f dataverse" you can wait for the "Dataverse started" message.


### Simple test case
* Open <host>:8080 in your browser
* Login using the default dataverseAdmin/admin username and password
* From this interface, you can create dataverses, add users, groups, permissions, etc. 
* For now, we'll simply upload a file
* Select "Add Data+" > New Dataset
* Fill in required fields and select "Select files to add"
* Upload the test/test.csv file
* Select "Save dataset"
* Note that the file is converted to "Tabular" format and the "Explore" button is now enabled. Explore is the link to the TwoRavens service.
* Select "Explore", which will open the TwoRavens interface in a new tab or window
* The TwoRavens interface should display a network of variables.


### What's different
The following changes were made to the Dataverse application:
* Dataverse: Heavily customized startup process based on the dvinstall/install script.
* Dataverse: Static DDL for table creation
* Dataverse: Custom WAR with persistence.xml to avoid database recreation by EclipseLink on restart
* TwoRavens: Customized startup process based on the original install.pl
* TwoRavens: endpoint.sh reads Kubernetes-supplied environment variables and connects to required services
