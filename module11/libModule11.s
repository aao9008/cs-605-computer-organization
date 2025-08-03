#
# Program Name: libModule11.s
# Author: Alfredo Ormeno Zuniga
# Date: 7/25/2025
# Purpose:
#   This file demonstrates recursion in ARM assembly by implementing two functions:
#     - F:     Computes the n-th Fibonacci number using recursive calls.
#     - Mult:  Computes the product of two integers using recursive addition.
#
# Description:
#   - These recursive functions showcase how stack frames and branching are handled
#     in low-level recursive function calls in ARM assembly.
#   - The Fibonacci function implements the classic recursive definition:
#       F(n) = F(n-1) + F(n-2), with base cases F(0) = 0, F(1) = 1.
#   - The Mult function implements recursive multiplication as:
#       Mult(a, b) = a + Mult(a, b-1), with base case Mult(a, 0) = 0.
#
# Functions:
#   - F:       Computes the n-th Fibonacci number.
#   - Mult:    Computes a × b using recursive addition.
#

#
# Function: F
# Purpose:
#   Computes the n-th Fibonacci number recursively.
#
# Input:
#   r0 - integer n (the position in the Fibonacci sequence)
#
# Output:
#   r0 - result F(n), the n-th Fibonacci number
#
# Pseudo Code:
#   int F(int n) {
#       if (n == 0)
#           return 0;
#       else if (n == 1)
#           return 1;
#       else
#           return F(n - 1) + F(n - 2);
#   }
#
.text
.global F
F:
    # Program dictionary
    #   r0 - passed argument (n) and return value once fucntion exits
    #   r4 - n (passed argument)

    # Push the stack 
    SUB sp, sp, #16
    STR lr, [sp, #0]
    STR r4, [sp, #4]
    STR r5, [sp, #8]
    STR r6, [sp, #12]

    # Perserve passed argument (n)
    MOV r4, r0

    # Base case if n == 0
    CMP r4, #0
    BNE returnOne
        MOV r0, #0 @ r0 <- 0
        B endF @ return 0

    returnOne:
    # Base case if (n == 1)
    CMP r4, #1
    BNE recurseFib
        MOV r0, #1 @ r0 <- 1
        B endF @ return 1

    recurseFib:
        # Call F(n - 1)
        MOV r0, r4
        SUB r0, r0, #1
        BL F
        MOV r5, r0 @ r1 = F(n-1)

        # Call F(n-2)
        MOV r0, r4
        SUB r0, r0, #2
        BL F 
        MOV r6, r0

        # F(n - 1) + F(n - 2)
        ADD r0, r5, r6 
    
    endF:
    # Pop the stack
    LDR lr, [sp, #0]
    LDR r4, [sp, #4]
    LDR r5, [sp, #8]
    LDR r6, [sp, #12]
    ADD sp, sp, #16
    MOV pc, lr
# END F

#
# Function: Mult
# Purpose:
#   Performs multiplication using recursion and successive addition.
#   Mult(m, n) = m + m + ... + m (n times)
#
# Inputs:
#   r0 - multiplier (m)
#   r1 - number of times to add (n)
#
# Outputs:
#   r0 - result of m * n
#
# Pseudocode:
# int Mult(int m, int n, bool isNegativeFlag) {
#     bool isNegative = false;
#
#     if (n < 0) {
#         isNegative = true;
#         n = -n;
#     }
#
#     // Base case
#     if (n == 1) {
#         result = m;
#     } else {
#         result = m + Mult(m, n - 1);
#     }
#
#     if (isNegative) {
#         result = -result;
#     }
#
#     return result;
# }
#
.text
.global Mult
Mult:
    # Push the stack
    SUB sp, sp, #12
    STR lr, [sp, #0]
    STR r4, [sp, #4]
    STR r5, [sp, #8]

    # Perserve the value of m
    MOV r4, r0

    # Initialize isNegativeFlag to 0
    MOV r5, #0

    CMP r1, #0
    BGE checkBaseCase @ If n >= 0, skip negation setup

    # n is negative: set a flag and make n positive
    MOV r5, #1 @ r2 will hold the "isNegative" flag
    RSB r1, r1, #0 @ r1 = -r1

    checkBaseCase:
    # if (n == 1)
    CMP r1, #1
    BNE recurseMult
        B maybeNegateResult @ return m (r0)
    
    recurseMult:
        SUB r1, r1, #1 @ r1 <- n - 1
        BL Mult @ Call Mult(m, n-1)
        ADD r0, r4, r0 @ r0 <- m + Mult(m, n-1)

    maybeNegateResult:
    CMP r5, #1
    BNE endMult
    RSB r0, r0, #0 @ r0 = -r0

    endMult:
    # Pop the stack
    LDR lr, [sp, #0]
    LDR r4, [sp, #4]
    LDR r5, [sp, #8]
    ADD sp, sp, #12
    MOV pc, lr
# END Mult





