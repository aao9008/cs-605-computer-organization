# Program Name: main.s
# Author: Alfredo Ormeno Zuniga
# Date: 7/13/2025
# Purpose: This program reads input values from the user, performs the conversions using
#          functions defined in libConversions.s, and displays the results.
# Functions:
#   main – Coordinates input/output and calls unit conversion functions
# Inputs:
#   - Miles (for speed calculation & distance conversion)
#   - Hours (for speed calculation)
#   - Celsius (for temperature conversion)
#   - Inches (for length conversion)
# Outputs:
#   - Kilometers 
#   - Kilometers per hour (kph)
#   - Temperature in Fahrenheit
#   - Length in feet
.text
.global main
main:
    # Push stack
    SUB sp, sp, #4
    STR lr, [sp, #0]
    
    #################### Part 1: Convert miles to km using integer math ###################
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
    
    # Store output in preserved register 
    MOV r4, r0 @ r4 <- r0 (kilometers)

    # Display result
    # Print output message
    LDR r0, =output1
    BL printf 

    # Append final result to the end of the output message
    MOV r0, r4 @ r0 <- r4 (kilometers)
    MOV r1, #10 @ Scale value used to format scaled integer reslut to decimal number with 1 point precision
    BL printScaledInt

    # Print new line character to move cursor to next line
    LDR r0, =newline
    BL printf

    ################## Part 2: Convert miles and hours to kph #####################
    # Prompt user for hours and miles
    LDR r0, =prompt2
    BL printf

    # Scan user input (hours and miles)
    LDR r0, =format2
    LDR r1, =input2Hours
    LDR r2, =input2Miles
    BL scanf

    # Convert hours and miles to kph
    LDR r0, =input2Hours
    LDR r0, [r0, #0]
    LDR r1, =input2Miles
    LDR r1, [r1, #0]
    BL kph

    # Display the converted value
    MOV r4, r0
    LDR r0, =output2Part1
    BL printf

    MOV r0, r4
    MOV r1, #10
    BL printScaledInt

    LDR r0, =output2Part2
    BL printf

    ################## Part 3: Convert temprature from Celsius to Fahrenheit #####################
    # Prompt user for temprature in Celsius
    LDR r0, =prompt3
    BL printf

    # Scan user input (temprature)
    LDR r0, =format3
    LDR r1, =input3Temprature
    BL scanf

    # Load user input into r0
    LDR r0, =input3Temprature @ Load address of user input
    LDR r0, [r0, #0] @ Load temprature value located at this address
    BL CToF

    # Display Results
    MOV r1, r0
    LDR r0, =output3
    BL printf

    # Pop stack and return
    LDR lr, [sp, #0]
    ADD sp, sp, #4
    MOV pc, lr

.data
    # Part 1 Variables
    format1: .asciz "%d"
    input1Miles: .word 0
    newline: .asciz "\n\n"
    output1: .asciz "Distance in kilometers is "
    prompt1: .asciz "Please enter miles (integers only) for conversion to kilometers: "
    
    # Part 2 Variables
    format2: .asciz "%d%d"
    input2Hours: .word 0
    input2Miles: .word 0
    output2Part1: .asciz "The converted velocity is approximately "
    output2Part2: .asciz " kph.\n\n"
    prompt2: .asciz "Pleaes enter hours then miles (integers only) for conversion to kilometers per hour: "

    # Part 3 Variables
    format3: .asciz "%d"
    input3Temprature: .word 0
    output3: .asciz "The converted temprature is %d degrees Fahrenheit.\n"
    prompt3: .asciz "Please enter a temprature (integers only) in Celsius: "

     