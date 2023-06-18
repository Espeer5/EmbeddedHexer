;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                                                            ;
;                                HARDWARE_INIT                               ;
;                      Hardware Initialization Functions                     ;
;                       Microprocessor-Based Hexer Game                      ;
;                                                                            ;
;                                                                            ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; This file contains the hardware initialization function for the I/O port 
; and timer used in switch debouncing for the Microprocessor-Based Hexer Game.
;
; Public Routines: InitSwitchIO - Intializes Port D for switch input 
;                  LEDBoardInit - Initializes ports C and D for LED muxing 
;                  InitMsTimer  - Initializes timer0 to provide 1 ms timer 
;                                 interrupts to the system
;                  SpeakerIoInit- Intializes portB to ouput to speaker
;
; Revision History:
;     5/4/23    Edward Speer    Initial revision 
;     5/4/23    Edward Speer    Comments updated
;     5/19/23   Edward Speer    Add IO setup for display code
;     5/20/23   Edward Speer    Update comments
;     6/3/23    Edward Speer    Add speaker initialization 
;     6/3/23    Edward Speer    Debug speaker control settings 
;     6/15/23   Edward Speer    Finalize comments

.cseg 


; InitSwitchIO 
;
; Description:        This procedure initializes the IO Port used to read 
;                     the value of the switches
; Operation:          The IO mode for PortE is initialized to input mode  
;                     by writing to the port direction register
;
; Arguments:          None
; Return Value:       None
;
; Local Variables:    None
; Shared Varibales:   None
;
; Input:              None
; Ouput:              Output switch direction to switch direction register
;
; Error Handling:     None
;
; Algorithms:         None
; Data Structures:    None
;
; Registers Changed: R16
; 
; Author:             Edward Speer
; Last Modified:      6/14/23

InitSwitchIo:

        LDI    R16, READ 
        OUT    DDRE, R16     ;Instruct PortE to be used as an input

        RET                  ;Done, so return


; LEDBoardInit
;
; Description:        This procedure initializes the I/O ports needed to display 
;                     data on the 7 segment display and the 15 LED display in 
;                     the Hexer game. Also initializes all LED's to off
;
; Operation:          Sets ports C and D as outputs by setting the port 
;                     direction registers, then turns off LEDs by setting port D 
;                     to the state of all LED's off
;
; Arguments:          None
; Return Value:       None
;
; Local Variables:    None
; Shared Variables:   None
;
; Input:              None
; Ouput:              Outputs port directions to the port direction registers 
;                     for port C and port D
;
; Error Handling:     None
;
; Algorithms:         None
; Data Structures:    None
;
; Registers Changed: R16
; 
; Author:             Edward Speer
; Last Modified:      6/14/23

LEDBoardInit:
        
        LDI    R16, OUTP
        OUT    DDRC, R16     ;Set direction register for port C to output
        OUT    DDRD, R16     ;Set direction register for port D to output

        LDI    R16, LEDSOFF  ;Turn off LEDS by disabling voltage across all LEDS
        OUT    DIGIT_PORT, R16

        RET                  ;Done, so return


; InitMsTimer
;
; Description:        This procedure initializes timer 2 to provide a 1 ms timer 
;                     for the system, generating interrupts each milisecond 
; Operation:          The timer mode for 8 bit timer is initialized, prescaled   
;                     to CLK/32, and the timer interrupts setup for generating 
;                     1 ms interrupts
;
; Arguments:          None
; Return Value:       None
;
; Local Variables:    None
; Shared Varibales:   None
;
; Input:              None
; Ouput:              Timer settings output to timer control register
;                     TIMSK register edited to allow timer interrupts Output 
;                     Compare register set for 1 ms timer
;
; Error Handling:     None
;
; Algorithms:         None
; Data Structures:    None
;
; Registers Changed: R16
; 
; Author:             Edward Speer
; Last Modified:      6/15/23

InitMsTimer:

        LDI    R16, TIMERCLK32
        OUT    TCCR0, R16       ;Set timer controls

SetOutputComp:

        LDI    R16, OUTC 
        OUT    OCR0, R16       ;Set output control register

EnableTimerInt:

        LDI    R16, TIMSKEN
        IN     R17, TIMSK 
        OR     R16, R17         ;Change only the timer0 interrupt bit in TIMSK
        OUT    TIMSK, R16       ;Enable timer interrupts

        RET                     ;Done, so return


; SpeakerIOInit
;
; Description:        This procedure initializes the I/O ports needed to produce
;                     tones on the speaker.
;
; Operation:          Sets the data direction register for the speaker port 
;                     (Port OC1A)
;
; Arguments:          None
; Return Value:       None
;
; Local Variables:    None
; Shared Variables:   None
;
; Input:              None
; Ouput:              Outputs port direction to OC1A 
;
; Error Handling:     None
;
; Algorithms:         None
; Data Structures:    None
;
; Registers Changed: None
; 
; Author:             Edward Speer
; Last Modified:      6/3/23

SpeakerIOInit:

      LDI    R16, OUTP
      OUT    DDRB, R16    ;Set data direction register for speaker to output

      RET