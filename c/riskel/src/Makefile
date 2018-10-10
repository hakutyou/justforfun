AS = yasm

TARGET = $(IMAGE)
IMAGE = out/risk.img
LOADER = out/loader.bin
KERNEL = out/kernel.bin

OS_NAME = $(shell uname -o | tr '[A-Z]' '[a-z]')

.PHONY: all, clean, mounttip, mountauto

ifeq ($(OS_NAME), cygwin)
    TARGET += mounttip
else
    TARGET += mountauto
endif

test: $(LOADER) $(KERNEL)

all: clean $(TARGET)

out/risk.img: out/boot.bin $(LOADER) $(KERNEL)
	cp tools/a.img $@
	dd if=$< of=$@ bs=512 count=1 conv=notrunc

out/%.bin: boot/%.asm
	$(AS) $^ -o $@

clean:
	-rm out/*

mounttip:
	@echo -e "\e[1;31mmount not available in cygwin, try manually\e[0m"

mountauto: $(IMAGE) $(LOADER)
	-mkdir -p /mnt/floppy
	mount -o loop $< /mnt/floppy
	cp $(word 2, $^) /mnt/floppy
	umount /mnt/floppy
