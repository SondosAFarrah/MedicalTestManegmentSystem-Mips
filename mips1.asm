# First Architecture Project: Medical Test Management System
# Done by students --> Name: Sondos Farrah ID: 1200905
#                  --> Name: Mohammad Makhamreh ID: 1200227
#
# INSTRUCTOR AND SECTION
# INSTRUCTOR NAME: Dr.Aziz Qaroush
# SECTION NO.: 2

################ Data Section ################
.data
file_name:          .asciiz "C:\\Users\\LENOVO\\Desktop\\cse\\cse4.2\\Arch\\project1\\test.txt"
# to make the program run properly, the path must be the path of the test.txt file

#-----------------------Menu Choices Messages----------------------------
welcomeMSG:         .asciiz "\n\t\t~Welcome To the Medical Test Management System program~\t\t\n"
menu:               .asciiz "\t Please enter your choice:\n"
addMedicalTest:     .asciiz "\t 1. Add a new medical test.\n"
searchByPatientID:  .asciiz "\t 2. Search for a test by patient ID\n"
retrieveAllTests:   .asciiz "\t\ta. Retrieve all patient tests\n"
retrieveNormalTests: .asciiz "\t\tb. Retrieve all up normal patient tests\n"
retrieveSpecificPeriod: .asciiz "\t\tc. Retrieve all patient tests in a given specific period\n"
searchForUnnormalTests: .asciiz "\t 3. Search for unnormal tests.\n"
averageTestValue:   .asciiz "\t 4. Average test value\n"
updateAnExistingTestResult: .asciiz "\t 5.Update an existing test result\n"
deleteATest:        .asciiz "\t 6. Delete a test\n"
invalidInputMsg:    .asciiz "\t Invalid input. Please try again.\n"
enterPatientIDMsg:  .asciiz "\t Enter Patient ID (7 digits): "
enterTestNameMsg:   .asciiz "\t Enter Test name: "
enterTestDateMsg:   .asciiz "\t Enter Test date (YYYY-MM): "
enterTestResultMsg: .asciiz "\t Enter Test result: "
confirmationMsg:    .asciiz "\nMedical test information entered:\n"
LDL: .asciiz "LDL"
BPT: .asciiz "BPT"
Hgb: .asciiz "Hgb"
BGT: .asciiz "BGT"
test_name_buffer:   .space 4    # Buffer to store Test name
test_date_buffer:   .space 8   # Buffer to store Test date (YYYY-MM)
buffer:             .space 1000 # Buffer to store the contents of the file
#---------------------End of Choices Message -----------------------------

################ Code Section ################
.text
.globl main

main:
    # Print welcome message
    li $v0, 4
    la $a0, welcomeMSG
    syscall

    # Open the file
    li $v0, 13
    la $a0, file_name
    li $a1, 0
    li $a2, 0
    syscall
    move $s0, $v0  # Save the file descriptor

    # Read and print the contents of the file
    li $v0, 14
    move $a0, $s0
    la $a1, buffer
    li $a2, 1000
    syscall

    # Print the contents of the file
    li $v0, 4
    la $a0, buffer
    syscall

    # Close the file
    li $v0, 16
    move $a0, $s0
    syscall

    # Print the menu
    li $v0, 4
    la $a0, menu
    syscall

    # Print the menu choices
    li $v0, 4
    la $a0, addMedicalTest
    syscall
    li $v0, 4
    la $a0, searchByPatientID
    syscall
    li $v0, 4
    la $a0, retrieveAllTests
    syscall
    li $v0, 4
    la $a0, retrieveNormalTests
    syscall
    li $v0, 4
    la $a0, retrieveSpecificPeriod
    syscall
    li $v0, 4
    la $a0, searchForUnnormalTests
    syscall
    li $v0, 4
    la $a0, averageTestValue
    syscall
    li $v0, 4
    la $a0, updateAnExistingTestResult
    syscall
    li $v0, 4
    la $a0, deleteATest
    syscall

    # Get user's choice
    li $v0, 5
    syscall
    move $s1, $v0 # Save the user's choice

    # Check if user chose to add a new medical test
    li $t0, 1
    beq $s1, $t0, addNewMedicalTest
    # Add branch

    # Exit the program
    li $v0, 10
    syscall

addNewMedicalTest:
    # Print prompts and get input data
    #-------------------read ID---------------------------------
readID:
    li $v0, 4
    la $a0, enterPatientIDMsg
    syscall
    li $v0, 5 #read int
    syscall
    move $s2, $v0  # Save Patient ID
    #validate id is 7digits integer
    move $t0, $s2  
    li $t1, 0 # Counter for the number of divisions
validateID:
    div $t0, $t0, 10  # Divide $t0 by 10
    addi $t1, $t1, 1  # Increment the counter
    beqz $t0, checkID
    j validateID  
checkID:
    beq $t1, 7, is7digits
not7digits:
    li $v0,4
    la $a0,invalidInputMsg
    syscall
    j readID
is7digits:
    #-------------------read test name --------------------------------
readTName:
    li $v0, 4
    la $a0, enterTestNameMsg
    syscall
    # Assuming test name is limited to 3 characters
    li $v0, 8 #read string
    la $a0, test_name_buffer
    li $a1, 4
    syscall
    #move $s3, $v0  # Save Test name
    # Compare the input string with LDL
    la $a0, test_name_buffer 
    la $a1, LDL
    jal strcmp
    beqz $v0, matched
    # Compare the input string with BPT
    la $a0, test_name_buffer 
    la $a1, BPT
    jal strcmp
    beqz $v0, matched
    # Compare the input string with Hgb
    la $a0, test_name_buffer 
    la $a1, Hgb
    jal strcmp
    beqz $v0, matched
    # Compare the input string with BGT
    la $a0, test_name_buffer 
    la $a1, BGT
    jal strcmp
    beqz $v0, matched
    b unmatched
strcmp:
    validateName:
        lb $t0, 0($a0)   # load a byte from string1
        lb $t1, 0($a1)   # load a byte from string2
        beqz $t0, check_end   # if string1 is finished, check if string2 is also finished
        beqz $t1, not_equal   # if string2 is finished, strings are not equal
        bne $t0, $t1, not_equal   # if characters are not equal, strings are not equal
        addi $a0, $a0, 1   # move to the next character in string1
        addi $a1, $a1, 1   # move to the next character in string2
        j validateName

    check_end:
        beqz $t1, equal   # if string2 is also finished, strings are equal
        j not_equal

    equal:
        li $v0, 0   # strings are equal
        jr $ra

    not_equal:
        li $v0, 1   # strings are not equal
        jr $ra
matched:
    #-------------------read test date --------------------------------
readTDate:
    li $v0, 4
    la $a0, enterTestDateMsg
    syscall
    # Assuming test date is in format YYYY-MM
    li $v0, 8
    la $a0, test_date_buffer
    li $a1, 8
    syscall
    #move $s4, $v0  # Save Test date

    li $v0, 4
    la $a0, enterTestResultMsg
    syscall
    li $v0, 6 #read float
    syscall
    mov.s $f12, $f0 # Save Test result

unmatched:
    li $v0,4
    la $a0,invalidInputMsg
    syscall
    j readTName

