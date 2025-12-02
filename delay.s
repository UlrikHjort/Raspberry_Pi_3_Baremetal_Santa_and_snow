/**************************************************************************
--          Counter-timer Virtual Count register delay ms
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

// void delay_ms(unsigned int ms);
.global delay_ms
.type delay_ms, %function

delay_ms:
    // x0 = milliseconds
    mrs x1, cntfrq_el0        // x1 = timer frequency
    mov x2, x0                // copy ms
    mul x2, x2, x1            // x2 = ms * ticks_per_second
    lsr x2, x2, #10           // divide by 1024 ≈ adjust to ticks_per_millisecond
    mrs x3, cntvct_el0        // start count Counter-timer Virtual Count register
.loop:
    mrs x4, cntvct_el0	      // current count
    sub x4, x4, x3		      // elapsed ticks
    cmp x4, x2                // reached required ticks?
    blt .loop                 // if not, keep waiting
    ret
