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

    # Pop stack and return
    LDR lr, [sp, #0]
    ADD sp, sp, #4
    MOV pc, lr

.data
    format: .asciz "%d\n"

