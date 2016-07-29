FROM ndslabs/irods-icat:4.1.3
MAINTAINER willis8@illinois.edu

# Install bulk_extractor

RUN apt-get update -y && apt-get install -y openjdk-7-jdk curl supervisor ssmtp

# http://container-solutions.com/6-dockerfile-tips-official-images/
RUN apt-get install -y flex make g++ libssl-dev \
	&& wget http://digitalcorpora.org/downloads/bulk_extractor/bulk_extractor-1.5.5.tar.gz -O  /tmp/bulk_extractor.tar.gz \
    && cd /tmp \
	&& tar xvfz bulk_extractor.tar.gz  \
	&& cd bulk_extractor-1.5.5 \
	&& ./configure \
	&& make \
	&& make install \
	&& rm /tmp/bulk_extractor.tar.gz \
	&& rm -r /tmp/bulk_extractor-1.5.5 \
	&& apt-get purge -y flex make g++ libssl-dev

RUN wget https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64 -O /usr/bin/jq && chmod +x /usr/bin/jq

RUN mkdir /opt/dataverse && mkdir /tmp/bcworking && chmod a+w /tmp/bcworking
COPY rules /opt/dataverse/
COPY setup-irods.sh /opt/dataverse/
COPY archive.sh /opt/dataverse/
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY entrypoint.sh /
COPY cmd/*sh /var/lib/irods/iRODS/server/bin/cmd/
COPY mail /usr/bin/mail
COPY ssmtp.conf /etc/ssmtp.conf
RUN  chmod +x /usr/bin/mail
COPY rules/dataverse.re /etc/irods/


EXPOSE 1247
CMD ["/entrypoint.sh", "icat"]
