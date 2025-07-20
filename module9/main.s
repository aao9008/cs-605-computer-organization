# Program Name: main.s
# Author: Alfredo Ormeno Zuniga
# Date: 7/19/2025
# Purpose: This program reads input values from the user, performs various logical checks using
#          functions defined in libModule9.s, and displays the results.
# Functions:
#   main – Coordinates input/output and calls unit conversion functions
# Inputs:
#   - single character (for isAlpha character check).
# Outputs:
#   - Boolean
.text
.global main
main:
    # Push stack
    SUB sp, sp, #4
    STR lr, [sp, #0]

    # Test
    MOV r0, #100
    BL isAlphaNoLogical

    MOV r1, r0
    LDR r0, =format
    BL printf

    # Function Grade Student
    BL gradeStudent

    # Find max of 3 values
    # Prompt user for 3 int values
    LDR r0, =prompt3Values
    BL printf 

    # Scan for user input (3 int values)
    LDR r0, =format3Values
    LDR r1, =inputValue1
    LDR r2, =inputValue2
    LDR r3, =inputValue3
    BL scanf

    # Load user input values
    LDR r0, =inputValue1
    LDR r0, [r0, #0]
    LDR r1, =inputValue2
    LDR r1, [r1, #0]
    LDR r2, =inputValue3
    LDR r2, [r2, #0]

    # Call max function
    BL findMaxOf3
    MOV r1, r0 @ Move max value into r1

    # Print out max value (r1)
    LDR r0, =outputMax
    BL printf

    # Pop stack and return
    LDR lr, [sp, #0]
    ADD sp, sp, #4
    MOV pc, lr

.data
    format: .asciz "%d\n"

    # Variables for max function
    format3Values: .asciz "%d%d%d"
    inputValue1: .word 0
    inputValue2: .word 0
    inputValue3: .word 0
    outputMax: .asciz "The max value is %d.\n"
    prompt3Values: .asciz "Please enter 3 integer values.\nThe max value will be printed.\n"

