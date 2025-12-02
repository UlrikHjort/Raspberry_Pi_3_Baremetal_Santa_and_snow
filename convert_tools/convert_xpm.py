'''
    Converts the XPM GIMP csourse file from the original xsnow program, to 32 bit BGR arrays.
    Also set the transparent 0xCC0000 backgroung color to 0x000000

    First convert BigSantaRudolfX.XPM to c source file with GIMP and then run this 
    script in the directory where the BigSantaRudolfX.c are located (there shall be 4).

    Copyright (C) 2025 By Ulrik Hørlyk Hjort
'''

import re

for santa_n in range (1,5):
    INPUT = f"BigSantaRudolf{santa_n}.c"
    OUTPUT = f"santa{santa_n}.h"

    with open(INPUT) as f:
        data = f.read()

    # --- Extract width, height, bpp ---
    m = re.search(r"\{\s*(\d+),\s*(\d+),\s*(\d+),", data)
    if not m:
        raise ValueError("Could not find header { width, height, bpp, ... }")

    width  = int(m.group(1))
    height = int(m.group(2))
    bpp    = int(m.group(3))

    if bpp != 3:
        raise ValueError(f"Expected 3 bytes per pixel (RGB), found {bpp}")

    print(f"Detected: {width}x{height}, {bpp} bytes per pixel")

    # --- Extract pixel data strings ---
    # All quoted strings inside pixel_data[]
    matches = re.findall(r"\"(.*?)\"", data, re.DOTALL)

    byte_stream = []

    for m in matches:
        i = 0
        while i < len(m):
            if m[i] == '\\':
                val = int(m[i+1:i+4], 8)
                byte_stream.append(val)
                i += 4
            else:
                byte_stream.append(ord(m[i]))
                i += 1

    expected = width * height * 3
    if len(byte_stream) < expected:
        raise ValueError(f"Pixel data too short ({len(byte_stream)} < {expected})")
    elif len(byte_stream) > expected:
        # GIMP puts a NULL byte at end, so truncate
        byte_stream = byte_stream[:expected]

    # --- Convert RGB → uint32_t ---
    pixels = []
    for i in range(0, len(byte_stream), 3):
        # Here R and B are swapped to get BGR for the raspi frambuffer
        B = byte_stream[i]    
        G = byte_stream[i+1]
        R = byte_stream[i+2]
        
        if B == 0xCC and G == 0x00 and R == 0x00: # bg from red to black
            B = 0x00
        pixels.append((R << 16) | (G << 8) | B)

    # --- Write header ---
    with open(OUTPUT, "w") as f:
        f.write(f"#define SANTA{santa_n}_WIDTH {width}\n")
        f.write(f"#define SANTA{santa_n}_HEIGHT {height}\n\n")
        f.write(f"uint32_t santa{santa_n}[] = {{\n")

        for i, px in enumerate(pixels):
            f.write(f"  0x{px:06X},")
            if (i+1) % 10 == 0:
                f.write("\n")

        f.write("\n};\n")

    print(f"Written {OUTPUT} successfully.")
