#
# Program Name: module5BonusXORSwap.s
# Author: Alfredo Ormeno Zuniga
# Date: 6/21/2025
# Purpose: Swap two register values using only EOR instructions (no third register). 
#          This demonstrates the reversibility property of the EOR operation.
#
.text
.global main
main:
    # Push stack
    SUB sp, sp, #4
    STR lr, [sp, #0]
    
    # Bonus Question - Multiply a number by 10 using logical left shifts and add instructions. 
    # Prompt user for input
    LDR r0, =prompt1
    BL printf

    # Scanf - user input (integer)
    LDR r0, =format1
    LDR r1, =input1
    LDR r2, =input2
    BL scanf

    # Load values from memory
    LDR r1, =input1
    LDR r1, [r1, #0]
    LDR r2, =input2
    LDR r2, [r2, #0]

    # Print before the swap
    LDR r0, =outputBefore
    BL printf

    # Load values from memory again (Previous Printf wiped r1 and r2)
    LDR r1, =input1
    LDR r1, [r1, #0]
    LDR r2, =input2
    LDR r2, [r2, #0]

    # XOR Swap
    EOR r2, r1, r2    @ r2 = A ^ B (combined info of A and B)
    EOR r1, r1, r2    @ r1 = A ^ (A ^ B) = B (recover original B)
    EOR r2, r1, r2    @ r2 = B ^ (A ^ B) = A (recover original A)
    # Now r1 holds B, and r2 holds A — swap completed without using a temp register

    # Print after the swap
    LDR r0, =outputAfter
    BL printf

    # Pop stack and return
    LDR lr, [sp, #0]
    ADD sp, sp, #4
    MOV pc, lr

.data
    prompt1: .asciz "Enter two integers to swap:\n"
    format1: .asciz "%d %d"
    input1: .word 0
    input2: .word 0
    outputBefore: .asciz "Before swap: a = %d, b = %d\n"
    outputAfter:  .asciz "After swap:  a = %d, b = %d\n"
