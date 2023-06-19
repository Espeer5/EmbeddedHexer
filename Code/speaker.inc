 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                                                            ;
;                                 SPEAKER.INC                                ;
;                             Speaker Definitions                            ;
;                       Microprocessor-Based Hexer Game                      ;
;                                                                            ;
;                                                                            ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; This file contains the definitions needed for speaker control for the
; microprocessor-based hexer game
;
; Revision History:
;     6/3/23   Edward Speer    Initial Revision

; Timer Definitions 

.EQU   OC_OFF     = 0b00000000  ;Timer1 controlA to turn off OC on all channels 
.EQU   OC1A_TOG   = 0b01000000  ;Timer1 controlA, OC Toggle mode on on channel A
.EQU   CTC_ON     = 0b00001000  ;Timer1 controlB to turn on CTC mode
.EQU   PRESC_8    = 0b00000010  ;Timer1 controlB for clock over 8 prescaler 

; Speaker Port constants 

.EQU  SP_LOW      = 0b00000000  ;Speaker output pin low on port B

;Frequency constants

.EQU F_MIN_HIGH   = 0           ;High byte of min freq for carry propogation
.EQU F_MIN_LOW    = 20          ;Minimum frequency that may be played on speaker 
.EQU F_MAX        = 20000       ;Maximum frequency that may be played on speaker
.EQU SCALE_CONST  = 500000      ;CLK/(8 prescale * 2) used to compute OC
