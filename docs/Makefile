BUILDPATH= ../build
ORIX_MANPATH= $(BUILDPATH)/usr/share/man

MD2HLP_PATH ?= ../../md2hlp/src/
MD2HLP ?= ../../md2hlp/src/md2hlp.py

export MD2HLP_PATH

SRC= $(wildcard *.md)
OBJ= $(SRC:.md=.hlp)

all: docs

%.hlp: %.md
	@mkdir -p "$(ORIX_MANPATH)"
	@echo "Generate $@"
	@$(MD2HLP) --file $< --output $(ORIX_MANPATH)/$@

.PHONY: docs clean mrproper

docs: $(OBJ)


clean:
	@echo "Clean docs"


mrproper: clean
	@echo "Mr Proper docs"
	rm -f $(ORIX_MANPATH)/*hlp
