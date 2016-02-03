FROM centos:latest
MAINTAINER Craig Willis (willis8@illinois.edu)

RUN rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm && \
	yum update -y && \
	yum install -y R R-devel ed openssl-devel libcurl wget && \
	yum install -y mesa-libGL-devel mesa-libGLU-devel libpng-devel && \
	yum install -y mysql-devel postgresql-devel libxml2-devel libcurl-devel 


RUN R -q -e "install.packages(c('R2HTML', 'Rserve', 'VGAM', 'AER', 'dplyr', 'quantreg', 'geepack', 'maxLik', 'Amelia', 'Rook', 'jsonlite', 'rjson', 'devtools', 'DescTools'), INSTALL_opts=c('--no-test-load'), repos='http://cran.r-project.org', quiet=T, dependencies=T)"

#RUN cd /tmp && wget https://github.com/IQSS/Zelig/archive/master.zip && unzip master.zip  && \
#    R CMD 
#(cd /tmp; unzip master.zip)
#
#echo 'setwd("/tmp"); library(devtools); install("Zelig-master")' | (unset DISPLAY; R --vanilla --slave ) 2>&1 | tee ${LOG}
#
#    echo "ok"
#else
#    echo "Could not find library directory!"
#    if [ "x"$RLIBDIR != "x" ]
#        then
#        echo "directory $RLIBDIR does not exist."
#    else
#        echo "R is not installed (?)"
#    fi
#    exit 1
#fi

RUN /usr/sbin/groupadd -g 97 -o -r rserve 
RUN /usr/sbin/useradd -g rserve -o -r -d /usr/lib64/R/library -s /bin/bash -c "Rserve User" -u 97 rserve 

RUN cd /tmp/ && wget https://raw.githubusercontent.com/IQSS/dataverse/develop/conf/R/Rserv.conf && \
	wget https://raw.githubusercontent.com/IQSS/dataverse/develop/conf/R/Rserv.pwd && \
	wget https://raw.githubusercontent.com/IQSS/dataverse/develop/conf/R/rserve-startup.sh && \
        install -o rserve -g rserve Rserv.conf /etc/Rserv.conf && \ 
        install -m 0600 -o rserve -g rserve Rserv.pwd /etc/Rserv.pwd && \
        install rserve-startup.sh /etc/init.d/rserve 

RUN yum install -y initscripts

EXPOSE 6311
#COPY entrypoint.sh /
#ENTRYPOINT ["/entrypoint.sh"]
CMD ["R", "CMD", "Rserve.dbg", "--vanilla"]
