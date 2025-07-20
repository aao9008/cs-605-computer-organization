# Program Name: main.s
# Author: Alfredo Ormeno Zuniga
# Date: 7/19/2025
# Purpose: 
#   This program performs several tasks involving user input and logical evaluation.
#   It demonstrates the use of external functions written in libModule9.s by:
#     - Checking if a user-input character is alphabetic using both logical and non-logical methods
#     - Prompting the user for a student's name and average, and printing the corresponding letter grade
#     - Prompting the user for three integers and printing the maximum value
#
# Functions Called (from libModule9.s):
#   - isAlphaLogical:     Determines if a character is alphabetic using logical operations
#   - isAlphaNoLogical:   Determines if a character is alphabetic using only comparisons and branches
#   - gradeStudent:       Prompts for a student name and average, prints a grade or error
#   - findMaxOf3:         Returns the maximum of three integer values
#
# Inputs:
#   - A single character (used in both alphabetic checks)
#   - A student name (may include spaces)
#   - A student average (integer 0–100)
#   - Three integer values
#
# Outputs:
#   - A message indicating if the character is alphabetic
#   - The student's name and grade (or error if invalid)
#   - The maximum of three input values
.text
.global main
main:
    # Push stack
    SUB sp, sp, #4
    STR lr, [sp, #0]

#############Function isAlphaLogical##############
# Pseudo Code:
#   printf("isAlpha check will be done with logical operators.\n");
#   printf("Please enter a single character...\n");
#   scanf(" %c", &inputChar);
#
#   result = isAlphaLogical(inputChar);
#
#   if (result == 1) {
#       printf("The character '%c' is an alphabetical character.\n", inputChar);
#   } else {
#       printf("The character '%c' is NOT an alphabetical character.\n", inputChar);
#   }

    # Declare function being used
    LDR r0, =logical
    BL printf 

    # Prompt user for input (single character)
    LDR r0, =promptChar
    BL printf 

    # Scan user input (single character)
    LDR r0, =formatChar
    LDR r1, =inputChar
    BL scanf

    # Load user input (char)
    LDR r0, =inputChar
    LDRB r0, [r0, #0]
    
    # Call isAlphaLogical
    BL isAlphaLogical @ r0 holds 0 (flase) / 1 (true) value

    MOV r1, #0 @ r1 will hold false value for comparison to function output 
    CMP r0, r1
    BEQ LogicalFalse @ branch to flase statment if false
        # If true, output true statment
        LDR r0, =outputTrue
        LDR r1, =inputChar
        LDRB r1, [r1, #0]
        BL printf
        B LogicalEndIF @ branch to end of if code block 

    LogicalFalse:
        # False code block
        LDR r0, =outputFalse
        LDR r1, =inputChar
        LDRB r1, [r1, #0]
        BL printf

    LogicalEndIF:

##############Function isAlphaNoLogical##############
# Pseudo Code:
#   printf("isAlpha check will be done with no logical operators.\n");
#   printf("Please enter a single character...\n");
#   scanf(" %c", &inputChar);
#
#   result = isAlphaNoLogical(inputChar);
#
#   if (result == 1) {
#       printf("The character '%c' is an alphabetical character.\n", inputChar);
#   } else {
#       printf("The character '%c' is NOT an alphabetical character.\n", inputChar);
#   }

    # Declare functino being used
    LDR r0, =NoLogical
    BL printf

    # Prompt user for input (single character)
    LDR r0, =promptChar
    BL printf 

    # Scan user input (single character)
    LDR r0, =formatChar
    LDR r1, =inputChar
    BL scanf

    # Load user input (char)
    LDR r0, =inputChar
    LDRB r0, [r0, #0]
    
    # Call isAlphaNoLogical
    BL isAlphaNoLogical @ r0 holds 0 (flase) / 1 (true) value

    # Check if function returned true or false
    MOV r1, #0 @ r1 will hold false value for comparison to function output
    CMP r0, r1
    BEQ NoLogicalFalse @ Branch to flase code block if false
    # If true, output true statment 
    LDR r0, =outputTrue
    LDR r1, =inputChar
    LDRB r1, [r1, #0]
    BL printf
    B NoLogicalEndIF @ branch to end of if block

    # False code block
    NoLogicalFalse:
    LDR r0, =outputFalse
    LDR r1, =inputChar
    LDRB r1, [r1, #0]
    BL printf

    NoLogicalEndIF:

    ##################Function Grade Student################
    BL gradeStudent

    ####################Find max of 3 values################
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
    # Variables for isAlpha functions
    formatChar: .asciz " %c"
    inputChar: .byte 0
    logical: .asciz "isAlpha check will be done with logical operators.\n"
    NoLogical: .asciz "isAlpha check will be done with no logical operators.\n"
    outputTrue: .asciz "The character '%c' is an alphabetical character.\n\n"
    outputFalse: .asciz "The character '%c' is NOT an alphabetical character.\n\n"
    promptChar: .asciz "Please enter a single character.\nIf multiple characters are entered, only the first will be processed.\n"

    # Variables for max function
    format3Values: .asciz "%d%d%d"
    inputValue1: .word 0
    inputValue2: .word 0
    inputValue3: .word 0
    outputMax: .asciz "The max value is %d.\n"
    prompt3Values: .asciz "Please enter 3 integer values.\nThe max value will be printed.\n"
