#
# Program Name: libModule10.s
# Author: Alfredo Ormeno Zuniga
# Date: 7/23/2025
# Purpose:
#   This file contains utility functions for identifying and printing prime numbers
#   within a specified range in ARM Assembly.
#   These functions are intended to be called from a main driver program.
#
# Functions:
#   - listPrimes:   Prints all prime numbers from 3 up to a given integer n.
#
# Internal Functions:
#   - remainder:    Computes the remainder of two integers using subtraction (no MOD operator).
#                   Not accessible from outside this file.
#
# Inputs:
#   Vary by function — see individual function headers for specific usage.
#
# Outputs:
#   Vary by function — see individual function headers for specific usage.

# Function: listPrimes
# Purpose: To print all prime numbers from 3 up to the input value using subtraction-based division checks.
#
# Input:  r0 - upper limit (inclusive) for prime number search
# Output: Prints all prime numbers from 3 to r0 (comma-separated)
#
# Pseudo Code:
#   void listPrimes(int n) {
#       for (int i = 3; i <= n; i++) {
#           int is_prime = 1;
#           for (int j = 2; j <= i / 2; j++) {
#               if (remainder(i, j) == 0) {
#                   is_prime = 0;
#                   break;
#               }
#           }
#           if (is_prime) {
#               printf("%d, ", i);
#           }
#       }
#   }
.text
.global listPrimes
listPrimes:
    # Push the stack
    SUB sp, sp, #24
    STR lr, [sp, #0]
    STR r4, [sp, #4]
    STR r5, [sp, #8]
    STR r6, [sp, #12]
    STR r7, [sp, #16]
    STR r8, [sp, #20]

    MOV r4, r0 @ r4 = n (upper limit)
    MOV r5, #3 @ Initialize outer iterator (i = 3)
    
    startOuterLoop:
    CMP r5, r4
    BGT endOuterLooop @ if i > n, exit

    MOV r6, #1 @ isPrime(r6) = 1; assume i is prime
    MOV r7, #2 @ j = 2 (initialize inner loop iterator)
    # r8 = r5/2 (i/2)

    startInnerLooop:
        CMP r7, r8
        BGT endInnerLoop @ if j > i/2, exit

        MOV r0, r5 @ dividend = i
        MOV r1, r7 @ divisor = j
        BL remainder @ call custom remainder function

        CMP r0, #0
        BNE skipSetNotPrime

        MOV r6, #0 @isPrime = false (i is divisible by j)
        
        skipSetNotPrime:
        ADD r7, r7, #1 @ Increment j 
        CMP r6, #0 @ Check isPrime boolean flag
        BEQ endInnerLoop @ If isPrime is false, break early
        B startInnerLoop
        
    endInnerLoop:
       
    # Check if i is a prime number
    CMP r6, #1
    BNE nextIteration  @ if isPrime != 1, skip printing

    # Print out prime number i
    MOV r0, =formatInt
    MOV r1, r5
    BL printf

    nextIteration:
    # Increment iterator i and branch to start of outer loop
    ADD r5, r5, #1
    B startOuterLoop

    endOuterLooop:

    # Pop stack
    LDR lr, [sp, #0]
    LDR r4, [sp, #4]
    LDR r5, [sp, #8]
    LDR r6, [sp, #12]
    LDR r7, [sp, #16]
    LDR r8, [sp, #20]
    ADD sp, sp, #24
    MOV pc, lr 
# END listPrimes

# Function: remainder
# Purpose: To compute the remainder of two positive integers.
#
# Input:  r0 - dividend (numerator)
#         r1 - divisor  (denominator)
#
# Output: r0 - remainder (dividend % divisor)
#
# Pseudo Code:
#   int remainder(int dividend, int divisor) {
#       while (dividend >= divisor) {
#           dividend = dividend - divisor;
#       }
#       return dividend;
#   }
.text
remainder:
    # Push stack
    SUB sp, sp, #4
    STR lr, [sp, #0]

    startRemainderLoop:
        # Loop: while (dividend >= divisor) 
        CMP r0, r1
        BLT endLoop @ Exit loop if dividend < divisor 

        SUB r0, r0, r1 @ dividend -= divisor
        
        B startRemainderLoop @ Move to next iteration
    endRemainderLoop:

    # Pop stack
    LDR lr, [sp, #0]
    ADD sp, sp, #4
    MOV pc, lr
# END remainder


