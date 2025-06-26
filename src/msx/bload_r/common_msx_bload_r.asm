;
; This file is part of z80test MSX version.
; Copyright (C) 2025 Suzumizaki-Kimitaka(鈴見咲 君高)
; This source code is released under the MIT license, see included license.txt.
;
            org     0x8040 - 7
            
            db      0xFE           ; MSX-BASIC BLOAD header
            dw      bload_loop     ; The lowest address to load.
            dw      last_ptr - 1   ; The highest address to load.
            dw      bload_loop     ; The address to auto-run.
bload_loop:
            call    common_pre_msx
            call    main
            
            call    print
            db      "Press any character key to re-run.",0
            call    waitkeyandput
            jr      bload_loop
            
msx_main_starts   equ   0x8100
for_bload_r       equ   1
for_msx_dos       equ   0

; EOF ;
