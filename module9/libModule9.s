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
    MOVGE r2, #1 @ If r0 >= 65, move 1 (true) into r2 

    # Check if input <= 'Z' (90)
    MOV r3, #0 @ r3 will hold result of input <= 'Z' check.
    MOV r1, #90 @ Move ascii value of 'Z' into r1 for comparison
    CMP r0, r1 @ Compare r0 (user input) and r1 ('Z' char ascii value)
    MOVLE r3, #1 @ If r0 <= 90, move 1 (true) into r3

    # AND r2 & r3 to check if 'A' <= input <= 'Z'
    AND r4, r2, r3

    # Step 2: Check if input >= 'a' && input <= 'z'
    # Check if input >= 'a' (97)
    MOV r2, #0 @ r2 will hold result of input >= 'a' check. 
    MOV r1, #97 @ Move ascii value of 'a' into r1 for comparison
    CMP r0, r1 @ Compare r0 (user input) and r1 ('a' ascii value)
    MOVGE r2, #1 @ If r0 >= 97, move 1 (true) into r2

    # Check if input <= 'z' (122)
    MOV r3, #0 @ r3 will hold result of input <= 'z' check. 
    MOV r1, #122 @ Move ascii value of 'z' int r1 for comparison
    CMP r0, r1 @ Compare r0 (user input) and r1 ('z' ascii value)
    MOVLE r3, #1 @ If r0 <= 122, move 1 (true) into r3

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
    MOV r1, #65 @ r1 = 'A'
    CMP r0, r1
    BLT checkLowercase @ if input < 'A', skip uppercase check

    MOV r1, #90 @ r1 = 'Z'
    CMP r0, r1
    BLE returnTrue @ if input <= 'Z', return 1

    checkLowercase:
    MOV r1, #97 @ r1 = 'a'
    CMP r0, r1
    BLT returnFalse @ if input < 'a', not alphabetic

    MOV r1, #122 @ r1 = 'z'
    CMP r0, r1
    BLE returnTrue @ if input <= 'z', return 1

    returnFalse:
    MOV r0, #0
    B endIf

    returnTrue:
    MOV r0, #1
    B endIf

    endIf:

    # Pop stack and return
    LDR lr, [sp, #0]
    ADD sp, sp, #4
    MOV pc, lr
# END isAlphaNoLogical

# Function: gradeStudent
# Purpose: Prompt for a student's name and average, validate the average, 
#          assign a letter grade based on the average, and print the result.
#          If the average is out of range, print an error message.
#
# Input:  None (input is taken via scanf)
# Output: Prints result in the format:
#         "[name] received a grade of [A/B/C/F]\n"
#         or an error message if the average is invalid.
#
# Pseudo Code:
#   void gradeStudent() {
#       prompt("Enter name: ");
#       scanf("%s", name);
#
#       prompt("Enter average: ");
#       scanf("%d", &average);
#
#       if (average <= 0 || average >= 100) {
#           print("Invalid input.\n");
#           return;
#       }
#
#       if (average >= 90) grade = 'A';
#       else if (average >= 80) grade = 'B';
#       else if (average >= 70) grade = 'C';
#       else grade = 'F';
#
#       printf("%s received a grade of %c\n", name, grade);
#   }
.text
.global gradeStudent
gradeStudent:
    # Push stack
    SUB sp, sp, #8
    STR lr, [sp, #0]
    STR r4, [sp, #4]

    # Prompt for student name
    LDR r0 , =promptName
    BL printf

    # Scan for student name 
    LDR r0, =formatName
    LDR r1, =inputName
    BL scanf

    # Prompt for average grade
    LDR r0, =promptGrade
    BL printf

    # Scan for average grade
    LDR r0 , =formatGrade
    LDR r1, =inputGrade
    BL scanf

# Print student grade
# if block
    # Load average grade value into r4
    LDR r4, =inputGrade
    LDR r4, [r4, #0]

    # check 0 <= grade <= 100
    MOV r2, #0 @ r2 holds result of logical operation
    MOV r0, #0
    CMP r4, r0
    MOVGE r2, #1

    MOV r3, #0
    MOV r0, #100
    CMP r4, r0
    MOVLE r3, #1

    AND r0, r2, r3 @ AND results of each logical operation to get final result
    MOV r1, #1 @ r1 will be used to check if r0 is true
    CMP r0, r1
    BEQ GradeA @ Grade is vailid. Branch to if else statmetns, skip invalid grade code block. 

    # Code block for invalid grade 
    LDR r0, =promptInvalidGrade
    BL printf 
    B EndIf 

    GradeA:
    # Print Student's name, student name will print regardless of grade
    LDR r0, =outputName
    LDR r1, =inputName
    BL printf 

    # Check if grade < 90
    MOV r0, #90
    CMP r4, r0
    BLT GradeB @ Branch to Grade B if grade < 90
    
    # Grade A code block
    LDR r0, =gradeA
    BL printf
    B EndIf

    GradeB:
    # Check if grade < 80
    MOV r0, #80
    CMP r4, r0
    BLT GradeC

    # Grade B code block
    LDR r0, =gradeB
    BL printf
    B EndIf

    GradeC:
    # Check if grade < 70
    MOV r0, #70
    CMP r4, r0
    BLT GradeD

    # Grade C code block
    LDR r0, =gradeC
    BL printf
    B EndIf

    GradeD:
    # Check if grade < 60
    MOV r0, #60
    CMP r4, r0
    BLT Else

    # Grade D code block
    LDR r0, =gradeD
    BL printf
    B EndIf

    Else:
    # Grade F code block
    LDR r0, =gradeF
    BL printf

    EndIf:
    # Pop stack
    LDR lr, [sp, #0]
    LDR r4, [sp, #4]
    ADD sp, sp, #8
    MOV pc, lr 
# END gradeStudent



.data
    formatGrade: .asciz "%d"
    formatName: .asciz "%[^\n]"
    gradeA: .asciz "Grade is A\n"
    gradeB: .asciz "Grade is B\n"
    gradeC: .asciz "Grade is C\n"
    gradeD: .asciz "Grade is D\n"
    gradeF: .asciz "Grade is F\n"
    inputGrade: .word 0
    inputName: .space 100
    outputName: .asciz "\nStudent Name: %s\n"
    promptInvalidGrade: .asciz "Invalid Input. Grade must be 0 <= grade <= 100\n"
    promptName: .asciz "Enter student's name: "
    promptGrade: .asciz "Enter average grade (integers only): "
    