FROM centos:latest
MAINTAINER Craig Willis (willis8@illinois.edu)

# For RServe
RUN rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm && \
	yum update -y && \
	yum install -y R R-devel ed openssl-devel libcurl wget && \
	yum install -y mesa-libGL-devel mesa-libGLU-devel libpng-devel  && \
        yum install -y mysql-devel postgresql-devel libxml2-devel libcurl-devel  

# For Two-Ravens
#RUN yum install -y mysql-devel postgresql-devel libxml2-devel libcurl-devel  && \
#	yum install -y httpd-devel libapreq2 && \
#	yum install -y rpm-build make httpd-devel libapreq2-devel 


# Build RApache 
#RUN cd /tmp && wget https://github.com/jeffreyhorner/rapache/archive/v1.2.6.tar.gz -O rapache-1.2.6.tar.gz  && \
#	tar xzvf rapache-1.2.6.tar.gz rapache-1.2.6/rpm/rapache.spec --strip-components 2 && \
#	mkdir -p ~/rpmbuild/SOURCES && \
#	mkdir -p ~/rpmbuild/SPECS && \
#	mv -f rapache-1.2.6.tar.gz ~/rpmbuild/SOURCES/ && \
#	mv -f rapache.spec ~/rpmbuild/SPECS/ && \
# 	rpmbuild -ba ~/rpmbuild/SPECS/rapache.spec && \
# 	cd ~/rpmbuild/RPMS/x86_64/ && \
#	rpm -ivh rapache-1.2.6-rpm0.x86_64.rpm 

# Download TwoMasters
#RUN cd /tmp && rm -f master.zip && \
#	wget https://github.com/IQSS/TwoRavens/archive/master.zip && \
#	unzip master.zip && \
#	rm -f master.zip && \
#	mv TwoRavens-master /var/www/html/dataexplore

RUN R -q -e "install.packages(c('R2HTML'), INSTALL_opts=c('--no-test-load'), repos='http://cran.r-project.org', quiet=T, dependencies=T)"
RUN R -q -e "install.packages(c('Rserve'), INSTALL_opts=c('--no-test-load'), repos='http://cran.r-project.org', quiet=T, dependencies=T)"
RUN R -q -e "install.packages(c('VGAM'), INSTALL_opts=c('--no-test-load'), repos='http://cran.r-project.org', quiet=T, dependencies=T)"
RUN R -q -e "install.packages(c('AER'), INSTALL_opts=c('--no-test-load'), repos='http://cran.r-project.org', quiet=T, dependencies=T)"
RUN R -q -e "install.packages(c('dplyr'), INSTALL_opts=c('--no-test-load'), repos='http://cran.r-project.org', quiet=T, dependencies=T)"
RUN R -q -e "install.packages(c('quantreg'), INSTALL_opts=c('--no-test-load'), repos='http://cran.r-project.org', quiet=T, dependencies=T)"
RUN R -q -e "install.packages(c('geepack'), INSTALL_opts=c('--no-test-load'), repos='http://cran.r-project.org', quiet=T, dependencies=T)"
RUN R -q -e "install.packages(c('maxLik'), INSTALL_opts=c('--no-test-load'), repos='http://cran.r-project.org', quiet=T, dependencies=T)"
RUN R -q -e "install.packages(c('Amelia'), INSTALL_opts=c('--no-test-load'), repos='http://cran.r-project.org', quiet=T, dependencies=T)"
RUN R -q -e "install.packages(c('Rook'), INSTALL_opts=c('--no-test-load'), repos='http://cran.r-project.org', quiet=T, dependencies=T)"
RUN R -q -e "install.packages(c('jsonlite'), INSTALL_opts=c('--no-test-load'), repos='http://cran.r-project.org', quiet=T, dependencies=T)"
RUN R -q -e "install.packages(c('rjson'), INSTALL_opts=c('--no-test-load'), repos='http://cran.r-project.org', quiet=T, dependencies=T)"
RUN R -q -e "install.packages(c('devtools'), INSTALL_opts=c('--no-test-load'), repos='http://cran.r-project.org', quiet=T, dependencies=T)"
RUN R -q -e "install.packages(c('DescTools'), INSTALL_opts=c('--no-test-load'), repos='http://cran.r-project.org', quiet=T, dependencies=T)"

RUN cd /tmp && wget https://github.com/IQSS/Zelig/archive/master.zip && unzip master.zip  && \
     R -q -e "setwd('/tmp'); library(devtools); install('Zelig-master')" 

RUN /usr/sbin/groupadd -g 97 -o -r rserve 
RUN /usr/sbin/useradd -g rserve -o -r -d /usr/lib64/R/library -s /bin/bash -c "Rserve User" -u 97 rserve 

COPY Rserv.conf /tmp/
COPY Rserv.pwd /tmp/

RUN cd /tmp/  && \
        install -o rserve -g rserve /tmp/Rserv.conf /etc/Rserv.conf && \ 
        install -m 0600 -o rserve -g rserve /tmp/Rserv.pwd /etc/Rserv.pwd 

EXPOSE 6311

#COPY start-tworavens /
#COPY entrypoint.sh /
#ENTRYPOINT ["/entrypoint.sh"]
CMD ["R", "CMD", "Rserve.dbg", "--vanilla"]
