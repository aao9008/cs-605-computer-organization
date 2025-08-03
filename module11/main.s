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

    #-------------Fibonnaci Function Test-------------
    # Display function msg
    LDR r0, =msg1
    BL printf

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
    LDR r0, =resultMsg1
    BL printf

    #----------------MULT Function Test---------------
     # Display function msg
    LDR r0, =msg2
    BL printf

    # Prompt for m
    LDR r0, =promptM
    BL printf

    # Scan input into variable m
    LDR r0, =formatInt
    LDR r1, =m
    BL scanf

    # Prompt for n
    LDR r0, =promptN
    BL printf

    # Scan input into variable n
    LDR r0, =formatInt
    LDR r1, =n
    BL scanf

    # Load M & n value into r0 & r1 and call Mult
    LDR r0, =m
    LDR r0, [r0, #0]
    LDR r1, =n
    LDR r1, [r1, #0]
    BL Mult

    # Print result
    MOV r1, r0 @ Move reslut into r1
    LDR r0, =resultMsg2
    BL printf

    # Pop the stack
    LDR lr, [sp, #0]
    ADD sp, sp, #4
    MOV pc, lr

.data
    msg1: .asciz "This function will calculate the n-th Fibonnaci number.\n"
    msg2: .asciz "This function will caclulate the product of m and n.\n"
    promptM: .asciz "Enter a value for m: "
    promptN: .asciz "Enter a value for n: "
    resultMsg1: .asciz "The Fibonacci number is %d\n\n"
    resultMsg2: .asciz "The product is %d\n"
    formatInt: .asciz "%d"
    n: .word 0
    m: .word 0
