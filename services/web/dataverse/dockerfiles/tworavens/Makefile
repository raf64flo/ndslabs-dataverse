NAME = ndslabs\/dataverse-tworavens
VERSION = 1.0
TAGNAME=$(NAME)\:$(VERSION)

.PHONY: all build tag_latest 

all: build

build: Dockerfile
	docker build -t $(TAGNAME) --rm .

shell:
	docker run --rm -it $(TAGNAME) bash

#tag_latest:
#        docker tag -f $(NAME):$(VERSION) $(NAME):latest
