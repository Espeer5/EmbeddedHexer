;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                                                            ;
;                                  HEXER.ASM                                 ;
;                            Main Method Game Code                           ;
;                                  EE/CS 10b                                 ;
;                                                                            ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; This program sets up the interrupt table for the system, calls all hardward 
; and variables initialization, and then starts up the game loop for the 
; Microprocessor-based Hexer game
;
; Public Routines - None
;
;
; Revision History:
;    5/20/23   Edward Speer        initial revision
;    6/3/23    Edward Speer        Update for speaker code
;    6/13/23   Edward Speer        Update for game main code
;    6/16/23   Edward Speer        Finalize comments

;set the device
.device	ATMEGA64

;get the definitions for the device
.include  "m64def.inc"

;include all the .inc files since all .asm files are needed here (no linker)
.include  "swtch.inc"
.include  "disp.inc"
.include  "hexer.inc"
.include  "speaker.inc"
.include  "sound.inc"
.include  "moves.inc"

.cseg

;setup the vector area

.org	$0000

	JMP	Start			;reset vector
	JMP	PC			;external interrupt 0
	JMP	PC			;external interrupt 1
	JMP	PC			;external interrupt 2
	JMP	PC			;external interrupt 3
	JMP	PC			;external interrupt 4
	JMP	PC			;external interrupt 5
	JMP	PC			;external interrupt 6
	JMP	PC			;external interrupt 7
	JMP	PC			;timer 2 compare match
	JMP	PC			;timer 2 overflow
	JMP	PC			;timer 1 capture
	JMP	PC			;timer 1 compare match A
	JMP	PC			;timer 1 compare match B
	JMP	PC			;timer 1 overflow
	JMP	HexerTimerInterrupt          ;timer 0 compare match (1 ms)
	JMP	PC		    ;timer 0 overflow
	JMP	PC			;SPI transfer complete
	JMP	PC			;UART 0 Rx complete
	JMP	PC			;UART 0 Tx empty
	JMP	PC			;UART 0 Tx complete
	JMP	PC			;ADC conversion complete
	JMP	PC			;EEPROM ready
	JMP	PC			;analog comparator
	JMP	PC			;timer 1 compare match C
	JMP	PC			;timer 3 capture
	JMP	PC     			;timer 3 compare match A
	JMP	PC			;timer 3 compare match B
	JMP	PC			;timer 3 compare match C
	JMP	PC			;timer 3 overflow
	JMP	PC			;UART 1 Rx complete
	JMP	PC			;UART 1 Tx empty
	JMP	PC			;UART 1 Tx complete
	JMP	PC			;Two-wire serial interface
	JMP	PC			;store program memory ready


; start of the actual program


Start:					         ;start the CPU after a reset
	LDI	R16, LOW(TopOfStack)	 ;initialize the stack pointer
	OUT	SPL, R16
	LDI	R16, HIGH(TopOfStack)
	OUT	SPH, R16


	;initialization of the system
	;initialize I/O ports and timer
    ;Initialize variables for system

    RCALL InitSwitchIO          ;Initialize switch IO port as input
    RCALL InitMsTimer           ;Generate timer interrupts every milisecond
    RCALL SpeakerIOInit         ;Set speaker IO port to output
    RCALL InitSpeaker           ;Initialize speaker off
	RCALL InitSoundVars         ;Initialize sound playing variables
	RCALL LEDBoardInit          ;Initialize display ports as outputs
	RCALL InitSwitchVars        ;Initialize switch debugging variables
	SEI				            ;ready to go, allow interrupts

    RCALL SpeakerSD Test              ;Run the homework 4 test code

	RJMP	Start			    ;shouldn't return, but if it does, restart

;the data segment

.dseg

; the stack - 128 bytes
		.BYTE	127
TopOfStack:	.BYTE	1		     ;top of the stack

;Current game board

GameBoard:  .BYTE   2            ;The current game board given in order: 
                         ;[9, 1, 5, _, 10, 4, 3, 2, 13, 11, 8, 15, 14, 12, 7, 6]




; since don't have a linker, include all the .asm files
;.include "file.asm"

.include "hardware_init.asm"     ;IO/Timer setup routines
.include "speaker.asm"           ;Speaker routines
.include "utils.asm"             ;General utility functions
.include "sound.asm"             ;Sound playing routines
.include "irq.asm"               ;Timer0 interrupt handler
.include "disp.asm"              ;Display functions
.include "segtable.asm"          ;Segment definitions for 7 seg display 
.include "loop.asm"              ;Game main loop 
.include "switches.asm"          ;Switch debouncing functions
.include "moves.asm"             ;Functions enabling users to make moves