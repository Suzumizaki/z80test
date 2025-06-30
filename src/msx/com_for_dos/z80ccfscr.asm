; Z80 test - monitor random behavior of bits 5 and 3 after CCF.
;
; Copyright (C) 2023 Patrik Rak (patrik@raxoft.cz)
;
; This file is part of z80test MSX version.
; Copyright (C) 2025 Suzumizaki-Kimitaka(鈴見咲 君高)
;
; This source code is released under the MIT license, see included license.txt.

            org     0x100

WORK        equ     09000H

            macro   call_bios addr
            ld      iy,(EXPTBL - 1)
            ld      ix,addr
            call    CALSLT
            endm

            macro   read_bios addr
            ld      a,(EXPTBL)
            ld      hl,addr
            call    RDSLT
            endm
            
            ld      hl,main_from
            ld      de,main
            ld      bc,end_of_all_code - main
            ldir
            jp      start_check
            
main_from:
            org     0x8000
            include ../common_z80ccfscr.asm

; EOF ;
