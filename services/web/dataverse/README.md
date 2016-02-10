## Dataverse 4.2.3

This is an experimental Kubernetes-based implemention of the [Dataverse](http://dataverse.org/) and [TwoRavens](http://datascience.iq.harvard.edu/about-tworavens) services. Dataverse is a web-based application used for sharing, preserving, citing, exploring, and analyzying research data. 

This is a preliminary implementation of the [Dataverse installation process](http://guides.dataverse.org/en/latest/installation/). Dataverse itself is a Java-based web application deployed under the Glassfish application server. It requires installations of Postgres, Solr 4.6.0, and R/Rserve. Dataverse optionally integrates with TwoRavens -- a Javascript-based application that runs under Apache/rApache and requires R shared librares.

### Building Docker images
The dockerfiles subdirectory contains Dockerfiles and associated startup files (e.g., entrypoint.sh) for each of these services. Custom images have been created for each of the following:

* Dataverse webapp (ndslabs/dataverse): Glassfish 4.1 + Dataverse webapp
* R/Rserve (ndslabs/dataverse-rserve): R core, Rserve + required R packages
* Solr 4.6.0 (ndslabs/dataverse-solr): Solr 4.6.0 + Dataverse schema
* TwoRavens (ndslabs/tworavens): Apache httpd, rApache, R core, required R packages, TwoRavens application

Postgres 9.3 is used from an official image. 

To build all custom images:
```
cd services/web/dataverse/dockerfiles
make 
```


### Versioning
All images currently have version "latest"

### Starting Dataverse Services under Kubernetes

A simple script has been provided to start these services under Kubernetes:

```
start-dataverse.sh
```

### What's different
The following changes were made to the Dataverse application:
* Dataverse: Heavily customized startup process based on the dvinstall/install script.
* Dataverse: endpoint.sh reads Kubernetes-supplied environment variables and connects to required services
* Dataverse: Custom WAR with persistence.xml to avoid database recreation by EclipseLink on restart
* TwoRavens: Customized startup process based on the original install.pl
* TwoRavens: endpoint.sh reads Kubernetes-supplied environment variables and connects to required services


### Open issues
* Can't access /proc/meminfo
* TwoRavens and Dataverse both need the public address/port of each service for integration.  This is currently achieved through the use of Kubernetes NodePort and a hack to tworavens/endpoint.sh to read the public IP of the host. This opens questions about use of Kubernetes to host publicly accessible services.
* This implementation does not include Shibboleth
* Older versions of DataVerse rely on Rserve, but this integration is no longer apparent in 4.2.3
* Volumes are currently not implemented

