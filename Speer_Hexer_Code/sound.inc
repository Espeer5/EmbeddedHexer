;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                                                            ;
;                                 SPEAKER.INC                                ;
;                             Speaker Definitions                            ;
;                       Microprocessor-Based Hexer Game                      ;
;                                                                            ;
;                                                                            ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; This file contains the definitions needed for to play the game sounds for the 
; Hexer game, including the startup sound for the game and the win sound for the
; game.
;
; Revision History:
;     6/13/23   Edward Speer    Initial Revision
;     6/14/23   Edward Speer    Edit constants for longer music


;MusicTable constants

.EQU EIGHTH_TIME   = 254        ;Number of miliseconds per eighth note 

.EQU START_OFFS    = 0          ;Offset to start sound in music table 
.EQU WIN_OFFS      = 162        ;Offset to win sound in music table (in bytes)
.EQU STARTUP_NOTES = 81         ;Number of notes in the startup sound 
.EQU WIN_NOTES     = 34         ;Number of notes in the win sound
