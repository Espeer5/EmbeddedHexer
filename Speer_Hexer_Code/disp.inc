;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                                                            ;
;                                   DISP.INC                                 ;
;                             Display Definitions                            ;
;                       Microprocessor-Based Hexer Game                      ;
;                                 Include File                               ;
;                                                                            ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; This file contains the display hardware and constants definitions for the
; Microprocessor-Based Hexer game.
;
; Revision History:
;     5/19/23   Edward Speer    initial revision
;     5/20/23   Edward Speer    Add port constants and specific digit patterns
;     5/20/23   Edward Speer    Debug display muxing
;     6/15/23   Edward Speer    Rename constants 
;     6/15/23   Edward Speer    Add blinking constants

;IO constants 

.EQU     LEDSOFF     = 0x00                ;Port D value to turn off all LEDS 
.EQU     LED_OFF     = 0b00000000          ;Constant pattern for an off LED

;Display parameters

.EQU     LOW_NIBBLE  = 0b00001111          ;Mask for the low nibble of a byte 
.EQU     DISP_LINES  = 7                   ;Number of multiplexed display lines
.EQU     SEG_OFFS    = 3                   ;Offset to reach segment display in buffer
.EQU     SEG_NUM     = 4                   ;The number of segment display digits

.EQU     INIT_PATT   = 0b00000001          ;Initial segment drive pattern 
.EQU     HIGH_MASK   = 0b11101111          ;Mask for high bits of game LEDS
.EQU     LOW_MASK    = 0b11111111          ;Mask for low bits of game LEDS

.EQU     BLINKING    = 1                   ;Value of blinking flag when blinking
.EQU     NBLINKING   = 0                   ;Value of blinking flag when not blinking
.EQU     BL_TIME     = 200                 ;Frequency with which to blink display
.EQU     FALSE       = 0                   ;Flag value when false
.EQU     TRUE        = 1                   ;Flag value when true

;Ports 

.EQU    DIG_PORT       = PORTC             ;LED display patterns on port C 
.EQU    DIGIT_PORT     = PORTD             ;LED mux selection on port D