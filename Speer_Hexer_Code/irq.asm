;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                                                            ;
;                                   IRQ.ASM                                  ;
;                               Interrupt Code                               ;
;                 Microprocessor-Based Hexer Game (AVR version)              ;
;                                                                            ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; This file contains the timer generated interrupt event handler for the
; Microprocessor-based hex game. The event handler handles both the display 
; multiplexing as well as the switch debouncing for the Hexer game. 
;
; Revision History:
;     6/13/23   Edward Speer    Initial Revision
;     6/13/23   Edward Speer    Add sound to interrupt handling 
;     6/14/23   Edward Speer    Debug register usage in interrupts
;     6/15/23   Edward Speer    Update comments

.cseg

; HexerTimerInterrupt
;
; Description:        This procedure is an event handler for the timer interrupt 
;                     used to display Hexer game data on the 2 game board
;                     displays, to debounce the switch presses input by the 
;                     user, and to play game sounds on the speaker
;
; Operation:          Upon each milisecond clock interrupt, this handler is 
;                     called, and it makes subsequent calls to the routines
;                     which are intended to be called per milisecond for the 
;                     switch, sound, and display code.
;
; Arguments:          None
; Return Value:       None
;
; Local Variables:    None
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
; Registers Changed: None
; 
; Author:             Edward Speer
; Last Modified:      6/14/23

HexerTimerInterrupt:

        PUSH   R20              ;Save touched registers 
        IN     R20, SREG        ;And the status register
        PUSH   R20 

        RCALL  DebounceSwitch   ;Debounce user switch presses 
        RCALL  DisplayInterrupt ;Display current data on LEDs/Display 
        RCALL  SoundInterrupt   ;Play current sounds on speaker

        POP    R20
        OUT    SREG, R20        ;Restore status register 
        POP    R20              ;And restore touched registers 
       
        RETI                    ;And done, so return
