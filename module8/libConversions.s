#
# Program Name: libConversions.s
# Author: Alfredo Ormeno Zuniga
# Date: 7/13/2025
# Purpose: This file contains utility functions for performing unit conversions.
# Functions:
#   CToF - Coverts temprature from Celsius to Fahrenheit
#   InchesToFt - Converts inches to feet
#   miles2Kilometers- Converts distance from miles to kilometers
#   kph - Calculates velocity (km/h) from miles and hours
# Inputs: Varies by function (see function descriptions)
# Outputs: Varies by function (see function descriptions)

# Function: miles2Kilometers
# Purpose: To convert an miles (int) to kilometers (integer) using integer math. 
# Input: r0 - miles (integer)
# Output: r0 - kilometers (integer)
# Pseduo Code: 
#   kilometers  = (miles * 161) / 100
#   
#   Note: We multiply by 161 and divide by 100 to approximate 1 mile = 1.61 km
#         without using floating point. This keeps the math entirely in integers.
#         Greater precision can be achieved by scaling up further, e.g. using
#         (miles * 1610) / 1000 to preserve more decimal places.

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
    MOV r1, #100 @ r1 <- 100 (divisor)
    BL __aeabi_idiv

    # Pop stack and return
    LDR lr, [sp, #0]
    ADD sp, sp, #4
    MOV pc, lr

# END miles2Kilometers
