OBJDIR := $(shell uname --machine)
CC65_DIR := /root/cc65-master/bin/
AS := $(CC65_DIR)ca65
CC := $(CC65_DIR)cc65
LD := $(CC65_DIR)ld65

BUDGE_DEPS := \
	budge.s \
	common.inc \
	common.s \
        tables.s

budge.d64: $(BUDGE_DEPS) budge2
	rm -f budge.d64
	$(AS) -t c64 budge.s
	$(LD) -C budge.cfg budge.o -o budge c64.lib
	c1541 -format "budge,00" d64 budge.d64
#	c1541 -attach budge.d64 -write budge budge,p
	c1541 -attach budge.d64 -write budge2 budge2,p


budge2: budge2.s tables2.s common.inc
	$(AS) -t c64 budge2.s
	$(LD) -C budge.cfg budge2.o -o budge2 c64.lib

clean:
	rm -f budge.d64 budge

