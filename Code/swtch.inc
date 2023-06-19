
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                                                            ;
;                                  SWTCH.INC                                 ;
;                              Switch Definitions                            ;
;                       Microprocessor-Based Hexer Game                      ;
;                                 Include File                               ;
;                                                                            ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; This file contains the definitions for the switch functions for the
; Microprocessor-Based Hexer game.
;
; Revision History:
;     5/3/23    Edward Speer    initial revision
;     5/4/23    Edward Speer    Add definitions for timer/port initialization
;     5/20/23   Edward Speer    Transfer IO constants to general inc file
;     5/20/23   Edward Speer    Update comments
;     6/13/23   Edward Speer    Add auto-repeat constants 

; Switch definitions 

; Timing parameters (assumes 1 ms interrupt)

.EQU    DEBOUNCE_TIME_LOW = 4           ;Threshold debouncing time in miliseconds byte 1
.EQU    DEBOUNCE_TIME_HIGH= 0           ;Threshold debouncing time in ms byte 2
.EQU    AR_TIME_BOT_LOW   = 0b00000000  ;Bottom value for auto-repeat counter (ms) byte 1
.EQU    AR_TIME_BOT_HIGH  = 0b10000000  ;Bottom value for auto-repeat counter byte 2
.EQU    AR_TIME_TOP_lOW   = 0b11111111  ;Top value for auto-repeat counter (ms) byte 1
.EQU    AT_TIME_TOP_HIGH  = 0b01111111  ;Top value for auto-repeat counter byte 2

; Hardware definitions

.EQU    SWITCHES_OFF = 0b01111110    ;Inactive state of the 6 switches 
