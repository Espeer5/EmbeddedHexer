;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                                                            ;
;                                 SOUND.ASM                                  ;
;                              Sound Functions                               ;
;                       Microprocessor-Based Hexer Game                      ;
;                                                                            ;
;                                                                            ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; This file contains the routines which play the game sound effects for the Hexer 
; game. Sounds are played by sending the correct frequencies to the speaker 
; on the board via the PlayNote routine in speaker.asm.
;
; Public Routines: InitSoundVars - Initializes the variables needed to play music 
;                  SoundInterrupt- Uses a counter during each interrupt to change
;                                  notes every 8th note interval
;                  PlayStartupSound - Causes the board to play the game music
;                  PlayWinSound  - Causes the  board to play the win music 
;
; Revision History:
;     6/13/23   Edward Speer    Initial Revision
;     6/13/23   Edward Speer    Add forgotten data segment
;     6/13/23   Edward Speer    Address critical code
;     6/14/23   Edward Speer    Cause music to play continuously
;     6/15/23   Edward Speer    Update comments

.cseg


;InitSoundVars
;
; Description:        This procedure initializes the variables needed to play 
;                     the game sounds (startup and win sounds) for the hexer
;                     game.
;
; Operation:          Sets the number of notes to currently be played at 0, the 
;                     current offset in the MusicTable to 0, and the eighth note 
;                     counter to 0 so that the first note will be played right 
;                     away when a sound is played
;
; Arguments:          None
; Return Value:       None
;
; Local Variables:    None 
;
; Shared Variables:   NoteCounter (W) - a counter which upon reaching zero indicates
;                                   an eighth note of time has elapsed
;                     NotesToPlay (W) - a counter giving the number of notes which 
;                                   need to be played to complete the sound
;                     MusicOffset (W) - the offset to the sound currently being 
;                                   played in the music table
;
; Input:              None
; Ouput:              None
;
; Error Handling:     None
;
; Algorithms:         None
; Data Structures:    None
;
; Registers Changed: R16
; 
; Author:             Edward Speer
; Last Modified:      6/13/23

InitSoundVars:

        LDI   R16, 0
        STS   NoteCounter, R16    ;Note timing = 0 to play note right away 
        STS   NotesToPlay, R16    ;Currently no notes to be played 
        STS   MusicOffset, R16    ;Nothing to lookup in MusicTable

        RET                       ;All variables set so return


;SoundInterrupt
;
; Description:        This procedure is intended to be called at each milisecond 
;                     generated timer interrupt to play the sounds currently 
;                     required by the system. Plays no sound when game not 
;                     actively playing any music.
;
; Operation:          Checks the number of notes enqueued to be played for the
;                     sound being played by the system. If zero, plays nothing 
;                     on the speaker, if non-zero, plays the frequencies 
;                     designated in the music table at the rate of one frequency 
;                     per an eighth note for a rate of 120 bpm.
;
; Arguments:          None
; Return Value:       None
;
; Local Variables:    None 
;
; Shared Variables:   NoteCounter - (R/W) a counter which upon reaching zero indicates
;                                   an eighth note of time has elapsed
;                     NotesToPlay - (R/W) a counter giving the number of notes which 
;                                   need to be played to complete the sound
;                     MusicOffset - (R/W) the offset to the sound currently being 
;                                   played in the music table
;
; Input:              None
; Ouput:              None
;
; Error Handling:     None
;
; Algorithms:         None
; Data Structures:    None
;
; Registers Changed:  None
; 
; Author:             Edward Speer
; Last Modified:      6/13/23

SoundInterrupt:

        PUSH   R12
		PUSH   R13
        PUSH   R15                 ;Save touched registers since called from
		PUSH   R16                 ; an interrupt handler, including those 
		PUSH   R17                 ; changed in PlayNote
		PUSH   R18
        PUSH   R19
		PUSH   R20
		PUSH   R21
		PUSH   R22
		PUSH   R23
		PUSH   R24                
        PUSH   ZL
        PUSH   ZH 

        LDS    R15, NotesToPlay 
        TST    R15
        BRNE   PlaySound            ;Otherwise play the necessary sound
		;BREQ   RepeatSound          ;if at end of music, repeat music

RepeatSound:

        LDS    R15, NotesInSound
		STS    NotesToPlay, R15      ;Reset the number of notes to the total 
		LDS    R19, OffsetToSound
		STS    MusicOffset, R19      ;and the offset to the start of the sound


PlaySound:

        LDS    R19, NoteCounter
        TST    R19 
        BRNE   Update8thCounter     ;If noteCounter not 0, still playing last note 
        ;BREQ  NextNote

NextNote:
    
        LDI    ZL, LOW(MusicTable << 1)   ;Get address of music table, shifted
        LDI    ZH, HIGH(MusicTable << 1)  ; for byte addressing 
        LDS    R13, MusicOffset           ;Get offset to next frequency to play in entries
        CLR    R12                        ;Use R12 for carry propogation 
        ADD    ZL, R13                    
        ADC    ZH, R12                    ;Move to next sound in MusicTable 
        LPM    R16, Z+
        LPM    R17, Z+                    ;Get next frequency in R17|R16 

		PUSH   R15                        ;Push registers changed in PlayNote

        RCALL  PlayNote                   ;And play it
		
		POP    R15                        ;Restore registers changed in PlayNote
		 
        INC    R13
		INC    R13                        ;Advance 2 bytes in the music table 
        STS    MusicOffset, R13           ;Set table offset to the next note
        DEC    R15
        STS    NotesToPlay, R15           ;One less note remaining to be played
        LDI    R19, (EIGHTH_TIME + 1)     ;Reset eighth note counter, +1 since about to dec

Update8thCounter:

        DEC    R19                        ;Count down miliseconds until next eighth note 
        STS    NoteCounter, R19           ;Update eighth note Timing counter 

SoundPlayed:

        POP    ZH                        ;Restore touched registers since called from 
        POP    ZL                        ; an interrupt handler
        POP    R24
        POP    R23 
        POP    R22 
        POP    R21
        POP    R20 
        POP    R19
		POP    R18
		POP    R17
		POP    R16
		POP    R15
		POP    R13
		POP    R12

        RET                               ;Correct sound played so return


;PlayStartupSound
;
; Description:        This procedure sets the shared sound variables so that 
;                     when caleld the sound interrupt routine will play the 
;                     startup sound for the Hexer game. Contains critical code 
;                     since the sound variables are edited and accessed in the 
;                     sound interrupt code.
;
; Operation:          Sets the Offset in the MusicTable to the begninning of the 
;                     startup sound, the number of notes to play to the number of 
;                     notes in the startup sound, and the eighth note timer
;                     counter to 0 to play the next note right away.
;
; Arguments:          None
; Return Value:       None
;
; Local Variables:    None 
;
; Shared Variables:   NoteCounter - (W) a counter which upon reaching zero indicates
;                                   an eighth note of time has elapsed
;                     NotesToPlay - (W) a counter giving the number of notes which 
;                                   need to be played to complete the sound
;                     MusicOffset - (W) the offset to the sound currently being 
;                                   played in the music table
;
; Input:              None
; Ouput:              None
;
; Error Handling:     None
;
; Algorithms:         None
; Data Structures:    None
;
; Registers Changed: R16
; 
; Author:             Edward Speer
; Last Modified:      6/13/23

PlayStartupSound:

        LDI    R16, START_OFFS
        IN     R0, SREG                ;Save current interrupt flag 
        CLI                            ;Critical code so disable interrupts
        STS    OffsetToSound, R16        ;Offset to startup sound in music table 

        LDI    R16, STARTUP_NOTES
        STS    NotesInSound, R16        ;Number of notes to play for startup
		
		LDI    R16, 0
		STS    NotesToPlay, R16        ;Stop current sound from playing 

        LDI    R16, 0                  ;Number of 8th notes to wait before next
        STS    EIGHTH_TIME, R16        ; note played

        OUT    SREG, R0                ;Restore status register including iterrupts 
        RET                            ;Done, so return 


;PlayWinSound
;
; Description:        This procedure sets the shared sound variables so that 
;                     when called the sound interrupt routine will play the 
;                     win sound for the Hexer game. Contains critical code 
;                     since the sound variables are edited and accessed in the 
;                     sound interrupt code.
;
; Operation:          Sets the Offset in the MusicTable to the beginning of the 
;                     win sound, the number of notes to play to the number of 
;                     notes in the win sound, and the eighth note timer
;                     counter to 0 to play the next note right away.
;
; Arguments:          None
; Return Value:       None
;
; Local Variables:    None 
;
; Shared Variables:   NoteCounter - (W) a counter which upon reaching zero indicates
;                                   an eighth note of time has elapsed
;                     NotesToPlay - (W) a counter giving the number of notes which 
;                                   need to be played to complete the sound
;                     MusicOffset - (W) the offset to the sound currently being 
;                                   played in the music table
;
; Input:              None
; Ouput:              None
;
; Error Handling:     None
;
; Algorithms:         None
; Data Structures:    None
;
; Registers Changed: R16
; 
; Author:             Edward Speer
; Last Modified:      6/13/23

PlayWinSound:

        LDI    R16, WIN_OFFS
        IN     R0, SREG                ;Save current interrupt flag 
        CLI                            ;Critical code so disable interrupts
        STS    OffsetToSound, R16      ;Offset to startup sound in music table 

        LDI    R16, WIN_NOTES
        STS    NotesInSound, R16       ;Number of notes to play for Winning sound

		LDI    R16, 0
		STS    NotesToPlay, R16        ;Stop current sound from playing

        LDI    R16, 0                  ;Number of 8th notes to wait before next
        STS    EIGHTH_TIME, R16        ; note played

        OUT    SREG, R0                ;Restore status register including iterrupts 
        RET                            ;Done, so return 


MusicTable:  ;Gives frequencies of eighth notes in game sounds. Each game sound 
             ; must end with a 0 to turn the speaker off after playing

        ;DW   ;Frequencies to play sound in order 

        .DW    880, 880, 1319, 1568, 1568, 1480, 1175, 988, 1319, 1760, 1760, 0
        .DW    1760, 1760, 2217, 2217, 2217, 2217, 0, 0, 1047, 1047, 1865, 1865, 1865, 1760, 1568 
		.DW    1397, 1319, 1245, 1245, 1245, 1245, 0, 0, 1047, 1047, 2093, 2093, 2093, 1865, 1760, 1568 
		.DW    1397, 1319, 1319, 1319, 1319, 0, 0, 1245, 1175, 1175, 1319, 1480, 1568, 1760
		.DW    1976, 2093, 2349, 2349, 2489, 2498, 0, 0, 1245, 1245, 1245, 1245, 1397, 1568
		.DW    1661, 1865, 2093, 2217, 2489, 2489, 2637, 2637, 0, 0
        .DW    392, 523, 659, 784, 1047, 1319, 1568, 1568, 1319, 0
        .DW    415, 523, 622, 831, 1047, 1245, 1661, 1661, 1245, 0
        .DW    466, 587, 698, 923, 1175, 1397, 1865, 1865, 0, 1865, 0, 1865
        .DW    2093, 0

;The data segment 

.dseg

NoteCounter:    .BYTE    1    ;Eighth note timing counter
NotesToPlay:    .BYTE    1    ;The number of notes to be played in current sound
MusicOffset:    .BYTE    1    ;Offset to current sound in the music table
NotesInSound:   .BYTE    1    ;Total number of notes in sound being played 
OffsetToSound:  .BYTE    1    ;Offset to the beginning of the current sound
