;
; 48k spectrum specific definitions here.
;

printinit:  ld      a,2
            jp      0x1601      ; CHAN-OPEN

printchr:   push    iy
            ld      iy,0x5c3a   ; ERR-NR
            push    de
            push    bc
            exx
            ei
            ; out     (0xff),a
            rst     0x10
            di
            exx
            pop     bc
            pop     de
            pop     iy
            ret

ok_print:   call    print                       ; print success
            db      23,32-2,1,"OK",13,0
            ret

failed_print:
            call    print
            db      23,32-6,1,"FAILED",13
            db      "CRC:",0

            call    printcrc

            call    print
            db      "   Expected:",0

            ex      de,hl
            call    printcrc

            ld      a,13
            jp      printchr

; EOF ;
