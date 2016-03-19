FROM ndslabs/irods-icat:latest
MAINTAINER willis8@illinois.edu

COPY irods_setup.pl /var/lib/irods/iRODS/scripts/perl/irods_setup.pl
COPY entrypoint.sh /

EXPOSE 1247
CMD ["/entrypoint.sh", "icat"]
