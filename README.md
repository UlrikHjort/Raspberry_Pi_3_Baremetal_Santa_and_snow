# Raspberry Pi Baremetal Santa and Snow

Bare metal xsnow like port for Raspberry PI 3 (works for 4 as well, set target to raspi4 in makefile).

Just for fun December xmas project, put togehter in no time.
Aim was to have it done for December, not to have perfectly working or beautyful code.
So yes, code is ugly and mostly undocumented - and nobody cares about that. 


I took all the pixmaps from the original xsnow sources for UNIX. The XPM files was converted to plain 32bit RRGGBB
and then swapped in the code to BBGGRR to sastify the Raspi frambuffer.
Scripts for this are located in the 'convert_tools' directory (but not needed unless adding new XPM pixmaps).

Usage:
	"make run" to run demo in QEMU

Tested on QEMU version 10.0.50

One can also install the kernel image kernel8.img on a sdcard and run it on the real HW, but nobody probarbly will do that. 
  
