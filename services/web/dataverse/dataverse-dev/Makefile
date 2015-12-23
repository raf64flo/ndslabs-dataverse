#
# Final image info
#
##REPO		= nds/
REPO		= 
IMG		= nds-dataverse-dev
#VER 		= :0.1
VER		= 
TAG		= $(REPO)$(IMG)$(VER)
BUILDORDER	= Data Dockerfile Container1
TSTEPS		= $(BUILDORDER:%=$(IMG).%)

db:
	echo $(TSTEPS)

include Makefiles/Makefile.nds


build: $(DEPS)
	docker build -t $(TAG) . 
	docker inspect $(TAG)


