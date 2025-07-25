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

    # -------- Prompt for prime upper limit --------
    input_loop:
        LDR r0, =promptPrime
        BL printf

        LDR r0, =formatInt
        LDR r1, =primeLimit
        BL scanf

        # Load the entered number into r0
        LDR r0, =primeLimit
        LDR r0, [r0] @ r0 = *primeLimit

        @ if r0 < 3
        MOV r1, #3
        CMP r0, r1
        BLT print_error @ If input < 3, print error and loop
            # Valid input: call listPrimes
            BL listPrimes
            B end_input @ Exit the loop

        print_error:
            LDR     r0, =errorMsg
            BL      printf
            B       input_loop  @ Go back and prompt again
    end_input:

    # -------- Prompt for guessing game max --------
    MOV r0, #0
    BL time
    BL srand

    guess_input_loop:
        LDR r0, =promptGuessMax
        BL printf

        LDR r0, =formatInt
        LDR r1, =guessMax
        BL scanf

        # Load guessMax into r0
        LDR r0, =guessMax
        LDR r0, [r0] @ r0 = *guessMax

        # Check if r0 <= 1
        MOV r1, #2
        CMP r0, r1
        BLT guess_print_error @ if input < 2, show error and repeat

        # Valid input - call guessNumber(guessMax)
        BL guessNumber
        B guess_done

    guess_print_error:
        LDR r0, =guessErrorMsg
        BL printf
        B guess_input_loop @ repeat prompt

    guess_done:

    # Pop the stack
    LDR lr, [sp, #0]
    ADD sp, sp, #4
    MOV pc, lr

.data
    errorMsg:    .asciz "Error: Please enter an integer ≥ 3.\n\n"
    primeLimit: .word 0
    promptPrime: .asciz "Enter an upper limit to list primes: "
    promptGuessMax: .asciz "Enter a maximum value for the guessing game (>1): "
    formatInt: .asciz "%d"
    guessErrorMsg:  .asciz "Error: Please enter an integer greater than 1.\n\n"
    guessMax: .word 0
