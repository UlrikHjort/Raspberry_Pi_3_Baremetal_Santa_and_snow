/**************************************************************************
--          ARM64 xorshift32 Pseudo Random Nymber Generator
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
    .section .data
    .align 4
rand_state: .word 0x12345678    // seed, must not be zero

    .section .text
    .align 2
    .global random_range
    .type random_range, %function

// int32_t random_range(int32_t LIMIT)
// returns a number in the range - (LIMIT/2) .. (LIMIT/2) 
random_range:
    // w0 = LIMIT
    adrp    x1, rand_state
    add     x1, x1, :lo12:rand_state
    ldr     w2, [x1]          // w2 = state

    lsl     w3, w2, #13
    eor     w2, w2, w3
    lsr     w3, w2, #17
    eor     w2, w2, w3
    lsl     w3, w2, #5
    eor     w2, w2, w3

    str     w2, [x1]          // save new state
    // w2 = rnd
	add 	w0,w0, #1         // add one to limit to get the result in range -limit/2 ... limit/s
    // --- modulo LIMIT ---
    udiv    w3, w2, w0        // w3 = rnd / LIMIT
    msub    w2, w3, w0, w2    // w2 = rnd % LIMIT

    // --- compute (LIMIT/2) - (rnd % LIMIT) ---
    lsr     w4, w0, #1        // w4 = LIMIT / 2
    sub     w0, w4, w2        // w0 = (LIMIT/2) - (rnd % LIMIT)

    ret

	



    .section .text
    .align 2
    .global random32
    .type random32, %function

// uint32_t random32(void)
// Returns a unsigned 32 bit random number	
random32:
    // Load address of rand_state (PC-relative)
    adrp    x1, rand_state
    add     x1, x1, :lo12:rand_state

    // Load state into w0
    ldr     w0, [x1]

    // --- xorshift32 PRNG ---
    lsl     w2, w0, #13
    eor     w0, w0, w2
    lsr     w2, w0, #17
    eor     w0, w0, w2
    lsl     w2, w0, #5
    eor     w0, w0, w2
    // -----------------------

    // Store back updated state
    str     w0, [x1]

    // Return w0
    ret

