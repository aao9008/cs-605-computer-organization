#
# Program Name: main.s
# Author: Alfredo Ormeno Zuniga
# Date: 7/23/2025
# Purpose:
#   This file contains the main driver program for calling utility functions defined in the associated library file(s).
#   Specifically, it demonstrates two features:
#     - Listing all prime numbers up to a user-defined limit.
#     - Running a number guessing game where the user guesses a randomly generated number.
#
# Functions Called:
#   - listPrimes:      Prints all prime numbers from 3 to a user-defined upper limit n.
#   - guessNumber:     Allows user to guess a randomly generated number between 1 and a user-defined maximum.
#
# Inputs:
#   Prompts the user to enter an integer limit for listing prime numbers.
#   Prompts the user to enter a maximum value for the guessing range.
#
# Outputs:
#   Prints all prime numbers from 3 to the given limit.
#   Prompts and feedback messages throughout the guessing game.
#   Prints the number of guesses taken to guess the correct number.
.text
.global main
main:
    # Push the stack
    SUB sp, sp, #4
    STR lr, [sp, #0]

    # -------- Prompt for guessing game max --------
    MOV r0, #0
    BL time
    BL srand 

    LDR r0, =promptGuessMax
    BL printf

    LDR r0, =formatInt
    LDR r1, =guessMax
    BL scanf

    # Call guessNumber(guessMax)
    LDR r0, =guessMax
    LDR r0, [r0] @ r0 = value of guessMax
    BL guessNumber

    # Pop the stack
    LDR lr, [sp, #0]
    ADD sp, sp, #4
    MOV pc, lr

.data
    promptPrime: .asciz "Enter an upper limit to list primes: "
    promptGuessMax: .asciz "Enter a maximum value for the guessing game: "
    formatInt: .asciz "%d"
    guessMax: .word 0
