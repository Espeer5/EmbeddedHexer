;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                                                            ;
;                                  HEXER.INC                                 ;
;                                 Definitions                                ;
;                       Microprocessor-Based Hexer Game                      ;
;                                 Include File                               ;
;                                                                            ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; This file contains the general hardware and constants definitions for the
; Microprocessor-Based Hexer game.
;
; Revision History:
;     5/19/23    Edward Speer    initial revision
;     5/20/23    Edward Speer    Debug IO constants
;     6/13/23    Edward Speer    Add switch patterns 
;     6/13/23    Edward Speer    Add move number digit masks
;     6/15/23    Edward Speer    Add win conditions constants
;     6/15/23    Edward Speer    Update comments and constant names

; IO port definitions
.EQU     READ     = 0b00000000       ;IO input mode select 
.EQU     OUTP     = 0b11111111       ;IO output mode select
.EQU     OCR_OUT  = 0b00100000       ;Output select on OCR1A bit on port B

;Timer controls
.EQU    TIMERCLK32 = 0b01000011      ;Timer0 runs at clock / 32
.EQU    OUTC       = 0b11111010      ;Register for timer output compare
.EQU    TIMSKEN    = 0b00000010      ;Enable timer0 generated interrupts

;Switch Patterns 
.EQU    WHITE_S    = 0b01110110      ;Switch pattern for white switch pressed 
.EQU    BLACK_S    = 0b01011110      ;Switch pattern for black switch pressed 
.EQU    BLUE_S     = 0b01111100      ;Switch pattern for blue switch pressed 
.EQU    RED_S      = 0b01101110      ;Switch pattern for red switch pressed 
.EQU    GREEN_S    = 0b01111010      ;Switch pattern for green switch pressed 
.EQU    RAND_S     = 0b00011110      ;Switch pattern for random start switch 
.EQU    RESET_0    = 0b00111010      ;Switch pattern for reset 0 pressed 
.EQU    RESET_1    = 0b00111100      ;Switch pattern for reset 1 pressed     

;LED Patterns
.EQU   WIN_BOARD_LOW = 0b11111111    ;GameBoard when game is won
.EQU   WIN_BOARD_HIGH= 0b11101111
.EQU   ALL_ON_LOW    = 0b11111111    ;Mask to remove bit 12 from an LED pattern
.EQU   ALL_ON_HIGH   = 0b11101111

;Move number digit masks
.EQU  LOW_DIGIT   = 0b00001111       ;Bit positions right digit in hex number
.EQU  HIGH_DIGIT  = 0b11110000       ;Bit positions of left digit in hex number

.EQU  HEX_09      = 0x09             ;Decimal value 9 in hex
.EQU  HEX_90      = 0x90             ;Decimal value 90 in hex
.EQU  HEX_01      = 0x01             ;Decimal 01 to be added to a hex number 
.EQU  HEX_10      = 0x10             ;Decimal 10 to be added to a hex number
