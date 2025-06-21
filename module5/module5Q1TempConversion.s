#
# Program Name: module5Q1TempConversion.s
# Author: Alfredo Ormeno Zuniga
# Date: 6/21/2025
# Purpose: Show Add, Subtract, Multiply,and Divide operations
#
.text
.global main
main:
    # Push stack
    SUB sp, sp, #4
    STR lr, [sp, #0]

    # Question 1: Part 1 - Celsius to Fahrenheit Convertor
    # Prompt user for temprature in Celsius
    LDR r0, =prompt1Celsius
    BL printf

    # Scanf - temprature (Celsius) input
    LDR r0, =format1
    LDR r1, =temprature1
    BL scanf

    # Convert temprature from Celsius to Fahrenheit
    # First multiply user input by 9
    LDR r1, =temprature1 @ load address of the user input
    LDR r1, [r1, #0] @ load the value located at that address
    MOV r2, #9 @ Move the immediate value of 9 into r3
    MUL r0, r1, r2 @ Multiply the user input by 9 ( r1 <- r2 * r3)

    # Divide the temprature by 5
    # r0 holds the current result and is the numberator. No changes needed.
    MOV r1, #5 @ r1 is the denomenator, so move immediate value 5 into r1
    BL __aeabi_idiv @ Divide the temprature by 5 and store result in r0 (r0 <- r0/r1)
   

    # Add 32 to the temprature to get final temprature value in Fahrenheit
    Add r1, r0, #32

    # Print the temprature in Celsius converted to Fahrenheit
    LDR r0, =output1CelsiusToFahrenheit @ Load conversion output string into r0
    MOV r2, r1 @ Move r1 to r2 for printing purposes
    LDR r1, =temprature1 @ Load the address of the user's orginal input
    LDR r1, [r1, #0] @ Load the value located at this address
    BL printf @ Print Celsius to Fahrenheit conversion results

    # Question 1: Part 2 - Fahrenheit to Celsius Convertor
    # Prompt the user for temprature in Fahrenheit
    LDR r0, =prompt1Fahrenheit
    BL printf

    # Scanf - temprature (Fahrenheit input)
    LDR r0, =format1
    LDR r1, =temprature1
    BL scanf

    # Convert temprature from Fahrenheit to Celsius
    # First subrtract 32 from the input
    LDR r0, =temprature1 @ Load the address of the user input
    LDR r0, [r0, #0] @ Load the value located at that address
    SUB r0, r0, #32 @ Subtract 32 from the temprature value (r0 <- r0 - 32)

    # Multiply the result by 5
    MOV r1, #5 @ MUL cannot use immediates. Move immediate value 5 into a register
    MUL r0, r0, r1 @ Multipy the current result by 5 (r0 <- r0 * r1)

    # Divide the result by 9
    # r0 holds the current result which is also the numerator. Nothing to do here
    MOV r1, #9 @ move immedate value 9 into r1 (the denomenator)
    BL __aeabi_idiv @ Divide reulst by 9 (r0 <- r0/r1)

    # Print the temprature in Fahrenheit converted to Celsisus
    MOV r2, r0 @ Move final result to r2 for printing
    LDR r0, =output1FahrenheitToCelsius @ Move address of final output string to r0
    LDR r1, =temprature1 @ Load address of temprature in Fahrenheit
    LDR r1, [r1, #0] @ Load value located at this address
    BL printf @ Print final results

    # Pop stack and return
    LDR lr, [sp, #0]
    ADD sp, sp, #4
    MOV pc, lr

.data
    # Variables for Question 1
    prompt1Fahrenheit: .asciz "Please enter a temprature (integers only) in Fahrenheit: "
    prompt1Celsius: .asciz "Please enter a temprature (integesr only) temprature in Celsius: "
    format1: .asciz "%d"
    temprature1: .word 0
    output1FahrenheitToCelsius: .asciz "The temprature %d degrees Fahrenheit is %d degrees Celsius.\n"
    output1CelsiusToFahrenheit: .asciz "The temprature %d degrees Celsius is %d degrees Fahrenheit.\n \n"
    