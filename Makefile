ARMGNU ?= aarch64-linux-gnu

TARGET = raspi3b
KERNEL = kernel8

CSOURCES  := $(wildcard *.c)
ASOURCES  := $(wildcard *.s)

OBJECTS   = $(CSOURCES:.c=.o) $(ASOURCES:.s=.o)

CFLAGS = -Wall -Ofast -ffreestanding -nostdlib -nostartfiles -march=armv8-a 

LDFLAGS = -T $(TARGET).ld 

all: $(KERNEL).img

%.o: %.c
	$(ARMGNU)-gcc $(CFLAGS) $(DEFS) -c -o $@ $<

%.o: %.s
	$(ARMGNU)-as  -c -o $@ $<

$(KERNEL).elf: $(OBJECTS)
	$(ARMGNU)-ld $(LDFLAGS) -o $@ $^

$(KERNEL).img: kernel8.elf
	$(ARMGNU)-objcopy $< -O binary $@

run: $(KERNEL).img
	qemu-system-aarch64 -M $(TARGET) -kernel $< -serial stdio




clean:
	rm -f *.o *.elf *.img *~ $(KERNEL).*

