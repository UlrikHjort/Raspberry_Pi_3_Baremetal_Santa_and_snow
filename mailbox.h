#ifndef MAILBOX_H
#define MAILBOX_H

#define PERIPHERAL_BASE   0x3F000000
#define MAILBOX_BASE      (PERIPHERAL_BASE + 0xB880)
#define MAILBOX_WRITE      0x20
#define MAILBOX_STATUS     0x18
#define MAILBOX_FULL       0x80000000
#define MAILBOX_EMPTY      0x40000000

#define MAILBOX_FB_CHANNEL 1




void mailbox_write(unsigned int value, unsigned int channel);

unsigned int mailbox_read(unsigned int channel);

#endif
