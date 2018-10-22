AS = ca65
LD = ld65
LDFLAGS = -t none -Ln TeleForth.sym
ASFLAGS = -t none -l TeleForth.lst

#  -v --debug-info --list-bytes 0 -t none -l TeleForth.lst -m TeleForth.map -Ln TeleForth.sym TeleForth.s
# sed -re 's/al 00(.{4}) \.(.+)$/\1 \2/' TeleForth.sym | sort > TeleForth.sym

ROM = TeleForth

VERSION ?= 2
STARTUP ?= STARTUP.DAT

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
	$(AS) --create-dep .depend $<


clean:
	rm -f *.o


mrproper: clean
	rm -f $(ROM) *.lst *.sym .depend build.inc
