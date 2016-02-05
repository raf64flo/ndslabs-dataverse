NAME = ndslabs\/dataverse-rserve
VERSION = 3.2.3  # R version
TAGNAME=$(NAME)\:$(VERSION)

.PHONY: all build tag_latest 

all: build

build: Dockerfile
	docker build -t $(TAGNAME) --rm .

shell:
	docker run --rm -it $(TAGNAME) bash

#tag_latest:
#        docker tag -f $(NAME):$(VERSION) $(NAME):latest
