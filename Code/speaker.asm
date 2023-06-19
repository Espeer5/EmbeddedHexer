;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                                                            ;
;                                 SPEAKER.ASM                                ;
;                              Speaker Functions                             ;
;                       Microprocessor-Based Hexer Game                      ;
;                                                                            ;
;                                                                            ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; This file contains the functions necessary to play sounds on the speaker for
; the Microprocessor-Based Hexer game.
;
; Revision History:
;     6/3/23    Edward Speer    Initial Revision
;     6/13/23   Edward Speer    Set up arguments correctly for division 
;     6/16/23   Edward Speer    Update comments

.cseg


;InitSpeaker
;
; Description:        This procedure initializes the speaker such that the
;                     timer used to send signals to the speaker is turned off, 
;                     with the output on the timer compare register port set low 
;                     such that the speaker is not receiving current.
;
; Operation:          Sets the timer compare register for timer 1 such that the 
;                     timer is off and the output compare signal is low.
;
; Arguments:          None
; Return Value:       None
;
; Local Variables:    None
; Shared Variables:   None
;
; Input:              None
; Ouput:              Output timer controls to TCCR1A and TCCR1B
;
; Error Handling:     None
;
; Algorithms:         None
; Data Structures:    None
;
; Registers Changed:  R16
; 
; Author:             Edward Speer
; Last Modified:      6/16/23

InitSpeaker:

        LDI  R16, OC_OFF
        OUT  TCCR1A, R16              ;Turn off output compare for timer1 

        LDI  R16, (CTC_ON | PRESC_8) 
        OUT  TCCR1B, R16              ;Turn on CTC mode, CLK/8 prescale on timer1

        LDI  R16, SP_LOW 
        OUT  PORTB, R16               ;Set signal out to speaker low

        RET                           ;Done, so return
    

; PlayNote
;
; Description:        This procedure plays a note at the passed frequency on the 
;                     speaker. The tone generated is a square wave, and it is 
;                     played until a new tone is triggered by a call to this 
;                     function. A call to this routine with argument of 0 will 
;                     result in turning off the speaker. 
;                     Frequency range: 20Hz-20kHz Hz
;
; Operation:          Check the frequency passed to ensure it is in the valid 
;                     frequency range, and if not, turn off the speaker. If 
;                     valid, set the output compare register for the timer and 
;                     reset the counter to output the square wave with the right
;                     frequency on the output compare port for timer 1.
;
; Arguments:          f (frequency to play) passed in R17|R16 (range 20Hz-20kHz)
; Return Value:       None
;
; Local Variables:    CountMax - the value to set the output compare register to
; Shared Variables:   None
;
; Input:              None
; Ouput:              Output timer controls to TCCR1A and TCCR1B, and output 
;                     the output compare value to OCRA1
;
; Error Handling:     Calls to the function with a frequency outside of the 
;                     frequency change result in turning off the speaker
;
; Algorithms:         None
; Data Structures:    None
;
; Registers Changed: R16, R17, R18, R19, R20, R21, R22, R23, R24
; 
; Author:             Edward Speer
; Last Modified:      6/3/23

PlayNote: 

CheckMin: 

        LDI  R19, F_MIN_HIGH
        LDI  R18, F_MIN_LOW         ;Load minimum frequency
        CP   R16, R18 
        CPC  R17, R19               ;Compare f with minimum allowed frequency 
        BRLT SpeakerOff             ;If f < minimum, turn off speaker 
        ;BRGE CheckMax              ;Otherwise, check f below maximum

CheckMax:
        
        LDI  R18, LOW(F_MAX)
        LDI  R19, HIGH(F_MAX)       ;Load maximum frequency 
        CP   R16, R18 
        CPC  R17, R19               ;Compare f with maximum allowed frequency
        BRGE SpeakerOff             ;If f > maximum, turn off speaker 
        ;BRLT ComputeOC             ;Otherwise, go on to compute output compare 

ComputeOC:

        CLR  R24                     ;Set up args to divide: f in R24|R23|R22
		MOV  R23, R17
		MOV  R22, R16
        LDI  R19, LOW(SCALE_CONST)
        LDI  R20, BYTE2(SCALE_CONST) ;Load scale constant to perform division
        LDI  R21, BYTE3(SCALE_CONST)
        CALL Div24                   ;Perform division -> places OC in R20|R19 

SetOC:

        OUT  OCR1AH, R20             ;and high byte to output compare register
        OUT  OCR1AL, R19             ;Output low byte of output compare 

TimerOn:

        LDI  R16, OC1A_TOG
        OUT  TCCR1A, R16            ;Set toggle mode on for timer1
        RJMP NoteDone               ;And finished 

SpeakerOff:

        RCALL InitSpeaker           ;Reset speaker with timer off, pin low 

NoteDone:

        RET                         ;Done, so return