AS = ca65
LD = ld65
LDFLAGS = -t none -Ln TeleForth.sym
ASFLAGS = -t none -l TeleForth.lst -D VERBOSE_LEVEL=$(VERBOSE)

#  -v --debug-info --list-bytes 0 -t none -l TeleForth.lst -m TeleForth.map -Ln TeleForth.sym TeleForth.s
# sed -re 's/al 00(.{4}) \.(.+)$/\1 \2/' TeleForth.sym | sort > TeleForth.sym

ROM = TeleForth.rom

VERSION ?= 2
STARTUP ?= STARTUP.DAT
VERBOSE ?= 0


all: $(ROM)


TeleForth.o:
	$(AS) $(ASFLAGS) -o $@ $<


$(ROM): TeleForth.o
	$(LD) $(LDFLAGS) -o $@ $^

configure:
	@#date +'.define __DATE__ "__DATE__"'           > build.inc
	@date +'.define __DATE__ "%F %R"'              > build.inc
	@echo  ".define With TeleForth_V${VERSION}"   >> build.inc
	@echo  ".define AUTOSTART_FILE \"${STARTUP}\"" >> build.inc

-include .depend


.PHONY: clean mrproper deps


deps: .depend


.depend: TeleForth.s build.inc
	$(AS) $(ASFLAGS) --create-dep .depend $<


clean:
	rm -f *.o


mrproper: clean
	rm -f $(ROM) *.lst *.sym .depend build.inc

docs:
	mkdir ../build/usr/share/man/ -p
	mkdir ../build/usr/share/forth/ -p
	cat ../doc/orix/forth.md | md2hlp.py > ../build/usr/share/man/forth.hlp
	cat ../doc/orix/vlist.md | md2hlp.py > ../build/usr/share/forth/forth.hlp