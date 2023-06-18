;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                                                            ;
;                                   DISP.ASM                                 ;
;                              Display Functions                             ;
;                       Microprocessor-Based Hexer Game                      ;
;                                                                            ;
;                                                                            ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; This file contains the functions necessary to display game data on the two 
; multiplexed displays for the user interface of the microprocessor based 
; Hexer game.
;
; Public Routines: InitDisplay - Initializes the variables used for display  
;                                multiplexing. Must be called before displaying 
;                                anything on the board for the first time. 
;                  StartBlink  - Causes the 15 LED display to begin blinking
;                  StopBlink   - Causes the 15 LED display to stop blinking 
;                  BlinkDisplay- Called each ms intterupt to set the state of
;                                the LED to on or off at the appropriate times 
;                                when display blinking. 
;                  DisplayInterrupt - Called each 1 ms timer interrupt to 
;                                     perform display multiplexing
;                  ClearDisplay- Turns off all LEDs in the game board 
;                  DisplayHex  - Displays the 4 digit hex number passed into 
;                                R17|R16 on the 7 segment display 
;                  DisplayGameLEDs - Displays the 16 bit game board mask passed
;                                    into R17|R16 on the 15 LED display
;                  
;
; Revision History:
;     5/19/23   Edward Speer    Initial Revision
;     5/20/23   Edward Speer    Add code for display routines 
;     5/20/23   Edward Speer    Debug display muxing
;     5/20/23   Edward Speer    Update comments
;     6/13/23   Edward Speer    Update DisplayInterrupt for master event handler
;     6/15/23   Edward Speer    Add blinking of the GameBoard LEDs 
;     6/15/23   Edward Speer    Finalize comments 

.cseg


; InitDisplay
;
; Description:        This procedure initializes the variables used for display 
;                     multiplexing
;
; Operation:          Resets the Multiplexing counter to the number of output 
;                     options for the display mux and wipes the buffer using 
;                     ClearDisplay.
;
; Arguments:          None
; Return Value:       None
;
; Local Variables:    None
; Shared Variables:   CurMuxDigPat (W) - The pattern of the selected digit
;                     CurMuxDig (W)    - The display mux digit selected
;                     IsBlinking (W)   - Flag indicating if display blinking 
;                     BlinkCount (W)   - The counter used to time blinking
;                     DispOff (W)      - Flag indicating if diaplsy currently off
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
; Registers Changed: R16
; 
; Author:             Edward Speer
; Last Modified:      6/15/23

InitDisplay:

    CLR    R16               ;Store zero as index of the first elem in buffer
    STS    CurMuxDig, R16    ;Initialize current digit to the first activated

    LDI    R16, INIT_PATT 
    STS    CurMuxDigPat, R16 ;Store the drive pattern of the first digit
	
	LDI    R16, NBLINKING
	STS    IsBlinking, R16   ;Display not blinking initially

	LDI    R16, BL_TIME
	STS    BlinkCount, R16   ;Init blink counter to blinking time

	LDI    R16, FALSE
	STS    DispOff, R16      ;Display not initially off

    RCALL  ClearDisplay      ;Initialize display buffer to empty (all LEDS off)
                                       
    RET                      ;Done, so return


;StartBlink
;
; Description:        This procedure is called to cause the 15 LED GameBoard 
;                     display to begin blinking.
;
; Operation:          Sets the blinking flag high so the display will blink
;
; Arguments:          None
; Return Value:       None
;
; Local Variables:    None
; Shared Variables:   IsBlinking (W): A flag indicating the display is blinking
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
; Last Modified:      6/15/23

StartBlink:

        LDI    R16, BLINKING
		STS    IsBlinking, R16        ;Set blinking flag on
		RET


;StopBlink
;
; Description:        This procedure is called to cause the display to stop 
;                     blinking
;
; Operation:          Sets the blinking flag high so the display will not blink
;
; Arguments:          None
; Return Value:       None
;
; Local Variables:    None
; Shared Variables:   IsBlinking (W): Is a flag indicating the display is blinking
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
; Last Modified:      6/15/23

StopBlink:

        LDI    R16, NBLINKING
		STS    IsBlinking, R16        ;Set blinking flag on
		RET


;BlinkDisplay
;
; Description:        This procedure is called by the event handler for the 
;                     timer interrupts generated each milisecond on the Hexer 
;                     system, and is used to blink the gameboard display when
;                     the BlinkDisplay flag is set.
;
; Operation:          On every clock interrupt, this routine is called, and
;                     based on a counter, determines whether the display
;                     LEDs should shwo the current GameBoard, or should all be 
;                     off if the display is blinking. If the display is not 
;                     blinking, does nothing. Toggles the state of the LEDs 
;                     every time the counter reaches 0.
;
; Arguments:          None
; Return Value:       None
;
; Local Variables:   
; Shared Variables:   IsBlinking (R): Is a flag indicating the display is blinking
;                     BlinkCounter (R/W): The counter used to blink the display
;                     DispOff (R/W): Flag indicating if display is currently off
;
; Input:              None
; Ouput:              None
;
; Error Handling:     None
;
; Algorithms:         None
; Data Structures:    None
;
; Registers Changed:  R16, R17, R18
; 
; Author:             Edward Speer
; Last Modified:      6/15/23

BlinkDisplay:

        LDS    R16, IsBlinking     ;Check if the display is blinking
		LDI    R17, BLINKING
		CP     R16, R17
		BRNE   DoneBlinking        ;If not, nothing to do
		;BREQ  DoBlink             ;Otherwise, perform blinking

DoBlink:

        LDS    R18, BlinkCount
		DEC    R18
		BRNE   StoreBCount         ;If the blink counter non-zero, just decrement
		;BREQ  ChangeDisp          ;Otherwise, swap state of LEDs

ChangeDisp:

        LDS    R16, DispOff
		TST    R16
		BRNE   BoardOn             ;If LEDS previously off, set to game board
		;BREQ  ResetCount          ;Otherwise reset counter

ResetCount:

        LDI    R18, BL_TIME        ;If counter was 0, reset to blink time

BoardOff:

        LDI    R16, LEDSOFF
		LDI    R17, LEDSOFF
		RCALL  DisplayGameLEDs     ;If previously on, turn LEDs off
		LDI    R17, TRUE
		STS    DispOff, R17        ;mark display as currenty off
		RJMP   StoreBCount

BoardOn:

        LDI    ZL, LOW(GameBoard)
        LDI    ZH, HIGH(GameBoard)
        LD     R16, Z+ 
        LD     R17, Z              ;Load current game board to R17|R16
        RCALL  DisplayGameLEDs     ;Display the current game board
		LDI    R17, FALSE
		STS    DispOff, R17        ;mark display as currenty on
		RJMP   StoreBCount

StoreBCount:

        STS    BlinkCount, R18     ;Store counter back to memory

DoneBlinking:

        RET


; DisplayInterrupt
;
; Description:        This procedure is called by the event handler for the 
;                     timer0 interrupts generated each milisecond on the Hexer 
;                     system, and is used to display Hexer game data on the 2 
;                     game board displays.
;
; Operation:          On every clock interrupt, this routine is called, and
;                     based on a counter, determines which set of muxed LEDs in
;                     the display should be activated according to the muxing 
;                     frequency, then displays the data stored in the display
;                     buffer for those LEDs. Every LED is stored in the buffer 
;                     as either on or off, and at the mux frequency the set of 
;                     LEDs illuminated in the board are changed, rotating
;                     through all LEDs on the board. For each set of LEDs, ON or 
;                     OFF is sent out on port C, while the LEDs to illuminate are
;                     slected via mux select signals on port D.
;
; Arguments:          None
; Return Value:       None
;
; Local Variables:    None
; Shared Variables:   dispBuffer (R) - the data shown on the LED display
;                     CurMuxDigPat (R/W) - the counter keeping track of the mux 
;                                          selection to make
;                     CurMuxDig     - The digit currently selected to display                   
;
; Input:              None
; Ouput:              Outputs the display buffers and display select signals to 
;                     ports C and D
;
; Error Handling:     None
;
; Algorithms:         None
; Data Structures:    None
;
; Registers Changed: None
; 
; Author:             Edward Speer
; Last Modified:      6/15/23

DisplayInterrupt:

    PUSH   R16               ;Used by BlinkDisplay
	PUSH   R17               ;Used in BlinkDisplay
    PUSH   R18               ;Save touched registers since this will be called 
    PUSH   R19               ; during event handling
    PUSH   ZL
    PUSH   ZH
    PUSH   R0


    LDI    R18, LEDSOFF    
    OUT    Dig_PORT, R18     ;Initialize LEDS to be turned off; set drivers low
                             ; to avoid showing wrong pattern on wrong LED line. 

	RCALL  BlinkDisplay      ;Set display for blinking before showing it

    CLR    R19               ;zero constant for calculations with adc
    LDS    R18, CurMuxDig    ;Get the current LED seg pattern to display 

MuxLED:                      ;Get and output digit pattern and select

    LDI    ZL, LOW(dispBuffer)  ;Get the current display buffer
    LDI    ZH, HIGH(dispBuffer)
    ADD    ZL, R18              ;Move up in the buffer to the selected digit 
    ADC    ZH, R19 

    LDS    R19, CurMuxDigPat ;Get the current drive pattern
    OUT    DIGIT_PORT, R19   ;And output it 

    LD     R0, Z             ;Get the digit pattern from the buffer
    OUT    DIG_PORT, R0      ;and output to the display 

    LSL    R19               ;Advance to the next digit drive pattern 
    INC    R18               ;And the next mux digit number 
    CPI    R18, DISP_LINES   ;Check if all digits have been displayed
    BRLO   UpdateDigCnt      ;If not, update count with new value 
    ;BRSH  ResetDigCnt       ;otherwise, reset digit count

ResetDigCnt:

    CLR    R18               ;On last segnent, reset to first 
    LDI    R19, INIT_PATT    ;Reset to first driver pattern as well 
    ;RJMP  UpdateDigCnt  

UpdateDigCnt:

    STS    CurMuxDig, R18    ;Store the new digit counter 
    STS    CurMuxDigPat, R19 ;And the new digit drive pattern 
    ;RJMP  EndInter          ;Done 

EndInter: 

    POP    R0
    POP    ZH
    POP    ZL
    POP    R19
    POP    R18               ;Restore touched registers since always called 
	POP    R17               ; during an interrupt
	POP    R16
    
    RET                      ;Done, so return


; ClearDisplay
;
; Description:        This procedure sets all LEDS in the game display to be off
;                     including both the game board display and the 7 segment 
;                     display.
;
; Operation:          Sets the data written to the board displays to all 0's, 
;                     so that on the next interrupt and until new data is 
;                     entered, the display will be blank (all LEDs off)
;
; Arguments:          None
; Return Value:       None
;
; Local Variables:    None
; Shared Variables:   dispBuffer (W) - the data shown on the display
;
; Input:              None
; Ouput:              None
;
; Error Handling:     None
;
; Algorithms:         None
; Data Structures:    None
;
; Registers Changed: R16, YL, YH, R17
; 
; Author:             Edward Speer
; Last Modified:      5/20/23

ClearDisplay:

    LDI    R16, DISP_LINES     ;Number of digits to be cleared 
    LDI    YL, LOW(dispBuffer) ;Load current buffer 
    LDI    YH, HIGH(dispBuffer)
    LDI    R17, LED_OFF        ;Load the pattern of an off LED 
    ;RJMP ClcBuffLoop          ;Go on to clear out buffer 

ClcBuffLoop:                   ;Loop through and clear each buffer index 
    
    ST    Y+, R17              ;Clear the digit
    DEC   R16                  ;Move to the next digit
    BRNE  ClcBuffLoop         ;If not done clearing digits, loop 
    ;BREQ EndClc               ;Otherwise, done clearing 

EndClc: 

    RET                        ;Done, so return


; DisplayHex
;
; Description:        This procedure sets the bytes in the display buffer which 
;                     represent the patterns shown on the 7 segment display 
;                     such that the 4 digits passed in as hex will be shown on 
;                     the 7 segment display (i.e 0x0A -> "A"). The passed in 
;                     hex is padded on the left by blanks.
;
; Operation:          Sets the data written to the board display to the patterns 
;                     indicated by the value passed in R16|R17, by performing 
;                     lookup of each digit in the segment table. Empty digits 
;                     are padded left using blanks.
;
; Arguments:          16 bit unsigned value to be shown on 7-segment in R16|R17
; Return Value:       None
;
; Local Variables:    None
; Shared Variables:   dispBuffer (W) - the data shown on the display
;
; Input:              None
; Ouput:              None
;
; Error Handling:     None
;
; Algorithms:         None
; Data Structures:    None
;
; Registers Changed: R17, R16, R18, R20, YL, YH, R21, ZL, ZH
; 
; Author:             Edward Speer
; Last Modified:      6/15/23

DisplayHex: 

    LDI    R18, SEG_NUM    ;Get the number of digits to display  
    CLR    R20             ;Zero for propogating carries 
    LDI    YL, LOW(dispBuffer+SEG_OFFS) ;Pointer to display buffer, offset to 
    LDI    YH, HIGH(dispBuffer+SEG_OFFS); 7 segment display patterns
    ;RJMP  DisplayLoop     ;Go on to display digits 

DisplayLoop:               ;Loop through and set each digit 

    MOV    R21, R16        ;Get the digit to display 
    ANDI   R21, LOW_NIBBLE ;Digit is in the low nibble 
    LDI    ZL, LOW(DigitSegTable << 1)  ;Point to start of seg table
    LDI    ZH, HIGH(DigitSegTable << 1) ;Shifted for byte addressing
    ADD    ZL, R21         ;Get offset in Segment Table 
    ADC    ZH, R20 
    LPM                    ;Lookup the digit pattern; store in R0

DisplayDigits:

    ST     Y+, R0          ;Store the looked up digit in the next buffer index 

EndLoop:

    LSR    R17             ;move the next digit into place
    ROR    R16			   ;each digit is 4 bits
    LSR    R17
    ROR    R16
    LSR    R17
    ROR    R16
    LSR    R17
    ROR    R16

    DEC    R18             ;Update digit counter to next digit
    BRNE   DisplayLoop     ;If not all digits have been displayed, then loop 
    ;BRE   EndDisp         ;Otherwise, done updating buffer 

EndDisp:

    RET                    ;Done, so return


; DisplayGameLEDs
;
; Description:        This procedure takes in a 16 bit mask and triggers the 
;                     15 LED display to show the sequence indicated by the mask.
;
; Operation:          Writes the mask input into the function to the BoardBuffer 
;                     shared variable, masking out bit 12, so that it will be 
;                     displayed by the display muxing event handler.
;
; Arguments:          16 bit mask to be displayed on the 15 LED display in 
;                     R16|R17 giving the game LEDS as the following sequence:
;                      9, 1, 5, None, 10, 4, 3, 2, 13, 11, 8, 15, 14, 12, 7, 6
; Return Value:       None
;
; Local Variables:    None
; Shared Variables:   BoardBuffer (W) - the game data to be shown on the game
;                                       board display (Game LEDS stored at the 
;                                                      beginning of buffer)
;
; Input:              None
; Ouput:              None
;
; Error Handling:     None
;
; Algorithms:         None
; Data Structures:    None
;
; Registers Changed: YL, YH, R17, R16
; 
; Author:             Edward Speer
; Last Modified:      5/20/23

DisplayGameLEDs:

    LDI    YL, LOW(dispBuffer)  ;Pointer to buffer to store sequences in
    LDI    YH, HIGH(dispBuffer)
    ANDI   R17, HIGH_MASK       ;Mask out bit 12 from high bytes of argument 
    ST     Y+, R17              ;Store new pattern for high bytes of game LEDS 
    ANDI   R16, LOW_MASK        ;Mask low bytes of game LEDS from argument
    ST     Y+, R16              ;Store new pattern for low bytes of game LEDS

    RET                        ;Done, so return


.dseg 

dispBuffer:    .BYTE    DISP_LINES     ;Buffer holding display patterns

;Buffer Layout:
;  BYTE1: LEDS 9, 1, 5, None, 10, 4, 3, 2
;  BYTE2: LEDS 13, 11, 8, 15, 14, 12, 7, 6
;  BYTE3: 7 Seg Digit 4
;  BYTE4: 7 Seg Digit 3
;  BYTE5: 7 Seg Digit 2
;  BYTE6: 7 Seg Digit 1
;  BYTE4: 7 Seg Other Features

CurMuxDig:     .BYTE    1              ;Current display display data to out
CurMuxDigPat:  .BYTE    1              ;Current display output select pattern

IsBlinking:    .BYTE    1              ;Flag indicating if display is blinking
BlinkCount:    .BYTE    1              ;Counter used to blink the display
DispOff:       .BYTE    1              ;Used in blinking for state of board