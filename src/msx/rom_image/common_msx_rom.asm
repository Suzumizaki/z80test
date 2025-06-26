;
; This file is part of z80test MSX version.
; Copyright (C) 2025 Suzumizaki-Kimitaka(鈴見咲 君高)
; This source code is released under the MIT license, see included license.txt.
;
msx_main_starts  equ  0x8000
for_bload_r      equ  0
for_msx_dos      equ  0

            defpage 0, 4000h, 16384             ; Make ROM file to 16KB.
            page    0
            
            org     0x4000
            
            db      "AB"                        ; MSX ROM identifier
            dw      cpyndrun                    ; INIT to jump
            dw      0, 0, 0                     ; STATEMENT, DEVICE and TEXT are not used.
            dw      0, 0, 0                     ; reserved to use future MSX system definition.

cpyndrun:
            ld      hl, main_starts
            ld      de, main
            ld      bc, last_ptr - main
            ldir
            
            call    common_pre_msx
            call    main
            
            call    print
            db      "Press any character key to reset.",0
            call    waitkeyandput
            rst     0

; EOF ;
