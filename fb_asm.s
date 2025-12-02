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


// void fb_putpixel(unsigned int fb, uint32_t x, uint32_t y, uint32_t color)
// fb     -> x0
// x      -> x1
// y      -> x2
// color  -> x3
// scratch registers: x4, x5
// return: void
// assumption: 640x480 framebuffer, linear, 32-bit pixels

        .text
        .global fb_putpixel
        .align 2
fb_putpixel:
        // Mask fb & 0x3FFFFFFF
        and     x4, x0, #0x3FFFFFFF       // x4 = ptr base

        // Compute y * 640
        mov     x5, #640
        mul     x2, x2, x5               // x2 = y * 640

        // Add x
        add     x2, x2, x1              // x2 = y*640 + x

        // Multiply offset by 4 (since each pixel is 4 bytes)
        lsl     x2, x2, #2             // x2 = (y*640 + x) * 4

        // Compute final pointer
        add     x4, x4, x2            // x4 = ptr + offset

        // Store color
        str     w3, [x4]              // store 32-bit color at [ptr]

        ret
