#
# Program Name: libConversions.s
# Author: Alfredo Ormeno Zuniga
# Date: 7/19/2025
# Purpose: This file contains utility functions for demonstrating branching and logical operations in ARM. 
# Functions:
#   isAlphaLogical - Checks if use input value is a character or not
#  
# Inputs: Varies by function (see function descriptions)
# Outputs: Varies by function (see function descriptions)

# Function: isAlphaLogical
# Purpose: To check if user input is a character using logical operators.
#
# Input: r0 - user input value    
# Output: r0 - boolean (True - input value is a character, False - input value is not a character)
#
# Pseudo Code: 
#   int is_alpha_logical(char c) {
#       if ((c >= 'A' && c <= 'Z') || (c >= 'a' && c <= 'z'))
#           return 1;
#       else
#           return 0;
#   }
.text
.global isAlphaLogical
isAlphaLogical:
    # Push stack
    SUB sp, sp, #12
    STR lr, [sp, #0]
    STR r4, [sp, #4]
    STR r5, [sp, #8]

    # Step 1: Check if input >= 'A' && input <= 'Z'
    # Check if input >= 'A' (65)
    MOV r2, #0 @ r2 will hold result of input >= 'A' check. 
    MOV r1, #65 @ move ascii value of 'A' into r1 for comparison
    CMP r0, r1 @ Compare r0 (user input) and r1 ('A' char ascii value)
    movge r2, #1 @ If r0 >= 65, move 1 (true) into r2 

    # Check if input <= 'Z' (90)
    MOV r3, #0 @ r3 will hold result of input <= 'Z' check.
    MOV r1, #90 @ Move ascii value of 'Z' into r1 for comparison
    CMP r0, r1 @ Compare r0 (user input) and r1 ('Z' char ascii value)
    movle r3, #1 @ If r0 <= 90, move 1 (true) into r3

    # AND r2 & r3 to check if 'A' <= input <= 'Z'
    AND r4, r2, r3

    # Step 2: Check if input >= 'a' && input <= 'z'
    # Check if input >= 'a' (97)
    MOV r2, #0 @ r2 will hold result of input >= 'a' check. 
    MOV r1, #97 @ Move ascii value of 'a' into r1 for comparison
    CMP r0, r1 @ Compare r0 (user input) and r1 ('a' ascii value)
    movge r2, #1 @ If r0 >= 97, move 1 (true) into r2

    # Check if input <= 'z' (122)
    MOV r3, #0 @ r3 will hold result of input <= 'z' check. 
    MOV r1, #122 @ Move ascii value of 'z' int r1 for comparison
    CMP r0, r1 @ Compare r0 (user input) and r1 ('z' ascii value)
    movle r3, #1 @ If r0 <= 122, move 1 (true) into r3

    # AND r2 & r3 to check if 'a' <= input <= 'z'
    AND r5, r2, r3

    # Step 3: Combine uppercase and lowercase checks
    # If input is either uppercase (r4 = 1) or lowercase (r5 = 1), r0 = 1
    # If neither, r0 = 0
    ORR r0, r4, r5 

    # Pop stack
    LDR lr, [sp, #0]
    LDR r4, [sp, #4]
    LDR r5, [sp, #8]
    ADD sp, sp, #12
    MOV pc, lr
# END isAlphaLogical

# Function: isAlphaNoLogical
# Purpose: To check if user input is an alphabetic character using only comparisons and branches,
#          without using any logical operators.
#
# Input: r0 - user input value    
# Output: r0 - boolean (True - input value is a character, False - input value is not a character)
#
# Pseudo Code: 
#   int isAlphaNoLogical(char c) {
#       if (c >= 'A') {
#           if (c <= 'Z') {
#               return 1;
#           }
#       }
#       if (c >= 'a') {
#           if (c <= 'z') {
#               return 1;
#           }
#       }
#       return 0;
#   }
.text
.global isAlphaNoLogical
isAlphaNoLogical:
    # Push stack
    SUB sp, sp, #4
    STR lr, [sp, #0]

    @ Step 1: Check if 'A' <= r0 <= 'Z'
    mov r1, #65 @ r1 = 'A'
    cmp r0, r1
    blt checkLowercase @ if input < 'A', skip uppercase check

    mov r1, #90 @ r1 = 'Z'
    cmp r0, r1
    ble returnTrue @ if input <= 'Z', return 1

    checkLowercase:
    mov r1, #97 @ r1 = 'a'
    cmp r0, r1
    blt returnFalse @ if input < 'a', not alphabetic

    mov r1, #122 @ r1 = 'z'
    cmp r0, r1
    ble returnTrue @ if input <= 'z', return 1

    returnFalse:
    mov r0, #0
    b endIf

    returnTrue:
    mov r0, #1
    b endIf

    endIf:

    # Pop stack and return
    LDR lr, [sp, #0]
    ADD sp, sp, #4
    MOV pc, lr
# END isAlphaNoLogical
