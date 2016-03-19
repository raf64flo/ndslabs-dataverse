## Dataverse 4.2.3

[These files have been retained for reference purposes only. Please refer to the ndslabs-specs repo for the most recent service specitications].

This is an experimental Kubernetes-based implemention of the [Dataverse](http://dataverse.org/) and [TwoRavens](http://datascience.iq.harvard.edu/about-tworavens) services. Dataverse is a web-based application used for sharing, preserving, citing, exploring, and analyzying research data. 

### Starting Dataverse Services under Kubernetes

A simple script has been provided to start these services under Kubernetes:

```
start-dataverse.sh
```
This will start each of the Kubernetes services and replication controllers.

Note:
* If you are running this for the first time, image downloaded may take several minutes. 
* The dataverse webapp will take a few minutes to initialize and startup.  You can view the logs using kubectl logs -f <dataverse-rc-pod>.
* Once the services are running, you should be able to access your Dataverse instance on <host>:30000. 

### Simple test case
* Open <host>:30000 in your browser
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

