## DataVerse 4.2.3

This is an experimental Kubernetes-based implemention of the [DataVerse](http://dataverse.org/) and [TwoRavens](http://datascience.iq.harvard.edu/about-tworavens) services. DataVerse is a web-based application used for sharing, preserving, citing, exploring, and analyzying researchdata. DataVerse is a Java-based web-application deployed under the Glassfish application server.  It requires an installation of Postgres, Solr, and R/Rserve. DataVerse optionally integrates with TwoRavens.  TwoRavens is a Javascript-based application that runs under Apache/rApache and requires R shared librares.

### Starting DataVerse Services


### Kubernetes

Start elasticsearch resource controller and service. Remember to wait for the resource controller before starting the service:

To start the ELK stack, simply run ./start-elk.sh

