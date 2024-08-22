AS = nasm
CC = gcc
LD = ld

ASFLAGS = -f bin
CFLAGS = -m32 -ffreestanding -nostdlib -c
LDFLAGS = -m elf_i386 -Ttext 0x1000 --oformat binary

BOOTLOADER_SRC = boot/boot.asm
BOOTLOADER_BIN = bootloader.bin
KERNEL_SRC = kernel/kernel_main.c
KERNEL_OBJ = kernel.o
KERNEL_BIN = kernel.bin
IMAGE_BIN = bootable_image.bin

all: $(BOOTLOADER_BIN) $(KERNEL_BIN) $(IMAGE_BIN)

$(BOOTLOADER_BIN): $(BOOTLOADER_SRC)
	$(AS) $(ASFLAGS) -o $@ $<

$(KERNEL_OBJ): $(KERNEL_SRC)
	$(CC) $(CFLAGS) -o $@ $<

$(KERNEL_BIN): $(KERNEL_OBJ)
	$(LD) $(LDFLAGS) $< -o $@

$(IMAGE_BIN): $(BOOTLOADER_BIN) $(KERNEL_BIN)
	cat $(BOOTLOADER_BIN) $(KERNEL_BIN) > $(IMAGE_BIN)

clean:
	rm -f $(BOOTLOADER_BIN) $(KERNEL_BIN) $(KERNEL_OBJ) $(IMAGE_BIN)
