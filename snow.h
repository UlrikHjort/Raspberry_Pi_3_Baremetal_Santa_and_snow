/**************************************************************************
--                  Raspberry Pi Santa and snow
--                       The snow Sprites
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
#include <stdint.h>

#define SNOWFLAKE_PIXMAPS 2


#define SNOW01_WIDTH 8
#define SNOW01_HEIGHT 8
uint8_t snow01[] = {
   0x22, 0x6b, 0x14, 0x2a, 0x14, 0x6b, 0x22, 0x00};


#define SNOW02_WIDTH 8
#define SNOW02_HEIGHT 8
uint8_t snow02[] = {
   0x14, 0x08, 0x49, 0x36, 0x49, 0x08, 0x14, 0x00};




struct Snow_pixmap {
	int16_t width;
	int16_t height;
	uint8_t *pixmap;
} snowflake_pixmaps[SNOWFLAKE_PIXMAPS] = {{8,8,snow01},{8,8,snow02}};
