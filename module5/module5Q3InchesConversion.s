#
# Program Name: module5Q3InchesConversion.s
# Author: Alfredo Ormeno Zuniga
# Date: 6/21/2025
# Purpose: Convert between feet/inches and total inches using division and manual remainder.
#
.text
.global main
main:
    # Push stack
    SUB sp, sp, #4
    STR lr, [sp, #0]

    # Question 3: Part 1 - Feet and inches to inches conversion
    # Prompt user for input
    LDR r0, =prompt1
    BL printf

    # Scanf - user input (feet and inches)
    LDR r0, =format1
    LDR r1, =inputFeet
    LDR r2, =inputInches
    BL scanf

    # Load values from memory into registers
    LDR r1, =inputFeet
    LDR r1, [r1]
    LDR r2, =inputInches
    LDR r2, [r2]

    # Copy the feet input into r3
    MOV r3, r1

    # Convert feet to inches
    # Multiply the feet input by 12
    MOV r4, #12 @ Move the immediate value 12 into r3
    MUL r3, r3, r4 @ Multiply the feet input (r3) by 12 (r4). (r3 <- r3 * r4)

    # Add the result from the multiplication to the inches input
    ADD r3, r2, r3 @ Add the value of feet converted to inches and the inches input to get final value in inches (r3 <- r2 + r3)

    # Print final results of conversion (r1 = feet input, r2 = inches input, r3 = total inches)
    LDR r0, =output1
    BL printf

    # Question 3: Part 2 - Inches converted to feet and inches
    # Prompt user for inches input
    LDR r0, =prompt2
    BL printf

    # Scanf - user input (inches)
    LDR r0, =format2
    LDR r1, =inputInches
    BL scanf

    # Load values from memory into registers
    LDR r0, =inputInches
    LDR r0, [r0, #0]

    # Prepare to divide the total inches by 12 to get the number of whole feet
    # Move 12 (inches per foot) into r1 as the divisor
    MOV r1, #12

    # Divid r0 by r1 to get the number of feet
    # Result (quotient) will be placed in r0
    BL __aeabi_idiv

    # Store the quotient (number of feet) in r2 for later use
    MOV r2, r0  @ r2 = total feet

    # Now calculate the number of remaining inches (remainder)
    # Multiply the number of feet by 12 (r2 * 12) to get equivalent inches
    MUL r3, r0, r1  @ r3 = total feet * 12 (inches)

    # Reload the original inches input from memory (the original dividend)
    LDR r1, =inputInches
    LDR r1, [r1, #0]

    # Subtract (original inches - inches in whole feet) to get the leftover inches
    SUB r3, r1, r3  @ r3 = remainder (inches left after full feet)

    # Print the final result (r1 = original inches, r2 = feet, r3 = leftover inches)
    LDR r0, =output2
    BL printf

    # Pop stack and return
    LDR lr, [sp, #0]
    ADD sp, sp, #4
    MOV pc, lr

.data
    prompt1: .asciz "Please enter two integers to represent feet and inches.\nThe first number will repersent feet and the second number will repersent inches:\n"
    prompt2: .asciz "Please enter an integer to reperesent inches.\n"
    format1: .asciz "%d %d"
    format2: .asciz "%d"
    inputFeet: .word 0
    inputInches: .word 0
    output1: .asciz "%d Feet and %d inches is %d inches!\n\n"
    output2: .asciz "%d inches is %d feet and %d inches!\n"
