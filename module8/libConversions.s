#
# Program Name: libConversions.s
# Author: Alfredo Ormeno Zuniga
# Date: 7/13/2025
# Purpose: This file contains utility functions for performing unit conversions.
# Functions:
#   CToF - Coverts temprature from Celsius to Fahrenheit
#   InchesToFt - Converts inches to feet
#   kph - Calculates velocity (km/h) from miles and hours
#   miles2Kilometers- Converts distance from miles to kilometers
#   printScaledInt - Prints an integer-scaled value in decimal format
#                    with 1 decimal point of precision.
# Inputs: Varies by function (see function descriptions)
# Outputs: Varies by function (see function descriptions)

# Function: printScaledInt
# Purpose: to print a scaled integer value
# with the decimal point in the
# correct place
#
# Input: r0 - value to print
#        r1 - scale in
#
# Output: r0 - pointer to string that contains
#              the converted value
# Adapted from: 
#   Kann, Charles W., "Introduction to Assembly Language Programming: From Soup to Nuts: ARM Edition" (2021). Open Educational Resources. 8.
#   https://cupola.gettysburg.edu/oer/8
.text
.global printScaledInt
printScaledInt:
    # push
    SUB sp, #12
    STR lr, [sp, #0]
    STR r4, [sp, #4]
    STR r5, [sp, #8]
    MOV r4, r0
    MOV r5, r1

    # get whole part and save in r7
    bl __aeabi_idiv // r0/r1, result in r0
    MOV r6, r0
    #get decimal part and save in r7
    MUL r7, r5, r6
    SUB r7, r4, r7

    # print the whole part
    LDR r0, = __PSI_format
    MOV r1, r6
    bl printf

    # print the dot
    LDR r0, = __PSI_dot
    bl printf

    # print the decimal part
    LDR r0, = __PSI_format
    MOV r1, r7
    bl printf

    # pop and return
    LDR lr, [sp, #0]
    LDR r4, [sp, #4]
    LDR r5, [sp, #8]
    ADD sp, #12
    MOV pc, lr

.data
    __PSI_format: .asciz "%d"
    __PSI_dot: .asciz "."
# end printScaledInt

# Function: miles2Kilometers
# Purpose: To convert an miles (int) to kilometers (integer) using integer math. 
# Input: r0 - miles (integer)
# Output: r0 - kilometers (integer)
# Pseduo Code: 
#   kilometers  = (miles * 161) / 10
#   
#   Note: We multiply by 161 and divide by 10 to approximate to one deicaml
#         without using floating point. This keeps the math entirely in integers.
#         Greater precision can be achieved by scaling up further, e.g. using
#         (miles * 1610) / 10 to preserve more decimal places.
.text
.global miles2Kilometers
miles2Kilometers:
    # Push stack
    SUB sp, sp, #4
    STR lr, [sp, #0]

    # Multiply miles by 161
    MOV r1, #161 @ Multiplier for integer approximation of 1.61
    MUL r0, r0, r1 @ r0 <- r0 (miles) * r1 (161)

    # Divid result of multiplcation operation by 100
    MOV r1, #10 @ r1 <- 10 (divisor)
    BL __aeabi_idiv

    # Pop stack and return
    LDR lr, [sp, #0]
    ADD sp, sp, #4
    MOV pc, lr
# END miles2Kilometers

# Function: kph
# Purpose: To calculate kilometers per hour (kph) using integer math.
# Input: r0 - hours (integer)
#        r1 - miles (integer)
# Output: r0 - kph (scaled integer)
# Pseudo Code:
#   kilometers = miles2Kilometers(miles)
#   kph = kilometers / hours
#
#   Uses the miles2Kilometers function to perform the conversion.
#   The result is an integer approximation of speed in kilometers per hour.
.text
.global kph
kph:
    # Push stack
    SUB sp, sp, #12
    STR lr, [sp, #0]
    STR r4, [sp, #4]
    STR r5, [sp, #8]

    # Copy hours and miles into preserved registers
    MOV r4, r0 @ r4 <- r0 (hours)
    MOV r5, r1 @ r5 <- r1 (miles)

    # Convert miles to kilometers
    MOV r0, r1 @ r0 <- r1 (miles)
    BL miles2Kilometers @ r0 will hold result of conversion (kilometers)

    # Divide kilometers by hours to get velociy (km/h)
    MOV r1, r4 @ r1 <- r4 (hours)
    BL __aeabi_idiv @ r0 (kph) <- r0 (kilometers) / r1 (hours)

    # Pop stack and return
    LDR lr, [sp, #0]
    LDR r4, [sp, #4]
    LDR r5, [sp, #8]
    ADD sp, sp, #12
    MOV pc, lr
# END kph

# Function: CToF
# Purpose: To convert a temperature from Celsius to Fahrenheit
# Input: r0 - temperature in Celsius (integer)
# Output: r0 - temperature in Fahrenheit
# Pseudo Code:
#   fahrenheit = (celsius * 9) / 5 + 32
#
#   Uses integer math for conversion, resulting in an approximate Fahrenheit value.
.text
.global CToF
CToF:
    # Push stack
    SUB sp, sp, #4
    STR lr, [sp, #0]

    # First temperature (celcius) by 9
    MOV r1, #9 @ Move the immediate value of 9 into r3
    MUL r0, r0, r1 @ Multiply the temp by 9 ( r1 <- r2 * r3)

    # Divide the temprature by 5
    # r0 holds the current result and is the numberator. No changes needed.
    MOV r1, #5 @ r1 is the denomenator, so move immediate value 5 into r1
    BL __aeabi_idiv @ Divide the temprature by 5 and store result in r0 (r0 <- r0/r1)
   

    # Add 32 to the temprature to get final temprature value in Fahrenheit
    Add r0, r0, #32

    # Pop stack and return
    LDR lr, [sp, #0]
    ADD sp, sp, #4
    MOV pc, lr
# END CToF

# Function: InchesToFt
# Purpose: To convert a length in inches to feet, scaled to preserve one decimal place.
# Input: r0 - length in inches (integer)
# Output: r0 - length in feet scaled by 10 (integer)
# Pseudo Code:
#   scaled_feet = (inches * 10) / 12
#
#   This allows the result to retain 1 digit of decimal precision using only integer math.
#   The result can be printed using the printScaledInt function with a scale factor of 10.
.text
.global InchesToFt
InchesToFt:
    # Push stack
    SUB sp, #4
    STR lr, [sp, #0]
    
    # Multiply inches by scale factor of 10
    MOV r1, #10 @ r1 <- 10 (scale factor; MUL has no immediate format)
    MUL r0, r0, r1 @ r0 <- r0 (inches) * 10 (scale factor) ; this will give one decmial place of accuracy

    # Divide the scaled inches by 12 to get the scaled feet
    MOV r1, #12 @ r1 is the divisor in divsison function, move 12 into r1 
    BL __aeabi_idiv @ r0 (scaled feet) <- r0 (scaled inches) / r1 (12)

    # Pop the stack
    LDR lr, [sp, #0]
    ADD sp, sp, #4
    MOV pc, lr 
# END InchesToFt
