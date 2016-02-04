FROM centos:latest
MAINTAINER Craig Willis (willis8@illinois.edu)

#install.sh
RUN yum install -y wget unzip perl git java-1.8.0-openjdk-devel postgresql nc

# Install Glassfish 4.1
RUN cd /tmp && wget http://dlc-cdn.sun.com/glassfish/4.1/release/glassfish-4.1.zip && \
	unzip glassfish-4.1.zip && \
	mv glassfish4 /usr/local && \
	cd /usr/local/glassfish4/glassfish/modules && \
	rm weld-osgi-bundle.jar && \
	wget http://central.maven.org/maven2/org/jboss/weld/weld-osgi-bundle/2.2.10.SP1/weld-osgi-bundle-2.2.10.SP1-glassfish4.jar  && \
        rm -rf /usr/local/glassfish4/glassfish/domains/domain1 && \ 
	rm /tmp/glassfish-4.1.zip && \
	/usr/local/glassfish4/bin/asadmin create-domain --nopassword domain1 

# Install jq
RUN cd /tmp && wget https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64 && \
	mv jq-linux64 /usr/local/bin && \
	chmod +x /usr/local/bin/jq-linux64 && \
	ln -s /usr/local/bin/jq-linux64 /usr/local/bin/jq


RUN mkdir -p /tmp/WEB-INF/classes/META-INF/ 
COPY WEB-INF/classes/META-INF/persistence.xml /tmp/WEB-INF/classes/META-INF/

# Install DataVerse WAR
RUN  cd ~ && \
	wget https://github.com/IQSS/dataverse/releases/download/v4.2.3/dvinstall-4.2.3.zip && \
	unzip dvinstall-4.2.3.zip  && \
        cp dvinstall/dataverse.war dvinstall/dataverse-none.war && \
        jar -uf dvinstall/dataverse-none.war -C /tmp/ /WEB-INF/classes/META-INF/persistence.xml 


COPY start-dataverse /root/dvinstall/
COPY entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]

#
## rApache
#yum install httpd
#Update httpd.conf, remove Indexes
#yum install libapreq2
#
## Two Ravens
#wget https://github.com/IQSS/TwoRavens/archive/master.zip
#unzip master.zip
#mv TwoRavens-master/ /var/www/html/dataexplore
#cd /var/www/html/dataexplore/
#chmod +x install.pl
#
