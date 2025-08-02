#
# Program Name: main.s
# Author: Alfredo Ormeno Zuniga
# Date: 7/25/2025
# Purpose:
#   This program prompts the user to enter an integer `n`, 
#   then computes the nth Fibonacci number using a recursive function `F`.
#   The result is printed to the terminal.
#
# Functions Called:
#   - F:         Recursively calculates the nth Fibonacci number
#
# Inputs:
#   - User enters a single integer value `n`
#
# Outputs:
#   - The nth Fibonacci number is printed to the terminal
#
.text
.global main
main:
    # Push the stack
    SUB sp, sp, #4
    STR lr, [sp, #0]

    # Prompt for n
    LDR r0, =promptN
    BL printf

    # Scan input into variable n
    LDR r0, =formatInt
    LDR r1, =n
    BL scanf

    # Load n value into r0 and call F
    LDR r0, =n
    LDR r0, [r0, #0]
    BL F

    # Print result
    MOV r1, r0 @ Move reslut into r1
    LDR r0, =resultMsg
    BL printf

    # Pop the stack
    LDR lr, [sp, #0]
    ADD sp, sp, #4
    MOV pc, lr

.data
    promptN:    .asciz "Enter a value for n: "
    resultMsg:  .asciz "The Fibonacci number is %d\n"
    formatInt:  .asciz "%d"
    n:          .word 0
