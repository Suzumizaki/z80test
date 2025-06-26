;
; This file is part of z80test MSX version.
; Copyright (C) 2025 Suzumizaki-Kimitaka(鈴見咲 君高)
; This source code is released under the MIT license, see included license.txt.
;

            ; The values to assert should be defined before check.
            assert  msx_main_starts <= main

default_ok_msg:
            db      " OK",13,0
default_skip_msg:
            db      " Skipped",13,0
erase_last_line:
            db      0x1B, 'M', 0
ok_msg_ptr:
            dw      default_ok_msg
skip_msg_ptr:
            dw      default_skip_msg
            
printchr:
            push    hl
            push    bc
            ld      b,a
            ld      hl, .skipcnt
            ld      a,(hl)
            dec     a
            jr      z,.next_printchr
            ld      (hl),a
.end_printchr
            ld      a,b
            pop     bc
            pop     hl
            ret
.next_printchr
            ld      a,23
            cp      b
            jr      nz,.next2_printchr
            ; Skip 48K Spectrum escape sequence like.
            ld      (hl),3
            ld      a,' '
            call    .call_chput
            jr      .end_printchr
.next2_printchr
            ld      a,b
            pop     bc
            pop     hl
            call    .call_chput
            cp      13
            ret     nz
            ld      a,10
            call    .call_chput
            ld      a,13
            ret
.call_chput

if for_msx_dos
            push    ix
            push    iy
            ld      ix, CHPUT
            ld      iy, (EXPTBL - 1)
            call    CALSLT
            pop     iy
            pop     ix
else
            call    CHPUT
endif
            di           ; The test must be run under DI.
            ret
.skipcnt    db      1    ; to skip 48K Spectrum escape sequence like.

waitkeyandput:
if for_msx_dos
            ld      ix, KILBUF
            ld      iy, (EXPTBL - 1)
            call    CALSLT
            ld      ix, CHGET
            ld      iy, (EXPTBL - 1)
            call    CALSLT
else
            call    KILBUF
            call    CHGET
endif
            push    af
            call    printchr
            call    print
            db      13, 13, 0
            pop     af
printinit:
            ret

ok_print:
            ld      hl,(ok_msg_ptr)
            jp      printhl

failed_print:
            push    hl
            call    print
            db      " FAILED",0
            
            ld      a, (LINL40)
            cp      41
            jr      nc, .in_mode_80
            call    print
            db      13,32,0
            jr      .start_show_crc
.in_mode_80
            ld      hl, (CSRY)           ; l := (CSRY)
            ld      h, 36                ; h := x position
if for_msx_dos
            push    ix
            push    iy
            ld      ix, POSIT
            ld      iy, (EXPTBL - 1)
            call    CALSLT
            pop     iy
            pop     ix
else
            call    POSIT
endif
.start_show_crc
            call    print
            db      "CRC: ",0
            pop     hl
            call    printcrc
            call    print
            db      "  Expected: ",0

            ex      de,hl
            call    printcrc

            ld      a,13
            jp      printchr
last_ptr:


; EOF ;
