# First Architecture Project: Medical Test Management System
# Done by students --> Name: Sondos Farrah ID: 1200905
#                  --> Name: Mohammad Makhamreh ID: 1200227
#
# INSTRUCTOR AND SECTION
# INSTRUCTOR NAME: Dr.Aziz Qaroush
# SECTION NO.: 2

################ Data Section ################
.data
file_name:          .asciiz "C:\\Users\\HP\\Desktop\\test.txt"
file_nameO:          .asciiz "C:\\Users\\HP\\Desktop\\out.txt"
#file_name:          .asciiz "C:\\Users\\LENOVO\\Desktop\\cse\\cse4.2\\Arch\\project1\\test.txt"
#file_nameO:          .asciiz "C:\\Users\\LENOVO\\Desktop\\cse\\cse4.2\\Arch\\project1\\out.txt"
# to make the program run properly, the path must be the path of the test.txt file

#-----------------------Menu Choices Messages----------------------------
welcomeMSG:         .asciiz "\n\t\t~Welcome To the Medical Test Management System program~\t\t\n"
menu:               .asciiz "\t Please enter your choice:\n"
addMedicalTest:     .asciiz "\t 1. Add a new medical test.\n"
searchByPatientID:  .asciiz "\t 2. Search for a test by patient ID\n"
retrieveAllTests:   .asciiz "\t\t1. Retrieve all patient tests\n"
retrieveNormalTests: .asciiz "\t\t2. Retrieve all up normal patient tests\n"
retrieveSpecificPeriod: .asciiz "\t\t3. Retrieve all patient tests in a given specific period\n"
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
testNameBuffer:   .space 4    # Buffer to store Test name
testDateBuffer:   .space 8   # Buffer to store Test date (YYYY-MM)
buffer:             .space 10000 # Buffer to store the contents of the file
testIDBuffer:         .space 7# Define a label at the end of the buffer section
testResultBuffer1: .space 7
testResultBuffer2: .space 7
#testResultBufferDec:         .space 8
#testResultBufferFrac:         .space 8
comma: .asciiz ", " 
colon: .asciiz ": "
point: .asciiz "."

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
    li $a2, 2000
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
    # Check if user chose to Search for a test by patient ID
    li $t0,2
    beq $s1,$t0,searchByID

exit:    
    # Exit the program
    li $v0, 10
    syscall
#-----------------------------------------------------------option1---------------------------------------------------------------------------------------
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
    move $t7 , $s2
    move $a0,$s2
    la $a1,testIDBuffer
    jal intToString
    #validate id is 7digits integer
    move $t0, $t7 
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
    #convert int to string-----
intToString:
        sw $ra,($sp)
	sub $sp,$sp,4
	
	li $t1,10
	move $s2, $a0
	move $t4, $a1		
	
divLoop:
	div $s2, $t1
	mfhi $t3
	mflo $s2
	add $t3,$t3,48
	sb $t3,($t4)
	add $t4, $t4, 1
	bne $s2, $zero, divLoop
	
	
	move $t0,$a1
	jal getLengthStr
	
	move $t0,$a1
	move $t4,$a1
	
	add $t4, $t4 , $t3

	sub $t4, $t4,1
	
	div $t3,$t3,2
	
	li $t1,0 	#reset to 0
	
reverseLoop:
	
	lb $t2,($t0)
	lb $t5,($t4)
	
	sb $t5,($t0)
	sb $t2,($t4) 
	
	add $t1, $t1, 1
	
	sub $t4, $t4, 1
	add $t0, $t0, 1
	
	blt $t1,$t3,reverseLoop
	
	add $sp,$sp,4
	lw $ra,($sp)
	jr $ra
	
	
.globl getLengthStr
getLengthStr:
	sw $ra,($sp)
	sub $sp,$sp,4
	
	li $t3,0
	
loop:
		lb $t2,($t0)
		add $t0,$t0,1
		
		beq $t2,' ',Detect
		add $t3,$t3,1			 		 
	  
Condt:
	  bne $t2,'\0',loop 
	
	  j end
	  
Detect:
	  	j Condt
	  
end:
	  
	  sub $t3, $t3, 1
	  
	  add $sp,$sp,4
	  lw $ra,($sp)
	  jr $ra
is7digits:
    #-------------------read test name --------------------------------
readTName:
    li $v0, 4
    la $a0, enterTestNameMsg
    syscall
    # Assuming test name is limited to 3 characters
    li $v0, 8 #read string
    la $a0, testNameBuffer
    li $a1, 4
    syscall
    #move $s3, $v0  # Save Test name
    # Compare the input string with LDL
    la $a0, testNameBuffer
    la $a1, LDL
    jal strcmp
    beqz $v0, matched
    # Compare the input string with BPT
    la $a0, testNameBuffer
    la $a1, BPT
    jal strcmp
    beqz $v0, matchedBPT
    # Compare the input string with Hgb
    la $a0, testNameBuffer
    la $a1, Hgb
    jal strcmp
    beqz $v0, matched
    # Compare the input string with BGT
    la $a0, testNameBuffer 
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
matchedBPT:
    li $t9,1
matched:
    #-------------------read test date --------------------------------
readTDate:
    li $v0, 4
    la $a0, enterTestDateMsg
    syscall
    # Assuming test date is in format YYYY-MM
    li $v0, 8
    la $a0, testDateBuffer
    li $a1, 8
    syscall
    #move $s4, $v0  # Save Test date
validateDate:
    # Check if the month part is valid (from 1 to 12)
checkFormat:
    lb $t2, 4($a0)         # Check if the 5th character is '-'
    li $t3, '-'            # ASCII code for '-'
    bne $t2, $t3, notInFromat
    
    lb $t0, 5($a0)  
checkTen:
    lb $t0, 5($a0) 
    li $t1,'0'
    beq $t0,$t1 , zeroTens
    #oneTens
    lb $t0, 5($a0) 
    beq $t0,'1',oneTens  
    b notInFromat
zeroTens:
    lb $t0, 6($a0) 
    ble $t0, '9', lessThan9
    b notInFromat
lessThan9:
    lb $t0, 6($a0)
    bge $t0, '1', readResult
    b notInFromat
oneTens:
    lb $t0, 6($a0)
    beq $t0,'1' , readResult
    #oneTens
    lb $t0, 6($a0)
    beq $t0,'2',readResult  
    b notInFromat
      
readResult:
    #-------------------read test result -------------------------------- 
    li $v0, 4
    la $a0, enterTestResultMsg
    syscall
    # read result as string
    li $v0, 8
    la $a0, testResultBuffer1
    li $a1, 6
    syscall
    beq $t9,1,readR2
    b saveToFile
readR2:
    # read result as string
    li $v0, 4
    la $a0, enterTestResultMsg
    syscall
    li $v0, 8
    la $a0, testResultBuffer2
    li $a1, 6
    syscall
    b saveToFile
notInFromat:
    li $v0,4
    la $a0,invalidInputMsg
    syscall
    j readTDate
unmatched:
    li $v0,4
    la $a0,invalidInputMsg
    syscall
    j readTName
saveToFile:
 # Calculate the length of the buffer
    # Initialize counter
li $t0, 0             # Counter for length
la $t1, buffer        # Load address of the buffer

# calculate the buffer length.
calculateLength:
    lb $t2, ($t1)      # Load a byte from the buffer
    beqz $t2, done     # If null terminator is found, exit loop
    addi $t0, $t0, 1   # Increment counter for length
    addi $t1, $t1, 1   # Move to the next byte in the buffer
    j calculateLength  # Repeat loop
# calculate the result1 length.
calculateLength2:
    lb $t2, ($t1)      # Load a byte from the buffer
    beqz $t2, done2     # If null terminator is found, exit loop
    addi $t0, $t0, 1   # Increment counter for length
    addi $t1, $t1, 1   # Move to the next byte in the buffer
    j calculateLength2  # Repeat loop
# calculate the result2 length.
calculateLength3:
    lb $t2, ($t1)      # Load a byte from the buffer
    beqz $t2, done3     # If null terminator is found, exit loop
    addi $t0, $t0, 1   # Increment counter for length
    addi $t1, $t1, 1   # Move to the next byte in the buffer
    j calculateLength3  # Repeat loop

done:
# At this point, $t0 contains the length of the string stored in the buffer

        #open file 
    	li $v0,13           	# open_file syscall code = 13
    	la $a0,file_nameO     	# get the file name
    	li $a1,1           	# file flag = write (1)
    	syscall
    	move $s1,$v0        	# save the file descriptor. $s0 = file
    	
    # Write buffer to the file
    li $v0, 15           # write_file syscall code = 15
    move $a0, $s1        # file descriptor
    la $a1, buffer       # the string that will be written
    move $a2, $t0        # length of the toWrite string (without null terminator)
    syscall
    	
    	#Write buffer to the file
    	#li $v0,15		# write_file syscall code = 15
    	#move $a0,$s1		# file descriptor
    	#la $a1,buffer	# the string that will be written
    	#la $a2,1000		# length of the toWrite string
    	#syscall
    	#Write ID to the file
    	li $v0,15		# write_file syscall code = 15
    	move $a0,$s1		# file descriptor
    	la $a1,testIDBuffer	# the string that will be written
    	la $a2,7		# length of the toWrite string
    	syscall
    	#Write ':' to the file
    	li $v0,15		# write_file syscall code = 15
    	move $a0,$s1		# file descriptor
    	la $a1,colon	# the string that will be written
    	la $a2,2		# length of the toWrite string
    	syscall
    	#Write name to the file
    	li $v0,15		# write_file syscall code = 15
    	move $a0,$s1		# file descriptor
    	la $a1,testNameBuffer	# the string that will be written
    	la $a2,3		# length of the toWrite string
    	syscall
    	#Write ',' to the file
    	li $v0,15		# write_file syscall code = 15
    	move $a0,$s1		# file descriptor
    	la $a1,comma	# the string that will be written
    	la $a2,2		# length of the toWrite string
    	syscall
    	#Write date to the file
    	li $v0,15		# write_file syscall code = 15
    	move $a0,$s1		# file descriptor
    	la $a1,testDateBuffer	# the string that will be written
    	la $a2,7		# length of the toWrite string
    	syscall
    	#Write comma to the file
    	li $v0,15		# write_file syscall code = 15
    	move $a0,$s1		# file descriptor
    	la $a1,comma	# the string that will be written
    	la $a2,2		# length of the toWrite string
    	syscall
    	#Write result to the file
    	li $t0, 0             # Counter for length
	la $t1, testResultBuffer1        # Load address of the buffer
    	j calculateLength2
done2:
        	li $v0,15		# write_file syscall code = 15
    	move $a0,$s1		# file descriptor
    	la $a1,testResultBuffer1	# the string that will be written
	move $a2, $t0        # length of the toWrite string (without null terminator)		# length of the toWrite string
    	syscall
    	bne $t9,1, closeFile
	#Write ',' to the file
    	li $v0,15		# write_file syscall code = 15
    	move $a0,$s1		# file descriptor
    	la $a1,comma	# the string that will be written
    	la $a2,2		# length of the toWrite string
    	syscall
       #Write result to the file
        li $t0, 0             # Counter for length
	la $t1, testResultBuffer2        # Load address of the buffer
        j calculateLength3
done3:
    	li $v0,15		# write_file syscall code = 15
    	move $a0,$s1		# file descriptor
    	la $a1,testResultBuffer2	# the string that will be written
        move $a2, $t0        # length of the toWrite string (without null terminator)	
    	syscall  
closeFile:	
	#MUST CLOSE FILE IN ORDER TO UPDATE THE FILE
    	li $v0,16         		# close_file syscall code
    	move $a0,$s1      		# file descriptor to close
    	syscall
    	b exit
#-----------------------------------------------------------option2----------------------------------------------------------------------------------------
searchByID:
    li $v0, 4
    la $a0, enterPatientIDMsg
    syscall
    li $v0, 5 #read int
    syscall
    move $s2, $v0
        li $v0, 4
    la $a0, retrieveAllTests
    syscall
    li $v0, 4
    la $a0, retrieveNormalTests
    syscall
    li $v0, 4
    la $a0, retrieveSpecificPeriod
    syscall
    #Check if user chose to Retrieve all patient tests
    li $v0, 5 #read int
    syscall
    move $s1, $v0
    li $t0,1
    beq $s1,$t0,allPTests    
allPTests:


       
    
