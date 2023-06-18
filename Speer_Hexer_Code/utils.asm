;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                                                            ;
;                                 UTILS.ASM                                  ;
;                              Utility Functions                             ;
;                       Microprocessor-Based Hexer Game                      ;
;                                                                            ;
;                                                                            ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; This file contains some simple abstract utility functions needed for the
; microprocessor based hexer game
;
; Revision History:
;     6/3/23   Edward Speer    Initial Revision
;     6/13/23  Edward Speer    Add psuedo-random 16 bit number function 
;     6/16/23  Edward Speer    Update comments

.cseg


; Div24
;
; Description:        Performs integer division on 2 24 bit numbers
;
; Operation:          Takes in 2 24 bit numbers and returns the result of  
;                     integer division between them in R21|R20|R19
;
; Arguments:          24 bit dividend in R21|R20|R19, 
;                     24 bit divisor in R24|R23|R22
; Return Value:       24 bit division result in R21|R20|R19
;
; Local Variables:    None
; Shared Variables:   None
;
; Input:              None
; Ouput:              None
;
; Error Handling:     None
;
; Algorithms:         Euclid's division algorithm used to compute result
; Data Structures:    None
;
; Registers Changed:  R15, R16, R17, R25, R19, R20, R21, R22, R23, R24
; 
; Author:             Edward Speer
; Last Modified:      6/5/23

Div24:

    CLR  R15
    CLR  R16
    SUB  R17, R17     ;Clear registers for 24 bit remainder, clear carry flag
    LDI  R25, 25      ;Initialize for-loop counter

DivLoop:

    ROL  R19
    ROL  R20
    ROL  R21          ;Rotate dividend left 
    DEC  R25          ;Decrement for-loop counter
    BREQ DivDone      ;If counter is 0, we are done 
    ;BRNE CalcStep    ;Otherwise, perform the next step of division

CalcStep:

    ROL  R15
    ROL  R16
    ROL  R17          ;Shift dividend into remainder 
    SUB  R15, R22
    SBC  R16, R23
    SBC  R17, R24     ;Subtract divisor from remainder 
    BRCS RestRem      ;If result negative, restore remainder
    ;BRCC RepeatStep  ;Otherwise, repeat loop with carry to shift into result 

RepeatStep:

    SEC               ;Set carry to shift into result in next loop 
    RJMP  DivLoop     ;And restart for loop

RestRem:

    ADD  R15, R22
    ADC  R16, R23
    ADC  R17, R24     ;Restore remainder
    CLC               ;Clear carry for next loop iteration 
    RJMP DivLoop      ;And restart for loop 

DivDone:

    RET


; Random16No12
;
; Description:        Generates a 16 bit number with bit 12 masked out, 
;                     simulating randomness based on when the switch is pressed.
;                     Never returns a pattern with all 1's.
;
; Operation:          Generates a 16 bit number from the timer, then masks out  
;                     12. If the pattern was all 1's, regenerates a new pattern
;
; Arguments:          None
; Return Value:       16 bit number in R17|R16 with bit 12 0
;
; Local Variables:    None
;
; Shared Variables:   None
;
; Input:              None
; Ouput:              None
;
; Error Handling:     None
;
; Algorithms:         None
; Data Structures:    None
;
; Registers Changed: R16, R17, R18, R19
; 
; Author:             Edward Speer
; Last Modified:      6/11/23

Random16No12:

       IN     R16, TCNT1L        ;Use value of 16 bit timer as random - psuedo
	   IN     R17, TCNT1L        ; random depending on when user resets the game

       LDI    R18, ALL_ON_LOW
	   LDI    R19, ALL_ON_HIGH   ;Load mask to remove bit 12

	   AND    R16, R18
	   AND    R17, R19           ;Mask out bit 12 of the LEDs

	   LDI    R18, ALL_ON_LOW
	   LDI    R19, ALL_ON_HIGH

       CP     R16, R18
	   CPC    R17, R19
	   BREQ   Random16No12       ;If generated pattern with all 1's, regenerate
	   ;BRNE  Generated          ;Otherwise, done generating so return

       RET 