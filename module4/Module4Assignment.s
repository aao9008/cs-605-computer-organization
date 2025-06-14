#
# Program Name: Module4Assignment.s
# Author: Alfredo Ormeno Zuniga
# Date: 6/14/2025
# Purpose: Shows int, string, and float printf/scanf
#
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

    # Scanf - user age input
    LDR r0, =format1
    LDR r1, =age1
    BL scanf

    # Print users's age
    LDR r0, =output1
    LDR r1, =age1
    LDR r1, [r1, #0]
    BL printf 
    # END Part 1

    # Part 2
    # Print user age with tabs before and after
    LDR r0, =output2
    LDR r1, =age1
    LDR r1, [r1, #0]
    BL printf
    # END Part 2

    # Part 3
    # Print string that contains double quotation marks
    LDR r0, =output3
    BL printf
    # End Part 3

    # Bounus Question 5: Floating Point Number
    # Prompt user for a floating point number
    LDR r0, =prompt5
    BL printf

    # Scanf - user float input
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
    # Variables for Part 1
    prompt1: .asciz "Part 1 \nHow old are you? "
    format1: .asciz "%d"
    age1: .word 0
    output1: .asciz "Wow you are %d years old!\n" 

    # Variables for Part 2
    output2: .asciz "Part 2\n Before:\t%d\tAfter\n"

    # Variables for Part 3
    output3: .asciz "Part 3\nThey said, \"Hello World!\"\n" 

    # Variables for bonus question 5
    prompt5:    .asciz "Enter a float: "
    output5:   .asciz "You entered: %f\n"
    format5: .asciz "%f"
    float_val: .float 0.0  


