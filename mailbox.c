/**************************************************************************
--                      Raspberry Pi Framebuffer
-- 
--           Copyright (C) 2025 By Ulrik Hørlyk Hjort
--
--  This Program is Free Software; You Can Redistribute It and/or
--  Modify It Under The Terms of The GNU General Public License
--  As Published By The Free Software Foundation; Either Version 2
--  of The License, or (at Your Option) Any Later Version.
--
--  This Program is Distributed in The Hope That It Will Be Useful,
--  But WITHOUT ANY WARRANTY; Without Even The Implied Warranty of
--  MERCHANTABILITY or FITNESS for A PARTICULAR PURPOSE.  See The
--  GNU General Public License for More Details.
--
-- You Should Have Received A Copy of The GNU General Public License
-- Along with This Program; if not, See <Http://Www.Gnu.Org/Licenses/>.
***************************************************************************/


#include "mailbox.h"


void mailbox_write(unsigned int value, unsigned int channel) {
    while (*(volatile unsigned int*)(MAILBOX_BASE + MAILBOX_STATUS) & MAILBOX_FULL);
    *(volatile unsigned int*)(MAILBOX_BASE + MAILBOX_WRITE) = (value & ~0xF) | (channel & 0xF);
}

unsigned int mailbox_read(unsigned int channel) {
    unsigned int r;
    do {
        while (*(volatile unsigned int*)(MAILBOX_BASE + MAILBOX_STATUS) & MAILBOX_EMPTY);
        r = *(volatile unsigned int*)(MAILBOX_BASE + 0x00);
    } while ((r & 0xF) != channel);
    return r & ~0xF;
}
