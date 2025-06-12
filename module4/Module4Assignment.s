.text
.global main
main:
    # Push stack
    SUB sp, sp, #4
    STR lr, [sp, #0]
    
    # Part 1
    # Prompt for user's age
    LDR r0, =prompt1
    BL printf

    # Scanf
    LDR r0, =format1
    LDR r1, =age1
    BL scanf

    # Print message
    LDR r0, =output1
    LDR r1, =age1
    LDR r1, [r1, #0]
    STR r1, [sp, #-4]! @ Push: Decrement SP by 4 and store r1 at the new top of the stack 
    BL printf 
    # END Part 1

    # Part 2
    LDR r0, =output2
    LDR r1, [sp], #4 @ Pop: Load r1 from the top of the stack, then increment SP by 4
    BL printf
    # END Part 2

    # Part 3
    LDR r0, =output3
    BL printf
    # End Part 3

    # Bounus: Floating Point Number

    # Prompt user
    LDR r0, =prompt5
    BL printf

    # Scanf 
    LDR r0, =format5
    LDR r1, =float_val
    BL scanf

    # Convert 32-float to 64-float
    LDR r2, =float_val
    VLDR s0, [r2] @ Load float into single precision register
    vcvt.f64.f32 d0, s0 @ Convert float -> double (for printf)
    vmov r1, r2, d0 @ Move double bits into r2:r3 (for printf)

    # Print float
    LDR r0, =output5
    BL printf

    # Pop stack and return
    LDR lr, [sp, #0]
    ADD sp, sp, #4
    MOV pc, lr

.data
    prompt1: .asciz "Part 1 \nHow old are you? "
    format1: .asciz "%d"
    age1: .word 0
    output1: .asciz "Wow you are %d years old!\n" 
   
    output2: .asciz "Part 2\n Before:\t%d\tAfter\n"
    
    output3: .asciz "Part 3\nThey said, \"Hello World!\"\n" 

    prompt5:    .asciz "Enter a float: "
    output5:   .asciz "You entered: %f\n"
    format5: .asciz "%f"
    float_val: .float 0.0  


