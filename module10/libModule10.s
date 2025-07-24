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

    # Set upper limit for inner loop (i/2)
    MOV r0, r5 @ r0 <- r5 (i)
    MOV r1, #2
    BL __aeabi_idiv
    MOV r8, r0 @ r8 <- i/2
    
    startInnerLoop:
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
    LDR r0, =formatInt
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
        BLT endRemainderLoop @ Exit loop if dividend < divisor 

        SUB r0, r0, r1 @ dividend -= divisor
        
        B startRemainderLoop @ Move to next iteration
    endRemainderLoop:

    # Pop stack
    LDR lr, [sp, #0]
    ADD sp, sp, #4
    MOV pc, lr
# END remainder

# Function: guessNumber
# Purpose: To allow the user to guess a randomly generated number between 1 and a user-defined maximum.
#          The program gives feedback ("Too high" / "Too low") after each guess and counts total attempts.
#
# Input:  r0 - maximum value (upper bound for random number generation)
#
# Output: Prints instructions and feedback after each guess.
#         At the end, prints the number of guesses taken to guess correctly.
#
# Pseudo Code:
#   void guessNumber(int max) {
#       int secret = random_between(1, max);
#       int guess = -1;            // initialize to a value not equal to secret
#       int attempts = 0;
#
#       while (guess != secret) {
#           printf("Enter your guess: ");
#           scanf("%d", &guess);
#           attempts++;
#
#           if (guess < secret)
#               printf("Too low\n");
#           else if (guess > secret)
#               printf("Too high\n");
#       }
#
#       printf("Correct! You guessed it in %d attempts.\n", attempts);
#   }
.text
.global guessNumber
guessNumber:
    # Push the stack
    SUB sp, sp, #16
    STR lr, [sp, #0]
    STR r4, [sp, #4]
    STR r5, [sp, #8]
    STR r6, [sp, #12]

    # Generate random number from 1 to max
    BL generateRandom @ result stored in r0
    MOV r4, r0 @ r4 <- r0 (secret)
    MOV r5, #0 @ r5 <- number of atttempts
    MOV r6, #0 @ r6 will hold user guess. Initialize to 0

    startGuessLoop:
        # Check if loop is complete (guess == secret)
        CMP r6, r4
        BEQ endGuessLoop

        # loop block
        LDR r0, =promptGuess
        BL printf

        # Scan for user guess (int)
        LDR r0, =formatInt
        LDR r1, =guess
        BL scanf

        # Increment attempts counter 
        ADD r5, r5, #1

        # Load guess value from memory
        LDR r6, =guess
        LDR r6, [r6, #0] @ Load guess value 

        # if guess == secret
        CMP r6, r4
        BEQ endGuessLoop     @ If correct, go to end
        
        # else if guess < secret
        CMP r6, r4 
        BGT else
            # Print too low
            LDR r0, =promptLow
            BL printf
            B startGuessLoop

        # else if guess > secret
        else: 
            # Print to high
            LDR r0, =promptHigh
            BL printf

        B startGuessLoop

    endGuessLoop:

    # Prompt correct guess message
    LDR r0, =promptCorrect
    MOV r1, r5
    BL printf

    # Pop the stack
    LDR lr, [sp, #0]
    LDR r4, [sp, #4]
    LDR r5, [sp, #8]
    LDR r6, [sp, #12]
    ADD sp, sp, #16
    MOV pc, lr
# END guessNumber

# Function: generateRandom
# Purpose: To generate a pseudo-random number between 1 and a given maximum value using the C library's rand() function.
#
# Input:  r0 - max (upper bound of random range, inclusive)
# Output: r0 - random integer between 1 and max (inclusive)
#
# Pseudo Code:
#   int generateRandom(int max) {
#       int r = rand(); // Get raw random number from 0 to RAND_MAX
#       r = r % max; // Restrict range to 0 to max-1 (no MOD operator — uses custom remainder)
#       return r + 1; // Shift to 1 to max
#   }
.text
generateRandom:
    # Push the stack
    SUB sp, sp, #8
    STR lr, [sp, #0]
    STR r4, [sp, #4]

    MOV r4, r0 @ r1 <- r0 (max)

    BL rand @ call C function rand()
    @ r0 now contains a random number

    @ scale it to 1..max (assume max is in r1)
    MOV r1, r4
    BL remainder  @ r0 = r0 % r1 

    ADD r0, r0, #1 @ shift from 0..(max-1) to 1..max
    
    # Pop stack 
    LDR lr, [sp, #0]
    LDR r4, [sp, #4]
    ADD sp, sp, #8
    MOV pc, lr
# END generateRandom

.data
    formatInt: .asciz "%d"
    guess: .word 0
    promptCorrect: .asciz "Correct! You guessed the right number in %d attempts!\n"
    promptGuess: .asciz "Please enter your guess (integers only): "
    promptHigh: .asciz "Too high\n\n"
    promptLow: .asciz "Too low\n\n"
