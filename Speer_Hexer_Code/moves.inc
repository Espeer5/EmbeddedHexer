;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                                                            ;
;                                  MOVES.INC                                 ;
;                             User Move Definitions                          ;
;                       Microprocessor-Based Hexer Game                      ;
;                                                                            ;
;                                                                            ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; This file contains all the constants needed to allow the user to make moves 
; which manipulate the game data.
;
; Revision History:
;     6/12/23    Edward Speer    initial revision
;     6/15/23    Edward Speer    Seperate low and high bytes for ease of use 
;     6/16/23    Edward Speer    Update comments

;Game board constants 


.EQU    WHITE_ON_LOW  = 0b10000110       ;Bytes giving LEDs of white hexagon
.EQU    WHITE_ON_HIGH = 0b10000110       ;Bytes giving LEDs of white hexagon
.EQU    LED_1    = 14                    ;bit of GameBoard storing LED1 
.EQU    LED_2    = 8                     ;bit of GameBoard storing LED2 
.EQU    LED_3    = 9                     ;bit of GameBoard storing LED3  
.EQU    LED_4    = 10                    ;bit of GameBoard storing LED4  
.EQU    LED_5    = 13                    ;bit of GameBoard storing LED5  
.EQU    LED_6    = 0                     ;bit of GameBoard storing LED6  
.EQU    LED_7    = 1                     ;bit of GameBoard storing LED7  
.EQU    LED_8    = 5                     ;bit of GameBoard storing LED8  
.EQU    LED_9    = 15                    ;bit of GameBoard storing LED9 
.EQU    LED_10   = 11                    ;bit of GameBoard storing LED10  
.EQU    LED_11   = 6                     ;bit of GameBoard storing LED11  
.EQU    LED_12   = 2                     ;bit of GameBoard storing LED12 
.EQU    LED_13   = 7                     ;bit of GameBoard storing LED13 
.EQU    LED_14   = 3                     ;bit of GameBoard storing LED14 
.EQU    LED_15   = 4                     ;bit of GameBoard storing LED15 


.EQU    Bit0Mask_LOW  = 0000000001       ;Mask giving bit 0 of a 16 bit variable
.EQU    Bit0Mask_HIGH = 0b00000000       ;Mask giving bit 0 of a 16 bit variable
.EQU    MaskOut0_LOW  = 0b11111110       ;Mask removing bit 0 of 16 bit variable
.EQU    MaskOut0_HIGH = 0b11111111       ;Mask removing bit 0 of 16 bit variable

.EQU   LEDOn    = 0b00000001             ;Constant 1 turning on an LED
.EQU   LEDOff   = 0b00000000             ;Constant 0 turning an LED off 
