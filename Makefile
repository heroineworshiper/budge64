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

budge.d64: $(BUDGE_DEPS)
	rm -f budge.d64
	$(AS) -t c64 budge.s
	$(LD) -C budge.cfg -m budge.map budge.o -o budge c64.lib
	c1541 -format "budge,00" d64 budge.d64
	c1541 -attach budge.d64 -write budge budge,p


clean:
	rm -f budge.d64 budge

