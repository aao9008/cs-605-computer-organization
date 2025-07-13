# Program Name: main.s
# Author: Alfredo Ormeno Zuniga
# Date: 7/13/2025
# Purpose: This program reads input values from the user, performs the conversions using
#          functions defined in libConversions.s, and displays the results.
# Functions:
#   main – Coordinates input/output and calls unit conversion functions
# Inputs:
#   - Miles (for speed calculation)
#   - Hours (for speed calculation)
#   - Celsius (for temperature conversion)
#   - Inches (for length conversion)
# Outputs:
#   - Kilometers per hour (kph)
#   - Temperature in Fahrenheit
#   - Length in feet

.text
.global main
main:
    # Push stack
    SUB sp, sp, #4
    STR lr, [sp, #0]
    
    # Function 1: Convert miles to km using integer math
    # Prompt the user for miles
    LDR r0, =prompt1
    BL printf

    # Scanf - miles (user input)
    LDR r0, =format1
    LDR r1, =input1Miles
    BL scanf

    # Convert user input (miles) to kilometers
    LDR r0, =input1Miles @ miles2Kilometers takes the arugment miles through r0 
    LDR r0, [r0, #0] @ Load value located at this address
    BL miles2Kilometers @ Call the conversion function located in conversion library
    
    # Output result
    MOV r2, r0 @ Move the value returned by the function in r0 to r2
    LDR r1, =input1Miles @ Load address of original input into r1
    LDR r1, [r1, #0] @ Load value located at this address into r1
    LDR r0, =output1MilestoKilometers
    BL printf

    # Pop stack and return
    LDR lr, [sp, #0]
    ADD sp, sp, #4
    MOV pc, lr

.data
    prompt1: .asciz "Enter miles for conversion to kilometers: "
    output1MilestoKilometers: .asciz "%d miles is approximately %d kilometers.\n"
    format1: .asciz "%d"
    input1Miles: .word 0
    convertedDistance1: .word 0
