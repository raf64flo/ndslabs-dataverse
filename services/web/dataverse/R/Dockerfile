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
#
#echo
#echo "checking Rserve configuration:"
#
#/usr/sbin/groupadd -g 97 -o -r rserve >/dev/null 2>/dev/null || :
#/usr/sbin/useradd -g rserve -o -r -d $RLIBDIR -s /bin/bash \
#        -c "Rserve User" -u 97 rserve 2>/dev/null || :
#
#echo
#
#echo
#
#if [ ! -f /etc/Rserv.conf ]
#then
#    echo "installing Rserv configuration file."
#    install -o rserve -g rserve Rserv.conf /etc/Rserv.conf
#    echo
#fi
#
#if [ ! -f /etc/Rserv.pwd ]
#then
#    echo "Installing Rserve password file."
#    echo "Please change the default password in /etc/Rserv.pwd"
#    echo "(and make sure this password is set correctly as a"
#    echo "JVM option in the glassfish configuration of your DVN)"
#    install -m 0600 -o rserve -g rserve Rserv.pwd /etc/Rserv.pwd
#    echo
#fi
#
#if [ ! -f /etc/init.d/rserve ]
#then
#    echo "Installing Rserve startup file."
#    install rserve-startup.sh /etc/init.d/rserve
#    chkconfig rserve on
#    echo "You can start Rserve daemon by executing"
#    echo "  service rserve start"
#fi
#
#echo
##echo "Successfully installed Dataverse R framework."
#echo
#
