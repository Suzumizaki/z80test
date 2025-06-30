; Z80 test - monitor random behavior of bits 5 and 3 after CCF.
;
; Copyright (C) 2023 Patrik Rak (patrik@raxoft.cz)
;
; This file is part of z80test MSX version.
; Copyright (C) 2025 Suzumizaki-Kimitaka(鈴見咲 君高)
;
; This source code is released under the MIT license, see included license.txt.


WORK        equ     09000H

            macro   call_bios addr
            call    addr
            endm

            macro   read_bios addr
            ld      a,(addr)
            endm
            
            org     0x8080 - 7

            db      0xFE                ; MSX-BASIC BLOAD header
            dw      main                ; The lowest address to load.
            dw      end_of_all_code - 1 ; The highest address to load.
            dw      start_check         ; The address to auto-run.
            
            include ../common_z80ccfscr.asm

; EOF ;
