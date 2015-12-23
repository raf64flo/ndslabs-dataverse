from 	ubuntu:14.04

run 	apt-get -y update && \
	apt-get -y install gzip maven postgresql postgresql-contrib jq curl \
		git maven && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
run	git clone https://github.com/IQSS/dataverse.git


EXPOSE 80 443 8993 8080 8181
