@SCREEN
D=A
@sc-orig
M=D
@sc-loc
M=D
@256
D=A
@sc-height
M=D
@32
D=A
@sc-width
M=D // 32 registers of 16 bits each, 32 * 16 = 512

@KBD
D=A
@kb-addr
M=D

// Infinite loop
(INF_LOOP)
    // Get keyboard value
    @kb-addr
    A=M
    D=M
    @key
    M=D
    
    @sc-orig
    A=M
    D=M
    @SC_IS_WHITE
    D;JEQ
    @SC_IS_BLACK
    D+1;JEQ
    
(SC_IS_WHITE)
    // If key is 0, jump to INF_LOOP
    @key
    D=M
    @INF_LOOP
    D;JEQ
    
    // Else, make screen black
    @new-col
    M=-1
    @COLOR_SCREEN
    0;JMP
    
(SC_IS_BLACK)
    @key
    D=M
    @INF_LOOP
    D;JNE
    
    @new-col
    M=0
    @COLOR_SCREEN
    0;JMP
    
(COLOR_SCREEN)
    @i
    M=0
    (LOOP_ROWS)
        @j
        M=0
        (LOOP_COLS)
            // Write color into current location on screen
            @new-col
            D=M
            @sc-loc
            A=M
            M=D
            // Increment screen location and j
            @sc-loc
            M=M+1
            @j
            M=M+1
            // If j < sc-width, repeat LOOP_COLS
            D=M
            @sc-width
            D=D-M
            @LOOP_COLS
            D;JLT
            //  If j = sc-width
            //        Increment i
            //        If i < sc-height
            //            Repeat LOOP_ROWS
            //        If i = sc-height
            //            Jump to INF_LOOP
            //
            // D is currently j - sc-width
            @DONE-ROWS
            D;JEQ

(DONE-ROWS)
    @i
    M=M+1
    D=M
    @sc-height
    D=D-M
    @LOOP_ROWS
    D;JLT
    @sc-orig
    D=M
    @sc-loc
    M=D
    @INF_LOOP
    D;JEQ