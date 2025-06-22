#
# Program Name: module5Q4MultiplyBy10.s
# Author: Alfredo Ormeno Zuniga
# Date: 6/21/2025
# Purpose: Multiply user input by 10 using LSL and ADD instructions only.
#
.text
.global main
main:
    # Push stack
    SUB sp, sp, #4
    STR lr, [sp, #0]
    
    # Question 4 - Multiply a number by 10 using logical left shifts and add instructions. 
    # Prompt user for input
    LDR r0, =prompt1
    BL printf

    # Scanf - user input (integer)
    LDR r0, =format1
    LDR r1, =input1
    BL scanf

    # Load input from memory into a register
    LDR r1, =input1 @ Load the memory address of input1
    LDR r1, [r1, #0] @ Load the value located at the address of input1

    # Multiply r1 by 10 using shifts and adds
    # 10x = (8x + 2x) = (x << 3) + (x << 1)
    LSL r2, r1, #3 @ Shift the bit in r1 to the left by 8 bits and store in r2 (r2 <- r1 * 8)
    LSL r3, r1, #1 @  Shift the bits in r1 to the left by 2 bits and store in r3 (r3 <- r1 * 2 )

    # Add the shifted values of r2 and r3 to get the final value
    ADD r2, r2, r3

    # Print orginial number and final result (r1 = original input, r2 = input * 10)
    LDR r0, =output1
    BL printf

    # Pop stack and return
    LDR lr, [sp, #0]
    ADD sp, sp, #4
    MOV pc, lr

.data
    prompt1: .asciz "Please enter an integer. This program will multiply this integer by 10.\n"
    format1: .asciz "%d"
    input1: .word 0
    output1: .asciz "Original: %d, Multiplied by 10: %d\n"
