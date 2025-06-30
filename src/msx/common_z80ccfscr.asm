; Z80 test - monitor random behavior of bits 5 and 3 after CCF.
;
; Copyright (C) 2023 Patrik Rak (patrik@raxoft.cz)
;
; This file is part of z80test MSX version.
; Copyright (C) 2025 Suzumizaki-Kimitaka(鈴見咲 君高)
;
; This source code is released under the MIT license, see included license.txt.

VDP_W       equ     7
ROM_ID      equ     002DH
RDSLT       equ     000CH
CALSLT      equ     001CH
SETWRT      equ     0053H
INIGRP      equ     0072H
CHGET       equ     009FH
CHPUT       equ     00A2H
CHGCPU      equ     0180H
GRPCOL      equ     0F3C9H
CGPBAS      equ     0F924H
JIFFY       equ     0FC9EH
EXPTBL      equ     0FCC1H
COL1        equ     01EH
COL2        equ     0CFH

            assert  (WORK & 0xFF) == 0
main:
            call_bios INIGRP
            ld      hl,(GRPCOL)
            call_bios SETWRT
            read_bios VDP_W
            ld      c,a

            ld      d,0
.init_lp1
            ld      b,8
            ld      a,COL1
.init_lp2:
            out     (c), a
            djnz    .init_lp2
            
            ld      b,8
            ld      a,COL2
.init_lp3:
            out     (c), a
            djnz    .init_lp3
            
            dec     d
            jr      nz,.init_lp1
            
            ld      a,COL1
            out     (c), a
            ld      a,COL2
            out     (c), a

main_loop:
            push    bc
            ld      hl,WORK
            di                ; make sure no interrupt around 'ccf'.
            ld      a,h
            add     a,0FH
            assert  ($ >> 8) == 0x80
            ld      d,a
.loop
            push    hl
            pop     af        ; low byte of WORK is copied to F regstier.
            ccf
            push    af
            ei                ; make sure to count up JIFFY.
            pop     bc
            ld      a,l
            xor     c
            ld      (hl),a
            inc     hl
            ld      a,d
            di                ; make sure no interrupt around 'ccf'.
            cp      h
            jp      nc,.loop
            assert  ($ >> 8) == 0x80
            
            ;
            ; Show result like 48K Spectrum.
            ;
            ld      hl,(CGPBAS)
            call_bios SETWRT
            pop     bc
            ei                ; make sure to count up JIFFY.
            
            ld      de,0
            ld      b,7
.vram_loop
            ld      l,e
            ld      a,d
            rra
            rr      l
            rra
            rr      l
            rra
            rr      l
            ld      a,e
            and     b
            ld      h,a
            ld      a,d
            and     8
            or      h
            add     a,WORK >> 8
            ld      h,a

            ld      a,(hl)
            out     (c),a
            
            inc     de
            ld      a,d
            cp      10H
            jp      c,.vram_loop
            
            ;
            ; Append signal to show program alive.
            ;
            ld      hl,(JIFFY)
            out     (c),l
            nop
            out     (c),h
            
            jr      main_loop
end_of_main:

start_check:
            read_bios ROM_ID
            cp      3
            jp      c,main
            call    print
            db "Run with R800? Please type y for yes.",0
            call_bios CHGET
            call_bios CHPUT
            cp      'y'
            ld      a,80H
            jr      nz,.set_cpu_mode
            inc     a
.set_cpu_mode
            call_bios CHGCPU
            jp      main

print:
            ex      (sp),hl
.print_loop
            ld      a,(hl)
            and     a
            jr      z,.print_end
            push    hl
            call_bios CHPUT
            pop     hl
            inc     hl
            jr      .print_loop
.print_end
            ex      (sp),hl
            ret
end_of_all_code:

; EOF ;
