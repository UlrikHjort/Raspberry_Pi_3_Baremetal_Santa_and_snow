/**************************************************************************
--                Draw Pixmap Function
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
    .text
    .global draw_pixmap
    .type draw_pixmap, %function

// void draw_pixmap_asm(uint32_t fb, uint32_t x0, uint32_t y0,
//                  uint8_t *px_buf, uint32_t height, uint32_t width, uint32_t color)
draw_pixmap:
    // Prologue: save fp/lr and callee-saved regs we will use (x19..x25)
    stp     x29, x30, [sp, #-16]!    // push fp,lr
    mov     x29, sp
    sub     sp, sp, #64              // allocate stack space (aligned)

    // store x19..x25 into stack
    stp     x19, x20, [sp, #0]
    stp     x21, x22, [sp, #16]
    stp     x23, x24, [sp, #32]
    str     x25,      [sp, #48]

    // Move incoming parameters into callee-saved registers so they survive calls
    // x0..x6 were: fb, x0_base, y0_base, px_buf, height, width, color
    mov     x19, x0      // fb -> x19
    mov     x20, x1      // x origin base -> x20
    mov     x21, x2      // y origin base -> x21
    mov     x22, x3      // px_buf pointer -> x22
    mov     x23, x4      // height -> x23
    mov     x24, x5      // width -> x24
    mov     x25, x6      // color -> x25

    // locals in volatile/temporary regs:
    // x26 := byte_index (we'll use it as byte offset into px_buf)
    // x27 := y loop counter
    // x28 := bx (byte column index)
    // w9  := byte value loaded from px_buf (8-bit)
    // w11 := bit loop counter (0..7)
    mov     x26, #0      // byte_index = 0
    mov     x27, #0      // y = 0

    // compute bx_count = width / 8  (integer division by 8)
    lsr     x8, x24, #3  // x8 = width >> 3

// ---------- outer y loop ----------
y_loop:
    cmp     x27, x23     // if y >= height -> done
    bge     y_done

    mov     x28, #0      // bx = 0

// ---------- inner bx loop ----------
bx_loop:
    cmp     x28, x8      // if bx >= (width/8) -> next row
    bge     next_row

    // load byte b = px_buf[byte_index++]
    // x22 = px_buf base, x26 = byte_index
    ldrb    w9, [x22, x26]   // load 8-bit value into w9
    add     x26, x26, #1     // byte_index++

    mov     w11, #0          // bit = 0

// ---------- bit loop: for (bit = 0; bit < 8; bit++) ----------
bit_loop:
    cmp     w11, #8
    bge     end_bit_loop

    // mask = 1 << bit
    mov     w12, #1
    lsl     w12, w12, w11    // w12 = (1 << bit)

    and     w13, w9, w12
    cbz     w13, no_pixel    // if ((b & (1<<bit)) == 0) -> skip

    // compute x = bx * 8 + bit
    lsl     x14, x28, #3     // x14 = bx << 3  (bx*8)
    uxtw    x15, w11         // extend bit to 64-bit into x15
    add     x15, x14, x15    // x15 = bx*8 + bit

    // call fb_putpixel(fb, x0 + x, y0 + y, color)
    add     x1, x20, x15     // x argument = x0_base + x
    add     x2, x21, x27     // y argument = y0_base + y
    mov     x0, x19          // fb
    mov     x3, x25          // color
    bl      fb_putpixel

no_pixel:
    add     w11, w11, #1     // bit++
    b       bit_loop

end_bit_loop:
    add     x28, x28, #1     // bx++
    b       bx_loop

next_row:
    add     x27, x27, #1     // y++
    b       y_loop

y_done:
    // Epilogue: restore saved callee-saved registers and return
    ldp     x19, x20, [sp, #0]
    ldp     x21, x22, [sp, #16]
    ldp     x23, x24, [sp, #32]
    ldr     x25,       [sp, #48]

    add     sp, sp, #64
    ldp     x29, x30, [sp], #16
    ret

    .size draw_pixmap, .-draw_pixmap
