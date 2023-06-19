;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                                                            ;
;                                   SEGTABLE                                 ;
;                           Tables of 7-Segment Codes                        ;
;                                                                            ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; This file contains tables of 7-segment codes.  The segment ordering is
; given below.  The tables included are:
;    ASCIISegTable - table of codes for 7-bit ASCII characters
;    DigitSegTable - table of codes for hexadecimal digits
;
; Revision History:
;     5/18/23  auto-generated           initial revision
;     5/18/23  Glen George              added DigitSegTable



; local include files
;    none




;table is in the code segment
        .cseg




; ASCIISegTable
;
; Description:      This is the segment pattern table for ASCII characters.
;                   It contains the active-high segment patterns for all
;                   possible 7-bit ASCII codes.  Codes which do not have a
;                   "reasonable" way of being displayed on a 7-segment display
;                   are left blank.  None of the codes set the decimal point.
;
; Notes:            READ ONLY tables should always be in the code segment so
;                   that in a standalone system it will be located in the
;                   ROM with the code.
;
; Author:           auto-generated
; Last Modified:    May 18, 2023

ASCIISegTable:


;        DB       fbeagedc    fbeagedc   ; ASCII character

        .DB     0b00000000, 0b00000000   ; NUL, SOH
        .DB     0b00000000, 0b00000000   ; STX, ETX
        .DB     0b00000000, 0b00000000   ; EOT, ENQ
        .DB     0b00000000, 0b00000000   ; ACK, BEL
        .DB     0b00000000, 0b00000000   ; backspace, TAB
        .DB     0b00000000, 0b00000000   ; new line, vertical tab
        .DB     0b00000000, 0b00000000   ; form feed, carriage return
        .DB     0b00000000, 0b00000000   ; SO, SI
        .DB     0b00000000, 0b00000000   ; DLE, DC1
        .DB     0b00000000, 0b00000000   ; DC2, DC3
        .DB     0b00000000, 0b00000000   ; DC4, NAK
        .DB     0b00000000, 0b00000000   ; SYN, ETB
        .DB     0b00000000, 0b00000000   ; CAN, EM
        .DB     0b00000000, 0b00000000   ; SUB, escape
        .DB     0b00000000, 0b00000000   ; FS, GS
        .DB     0b00000000, 0b00000000   ; AS, US

;        DB       fbeagedc    fbeagedc   ; ASCII character

        .DB     0b00000000, 0b00000000   ; space, !
        .DB     0b11000000, 0b00000000   ; ", #
        .DB     0b00000000, 0b00000000   ; $, %
        .DB     0b00000000, 0b01000000   ; &, '
        .DB     0b10110110, 0b01010011   ; (, )
        .DB     0b00000000, 0b00000000   ; *, +
        .DB     0b00000000, 0b00001000   ; ,, -
        .DB     0b00000000, 0b00000000   ; ., /
        .DB     0b11110111, 0b01000001   ; 0, 1
        .DB     0b01111110, 0b01011011   ; 2, 3
        .DB     0b11001001, 0b10011011   ; 4, 5
        .DB     0b10111111, 0b01010001   ; 6, 7
        .DB     0b11111111, 0b11011001   ; 8, 9
        .DB     0b00000000, 0b00000000   ; :, ;
        .DB     0b00000000, 0b00001010   ; <, =
        .DB     0b00000000, 0b00000000   ; >, ?

;        DB       fbeagedc    fbeagedc   ; ASCII character

        .DB     0b01111111, 0b11111101   ; @, A
        .DB     0b11111111, 0b10110110   ; B, C
        .DB     0b11110111, 0b10111110   ; D, E
        .DB     0b10111100, 0b10111111   ; F, G
        .DB     0b11101101, 0b01000001   ; H, I
        .DB     0b01100111, 0b00000000   ; J, K
        .DB     0b10100110, 0b00000000   ; L, M
        .DB     0b00000000, 0b11110111   ; N, O
        .DB     0b11111100, 0b00000000   ; P, Q
        .DB     0b00000000, 0b10011011   ; R, S
        .DB     0b00000000, 0b11100111   ; T, U
        .DB     0b00000000, 0b00000000   ; V, W
        .DB     0b00000000, 0b11001001   ; X, Y
        .DB     0b00000000, 0b10110110   ; Z, [
        .DB     0b00000000, 0b01010011   ; \, ]
        .DB     0b00000000, 0b00000010   ; ^, _

;        DB       fbeagedc    fbeagedc   ; ASCII character

        .DB     0b10000000, 0b00000000   ; `, a
        .DB     0b10101111, 0b00101110   ; b, c
        .DB     0b01101111, 0b00000000   ; d, e
        .DB     0b00000000, 0b11011011   ; f, g
        .DB     0b10101101, 0b00000001   ; h, i
        .DB     0b00000000, 0b00000000   ; j, k
        .DB     0b10100100, 0b00000000   ; l, m
        .DB     0b00101101, 0b00101111   ; n, o
        .DB     0b00000000, 0b00000000   ; p, q
        .DB     0b00101100, 0b00000000   ; r, s
        .DB     0b10101110, 0b00100111   ; t, u
        .DB     0b00000000, 0b00000000   ; v, w
        .DB     0b00000000, 0b11001011   ; x, y
        .DB     0b00000000, 0b00000000   ; z, {
        .DB     0b01000001, 0b00000000   ; |, }
        .DB     0b00010000, 0b00000000   ; ~, rubout




; DigitSegTable
;
; Description:      This is the segment pattern table for hexadecimal digits.
;                   It contains the active-high segment patterns for all hex
;                   digits (0123456789AbCdEF).  None of the codes set the
;                   decimal point.  
;
; Notes:            READ ONLY tables should always be in the code segment so
;                   that in a standalone system it will be located in the
;                   ROM with the code.
;
; Author:           Glen George
; Last Modified:    May 18, 2023

DigitSegTable:


;        DB       eaecgfdb    eaecgfdb   ; Hex Digit

        .DB     0b11110111, 0b01000001   ; 0, 1
        .DB     0b01111110, 0b01011011   ; 2, 3
        .DB     0b11001001, 0b10011011   ; 4, 5
        .DB     0b10111111, 0b01010001   ; 6, 7
        .DB     0b11111111, 0b11011001   ; 8, 9
        .DB     0b11111101, 0b10101111   ; A, b
        .DB     0b10110110, 0b01101111   ; C, d
        .DB     0b10111110, 0b10111100   ; E, F
