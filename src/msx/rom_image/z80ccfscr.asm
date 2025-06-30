; Z80 test - monitor random behavior of bits 5 and 3 after CCF.
;
; Copyright (C) 2023 Patrik Rak (patrik@raxoft.cz)
;
; This file is part of z80test MSX version.
; Copyright (C) 2025 Suzumizaki-Kimitaka(鈴見咲 君高)
;
; This source code is released under the MIT license, see included license.txt.

            defpage 0, 8000h, 16384             ; Make ROM file to 16KB.
            page    0

WORK        equ     0C000H
            
            org     0x8000
            
            db      "AB"                        ; MSX ROM identifier
            dw      start_check                 ; INIT to jump
            dw      0, 0, 0                     ; STATEMENT, DEVICE and TEXT are not used.
            dw      0, 0, 0                     ; reserved to use future MSX system definition.
            
            macro   call_bios addr
            call    addr
            endm

            macro   read_bios addr
            ld      a,(addr)
            endm
            
            include ../common_z80ccfscr.asm

; EOF ;
