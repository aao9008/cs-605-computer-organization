#
# Program Name: module5Q2TwosComplement.s
# Author: Alfredo Ormeno Zuniga
# Date: 6/21/2025
# Purpose: Read an integer and output its negative using two's complement (MVN + ADD).
#
.text
.global main
main:
    # Push stack
    SUB sp, sp, #4
    STR lr, [sp, #0]

    # Question 2 - Two's Complement Operation
    # Prompt user for an integer
    LDR r0, =prompt1
    BL printf

    # Scanf - user input (integer)
    LDR r0, =format1
    LDR r1, =input1
    BL scanf
    
    # Calculate the 2's complement
    # Load the input value
    LDR r1, =input1
    LDR r1, [r1, #0] @r1 = input
    
    # Calculate the 1's complement
    MVN r2, r1 @ r2 = one's complement of r1
    ADD r2, r2, #1 @ r2 = two's complement

    # Print the result
    LDR r0, =output1
    # r1 holds the original input value
    # r2 holds the two's complement value
    BL printf

    # Pop stack and return
    LDR lr, [sp, #0]
    ADD sp, sp, #4
    MOV pc, lr

.data
    prompt1: .asciz "Please enter an integer and I will output its negative value: "
    format1: .asciz "%d"
    input1: .word 0
    output1: .asciz "The negative of %d is %d\n"
