#
# Spécifique au Projet
#

PROJECT = TeleForth
BUILDPATH = ../build/cart

VERSION ?= 2
STARTUP ?= STARTUP.DAT
VERBOSE ?= 0

# %<-------------------------------------------------------------------------->%
#               Ne rien modifier au dela de cette ligne
#

#
# Définition des outils
#

AS = ca65
LD = ld65

#
# Définition des options pour les outils
#

ifeq ($(DEBUG),yes)
	ASFLAGS = -t none -I $(BUILDPATH) -D VERBOSE_LEVEL=$(VERBOSE) --list-bytes 0 -l $(BUILDPATH)/$(PROJECT).lst --debug-info
	LDFLAGS = -t none -Ln $(BUILDPATH)/$(PROJECT).ca.sym
else
	ASFLAGS = -t none -I $(BUILDPATH) -D VERBOSE_LEVEL=$(VERBOSE)
	LDFLAGS = -t none
endif


#
# Règles Make
#

SRC = $(PROJECT).s
OBJ = $(PROJECT).o
ROM = $(PROJECT).rom


all: $(BUILDPATH)/$(ROM)


$(BUILDPATH)/$(OBJ):
	$(AS) $(ASFLAGS) -o $@ $<


# Activer la regle suivante pour creer systematiquement 'build.inc'
# sans faire un 'make configure'
# $(BUILDPATH)/build.inc: configure


$(BUILDPATH)/$(ROM): $(BUILDPATH)/$(OBJ)
	@echo "Create $(ROM)"
	$(LD) $(LDFLAGS) -o $@ $^
ifeq ($(DEBUG),yes)
	sed -re 's/al 00(.{4}) \.(.+)$$/\1 \2/' $(BUILDPATH)/$(PROJECT).ca.sym | sort > $(BUILDPATH)/$(PROJECT).sym
endif

configure:
	@echo "Create $(BUILDPATH)/build.inc file"
	@mkdir -p $(BUILDPATH)
	@#date +'.define __DATE__ "__DATE__"'           > $(BUILDPATH)/build.inc
	@date +'.define __DATE__ "%F %R"'               > $(BUILDPATH)/build.inc
	@echo  ".define With TeleForth_V${VERSION}"    >> $(BUILDPATH)/build.inc
	@echo  ".define AUTOSTART_FILE \"${STARTUP}\"" >> $(BUILDPATH)/build.inc

-include $(BUILDPATH)/.depend


.PHONY: clean mrproper deps


deps: $(BUILDPATH)/.depend


$(BUILDPATH)/.depend: $(SRC) $(BUILDPATH)/build.inc
	$(AS) $(ASFLAGS) --create-dep $(BUILDPATH)/.depend -o $(BUILDPATH)/$(OBJ) $<


clean:
	cd $(BUILDPATH) && rm -f *.o


mrproper: clean
	cd $(BUILDPATH) && rm -f $(ROM) *.lst *.sym .depend build.inc
