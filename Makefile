
all: cart docs


.PHONY: configure cart docs clean mrproper

configure:
	@$(MAKE) -C src $@

cart:
	@$(MAKE) -C src

docs:
	@$(MAKE) -C docs

clean:
	@$(MAKE) -C src $@
	@$(MAKE) -C docs $@


mrproper: clean
	@$(MAKE) -C src $@
	@$(MAKE) -C docs $@
