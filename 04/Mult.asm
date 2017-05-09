@i
M=1
@sum
M=0
@R2
M=0
(LOOP)
    @R0
    D=M
    @sum
    M=M+D
   
    // Load i
    @i
    D=M
    // Compute i - R1
    @R1
    D=D-M
    // If i - R1 = 0, goto END
    @STORE
    D;JEQ
    // Else, increment i and keep going
    @i
    M=M+1
    @LOOP
    0;JMP
(STORE)
    // Store sum in R2
    @sum
    D=M
    @R2
    M=D
(END)
    @END
    0;JMP