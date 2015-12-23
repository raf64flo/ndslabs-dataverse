BASEIMG		= fedora:22
#REPO		= nds/
REPO		= 
IMG		= nds-dataverse
#VER 		= :0.1
VER		= 
TAG		= $(REPO)$(IMG)$(VER)
STEPS 		= 1 2 3 

DEBUG		=y	# delete or commend for production

include Makefiles/Makefile.nds

CMDS.1 		= apt-get -y update \
		apt-get -y install gzip maven postgresql postgresql-contrib jq curl git maven \
		apt-get clean \
		rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* 

CMDS.2		= mkdir -p /usr/java \
		tar xf $(DEPENDENCIES)/jdk-8u60-linux-x64.tar.gz -C /usr/java \
		unzip $(DEPENDENCIES)/glassfish-4.1.zip \
		tar xf $(DEPENDENCIES)/solr-4.6.0-src.tgz

CMDS.3 		= docker tag $(TAG) $(STEP)
	

#
#  Test/debug stuff below
#

db:
	echo $(CMDS.1)
	#echo $(call findnext, $(AA), "one")
