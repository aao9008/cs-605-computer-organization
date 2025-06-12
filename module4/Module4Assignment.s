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
