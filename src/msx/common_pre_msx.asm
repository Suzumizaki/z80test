;
; This file is part of z80test MSX version.
; Copyright (C) 2025 Suzumizaki-Kimitaka(鈴見咲 君高)
; This source code is released under the MIT license, see included license.txt.
;
io_compatible  equ  0

BDOS           equ  0005H
RDSLT          equ  000CH
CALSLT         equ  001CH
ROM_ID         equ  002DH
CHGCLR         equ  0062H
INITXT         equ  006CH
CHGET          equ  009FH
CHPUT          equ  00A2H
POSIT          equ  00C6H
KILBUF         equ  0156H
CHGCPU         equ  0180H
LINL40         equ  0F3AEH
CSRY           equ  0F3DCH
FORCLR         equ  0F3E9H
BDRCLR         equ  0F3EBH
EXPTBL         equ  0FCC1H

common_pre_msx:
            ld      hl, 040FH
            ld      (FORCLR), hl ; FORCLR, BAKCLR
            ld      a, h
            ld      (BDRCLR), a
if for_msx_dos
            ld      ix, CHGCLR
            ld      iy, (EXPTBL - 1)
            call    CALSLT
else
            call    CHGCLR
endif


if for_msx_dos
            ld      a, (EXPTBL)
            ld      hl, ROM_ID
            call    RDSLT
else
            ld      a, (ROM_ID)
endif
            and     a
            ld      a, 40
            jr      z, .msx1
            add     a, a
.msx1
            ld      (LINL40), a ; set width on screen 0.
if for_msx_dos
            ld      ix, INITXT  ; set screen 0.
            ld      iy, (EXPTBL - 1)
            call    CALSLT
else
            call    INITXT      ; set screen 0.
endif
            call    print
            db      "Show failed case only? please type y to yes. ",0
            call    waitkeyandput
            cp      'y'
            ld      hl, default_ok_msg
            ld      de, default_skip_msg
            jr      nz, .use_default_msg
            ld      hl, erase_last_line
            ld      d, h
            ld      e, l
.use_default_msg
            ld      (ok_msg_ptr), hl
            ld      (skip_msg_ptr), de

if for_msx_dos
            ld      a, (EXPTBL)
            ld      hl, ROM_ID
            call    RDSLT
else
            ld      a, (ROM_ID)
endif
            cp      3
            ret     c
            call    print
            db      "Run with R800? ",0
            call    waitkeyandput
            cp      'y'
            ld      a, 80H  ; Z80 (ROM) mode with LED changed
            jr      nz, .keep_z80
            inc     a       ; R800 ROM mode with LED changed.
.keep_z80
if for_msx_dos
            ld      ix, CHGCPU
            ld      iy, (EXPTBL - 1)
            jp      CALSLT  ; call CHGCPU and return.
else
            jp      CHGCPU  ; call CHGCPU and return.
endif
            
            ; note: ifdef doesn't work with sjasm 0.42c.
            if      for_bload_r
            ds      msx_main_starts - $, 0
            endif
main_starts:
            org     msx_main_starts
; EOF ;
