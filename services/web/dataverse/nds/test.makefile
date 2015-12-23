ARGS	= this1 that2 the3 other4
this1:
.SUFFIXES:
all:  $(ARGS)


define IMG_TMPL
$(2): $(1) 
	$(warning "rule $(2): $(1)")
	echo build $(2) from $(1)
endef

define ECHOARGS
echo one is $(1)
echo two is $(2)
echo three is $(3)
endef
genrules = $(if $(wordlist 2,2,$(1)),$(eval $(call IMG_TMPL,$(firstword $(1)),$(wordlist 2,2,$(1)))) $(call genrules,$(wordlist 2,$(words $(1)),$(1))),)

$(eval $(call genrules,$(ARGS)))


ec:
	echo $(words $(ARGS))
	echo $(word,1,$(ARGS))
	echo $(word,2,$(ARGS))
	echo $(call IMG_DEP,$(ARGS))

