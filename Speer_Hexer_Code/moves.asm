;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                                                            ;
;                                  MOVES.ASM                                 ;
;                              User Move Functions                           ;
;                       Microprocessor-Based Hexer Game                      ;
;                                                                            ;
;                                                                            ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; This file contains the functions necessary to change game data based on the 
; user input of a game move via the switches on the hexer board. This consists 
; mainly of the functions needed to shift, invert, or swap the LEDs in the game 
; board.
;
; Public Routines: MoveWhite - Performs the move corresponding to a white switch
;                  MoveBlack - Performs the move corresponding to a black switch 
;                  MoveBlue  - Performs the move corresponding to a blue switch 
;                  MoveGreen - Performs the move corresponding to a green switch
;                  MoveRed   - Performs the move corresponding to a red switch 
;                  MoveReset0 - Shifts a 0 into the LEDs as a shift register 
;                  MoveReset1 - Shifts a 1 intot he LEDs as a shift register
; Private Routines: SetBitEq - Sets one bit equal to another bit from 16 bits
;                   SetBit   - Sets a bit equal to a passed constant in 16 bits
;                   GetBit   - Gets the value of a certain bit from 15 bits
;
; Revision History:
;     6/12/23   Edward Speer    Initial Revision
;     6/13/23   Edward Speer    Fix GameBoard addressing issue
;     6/13/23   Edward Speer    Add manual reset 0 and 1 shifts
;     6/15/23   Edward Speer    Fix label problem with SetBit
;     6/16/23   Edward Speer    Update comments 

.cseg

; MoveWhite
;
; Description:        This procedure inverts the LEDS in the white inner hexagon 
;                     on the game board.
;
; Operation:          XOR's the LEDs of the white inner game board with 1's 
;                     to invert their values.
;
; Arguments:          None
; Return Value:       None
;
; Local Variables:    None
; Shared Variables:   GameBoard - the current GameBoard given as the status of 
;                     the 16 game LEDs, with 1's indicating LED on, and 0's 
;                     indicating LEDs off. 
;
; Input:              None
; Ouput:              None
;
; Error Handling:     None
;
; Algorithms:         None
; Data Structures:    None
;
; Registers Changed: R16, R17, R18, R19, YL, YH
; :        0 bytes
; 
; Author:             Edward Speer
; Last Modified:      6/12/23

MoveWhite:

        LDI    R16, WHITE_ON_LOW
        LDI    R17, WHITE_ON_HIGH          ;Get the mask for the white hexagon in LEDs

        LDI    YL, LOW(GameBoard)
        LDI    YH, HIGH(GameBoard)         ;Get the data address to the GameBoard 

        LD     R18, Y+
        LD     R19, Y                      ;Get the current Gameboard 

        EOR    R16, R18 
        EOR    R17, R19                    ;Invert the bits in the white hexagon

        ST     Y, R17
        ST     -Y, R16                     ;Store back the inverted Game Board 

        RET                                ;And done so return


; MoveBlue
;
; Description:        This procedure rotates the LEDs in the blue hexagon in the 
;                     game board clockwise 
;
; Operation:          Swaps the positions of the bits in the black hexagon until 
;                     all LEDs have been rotated one position clockwise
;
; Arguments:          None
; Return Value:       None
;
; Local Variables:    None
; Shared Variables:   GameBoard - the current GameBoard given as the status of 
;                     the 16 game LEDs, with 1's indicating LED on, and 0's 
;                     indicating LEDs off. 
;
; Input:              None
; Ouput:              None
;
; Error Handling:     None
;
; Algorithms:         None
; Data Structures:    None
;
; Registers Changed: R16, R17, R25
;
; Author:             Edward Speer
; Last Modified:      6/12/23

MoveBlue:
    
        LDI    R16, LED_5 
        RCALL  GetI           ;Get the state of LED_5 in R25
		PUSH   R25            ;And save it 

        LDI    R16, LED_5 
        LDI    R17, LED_4
        RCALL  SetBitEq       ;LED5 = LED4

        LDI    R16, LED_4 
        LDI    R17, LED_8
        RCALL  SetBitEq       ;LED4 = LED8

        LDI    R16, LED_8 
        LDI    R17, LED_13
        RCALL  SetBitEq       ;LED8 = LED13

        LDI    R16, LED_13 
        LDI    R17, LED_14
        RCALL  SetBitEq       ;LED13 = LED14 

        LDI    R16, LED_14 
        LDI    R17, LED_10
        RCALL  SetBitEq       ;LED14 = LED10 

        POP    R25            ;Restore the saved LED in R25
        LDI    R16, LED_10
        RCALL  SetBit         ;LED10 = R25 (Stored former value of LED5)

        RET                   ;And done



; MoveBlack
;
; Description:        This procedure rotates the LEDs in the black hexagon in the 
;                     game board counter-clockwise
;
; Operation:          Swaps the positions of the bits in the blue hexagon until 
;                     all LEDs have been rotated one position counter-clockwise
;
; Arguments:          None
; Return Value:       None
;
; Local Variables:    None
; Shared Variables:   GameBoard - the current GameBoard given as the status of 
;                     the 16 game LEDs, with 1's indicating LED on, and 0's 
;                     indicating LEDs off. 
;
; Input:              None
; Ouput:              None
;
; Error Handling:     None
;
; Algorithms:         None
; Data Structures:    None
;
; Registers Changed: R16, R17, R25
;
; Author:             Edward Speer
; Last Modified:      6/12/23

MoveBlack:

        LDI    R16, LED_2 
        RCALL  GetI           ;Get the state of LED_2 in R25
		PUSH   R25            ;and save it

        LDI    R16, LED_2 
        LDI    R17, LED_3
        RCALL  SetBitEq       ;LED2 = LED3 

        LDI    R16, LED_3 
        LDI    R17, LED_8
        RCALL  SetBitEq       ;LED3 = LED8 

        LDI    R16, LED_8 
        LDI    R17, LED_12
        RCALL  SetBitEq       ;LED8 = LED12

        LDI    R16, LED_12 
        LDI    R17, LED_11
        RCALL  SetBitEq       ;LED12 = LED11 

        LDI    R16, LED_11 
        LDI    R17, LED_6
        RCALL  SetBitEq       ;LED11 = LED6 

        POP    R25            ;Restore saved LED in R25
        LDI    R16, LED_6
        RCALL  SetBit         ;LED6 = R25 (Stored former value of LED2)

        RET                   ;And done


; MoveRed
;
; Description:        This procedure rotates the LEDs in the red triangle in the 
;                     game board clockwise
;
; Operation:          Swaps the positions of the bits in the red triangle until 
;                     all LEDs have been rotated one position clockwise
;
; Arguments:          None
; Return Value:       None
;
; Local Variables:    None
; Shared Variables:   GameBoard - the current GameBoard given as the status of 
;                     the 16 game LEDs, with 1's indicating LED on, and 0's 
;                     indicating LEDs off. 
;
; Input:              None
; Ouput:              None
;
; Error Handling:     None
;
; Algorithms:         None
; Data Structures:    None
;
; Registers Changed: R16, R17, R25 
;
; Author:             Edward Speer
; Last Modified:      6/12/23

MoveRed:

        LDI    R16, LED_1 
        RCALL  GetI           ;Get the state of LED_1 in R25
		PUSH   R25            ;And save it

        LDI    R16, LED_1 
        LDI    R17, LED_3
        RCALL  SetBitEq       ;LED1 = LED3 

        LDI    R16, LED_3 
        LDI    R17, LED_7
        RCALL  SetBitEq       ;LED3 = LED7 

        LDI    R16, LED_7 
        LDI    R17, LED_11
        RCALL  SetBitEq       ;LED7 = LED11 

        LDI    R16, LED_11 
        LDI    R17, LED_12
        RCALL  SetBitEq       ;LED11 = LED12 

        LDI    R16, LED_12 
        LDI    R17, LED_13
        RCALL  SetBitEq       ;LED12 = LED13 

        LDI    R16, LED_13 
        LDI    R17, LED_14
        RCALL  SetBitEq       ;LED13 = LED14 

        LDI    R16, LED_14 
        LDI    R17, LED_9
        RCALL  SetBitEq       ;LED14 = LED9 

        LDI    R16, LED_9 
        LDI    R17, LED_4
        RCALL  SetBitEq       ;LED9 = LED4 

        POP    R25            ;Restore the saved LED in R25
		LDI    R16, LED_4
        RCALL  SetBit         ;LED4 = R25 (Stored former value of LED1)

        RET                   ;And done


; MoveGreen
;
; Description:        This procedure rotates the LEDs in the green triangle in the 
;                     game board counter-clockwise
;
; Operation:          Swaps the positions of the bits in the green triangle until 
;                     all LEDs have been rotated one position counter-clockwise
;
; Arguments:          None
; Return Value:       None
;
; Local Variables:    None
; Shared Variables:   GameBoard - the current GameBoard given as the status of 
;                     the 16 game LEDs, with 1's indicating LED on, and 0's 
;                     indicating LEDs off. 
;
; Input:              None
; Ouput:              None
;
; Error Handling:     None
;
; Algorithms:         None
; Data Structures:    None
;
; Registers Changed: R16, R17, R25 
;
; Author:             Edward Speer
; Last Modified:      6/12/23

MoveGreen:

        LDI    R16, LED_15 
        RCALL  GetI           ;Get the state of LED_15 in R25
		PUSH   R25            ;And save it

        LDI    R16, LED_15 
        LDI    R17, LED_12
        RCALL  SetBitEq       ;LED15 = LED12 

        LDI    R16, LED_12 
        LDI    R17, LED_7
        RCALL  SetBitEq       ;LED12 = LED7 

        LDI    R16, LED_7 
        LDI    R17, LED_2
        RCALL  SetBitEq       ;LED7 = LED2 

        LDI    R16, LED_2 
        LDI    R17, LED_3
        RCALL  SetBitEq       ;LED2 = LED3 

        LDI    R16, LED_3 
        LDI    R17, LED_4
        RCALL  SetBitEq       ;LED3 = LED4 

        LDI    R16, LED_4 
        LDI    R17, LED_5
        RCALL  SetBitEq       ;LED4 = LED5 

        LDI    R16, LED_5 
        LDI    R17, LED_9
        RCALL  SetBitEq       ;LED5 = LED9 

        LDI    R16, LED_9 
        LDI    R17, LED_13
        RCALL  SetBitEq       ;LED9 = LED13 

        POP    R25            ;Restore the saved LED in R25
        LDI    R16, LED_13
        RCALL  SetBit         ;LED13 = R25 (Stored former value of LED15)

        RET                   ;And done


; MoveReset1
;
; Description:        This procedure rotates a 1 into the GameBoard at position 
;                     1 and shifts all other LEDs in the board accordingly
;
; Operation:          Swaps the positions of the bits in the gameboard clearing
;                     LED 1, and shifts a 1 into position 1
;
; Arguments:          None
; Return Value:       None
;
; Local Variables:    None
; Shared Variables:   GameBoard - the current GameBoard given as the status of 
;                     the 16 game LEDs, with 1's indicating LED on, and 0's 
;                     indicating LEDs off. 
;
; Input:              None
; Ouput:              None
;
; Error Handling:     None
;
; Algorithms:         None
; Data Structures:    None
;
; Registers Changed: R16, R17, R25 
;
; Author:             Edward Speer
; Last Modified:      6/12/23

MoveReset1:

        LDI    R16, LED_15
        LDI    R17, LED_14 
        RCALL  SetBitEq         ;LED15 = LED14

        LDI    R16, LED_14
        LDI    R17, LED_13 
        RCALL  SetBitEq         ;LED14 = LED13 

        LDI    R16, LED_13
        LDI    R17, LED_12 
        RCALL  SetBitEq         ;LED13 = LED_12

        LDI    R16, LED_12
        LDI    R17, LED_11 
        RCALL  SetBitEq         ;LED12 = LED11

        LDI    R16, LED_11
        LDI    R17, LED_10 
        RCALL  SetBitEq         ;LED11 = LED10

        LDI    R16, LED_10
        LDI    R17, LED_9 
        RCALL  SetBitEq         ;LED10 = LED9

        LDI    R16, LED_9
        LDI    R17, LED_8 
        RCALL  SetBitEq         ;LED9 = LED8

        LDI    R16, LED_8
        LDI    R17, LED_7 
        RCALL  SetBitEq         ;LED8 = LED_7

        LDI    R16, LED_7
        LDI    R17, LED_6 
        RCALL  SetBitEq         ;LED7 = LED6

        LDI    R16, LED_6
        LDI    R17, LED_5 
        RCALL  SetBitEq         ;LED6 = LED5

        LDI    R16, LED_5
        LDI    R17, LED_4 
        RCALL  SetBitEq         ;LED5 = LED4

        LDI    R16, LED_4
        LDI    R17, LED_3 
        RCALL  SetBitEq         ;LED4 = LED3 

        LDI    R16, LED_3
        LDI    R17, LED_2 
        RCALL  SetBitEq         ;LED3 = LED2 

        LDI    R16, LED_2
        LDI    R17, LED_1 
        RCALL  SetBitEq         ;LED2 = LED1

        LDI    R16, LED_1 
        LDI    R25, LEDOn 
        RCALL  SetBit           ;LED1 = 1

		RET


; MoveReset0
;
; Description:        This procedure rotates a 0 into the GameBoard at position 
;                     1 and shifts all other LEDs in the board 1 positon
;
; Operation:          Swaps the positions of the bits in the gameboard clearing
;                     LED 1, and shifts a 0 into position 1
;
; Arguments:          None
; Return Value:       None
;
; Local Variables:    None
; Shared Variables:   GameBoard - the current GameBoard given as the status of 
;                     the 16 game LEDs, with 1's indicating LED on, and 0's 
;                     indicating LEDs off. 
;
; Input:              None
; Ouput:              None
;
; Error Handling:     None
;
; Algorithms:         None
; Data Structures:    None
;
; Registers Changed: R16, R17, R25 
;
; Author:             Edward Speer
; Last Modified:      6/12/23

MoveReset0:

        LDI    R16, LED_15
        LDI    R17, LED_14 
        RCALL  SetBitEq         ;LED15 = LED14

        LDI    R16, LED_14
        LDI    R17, LED_13 
        RCALL  SetBitEq         ;LED14 = LED13 

        LDI    R16, LED_13
        LDI    R17, LED_12 
        RCALL  SetBitEq         ;LED13 = LED_12

        LDI    R16, LED_12
        LDI    R17, LED_11 
        RCALL  SetBitEq         ;LED12 = LED11

        LDI    R16, LED_11
        LDI    R17, LED_10 
        RCALL  SetBitEq         ;LED11 = LED10

        LDI    R16, LED_10
        LDI    R17, LED_9 
        RCALL  SetBitEq         ;LED10 = LED9

        LDI    R16, LED_9
        LDI    R17, LED_8 
        RCALL  SetBitEq         ;LED9 = LED8

        LDI    R16, LED_8
        LDI    R17, LED_7 
        RCALL  SetBitEq         ;LED8 = LED_7

        LDI    R16, LED_7
        LDI    R17, LED_6 
        RCALL  SetBitEq         ;LED7 = LED6

        LDI    R16, LED_6
        LDI    R17, LED_5 
        RCALL  SetBitEq         ;LED6 = LED5

        LDI    R16, LED_5
        LDI    R17, LED_4 
        RCALL  SetBitEq         ;LED5 = LED4

        LDI    R16, LED_4
        LDI    R17, LED_3 
        RCALL  SetBitEq         ;LED4 = LED3 

        LDI    R16, LED_3
        LDI    R17, LED_2 
        RCALL  SetBitEq         ;LED3 = LED2 

        LDI    R16, LED_2
        LDI    R17, LED_1 
        RCALL  SetBitEq         ;LED2 = LED1

        LDI    R16, LED_1 
        LDI    R25, LEDOff 
        RCALL  SetBit           ;LED1 = 0

		RET



; SetBitEq
;
; Description:        This procedure sets bit i = bit j in the gameboard, i.e 
;                     GameBoard[i] = GameBoard[j]
;
; Operation:          To set bit i = bit j, mask out all bits other than bit j,
;                     rotate bit j until it is in the position of bit j, then in 
;                     the GameBoard, mask out bit j and OR it with the bit j 
;                     shifted into position. Then store this back to the GameBoard.
;
; Arguments:          i passed into R16, J passed into R17
; Return Value:       None
;
; Local Variables:    None
; Shared Variables:   GameBoard - the current GameBoard given as the status of 
;                     the 16 game LEDs, with 1's indicating LED on, and 0's 
;                     indicating LEDs off. 
;
; Input:              None
; Ouput:              None
;
; Error Handling:     None
;
; Algorithms:         None
; Data Structures:    None
;
; Registers Changed:  YL, YH, R24, R25, R23, R17, R18, R19, R16 R20
; 
; Author:             Edward Speer
; Last Modified:      6/16/23

SetBitEq:

        LDI    YL, LOW(GameBoard)
        LDI    YH, HIGH(GameBoard) ;Get the data address to the GameBoard 

        LD     R18, Y+ 
        LD     R19, Y                  ;Get the current Gameboard

CreateMaskj:

        LDI    R24, Bit0Mask_LOW
        LDI    R25, Bit0Mask_HIGH     ;Load in a mask of bit 0
        CLR    R23
        OR     R23, R17               ;Copy j into R13 and set zero flag

UntilJ:                               ;Shift mask until masking bit j 

        BREQ   ShiftToI               ;If masking bit j, then move onto shifting
        ;BRNE  RotateMaskJ            ;Otherwise, continue shifting mask

RotateMaskJ:

        LSL    R24
        ROL    R25                    ;Shift masked bit to the left 
        DEC    R23                    ;Reduce shift counter
        RJMP   UntilJ                 ;Repeat shifting loop

ShiftToI:

        AND    R24, R18
        AND    R25, R19               ;Mask out all bits except j from GameBoard copy 
        CP     R17, R16
        BRLT   ShiftLeftJ             ;if j < i, need to shift bit j left
        ;BRGE  ShiftRightJ            ;Otherwise, need to shift bit j right 

ShiftRightJ:

        CP     R17, R16 
        BREQ   CreateMaski             ;If bit j shifted to position i, done
        ;BRNE  ShiftRightJ             ;Otherwise continue shifting
        LSR    R25
        ROR    R24                     ;Shift bit j to the right
        DEC    R17                     ;j = j - 1 
        RJMP   ShiftRightJ             ;Repeat shifting loop 

ShiftLeftJ:

        LSL    R24
        ROL    R25                     ;Shift bit j to the left 
        INC    R17                     ;j = j+1
        CP     R17, R16
        BRNE   ShiftLeftJ              ;If j != i, shift left again 
        ;BREQ  CreateMaski             ;If j=i, done shifting


CreateMaski:

        LDI   R20, MaskOut0_LOW
        LDI   R21, MaskOut0_HIGH      ;Load a mask to remove bit 0 
        CLR   R22
        OR    R22, R16                 ;Load in i and set 0 flag

UntilI:

        BREQ  SetI                     ;If shifted to i, done shifting 
        ;BRNE RotateMaskI              ;Otherwise continue shifting

RotateMaskI:

        SEC                           ;Always shift in a 1 to the mask
        ROL    R20
        ROL    R21                    ;Shift masked bit to the left 
        DEC    R22                    ;Reduce shift counter
        RJMP   UntilI                 ;Repeat shifting loop

SetI:

        AND    R20, R18
        AND    R21, R19               ;Mask out bit i from GameBoard 
        OR     R20, R24 
        OR     R21, R25               ;Bit i = bit j in R21|R20

StoreBoard: 

        ST     Y, R21 
        ST     -Y, R20                 ;Store transformed board to GameBoard 
  
        RET                           ;And done


;SetBit 
;
; Description:        This procedure sets bit i = c in the gameboard, i.e 
;                     GameBoard[i] = c
;
; Operation:          To set bit i = c, mask out bit i from the gameBoard,
;                     create a mask with c in position i, and then OR the board 
;                     with the mask.
;
; Arguments:          i passed into R16, c (0 or 1) passed into R25 
; Return Value:       None
;
; Local Variables:    None
; Shared Variables:   GameBoard - the current GameBoard given as the status of 
;                     the 16 game LEDs, with 1's indicating LED on, and 0's 
;                     indicating LEDs off. 
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
; Last Modified:      6/12/23

Setbit:

        LDI    YL, LOW(GameBoard)
        LDI    YH, HIGH(GameBoard)    ;Get the data address to the GameBoard 

        LD     R18, Y+ 
        LD     R19, Y                 ;Get the current Gameboard 

CreateCMask:
        
        MOV    R14, R25               ;Extend c to 16 bits in R14|R15
        CLR    R15                    ;Load high byte of a mask of bit 0
        CLR    R13
        OR     R13, R16               ;Get i as loop counter and set zero flag 

ShiftCLoop:

        BREQ  IFromBoard              ;if loop counter 0, done shifting
        ;BRNE ShiftC                  ;otherwise continue shifting c 

ShiftC:

        LSL    R14
        ROL    R15                    ;Shift c to the left in the mask 
        DEC    R13                    ;loopCounter -= 1
        RJMP   ShiftCLoop             ;repeat loop 

IFromBoard:

        LDI   R20, MaskOut0_LOW
        LDI   R21, MaskOut0_HIGH       ;Load a mask to remove bit 0 
        CLR   R22
        OR    R22, R16                 ;Load in i and set 0 flag

IMaskLoop:

        BREQ  SetIToC                  ;If shifted to i, done shifting 
        ;BRNE RotToI                   ;Otherwise continue shifting

RotToI:

        SEC                           ;Always shift in a 1 to the mask
        ROL    R20
        ROL    R21                    ;Shift masked bit to the left 
        DEC    R22                    ;Reduce shift counter
        RJMP   IMaskLoop              ;Repeat shifting loop

SetIToC:

        AND    R20, R18
        AND    R21, R19               ;Mask out bit i from GameBoard
        OR     R20, R14 
        OR     R21, R15               ;Set i = c in R21|R20

        ST     Y, R21 
        ST     -Y, R20                ;Store transformed board to GameBoard 

        RET                           ;And done


;GetI 
;
; Description:        This procedure returns the value of the bit i in the game 
;                     board, either 0 or 1
;
; Operation:          Rotate bit i into position 0, then set the preceeding 7
;                     bits to 0 and return 8 bits 
;
; Arguments:          i passed into R16
; Return Value:       value at bit i returned in R25 
;
; Local Variables:    None
; Shared Variables:   GameBoard - the current GameBoard given as the status of 
;                     the 16 game LEDs, with 1's indicating LED on, and 0's 
;                     indicating LEDs off. 
;
; Input:              None
; Ouput:              None
;
; Error Handling:     None
;
; Algorithms:         None
; Data Structures:    None
;
; Registers Changed: YL, YH, R18, R19, R16, R25
; 
; Author:             Edward Speer
; Last Modified:      6/12/23

GetI:
        
        LDI    YL, LOW(GameBoard)
        LDI    YH, HIGH(GameBoard) ;Get the data address to the GameBoard 

        LD     R18, Y+ 
		LD     R19, Y                  ;Get the current Gameboard
		AND    R16, R16                ;Set 0 flag if i=0
        
IShiftLoop:

        BREQ   Mask7Bits               ;if bit i in position 0, mask other bits 
        ;BRNE  IShift                  ;Otherwise continue shifting

IShift:

        LSR    R19 
        ROR    R18                     ;Shift R19|R18 to the right 
        DEC    R16                     ;Reduce needed shift counter
        RJMP   IShiftLoop              ;Repeat shifting loop

Mask7Bits:

        LDI    R25, Bit0Mask_LOW
        AND    R25, R18                ;Mask out the 7 bits preceeding bit i
        
        RET                            ;Return 0b0000000(i) in R25