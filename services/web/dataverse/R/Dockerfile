FROM centos:latest
MAINTAINER Craig Willis (willis8@illinois.edu)

RUN rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm && \
	yum update -y && \
	yum install -y R R-devel ed openssl-devel libcurl wget && \
	yum install -y mesa-libGL-devel mesa-libGLU-devel libpng-devel && \
	yum install -y mysql-devel postgresql-devel libxml2-devel libcurl-devel 


RUN R -q -e "install.packages(c('R2HTML', 'Rserve', 'VGAM', 'AER', 'dplyr', 'quantreg', 'geepack', 'maxLik', 'Amelia', 'Rook', 'jsonlite', 'rjson', 'devtools', 'DescTools'), INSTALL_opts=c('--no-test-load'), repos='http://cran.r-project.org', quiet=T, dependencies=T)"

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

CMD ["R", "CMD", "Rserve.dbg", "--vanilla"]
