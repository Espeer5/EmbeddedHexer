;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                                                            ;
;                                   LOOP.ASM                                 ;
;                                Game Main Loop                              ;
;                 Microprocessor-Based Hexer Game (AVR version)              ;
;                                                                            ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; This file contains the routine which is the main loop allowing the user to 
; play the microprocessor-based hexer game. This loop starts up the game, 
; takes in user input, and responds accordingly. There is also a function for 
; incrementing a 3 digit hex number by 1 to increment the user move number.
;
; Public Routines: PlayGame - Run the main loop of the game which accepts user 
;                             inputs, sets and resets the game conditions,
;                             triggers UI components (sound/display), and 
;                             checks win conditions
;                  IncMoveNum - Increments a decimal value stored as a 16 bit 
;                               hex number by 1 (i.e 0x09 -> 0x10)
;
; Revision History:
;     6/13/23   Edward Speer    Initial Revision
;     6/14/23   Edward Speer    Fix conflicts with functions changing registers
;     6/14/23   Edward Speer    Add game and win music 
;     6/15/23   Edward Speer    Hold on win until reset 
;     6/15/23   Edward Speer    Add display blinking on win
;     6/15/23   Edward Speer    Update comments 


.cseg

; PlayGame
;
; Description:        This procedure is the main loop for the hexer game. In 
;                     the loop, the user input is taken from the switches and 
;                     the game state updated, then the game state is displayed. 
;                     At the appropriate times, the speaker plays sounds.
;
; Operation:          The loop continually gets debounced user input from the
;                     switches, then alters the local versions of the game state 
;                     variables. These are then passed to the display. 
;                     After any move by the user, check if the game is won and 
;                     if so, inform the user of their score.
;
; Arguments:          None
; Return Value:       None
;
; Local Variables:    GameBoard - a 16 bit mask indicating for each LED if it is
;                                 on or off. The bits in the mask give the game
;                                 LEDs in the following order:
;                         [9, 1, 5, _, 10, 4, 3, 2, 13, 11, 8, 15, 14, 12, 7, 6]
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
; Registers Changed: ZL, ZH, R16, R17, R6, R7, R8, R9, R11, R12 
; 
; Author:             Edward Speer
; Last Modified:      6/15/23

PlayGame:

        RCALL  PlayStartupSound      ;Begin playing the game sound

RandomReset:

        RCALL  ClearDisplay      ;Ensure game board blank to begin with
		RCALL  StopBlink         ;And that board is not blinking
        RCALL  Random16No12      ;Generate a random game board in R9|R8
        LDI    ZL, LOW(GameBoard)
        LDI    ZH, HIGH(GameBoard)
        ST     Z+, R16           ;Store random game board to memory 
        ST     Z, R17
        CLR    R7 
        CLR    R6                ;Set R7|R6 to 0 to use as move number counter 

GameLoop:
        
        MOV    R16, R6
        MOV    R17, R7 
        RCALL  DisplayHex        ;Display number of moves made on 7 seg display
        PUSH   R6                ;Save user move number since registers changed 
        PUSH   R7                ; in other function calls 
        
        LDI    ZL, LOW(GameBoard)
        LDI    ZH, HIGH(GameBoard)
        LD     R16, Z+ 
        LD     R17, Z            ;Load current game board to R17|R16
        RCALL  DisplayGameLEDs   ;Display the current game board

        LDI    R18, WIN_BOARD_LOW
        LDI    R19, WIN_BOARD_HIGH
        CP     R18, R16          ;Compare gameboard with win condition
        BRNE   NextMove          ;If low bytes not equal, get next user move 
        ;BREQ  CheckWin          ;Otherwise check if user has won game 

CheckWin:

        CP     R19, R17 
        BREQ   GameWon           ;If GameBoard is winning board, respond to win
        ;BRNE  NextMove          ;Otherwise, get next user move

NextMove:
 
        RCALL  GetSwitches       ;Get next user switch pattern in R16 

CheckWhite:                      ;Check if white switch pressed 

        
		LDI    R17, WHITE_S
        CP     R16, R17
        BRNE   CheckBlack        ;If white not pressed, check black 
        ;BREQ  WhitePressed      ;Otherwise, respond to white switch 

WhitePressed:

       RCALL   MoveWhite        ;Invert white LEDs 
       RJMP    MoveMade         ;Move finished, go to increment move number 

CheckBlack:

        LDI    R17, BLACK_S
        CP     R16, R17
        BRNE   CheckBlue         ;if black not pressed, check blue 
        ;BREQ  BlackPressed      ;Otherwise respond to black switch

BlackPressed:

        RCALL  MoveBlack         ;Rotate black hexagon
        RJMP   MoveMade          ;Move finished, go to increment move number 

CheckBlue:

        LDI    R17, BLUE_S
        CP     R16, R17
        BRNE   CheckRed          ;if blue not pressed, check red  
        ;BREQ  BluePressed      ;Otherwise respond to blue switch

BluePressed:

        RCALL  MoveBlue          ;Rotate blue hexagon
        RJMP   MoveMade          ;Move finished, go to increment move number

CheckRed:

        LDI    R17, RED_S
        CP     R16, R17
        BRNE   CheckGreen        ;if red not pressed, check green 
        ;BREQ  RedPressed      ;Otherwise respond to red switch

RedPressed:

        RCALL  MoveRed           ;Rotate red triangle
        RJMP   MoveMade          ;Move finished, go to increment move number

CheckGreen:

        LDI    R17, GREEN_S
        CP     R16, R17
        BRNE   CheckRand         ;if green not pressed, check random reset  
        ;BREQ  GreenPressed      ;Otherwise respond to green switch

GreenPressed:

        RCALL  MoveGreen         ;Rotate green triangle
        RJMP   MoveMade          ;Move finished, go to increment move number

CheckRand:

        LDI    R17, RAND_S 
        CP     R16, R17
        BREQ   RandomReset        ;If random reset pressed, perform random reset
        ;BRNE   Check_R_0         ;if random reset not pressed check reset_0

Check_R_0:

        LDI    R17, RESET_0 
        CP     R16, R17 
        BRNE   Check_R_1         ;if reset_0 not pressed, check reset 1
        ;BREQ   DoReset_0           ;Otherwise perform reset_0 

DoReset_0:

        RCALL  MoveReset0
        POP    R7
        POP    R6                ;Clear former move number from stack 
        CLR    R7 
        CLR    R6                ;Reset move counter
        RJMP   GameLoop          ;Repeat game loop


Check_R_1:

        LDI    R17, RESET_1
        CP     R16, R17 
        BRNE   GameLoop          ;if reset_0 not pressed, no switches so restart
                                 ; loop 
        ;BREQ   DoReset_1        ;Otherwise perform reset_0

DoReset_1:

        RCALL  MoveReset1
        POP    R7
        POP    R6                ;Clear former move number from stack 
        CLR    R7 
        CLR    R6                ;Reset move counter
        RJMP   GameLoop          ;Repeat game loop

MoveMade:
        
		POP    R7                ;Restore user move counter
		POP    R6
        RCALL  IncMoveNum        ;Move made, so increment move counter 
        RJMP   GameLoop          ;After move, repeat game loop

GameWon:
        
        RCALL  PlayWinSound      ;Game won so play winning sound
		RCALL  StartBlink        ;And blink the display

WaitForReset:

        RCALL  GetSwitches       ;Wait for a switch press
		LDI    R17, RAND_S
		CP     R16, R17
		BRNE   WaitReset_0       ;If random reset not pressed, check manual
		RCALL  PlayStartupSound  ;Game restarted; play game music
		RJMP   RandomReset       ;Otherwise do random reset

WaitReset_0:

        LDI    R17, RESET_0
		CP     R16, R17
		BRNE   WaitForReset      ;If switch press not reset 0, wait for another switch
		;BREQ  Restar0           ;Otherwise, restart with shifted in 0
		RCALL  PlayStartupSound  ;Game restarted, play game music
		RCALL  MoveReset0        ;shift a 0 into the display
		RCALL  StopBlink         ;Game restarted so stop blinking

        RJMP   GameLoop          ;Initialize game with new config


;IncMoveNum
;
; Description:        This procedure increments a 4 digit decimal number stored 
;                     in hex by 1.
;
; Operation:          Look at each digit in reverse order of significance until
;                     least significant digit which is not a 9 is found, then
;                     increments that digit and sets all previous digits to 0.
;
; Arguments:          16 bits of decimal number stored as hex in R7|R6
; Return Value:       16 bit incremented decimal number as hex in R7|R6
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
; Registers Changed: R6, R7, R16, R17
; 
; Author:             Edward Speer
; Last Modified:      6/13/23

IncMoveNum:

        MOV    R16, R6
        LDI    R17, LOW_DIGIT
        AND    R16, R17          ;Get the ones place digit from the number 
        LDI    R17, HEX_09       
        CP     R16, R17
        BRNE   IncOnes           ;If ones place not 9, increment ones place 
        ;BREQ  CheckTens         ;Otherwise, check the tens place

CheckTens:
        
        MOV    R16, R6 
        LDI    R17, HIGH_DIGIT
        AND    R6, R17           ;Ones place was 9, so set one's place to 0
        AND    R16, R17          ;Get the tens place digit from the number
        LDI    R17, HEX_90 
        CP     R16, R17
        BRNE   IncTens           ;If the tens place not 9, increment tens place
        ;BREQ  CheckHunds        ;Otherwise check hundreds place 

CheckHunds:

        MOV    R16, R7
        LDI    R17, LOW_DIGIT 
        AND    R6, R17           ;Tens place was 9, so set tens to 0 
        AND    R16, R17          ;Get hundreds place from number 
        LDI    R17, HEX_09       
        CP     R16, R17 
        BRNE   IncHunds          ;If hundreds place not 9, then increment it 
        ;BREQ  CheckThous        ;Otherwsise, check thousands place 

CheckThousands:

        MOV    R16, R7 
        LDI    R17, HIGH_DIGIT 
        AND    R7, R17           ;Thousands place was 9, so set it to 0 
        AND    R16, R17          ;Get thousands digit from number 
        LDI    R17, HEX_90 
        CP     R16, R17 
        BRNE   IncThous          ;If thousands place not 9, then increment it 
        ;BREQ  ClearAll          ;If overflowed 4 digit decimal, reset to 0 

ClearAll:

        CLR    R7                ;Ones, tens, hundreds already 0, clear thousands 
        RJMP   Incremented       ;And done

IncOnes:

        LDI    R17, HEX_01 
        ADD    R6, R17           ;Add 1 to the ones place 
        RJMP  Incremented        ;And done 

IncTens: 

        LDI    R17, HEX_10 
        ADD    R6, R17           ;Add 1 to tens place       
        RJMP   Incremented       ;And done

IncHunds:

        LDI    R17, HEX_01 
        ADD    R7, R17           ;Add 1 to hundreds place 
        RJMP   Incremented       ;And done 

IncThous:

        LDI    R17, HEX_10
        ADD    R7, R17           ;Add 1 to thousands place 
        RJMP   Incremented       ;And return 

Incremented:

        RET                      ;Done incrementing, so return
