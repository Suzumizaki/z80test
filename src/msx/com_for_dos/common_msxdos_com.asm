;
; This file is part of z80test MSX version.
; Copyright (C) 2025 Suzumizaki-Kimitaka(鈴見咲 君高)
; This source code is released under the MIT license, see included license.txt.
;
msx_main_starts  equ  0x8000
for_bload_r      equ  0
for_msx_dos      equ  1

            org     0x0100
            
            ld      hl, main_starts
            ld      de, main
            ld      bc, last_ptr - main
            ldir
loop_on_msxdos:
            call    common_pre_msx
            call    main
            
            call    print
            db      "Re-run to press y or exit otherwise.",0
            call    waitkeyandput
            cp      'y'
            jr      z, loop_on_msxdos
            ld      c, 0
            jp      0005H

; EOF ;
