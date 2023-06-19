;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                                                            ;
;                                   SWITCHES                                 ;
;                                Switch Routines                             ;
;                 Microprocessor-Based Hexer Game (AVR version)              ;
;                                                                            ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; This file contains the functions for debouncing the switches and getting the 
; switch status. The public functions included are:
;    InitSwitchVars  - Initialize variables for switch debouncing
;    DebounceSwitch  - Debounce the switch pattern on the 6 push switches and
;                      autorepeat
;    SwitchAvailable - Reset zero flag if a new switch pattern was debounced
;    GetSwitches     - Hold until pattern debounced, then return that pattern
;
;
; Revision History:
;    5/3/23    Edward Speer    Initial revision 
;    5/4/23    Edward Speer    Interrupt handler added, comments updated
;    5/5/23    Edward Speer    Debug double reporting of switch pressed
;    5/6/23    Edward Speer    Clean up documentation
;    6/13/23   Edward Speer    Remove extra event handler
;    6/13/23   Edward Speer    Increase auto-repeat time
;    6/14/23   Edward Speer    Debug issue storing debounce counter
;    6/16/23   Edward Speer    Update comments

.cseg


; InitSwitchVars
;
; Description:        This procedure initializes the switch debouncing 
;                     variables
; Operation:          The current switch pattern stored is reset to none 
;                     active and the NewPattern flag is reset
;
; Arguments:          None
; Return Value:       None
;
; Local Variables:    None
; Shared Variables:   NewPattern (W) - flag indicating a new debounced pattern
;                                      available
;                     CurrPattern (W)- The most recently debounced switch pattern
;                                 
;
; Input:              None
; Ouput:              None
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

InitSwitchVars:

        LDI    R16, SWITCHES_OFF
        STS    PressedPattern, R16  ;Initalize pressed pattern to empty pattern
        LDI    R16, DEBOUNCE_TIME_LOW
		LDI    R17, DEBOUNCE_TIME_HIGH
        STS    DebCounter, R16      ;Initialize debounce counter to threshold
		STS    DebCounter+1, R17
        LDI    R16, SWITCHES_OFF
        STS    CurrPattern, R16     ;Set CurrPattern to all switches inactive 
        LDI    R16, 0x00
        STS    NewPattern, R16      ;Set NewPattern to false

        RET


; DebounceSwitch
;
; Description:        This procedure debounces the pressing of the push
;                     button switches. Expects to be called on every milisecond 
;                     timer interrupt. Includes 500 milisecond autorepeat.
; Operation:          If a new debounced pattern is available, then 
;                     CurrPattern is set to the pattern and SwitchAvailable is 
;                     set. Autorepeats switch presses held for 500 miliseconds
;                     after each subsequent press.
;
; Arguments:          None
; Return Value:       None
;
; Local Variables:    PressedPattern (Read/Write) - the switch pattern read on
;                                                   the most recent call of
;                                                   debouncing
;                     DebCounter (Read/Write) - the current count of calls for 
;                                               which the switch pattern has
;                                               been the same
; Shared Variables:   NewPattern (Write only) - flag indicating a new debounced 
;                                               pattern available
;                     CurrPattern (Write only) - The current debounced switch 
;                                                pattern
;
; Input:              The push button switch pattern detected from the 
;                     switches on bits 1-6 of port E
; Ouput:              None
;
; Error Handling:     None
;
; Algorithms:         Debouncing filters button presses by using a timed 
;                     counter to ensure the button is pressed for a long
;                     enough time, by checking if the counter reaches a 
;                     threshold
; Data Structures:    CurrPattern is stored in bits 1-6 of 1 byte variable
;
; Registers Changed: None
; 
; Author:             Edward Speer
; Last Modified:      6/14/23

DebounceSwitch:

        PUSH   R15               ;Save touched registers, since expects to be 
        PUSH   R16               ; called during interrupt handling
        PUSH   R17
		PUSH   R18
		PUSH   R19
		PUSH   R20
		PUSH   R21
		PUSH   R22

        IN     R16, PINE         ;Read the pattern from IO to R16
        ANDI   R16, SWITCHES_OFF ;Mask the 8 bit IO reading to switch bits 1-6

CheckNoSwitches:

        CPI    R16, SWITCHES_OFF 
        BREQ   ResetDebounce     ;If all switch inactive, no signal to debounce
        ;BRNE  CheckPatternMatch ;Otherwise, debounce the pressed signal

CheckPatternMatch:
        
        LDS    R17, PressedPattern
        CP     R16, R17          ;Check buttons pressed match debouncing signal
        BRNE   ResetDebounce     ;If not, reset debouncing
        ;BREQ  DebounceCount     ;Otherwise, update/check counter

DebounceCount:

        LDS    R18, DebCounter      ;Load current debouncing counter 
		LDS    R19, DebCounter+1
		CLR    R20                  ;Clear R20 for carry propogation
		LDI    R21, 0x01
		SUB    R18, R21
		SBC    R19, R20             ;Decrement 16 bit counter by 1

CheckCounter:

        TST    R18
        BREQ   LowByte0          ;If counter has reached zero, pattern debounced 
        ;BRNE  RepeatMin         ;Otherwise, pattern not yet debounced

RepeatMin:

        LDI    R21, AR_TIME_BOT_LOW
		LDI    R22, AR_TIME_BOT_HIGH 
        CP     R21, R18
		CPC    R22, R19
        BRNE   NotDebounced      ;If the counter not reached minimum, do nothing
        ;BREQ  ARCounterReset    ;If counter reached minimum, reset for repeat 

ARCounterReset:

        LDI    R18, AR_TIME_TOP_LOW  ;Set counter to repeat top value
		LDI    R19, AT_TIME_TOP_HIGH

NotDebounced:

        STS    DebCounter, R18   ;Write debounce counter back to memory 
        RJMP   DebounceDone      ;Done running debouncer

LowByte0:

        TST    R19
		BRNE   RepeatMin         ;If counter not zero, then pattern not debounced 
		;BREQ  Debounced         ;Otherwise new pattern has debounced

Debounced:

        LDI    R16, 0x01
        STS    NewPattern, R16   ;Indicate new pattern is available
        STS    CurrPattern, R17  ;Update most recently debounced pattern
		STS    DebCounter,  R18  ;Update counter; begin autorepeat
		STS    DebCounter+1, R19
        RJMP   DebounceDone      ;Done running debouncer
        
ResetDebounce:
        
        STS   PressedPattern, R16 ;Store pressed pattern
		LDI   R17, DEBOUNCE_TIME_HIGH
        LDI   R16, DEBOUNCE_TIME_LOW
        STS   DebCounter, R16     ;Reset counter up to threshold
		STS   DebCounter+1,R17 
        ;RJMP DebounceDone        ;Done running debouncer 

DebounceDone:
       
        POP    R22                ;Restore touched registers
        POP    R21
        POP    R20
		POP    R19
		POP    R18
		POP    R17
		POP    R16
		POP    R15

        RET                       ;Done, so return


; SwitchAvailable
;
; Description:        This procedure determines whether or not a new debounced
;                     switch pattern is available.
; Operation:          If a new debounced pattern is available, then 
;                     the zero flag is reset, otherwise the zero flag is set
;
; Arguments:          None
; Return Value:       None
;
; Local Variables:    None
; Shared Variables:   NewPattern (Write only) - flag indicating a new debounced 
;                                               pattern
;
; Input:              None
; Ouput:              None
;
; Error Handling:     None
;
; Algorithms:         None
; Data Structures:    None
;
; Registers Changed:  R16
; 
; Author:             Edward Speer
; Last Modified:      5/5/23

SwitchAvailable:

        LDS    R16, NewPattern  ;Get the current value of NewPattern 
        TST    R16              ;Set Zero flag if no new pattern available

SwitchAvailDone:

        RET                     ;We are done, so return


; GetSwitches
;
; Description:        This procedure blocks until a new switch pattern is 
;                     avaliable, then returns the new switch pattern.
;                     GetSwitches contains critical code and must block
;                     interrupts, as a new pattern should not be debounced 
;                     before GetSwitches resets the NewPattern flag.
; Operation:          If a new debounced pattern is available, then 
;                     the zero flag is reset, otherwise the zero flag is reset
;
; Arguments:          None
; Return Value:       The debounced switch pattern in R16
;
; Local Variables:    None
; Shared Variables:   CurrPattern (Read only)- The current debounced switch 
;                     pattern
;
; Input:              None
; Ouput:              None
;
; Error Handling:     None
;
; Algorithms:         None
; Data Structures:    None
;
; Registers Changed:  R0, R16
; 
; Author:             Edward Speer
; Last Modified:      6/14/23

GetSwitches:

WaitSwitchLoop:

        RCALL    SwitchAvailable   ;Check if new debounced pattern is available
        BREQ     WaitSwitchLoop    ;Go back to top of function if no pattern 
        ;BRNE    NewSwitch         ;Otherwise, handle new switch available

NewSwitch:
        
        IN       R0, SREG          ;Save current interrupt flag status
        CLI                        ;Critical code so disable interrupts

        LDI      R16, 0x00
        STS      NewPattern, R16   ;Reset NewPattern to show no new pattern

        LDS      R16, CurrPattern  

        OUT      SREG, R0          ;Reset status register including interrupts

        RET                        ;New pattern returned in R16

; The data segment 

.dseg

; Shared switch pattern variables
NewPattern:     .BYTE    1    ;Flag indicating new debounced pattern available 
CurrPattern:    .BYTE    1    ;The most recently debounced switch pattern 
                             ;(bits 1-6)

; Local debouncing variables
PressedPattern: .BYTE    1    ;The pattern detected on Port E
DebCounter:     .BYTE    2    ;The number of clocks a pattern has been pressed
