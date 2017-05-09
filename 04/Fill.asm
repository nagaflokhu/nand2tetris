@SCREEN
D=A
@sc-orig
M=D
@pos
M=D
@256
D=A
@sc-height
M=D
@32
D=A
@sc-width
M=D
@KBD
D=A
@kb-addr
M=D

(INF_LOOP)
    // Get key
    @kb-addr
    A=M
    D=M
    @key
    M=D
    
    // If key is pressed, make screen black
    @key
    D=M
    @PAINT_BLACK
    D;JNE
    @PAINT_WHITE
    D;JEQ
    
(PAINT_BLACK)
    @color
    M=-1
    @row
    M=0
    @LOOP_ROWS
    0;JMP
    
(PAINT_WHITE)
    @color
    M=0
    @row
    M=0
    @LOOP_ROWS
    0;JMP

(LOOP_ROWS)
    @col
    M=0
    @LOOP_COLS
    0;JMP
    
(LOOP_COLS)
    // Get color
    @color
    D=M
    // Put color at current position
    @pos
    A=M
    M=D
    // Increment col and pos
    @col
    M=M+1
    @pos
    M=M+1
    // Check if we have finished column
    @col
    D=M
    @sc-width
    D=D-M
    // Repeat LOOP_COLS if we are not done
    @LOOP_COLS
    D;JLT
    // If we are done this column, increment
    // row. If we are done all rows, reset pos
    // to sc-orig and restart infinite loop.
    // If not, jump to LOOP_ROWS
    @row
    M=M+1
    D=M
    @sc-height
    D=D-M
    @LOOP_ROWS
    D;JLT
    @sc-orig
    D=M
    @pos
    M=D
    @INF_LOOP
    0;JMP
    
    