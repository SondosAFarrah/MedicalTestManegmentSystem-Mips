# First Architecture Project: Medical Test Management System
# Done by students --> Name: Sondos Farrah ID: 1200905
#                  --> Name: Mohammad Makhamreh ID: 1200227
#
# INSTRUCTOR AND SECTION
# INSTRUCTOR NAME: Dr.Aziz Qaroush
# SECTION NO.: 2

################ Data Section ################
.data
#file_name:          .asciiz "C:\\Users\\HP\\Desktop\\test.txt"
#file_nameO:          .asciiz "C:\\Users\\HP\\Desktop\\out.txt"
file_name:          .asciiz "C:\\Users\\LENOVO\\Desktop\\cse\\cse4.2\\Arch\\project1\\test.txt"
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
enterTestDateMsg1:  .asciiz "\t Enter the first period date (from) (YYYY-MM): "
enterTestDateMsg2:  .asciiz "\t Enter the second period date(to) (YYYY-MM): "
updatedTestNum:  .asciiz "\t Enter number of test you want to update:\n"
deleteTestNum:  .asciiz "\t Enter number of test you want to delete:\n"
deleteSucc: .asciiz "\t --------- Delete Done Successfully---------\n"
updateSucc: .asciiz "\t --------- Update Done Successfully---------\n"
LDL: .asciiz "LDL"
BPT: .asciiz "BPT"
Hgb: .asciiz "Hgb"
BGT: .asciiz "BGT"
g: .asciiz "g"
D: .asciiz "D"
G: .asciiz "G"
P: .asciiz "P"
testNameBuffer:   .space 4    # Buffer to store Test name
testDateBuffer:   .space 8   # Buffer to store Test date (YYYY-MM)
testDateBuffer1:   .space 8   # Buffer to store Test date (YYYY-MM)
testDateBuffer2:   .space 8   # Buffer to store Test date (YYYY-MM)
buffer:             .space 10000 # Buffer to store the contents of the file
bufferCopy:             .space 10000 # Buffer to store the contents of the file
testIDBuffer:         .space 7# Define a label at the end of the buffer section
testResultBuffer1: .space 7
testResultBuffer2: .space 7
notFoundID: .asciiz "-------------------Not Found ID !!!! ------------------\n"
theAverageIs: .asciiz "\t The Average is:  "
bufferLine:             .space 10000 # Buffer to store the contents of the file
#testResultBufferDec:         .space 8
#testResultBufferFrac:         .space 8
comma: .asciiz ", " 
colon: .asciiz ": "
point: .asciiz "."
HgbMin: .float 13.8
HgbMax: .float 17.2
BGTMin: .float 70.0
BGTMax: .float 99.0
LDLMin: .float 0.0
LDLMax: .float 100.0
BPTMin: .float 0.0
BPTMaxS: .float 120.0
BPTMaxD: .float 80.0
f35: .float 0
ten: .float 10
one: .float 1
integerPart: .word 0       # Space for the integer part
fractionalPart: .word 0    # Space for the fractional part as an integer
scale: .word 1             # Scale for the fractional part (10^n)
MSG1: .asciiz "Converted Float: "
resultCutbuffer: .space 32  # Allocate space for the buffer to store the extracted bytes


#---------------------End of Choices Message -----------------------------

################ Code Section ################
.text
.globl main

main:

    # Print welcome message
    li $v0, 4
    la $a0, welcomeMSG
    syscall

   
    jal readFile
    # Print the contents of the file
    li $v0, 4
    la $a0, buffer
    syscall

    # Close the file
    li $v0, 16
    move $a0, $s0
    syscall
backToMenu:
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
    #Check if user chose to Searching for unnormal tests
    li $t0,3
    beq $s1,$t0,unNormalTests
    #Check if user chose to Searching for average.
    li $t0,4
    beq $s1,$t0,calculateAverage
    #Check if user chose to Update an existing test result
    li $t0,5
    beq $s1,$t0, updateTest
    #Check if user chose to Delete an existing test result
    li $t0,6
    beq $s1,$t0, deleteTest
exit:    
    # Exit the program
    b main
#----------------Read File Function - -------------------------#
readFile:
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
    jr $ra
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
    beq $t0,'0' , readResult
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
    	la $a0,file_name     	# get the file name
    	li $a1,1           	# file flag = write (1)
    	syscall
    	move $s1,$v0        	# save the file descriptor. $s0 = file
    	
    # Write buffer to the file
    li $v0, 15           # write_file syscall code = 15
    move $a0, $s1        # file descriptor
    la $a1, buffer       # the string that will be written
    move $a2, $t0        # length of the toWrite string (without null terminator)
    syscall
    	
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
    	jal readFile
    	#sondos2020
    	b main
#-----------------------------------------------------------option2----------------------------------------------------------------------------------------
searchByID:
    li $v0, 4
    la $a0, enterPatientIDMsg
    syscall
    li $v0, 5 #read int
    syscall
    move $s2, $v0
    move $a0,$s2
    la $a1,testIDBuffer
    jal intToString
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
     li $t0,2
    beq $s1,$t0,allUpnormalTests 
    li $t0,3
    beq $s1,$t0,allSpecificPeriod
    b exit 	    
    
allSpecificPeriod:
	# first we need to read the date and check it if it is valid input.
readTDate2:
    li $v0, 4
    la $a0, enterTestDateMsg1
    syscall
    # Assuming test date is in format YYYY-MM
    li $v0, 8
    la $a0, testDateBuffer1
    li $a1, 8
    syscall
    b validateDate2
readSecondDate:
    li $v0, 4
    la $a0, enterTestDateMsg2
    syscall
    # Assuming test date is in format YYYY-MM
    li $v0, 8
    la $a0, testDateBuffer2
    li $a1, 8
    syscall
    b validateDate3
    
   # here the two dates are written correctly form, we need to find the matched id and dates:. 
DoSomthingAboutPeriodTest:
    # Load address of buffer into register $a1
    la $a1, buffer

r119:
    # Load initial index (offset) of buffer into register $t0
    li $t0, 0
  #  addi $a1,$a1,1
        # Load address of ID into register $a3
    la $a3, testIDBuffer
read7bytes19:
    # Load byte from buffer at index $t0 into register $t1
   
    lb $t1, 0($a1) #buffer
    lb $t2,0($a3) #input ID
    bne $t1,$t2, newLine19
    # Increment index
    addi $t0, $t0, 1
    # Increment buffer pointer
    addi $a1, $a1, 1 #inc off buffer
    addi $a3, $a3, 1 #inc off ID
    beq $t0,7 ,dateCutTurn
    b read7bytes19
    #b newLine
    # Repeat loop
newLine19:
    lb $t1, 0($a1)
    beq $t1, '\n', r229
    beq $t1,'\0',exit
    addi $a1, $a1, 1 
    j    newLine19
r229:    
    li $t7,1
    add $a1,$a1,$t7
    b r119
    
#------------- now we need to cut the date of the id test to check it-----------------------------------------   
dateCutTurn:
    subi $a1,$a1,5 ## to reach the first index of the date~!------------------------------------------------------
    lb $t1,0($a1)   
   
     jal resultString

comparePeriods:
# Load addresses of strings into registers
    la $a0, resultCutbuffer     # Load address of resultCutbuffer into $a0
    la $a2, testDateBuffer1     # Load address of str2 into $a2
    
    # Call the compare_strings function
    b compare_strings
    
    # Exit program
    li $v0, 10       # System call code for exit
    syscall

# Function to compare strings
compare_strings:
    loop3:
        lb $t0, 0($a0)    # Load byte from resultCutbuffer
        lb $t1, 0($a2)    # Load byte from str2
        
        # Check if we've reached the end of either string
        beq $t0, $zero, checkSecondDates
        beq $t1, $zero, checkSecondDates
        
        # Compare characters
        sub $t2, $t0, $t1
        bne $t2, $zero, print_result
        
        # Increment pointers
        addi $a0, $a0, 1   # Move to next character in resultCutbuffer
        addi $a2, $a2, 1   # Move to next character in str2
        j loop3             # Repeat loop

    str2_end:
        b printPeriodTest
        #*****************************************************************In Range*******************************************
        
        
    print_result:
    	#***********out , num < min*************************************************newline
        bgt $t2, $zero, checkSecondDates   # If $t0 > $t1, print resultCutbuffer
        b newLine19

        
checkSecondDates:        
        # Load addresses of strings into registers
    la $a0, resultCutbuffer     # Load address of resultCutbuffer into $a0
    la $a2, testDateBuffer2     # Load address of str2 into $a2
    
    # Call the compare_strings function
    b compare_strings2
    
    # Exit program
    li $v0, 10       # System call code for exit
    syscall

# Function to compare strings
compare_strings2:
    loop2:
        lb $t0, 0($a0)    # Load byte from resultCutbuffer
        lb $t1, 0($a2)    # Load byte from str2
        
        # Check if we've reached the end of either string
        beq $t0, $zero, resultCutbuffer_end2
        beq $t1, $zero, str2_end
        
        # Compare characters
        sub $t2, $t0, $t1
        bne $t2, $zero, print_result2
        
        # Increment pointers
        addi $a0, $a0, 1   # Move to next character in resultCutbuffer
        addi $a2, $a2, 1   # Move to next character in str2
        j loop2            # Repeat loop
        
    resultCutbuffer_end2:
     b printPeriodTest
       #**************************************************************in range , num=max***********************

        
    print_result2:
        bgt $t2, $zero, newLine19  # If $t0 > $t1, print resultCutbuffer
        b printPeriodTest   
printPeriodTest:
	    li $v0,11
    li $a0,10 #printnewLine
    syscall    
 	subi $a1,$a1,21 #a1 now the first char in the line(test)
 	b printPeriodLine

printPeriodLine:
 	lb $t1, 0($a1)
 	beq $t1, '\n',periodNewLine 
 	beq $t1,'\0',exit
	addi $a1, $a1, 1
	#print line
	li $v0, 11        # Print the character
	move $a0, $t1     # Move the character to $a0
	syscall
	j printPeriodLine
	#la $t1, ($s0)        # Load address of the buffer
periodNewLine:
    li $v0,11
    li $a0,10 #printnewLine
    syscall
r2020:    
    li $t7,1
    add $a1,$a1,$t7
    b r119 	
#--------------------------End of reading the id lines and compare the id ------------------------------------	    
    #move $s4, $v0  # Save Test date
validateDate2:
    # Check if the month part is valid (from 1 to 12)
checkFormat2:
    lb $t2, 4($a0)         # Check if the 5th character is '-'
    li $t3, '-'            # ASCII code for '-'
    bne $t2, $t3, notInFromat2
    
    lb $t0, 5($a0)  
checkTen2:
    lb $t0, 5($a0) 
    li $t1,'0'
    beq $t0,$t1 , zeroTens2
    #oneTens
    lb $t0, 5($a0) 
    beq $t0,'1',oneTens2  
    b notInFromat2
zeroTens2:
    lb $t0, 6($a0) 
    ble $t0, '9', lessThan92
    b notInFromat2
lessThan92:
    lb $t0, 6($a0)
    bge $t0, '1', readSecondDate
    b notInFromat2
oneTens2:
    lb $t0, 6($a0)
    beq $t0,'0' , readSecondDate
    lb $t0, 6($a0)
    beq $t0,'1' , readSecondDate
    #oneTens
    lb $t0, 6($a0)
    beq $t0,'2',readSecondDate  
    b notInFromat2
    
notInFromat2:
    li $v0,4
    la $a0,invalidInputMsg
    syscall
    j readTDate2

validateDate3:
checkFormat3:
    lb $t2, 4($a0)         # Check if the 5th character is '-'
    li $t3, '-'            # ASCII code for '-'
    bne $t2, $t3, notInFromat3
    
    lb $t0, 5($a0)  
checkTen3:
    lb $t0, 5($a0) 
    li $t1,'0'
    beq $t0,$t1 , zeroTens3
    #oneTens
    lb $t0, 5($a0) 
    beq $t0,'1',oneTens3  
    b notInFromat3
zeroTens3:
    lb $t0, 6($a0) 
    ble $t0, '9', lessThan93
    b notInFromat3
lessThan93:
    lb $t0, 6($a0)
    bge $t0, '1', DoSomthingAboutPeriodTest
    b notInFromat2
oneTens3:
    lb $t0, 6($a0)
    beq $t0,'0' , DoSomthingAboutPeriodTest
    lb $t0, 6($a0)
    beq $t0,'1' , DoSomthingAboutPeriodTest
    #oneTens
    lb $t0, 6($a0)
    beq $t0,'2',DoSomthingAboutPeriodTest  
    b notInFromat3
    
notInFromat3:
    li $v0,4
    la $a0,invalidInputMsg
    syscall
    j readSecondDate
                
            
#------------------End of printing the specific Period tests-------------------------------                    
allPTests:
    # Load address of buffer into register $a1
    la $a1, buffer

r1:
   #li $v0,1
   #li $a0, 9
   #syscall
    # Load initial index (offset) of buffer into register $t0
    li $t0, 0
        # Load address of ID into register $a3
    la $a3, testIDBuffer
read7bytes:
    # Load byte from buffer at index $t0 into register $t1
    lb $t1, 0($a1) #buffer
    lb $t2,0($a3) #input ID
    bne $t1,$t2, newLine
    # Increment index
    addi $t0, $t0, 1
    # Increment buffer pointer
    addi $a1, $a1, 1 #inc off buffer
    addi $a3, $a3, 1 #inc off ID
    beq $t0,7 , printLine
    b read7bytes
    #b newLine
    # Repeat loop
newLine:
    lb $t1, 0($a1)
    beq $t1, '\n', r2
    beq $t1,'\0',main
    addi $a1, $a1, 1 
    j    newLine
printLine:
    li $t7, 7
    sub $a1,$a1,$t7 
printLineS:
    lb $t1, 0($a1)
    beq $t1, '\n', r3
    beq $t1,'\0',exit
    addi $a1, $a1, 1 
    # Print ID
    li $v0, 11        # Print the character
    move $a0, $t1     # Move the character to $a0
    syscall
    j printLineS
    
r3:
    li $v0,11
    li $a0,10
    syscall
r2:    
    li $t7,1
    add $a1,$a1,$t7
    
    b r1

r111:
    subi $a1,$a1,1
    b r11	


allUpnormalTests:
# Load address of buffer into register $a1
    la $a1, buffer

r11:
    # Load initial index (offset) of buffer into register $t0
    li $t0, 0
  #  addi $a1,$a1,1
        # Load address of ID into register $a3
    la $a3, testIDBuffer
read7bytes1:
    # Load byte from buffer at index $t0 into register $t1
   
    lb $t1, 0($a1) #buffer
    lb $t2,0($a3) #input ID
    bne $t1,$t2, newLine1
    # Increment index
    addi $t0, $t0, 1
    # Increment buffer pointer
    addi $a1, $a1, 1 #inc off buffer
    addi $a3, $a3, 1 #inc off ID
    beq $t0,7 , testType
    b read7bytes1
    #b newLine
    # Repeat loop
newLine1:
    lb $t1, 0($a1)
    beq $t1, '\n', r22
    beq $t1,'\0',exit
    addi $a1, $a1, 1 
    j    newLine1
r22:    
    li $t7,1
    add $a1,$a1,$t7
    b r11       
testType:
    addi $a1,$a1,4 ## maybe we need to increment it by 1------------------------------------------------------
    lb $t1,0($a1)
    #li $v0,11
    #move $a0,$t1
    #syscall
    beq $t1,'L',testIsLDL
    lb $t1,0($a1)
    #li $v0,11
    #move $a0,$t1
    #syscall
    beq $t1,'b',testIsHgb
    subi $a1,$a1,1
    lb $t1,0($a1)
    beq $t1,'G',testIsBGT
    beq $t1,'P',testIsBPT	
    b exit 	
    
    
#------------------------------BPT-------------------------------------------------------
testIsBPT:
	addi $a1,$a1,1

	jal resultString

	li $t5,0
	jal calculateFloatLength

	add $t5,$t5,$t0

	
	#b exit #-----------$$$$$$$

	jal stringToFloat
	mov.s $f18,$f1
	
	jal readStringBPT2

	jal calculateFloatLength
	add $t5,$t5,$t0
	jal stringToFloat
	mov.s $f20,$f1
	
#	b exit
checkMaxBPT: 

	#li $v0,2
    	#mov.s $f12,$f18
    	#syscall 
       
    	l.s $f2, BPTMaxS
   	c.lt.s $f18, $f2          # Compare $f1 with $f2 (set less than or equal flag)
  	bc1f r22  # Branch if $f1 < $f2 to printUpnormalTest label
   	b num2check
num2check:
	#li $v0,2
    	#mov.s $f12,$f1
    	#syscall 
       
    	l.s $f2, BPTMaxD
   	c.lt.s $f20, $f2          # Compare $f1 with $f2 (set less than or equal flag)
  	bc1f r22  # Branch if $f1 < $f2 to printUpnormalTest label
  	li $t6,0
  	li $t6,1
   	b printUpnormalTest
        #b exit 
#------------------------------BGT-------------------------------------------------------
testIsBGT:
#min 70 max 99
	addi $a1,$a1,1
   	lb $t1,0($a1)
	jal resultString
	jal stringToFloat	
	#f1 contains the result as float.    
checkMinBGT:
	l.s $f2, BGTMin
	c.lt.s $f2, $f1          # Compare $f2 with $f1 (set less than flag)
	bc1f   r22       # Branch if $f2 < $f1 to checkMaxHgb label
	b checkMaxBGT                    # Branch to new line label

checkMaxBGT: 

    	l.s $f2,BGTMax
   	c.le.s $f1, $f2          # Compare $f1 with $f2 (set less than or equal flag)
  	bc1f r22  # Branch if $f1 <= $f2 to printUpnormalTest label
   	b printUpnormalTest 
#------------------------------BGT END------------------------------------------------------    
 #------------------------------Hgb------------------------------------------------------ 
testIsHgb:
	#min 13.8 max 17.2
	jal resultString
	jal stringToFloat	
	#f1 contains the result as float.    
checkMinHgb:
	l.s $f2, HgbMin
	c.lt.s $f2, $f1          # Compare $f2 with $f1 (set less than flag)
	bc1f   r22       # Branch if $f2 < $f1 to checkMaxHgb label
	b checkMaxHgb                    # Branch to new line label

checkMaxHgb: 
       
    	l.s $f2, HgbMax
   	c.le.s $f1, $f2          # Compare $f1 with $f2 (set less than or equal flag)
  	bc1f r22  # Branch if $f1 <= $f2 to printUpnormalTest label
   	b printUpnormalTest 


#------------------------------LDL ------------------------------------------- 	   
testIsLDL:
	#min 0 max 100
	jal resultString
	jal stringToFloat	
	#f1 contains the result as float.
checkMaxLDL: 

       
    	l.s $f2, LDLMax
   	c.lt.s $f1, $f2          # Compare $f1 with $f2 (set less than or equal flag)
  	bc1f r22  # Branch if $f1 < $f2 to printUpnormalTest label
   	b printUpnormalTest
   	       
printUpnormalTest:              
	#li $v0,11
	#li $a0,'S'
	#syscall 
	#b exit 
    
    li $v0,11
    li $a0,10 #printnewLine
    syscall    
    	beq $t6,1, printBPT         
	jal calculateFloatLength
 	sub $a1,$a1,$t0 #a1 now is the first digit in the float number
 	#l.s $f5,f35
 	#c.eq.s $f6, $f5
 	#bc1f  printBPT
 	subi $a1,$a1,23 #a1 now the first char in the line(test)
 	b printUpNormalLine
printBPT:
	add $t5,$t5,2
 	sub $a1,$a1,23 #a1 now is the first digit in the float number
 	sub $a1,$a1,$t5
 	li $t6,0
 	
        #subi $a1,$a1,37
        #l.s $f6,f35
printUpNormalLine:
 	lb $t1, 0($a1)
 	beq $t1, '\n',r33 
 	beq $t1,'\0',exit
	addi $a1, $a1, 1
	#print line
	li $v0, 11        # Print the character
	move $a0, $t1     # Move the character to $a0
	syscall
	j printUpNormalLine
	#la $t1, ($s0)        # Load address of the buffer
r33:
    li $v0,11
    li $a0,10 #printnewLine
    syscall
r222:    
    li $t7,1
    add $a1,$a1,$t7
    b r111

resultString:
   move $s6,$ra
# Load the start index of the bytes to read (22nd byte) into $t0
    addi $a1,$a1,12
    b continue
    #li $t0, 23
readStringBPT2:
    move $s6,$ra
    addi $a1,$a1,2
continue: 
       # Call function to read bytes from the line and store in buffer
    jal readBytes


    move $ra,$s6
    jr $ra
  

# Subroutine to read specific bytes from the line and store in buffer
readBytes:
    # Initialize variables
    la $t2, resultCutbuffer  # $t2 will hold the address of resultCutbuffer
   

looop:
    # Load a byte from the line
    lb $t3, 0($a1)

    # Check if the byte is newline character or null terminator
    beq $t3, '\n', done_reading
    beq $t3, ',', done_reading
    beqz $t3, done_reading

    # Store the byte in the buffer
    sb $t3, 0($t2)

    # Move to the next byte in the line and buffer
    addi $a1, $a1, 1
    addi $t2, $t2, 1

    # Repeat until newline character or null terminator is encountered
    j looop

done_reading:
    # Null-terminate the buffer
    sb $zero, 0($t2)

    jr $ra          # Return to main
    
# calculate the result2 length.
calculateFloatLength:
    move $s6,$ra
    li $t0, 0       # Counter for length
    la $t1, resultCutbuffer   # Load address of the buffer
startCount:
    lb $t2, 0($t1)   # Load a byte from the buffer
    beqz $t2, done4  # If null terminator is found, exit loop
    addi $t0, $t0, 1 # Increment counter for length
    addi $t1, $t1, 1 # Move to the next byte in the buffer
    j startCount     # Repeat loop
done4:
    #subi $t0,$t0,1
    move $ra,$s6
    jr $ra
    
stringToFloat:
    move $s6,$ra
 # Parse the string and convert it to integer and fractional parts
    la $a0,resultCutbuffer            # Load address of the string
    jal parseString        # Jump to the string parsing function

    # The values are now stored in integerPart and fractionalPart
    
    # Convert integer and fractional parts to floating point and print
    jal convertPartsToFloatAndPrint


    # Exit the program
    #li $v0, 10             # syscall number for exit
    #syscall

# String parsing function that fills integerPart and fractionalPart
parseString:
    # Initialize variables
    li $t1, 0              # Will hold the integer part
    li $t2, 0              # Will hold the fractional part
    li $t3, 1              # Will be used for the scale
    li $t4,0               #will hold the number of int digit
    
    # Parse the integer part
parseInteger:
    #beq $t0,'\n',endInteger
    addi $t4,$t4,1
    lb $t0, 0($a0)         # Load the next byte (character) from the string
    beq $t0, '.', endInteger # Check for decimal point
    beq $t0,'\0',intNum2
    #beq $t0,'\n',intNum2
    beq $t0,',',endInteger #------------------------@@
back:
    sub $t0, $t0, '0'      # Convert from ASCII to integer
    mul $t1, $t1, 10       # Multiply current result by 10
    add $t1, $t1, $t0      # Add the new digit
    
    addiu $a0, $a0, 1      # Move to the next character
    j parseInteger         # Loop back
intNum2:
    sw $t1, integerPart    # Store the integer part
    addiu $a0, $a0, 1      # Move past the decimal point
    b endFractional
endInteger:
    sw $t1, integerPart    # Store the integer part
    addiu $a0, $a0, 1      # Move past the decimal point

    # Parse the fractional part
parseFractional:

    lb $t0, 0($a0)         # Load the next byte (character)
    beq $t0, '\0', endFractional # Check for null terminator
    beq $t0, '\n', endFractional # Check for null terminator
    sub $t0, $t0, '0'      # Convert from ASCII to integer
    mul $t2, $t2, 10       # Multiply current result by 10
    add $t2, $t2, $t0      # Add the new digit
    mul $t3, $t3, 10       # Increase scale
    addiu $a0, $a0, 1      # Move to the next character
    j parseFractional      # Loop back

endFractional:
    sw $t2, fractionalPart # Store the fractional part
    sw $t3, scale          # Store the scale
    jr $ra                 # Return

# Function to convert the parts to floating point and print
convertPartsToFloatAndPrint:
    # Load and convert integer part
    lw $s0, integerPart
    mtc1 $s0, $f1
    cvt.s.w $f1, $f1

    # Load and convert fractional part
    lw $s0, fractionalPart
    mtc1 $s0, $f2
    cvt.s.w $f2, $f2

    # Load and convert scale
    lw $s0, scale
    mtc1 $s0, $f3
    cvt.s.w $f3, $f3

    # Divide fractional part by scale
    div.s $f2, $f2, $f3

    # Combine integer and fractional parts
    add.s $f1, $f1, $f2
 
    move $ra,$s6
    jr $ra                 # Return
    
#---------------------------------------------------------------option 3-----------------------------------------------------------
unNormalTests:

readTNameO3:
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
    beqz $v0, matchedO3
    # Compare the input string with BPT
    la $a0, testNameBuffer
    la $a1, BPT
    jal strcmp
    beqz $v0, matchedO3
    # Compare the input string with Hgb
    la $a0, testNameBuffer
    la $a1, Hgb
    jal strcmp
    beqz $v0, matchedO3
    # Compare the input string with BGT
    la $a0, testNameBuffer 
    la $a1, BGT
    jal strcmp
    beqz $v0, matchedO3
    b unmatchedO3
    
unmatchedO3:
    li $v0,4
    la $a0,invalidInputMsg
    syscall
	b readTNameO3
	
matchedO3:
# Load address of buffer into register $a1
    la $a1, buffer
    li $t0,0
backO3:
    addi $a1,$a1,10 ## maybe we need to increment it by 1------------------------------------------------------
    lb $t1,0($a1)
    la $a3,testNameBuffer
    lb $t3,1($a3)
    beq $t1,$t3,CheckWhichTest
    b newLineO3
    #beq $t1,'D',testIsLDLO3
    #lb $t1,0($a1)
    #li $v0,11
    #move $a0,$t1
    #syscall
CheckWhichTest:
    beq $t3,'D',testIsLDLO3
    beq $t3,'g',testIsHgbO3
    beq $t3,'G',testIsBGTO3
    beq $t3,'P',testIsBPTO3	
    b exit 
testIsBPTO3:
	addi $a1,$a1,1

	jal resultString

	li $t5,0
	jal calculateFloatLength

	add $t5,$t5,$t0

	
	#b exit #-----------$$$$$$$

	jal stringToFloat
	mov.s $f18,$f1
	
	jal readStringBPT2

	jal calculateFloatLength
	add $t5,$t5,$t0
	jal stringToFloat
	mov.s $f20,$f1
	
#	b exit
checkMaxBPTO3: 

	#li $v0,2
    	#mov.s $f12,$f18
    	#syscall 
       
    	l.s $f2, BPTMaxS
   	c.lt.s $f18, $f2          # Compare $f1 with $f2 (set less than or equal flag)
  	bc1f num2checkO3  # Branch if $f1 < $f2 to printUnnormalTest label
   	b newLineO3
num2checkO3:
	#li $v0,2
    	#mov.s $f12,$f1
    	#syscall 

    	l.s $f2, BPTMaxD
    	li $t6,1
   	c.lt.s $f20, $f2          # Compare $f1 with $f2 (set less than or equal flag)
  	bc1f printUnnormalTest  # Branch if $f1 < $f2 to printUnnormalTest label
  	li $t6,0
   	b newLineO3
testIsBGTO3:
#min 70 max 99
	addi $a1,$a1,1
   	lb $t1,0($a1)
	jal resultString
	#jal resultStrin
	jal stringToFloat	
	#f1 contains the result as float.    
checkMinBGTO3:
	l.s $f2, BGTMin
	c.lt.s $f2, $f1          # Compare $f2 with $f1 (set less than flag)
	bc1f newLineO3         # Branch if $f2 < $f1 to checkMaxHgb label
	b checkMaxBGTO3                    # Branch to new line label

checkMaxBGTO3: 

    	l.s $f2,BGTMax
   	c.le.s $f1, $f2          # Compare $f1 with $f2 (set less than or equal flag)
  	bc1f printUnnormalTest  # Branch if $f1 <= $f2 to printUnnormalTest label
   	b  newLineO3   
testIsHgbO3:
	addi $a1,$a1,1
	lb $t1,0($a1)
	#min 13.8 max 17.2
	jal resultString
	jal stringToFloat	
	#f1 contains the result as float.    
checkMinHgbO3:
	l.s $f2, HgbMin
	c.lt.s $f2, $f1          # Compare $f2 with $f1 (set less than flag)
	bc1f printUnnormalTest         # Branch if $f2 < $f1 to checkMaxHgbO3 label
	b checkMaxHgbO3    #newLineO3                    # Branch to new line label

checkMaxHgbO3: 
       
    	l.s $f2, HgbMax
   	c.le.s $f1, $f2          # Compare $f1 with $f2 (set less than or equal flag)
  	bc1f  printUnnormalTest  # Branch if $f1 <= $f2 to printUnnormalTest label
   	b  newLineO3

testIsLDLO3:
	#min 0 max 100
	addi $a1,$a1,1
	lb $t1,0($a1)
	jal resultString
	#li $v0,4
	#la $a0,resultCutbuffer
	#syscall 
	#li $v0,11
	#li $a0,'S'
	#syscall 
	jal stringToFloat
	#li $v0,2
	#mov.s $f12,$f1
	#syscall 	
	#f1 contains the result as float.
checkMaxLDLO3: 
    	l.s $f2, LDLMax
   	c.lt.s $f1, $f2        
  	bc1f printUnnormalTest  
   	b newLineO3
newLineO3:
    lb $t1, 0($a1)
    beq $t1, '\n', addO3
    beq $t1,'\0',exit
    addi $a1, $a1, 1 
    j    newLineO3
addO3:
	addi $a1,$a1,1
	b backO3
printUnnormalTest:
	#li $v0,11
	#li $a0,10
	#syscall 
	#li $v0,11
	#la $a0,'X'
	#syscall 
	 li $v0,11
    li $a0,10 #printnewLine
    syscall    
    	beq $t6,1, printBPTO3         
	jal calculateFloatLength
 	sub $a1,$a1,$t0 #a1 now is the first digit in the float number
 	#l.s $f5,f35
 	#c.eq.s $f6, $f5
 	#bc1f  printBPTO3
 	subi $a1,$a1,23 #a1 now the first char in the line(test)
 	b printUnnormalLine
printBPTO3:
	add $t5,$t5,2
 	sub $a1,$a1,23 #a1 now is the first digit in the float number
 	sub $a1,$a1,$t5
 	li $t6,0
 	
        #subi $a1,$a1,37
        #l.s $f6,f35
printUnnormalLine:
 	lb $t1, 0($a1)
 	beq $t1, '\n',r33O3 
 	beq $t1,'\0',exit
	addi $a1, $a1, 1
	#print line
	li $v0, 11        # Print the character
	move $a0, $t1     # Move the character to $a0
	syscall
	j printUnnormalLine
	#la $t1, ($s0)        # Load address of the buffer
r33O3:
    li $v0,11
    li $a0,10 #printnewLine
    syscall
r222O3:    
    #li $t7,1
    #add $a1,$a1,$t7
    #b r111
    b newLineO3
	b newLineO3
#------------------------------------------------------option 4----------------------------------------------------------
#---------------------------------------- Calculate and Print the average value of a specific test -------------------
calculateAverage:
readTNameO4: 
    l.s $f26,f35
    l.s $f22,f35 # make the initial value 0 to increment it the sum of all the specific Test.
    l.s $f24, f35 # used for the second BPT test sum.
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
    beqz $v0, matchedO4
    # Compare the input string with BPT
    la $a0, testNameBuffer
    la $a1, BPT
    jal strcmp
    beqz $v0, matchedO4
    # Compare the input string with Hgb
    la $a0, testNameBuffer
    la $a1, Hgb
    jal strcmp
    beqz $v0, matchedO4
    # Compare the input string with BGT
    la $a0, testNameBuffer 
    la $a1, BGT
    jal strcmp
    beqz $v0, matchedO4
    b unmatchedO4
    
unmatchedO4:
    li $v0,4
    la $a0,invalidInputMsg
    syscall
	b readTNameO4
	
matchedO4:
# Load address of buffer into register $a1
    la $a1, buffer
    li $t0,0
backO4:
    addi $a1,$a1,10 ## maybe we need to increment it by 1------------------------------------------------------
    lb $t1,0($a1)
    la $a3,testNameBuffer
    lb $t3,1($a3)
    beq $t1,$t3,CheckWhichTestO4
    b newLineO4

CheckWhichTestO4:
    beq $t3,'D',testIsLDLO4
    beq $t3,'g',testIsHgbO4
    beq $t3,'G',testIsBGTO4
    beq $t3,'P',testIsBPTO4	
    b exit 
testIsBPTO4:
	addi $a1,$a1,1
	l.s $f28,one
	add.s $f26,$f26,$f28
	jal resultString
	li $t5,0
	jal calculateFloatLength
	add $t5,$t5,$t0
	#b exit #-----------$$$$$$$
	jal stringToFloat
	mov.s $f18,$f1
	add.s $f22,$f22,$f18
	jal readStringBPT2

	jal calculateFloatLength
	add $t5,$t5,$t0
	jal stringToFloat
	mov.s $f20,$f1
	add.s $f24,$f24,$f20
	b newLineO4

testIsBGTO4:
#min 70 max 99
	addi $a1,$a1,1
	l.s $f28,one
	add.s $f26,$f26,$f28
   	lb $t1,0($a1)
	jal resultString
	#jal resultStrin
	jal stringToFloat	
	#f1 contains the result as float.  
	add.s $f22,$f22,$f1
   	b  newLineO4 	  

testIsHgbO4:
	l.s $f28,one
	add.s $f26,$f26,$f28
	addi $a1,$a1,1
	lb $t1,0($a1)
	jal resultString
	jal stringToFloat	
	#f1 contains the result as float.   
	add.s $f22,$f22,$f1
   	b  newLineO4 	  
 


testIsLDLO4:
	l.s $f28,one
	add.s $f26,$f26,$f28	
	addi $a1,$a1,1
	lb $t1,0($a1)
	jal resultString
	jal stringToFloat
	add.s $f22,$f22,$f1
   	b  newLineO3 
	#f1 contains the result as float.

newLineO4:
    lb $t1, 0($a1)
    beq $t1, '\n', addO4
    beq $t1,'\0',calculateTheAvg
    addi $a1, $a1, 1 
    j    newLineO4
addO4:
	addi $a1,$a1,1
	b backO4
	
calculateTheAvg:
	li $v0, 11           # Print string service
   	la $a0, 10     # Load address of new line character
    	syscall
	li $v0, 4
    	la $a0, theAverageIs
    	syscall
	la $a3,testNameBuffer
   	lb $t3,1($a3)
   	beq $t3,'P',testIsBPTAverage	
	div.s $f22,$f22,$f26
    	 li $v0, 2           # Load float value into FPU register
   	 mov.s $f12, $f22
   	 syscall 	
	b exit
testIsBPTAverage:
	div.s $f22,$f22,$f26
    	 li $v0, 2           # Load float value into FPU register
   	 mov.s $f12, $f22
   	 syscall
   	 li $v0, 4
    	 la $a0, comma
    	syscall
   	 div.s $f24,$f24,$f26
   	 li $v0, 2 
   	 mov.s $f12, $f24
   	 syscall	
	b exit
#------------------------------------------------------option 5---------------------------------------------------------
updateTest:
readIDO5:
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
validateIDO5:
    div $t0, $t0, 10  # Divide $t0 by 10
    addi $t1, $t1, 1  # Increment the counter
    beqz $t0, checkIDO5
    j validateIDO5  
checkIDO5:
    beq $t1, 7, is7digitsO5
not7digitsO5:
    li $v0,4
    la $a0,invalidInputMsg
    syscall
    j readIDO5
    
is7digitsO5:

allPTestsO5:
    # Load address of buffer into register $a1
    la $a1, buffer
    li $t3,0 #counter
r1O5:
   #li $v0,1
   #li $a0, 9
   #syscall
    # Load initial index (offset) of buffer into register $t0
    li $t0, 0
        # Load address of ID into register $a3
    la $a3, testIDBuffer
read7bytesO5:
    # Load byte from buffer at index $t0 into register $t1
    lb $t1, 0($a1) #buffer
    lb $t2,0($a3) #input ID
    bne $t1,$t2, newLineO5
    # Increment index
    addi $t0, $t0, 1
    # Increment buffer pointer
    addi $a1, $a1, 1 #inc off buffer
    addi $a3, $a3, 1 #inc off ID
    beq $t0,7 , printLineO5
    b read7bytesO5
    #b newLineO5
    # Repeat loop
newLineO5:
    lb $t1, 0($a1)
    beq $t1, '\n', r2O5
    beq $t1,'\0',checkIDo5
    addi $a1, $a1, 1 
    j    newLineO5
printLineO5:
    li $t7, 7
    sub $a1,$a1,$t7
    addi $t3,$t3,1
    li $v0,1
    move $a0,$t3
    syscall 
    li $v0,11
    li $a0,'_'
    syscall
printLineO5S:
    lb $t1, 0($a1)
    beq $t1, '\n', r3O5
    beq $t1,'\0',exit
    addi $a1, $a1, 1 
    # Print ID
    li $v0, 11        # Print the character
    move $a0, $t1     # Move the character to $a0
    syscall
    j printLineO5S
    
r3O5:
    li $v0,11
    li $a0,10
    syscall
r2O5:    
    li $t7,1
    add $a1,$a1,$t7
    
    b r1O5
checkIDo5:
	bne $t3,0,choosenTest
	li $v0,4
	la $a0,notFoundID
	syscall 
	b readIDO5
   
choosenTest:
	li $v0,4
	la $a0,updatedTestNum
	syscall
	li $v0,5
	syscall 
	move $s0, $v0
	jal checkInput
	b searchTestUpdate
checkInput:
	beq $s0,0,choosCorrectTest
	bgt $s0,$t3,choosCorrectTest
	jr $ra
choosCorrectTest:
	li $v0,4
	la $a0 , invalidInputMsg
	syscall 
	b choosenTest
searchTestUpdate:
    # Load address of buffer into register $a1
    la $a1, buffer
    li $s3,0
    #li $s7,0
    li $t3, 0
r1O52:

    # Load initial index (offset) of buffer into register $t0
    li $t0, 0
        # Load address of ID into register $a3
    la $a3, testIDBuffer
	
read7bytesO52:
    # Load byte from buffer at index $t0 into register $t1
    lb $t1, 0($a1) #buffer
    lb $t2,0($a3) #input ID
    bne $t1,$t2, newLineO52
    # Increment index
    addi $t0, $t0, 1
    # Increment buffer pointer
    addi $a1, $a1, 1 #inc off buffer
    addi $a3, $a3, 1 #inc off ID
    beq $t0,7 , isTest
    #beq $t1,'\n',linesCount
contLoop:
    b read7bytesO52
linesCount:
	addi $t3,$t3,1
	#li $v0,1
	#move $a0,$t3
	#syscall 
	b r2O52
isTest: 
	move $a2,$t3
	addi $s3,$s3,1
	bne $s0,$s3 , read7bytesO52 #if not the chosen test
	#if the chosen test
	li $v0,4
	la $a0,enterTestResultMsg
	syscall 	 
	addi $a1,$a1,3
	lb $t7,0($a1)
	beq $t7,'P',updateBPT
	b readResultO5
	b exit
updateBPT:
	li $t9,1
	b readResultO5
newLineO52:
    lb $t1, 0($a1)
    beq $t1, '\n', linesCount
    beq $t1,'\0',isTest
    addi $a1, $a1, 1 
    j    newLineO52
r2O52:    
    li $t7,1
    add $a1,$a1,$t7
    b r1O52
readResultO5:
    #-------------------read test result -------------------------------- 
    # read result as string
    move $t5,$a1
    li $v0, 8
    la $a0, testResultBuffer1
    li $a1, 6
    syscall
    beq $t9,1,readR2O5
    b cutResultToUpdate
readR2O5:
    # read result as string
    li $v0, 4
    la $a0, enterTestResultMsg
    syscall
    li $v0, 8
    la $a0, testResultBuffer2
    li $a1, 6
    syscall
    la $a2,testResultBuffer1
    la $a3,testResultBuffer2
    jal concatnateResults
    b cutResultToUpdate
concatnateResults:
	lb $t1,0($a2)
	beq $t1, '\0',addComma
	addi $a2,$a2,1
	b concatnateResults
addComma:
	subi $a2,$a2,1
	li $t1,','
	sb $t1,0($a2)
	addi $a2,$a2,1
	li $t1,' '
	sb $t1,0($a2)
	addi $a2,$a2,1
loopR2:
	lb $t1,0($a3)
	beq $t1,'\0', endConcat
	sb $t1,0($a2)
	addi $a3,$a3,1
	addi $a2,$a2,1
	b loopR2
endConcat:

	jr $ra
############################################################
cutResultToUpdate:
 	move $a1,$t5
 	subi $a1,$a1,10
 	la $a2, bufferLine
 	la $a3,testResultBuffer1
 	li $t1 ,0 #counter
 	jal  copyLineToBufferLine
 	b exit
 copyLineToBufferLine:
 	lb $t2,0($a1)
 	sb $t2,0($a2)
 	addi $t1,$t1,1
 	addi $a1,$a1,1
 	addi $a2,$a2,1
 	beq $t1,23,newResult
 	b copyLineToBufferLine

newResult:
 	lb $t2,0($a3)
 	beq $t2,'\0',updatedLine
 	sb $t2,0($a2) 
 	addi $a3,$a3,1
 	addi $a2,$a2,1
	b newResult
updatedLine:
	la $a1,buffer
	la $a2,bufferCopy
	la $a3,bufferLine
	li $t2,0
	b copyNewBuffer

		
copyNewBuffer:
	#li $v0,1
	#move $a0,$t3
	#syscall 
	beq $t3,0,addUpdatedLine
	lb $t1,0($a1)
	sb $t1,0($a2)
	lb $t1,0($a1)
	addi $a1,$a1,1
	addi $a2,$a2,1
	beq $t1,'\n',isLine
	#beq $t1,'\0',isLine
	b copyNewBuffer
isLine:
	addi $t2,$t2,1
	beq $t2,$t3,addUpdatedLine
	b copyNewBuffer
addUpdatedLine:
	lb $t1,0($a3)
	sb $t1,0($a2)
	#lb $t1,0($a3)
	beq $t1,'\n',skipLine
	addi $a3,$a3,1
	addi $a2,$a2,1
	b addUpdatedLine
skipLine:
	li $t7,'\n'
	sb $t7,0($a2)
	addi $a2,$a2,1
Skip:
	lb $t1,0($a1)
	addi $a1,$a1,1
	beq $t1,'\n', contCopyLine
	b Skip
contCopyLine:
	lb $t1,0($a1)
	beq $t1,'\0', endUpdate
	sb $t1, 0($a2)
	addi $a1,$a1,1
	addi $a2,$a2,1
	b contCopyLine
endUpdate:
	#li $v0,4
	#la $a0,bufferCopy
	#syscall 
	b saveFile2
saveFile2:
li $t0, 0             # Counter for length
la $t1, bufferCopy        # Load address of the buffer

# calculate the buffer length.
calculateLengthO5:
    lb $t2, ($t1)      # Load a byte from the buffer
    beqz $t2, doneO5     # If null terminator is found, exit loop
    addi $t0, $t0, 1   # Increment counter for length
    addi $t1, $t1, 1   # Move to the next byte in the buffer
    j calculateLengthO5  # Repeat loop
 doneO5:   
        #open file 
    	li $v0,13           	# open_file syscall code = 13
    	la $a0,file_name     	# get the file name
    	li $a1,1           	# file flag = write (1)
    	syscall
    	move $s1,$v0        	# save the file descriptor. $s0 = file
    	
    # Write buffer to the file
    li $v0, 15           # write_file syscall code = 15
    move $a0, $s1        # file descriptor
    la $a1, bufferCopy       # the string that will be written
    move $a2, $t0        # length of the toWrite string (without null terminator)
    syscall
        # Close the file
    li $v0, 16
    move $a0, $s1
    syscall
    
    li $v0,4
    la $a0,bufferCopy
    syscall 

    b main
#------------------------------------------------------option 6---------------------------------------------------------
deleteTest:
readIDO6:
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
validateIDO6:
    div $t0, $t0, 10  # Divide $t0 by 10
    addi $t1, $t1, 1  # Increment the counter
    beqz $t0, checkIDO6
    j validateIDO6  
checkIDO6:
    beq $t1, 7, is7digitsO6
not7digitsO6:
    li $v0,4
    la $a0,invalidInputMsg
    syscall
    j readIDO6
    
is7digitsO6:

allPTestsO6:
    # Load address of buffer into register $a1
    la $a1, buffer
    li $t3,0 #counter
r1O6:
   #li $v0,1
   #li $a0, 9
   #syscall
    # Load initial index (offset) of buffer into register $t0
    li $t0, 0
        # Load address of ID into register $a3
    la $a3, testIDBuffer
read7bytesO6:
    # Load byte from buffer at index $t0 into register $t1
    lb $t1, 0($a1) #buffer
    lb $t2,0($a3) #input ID
    bne $t1,$t2, newLineO6
    # Increment index
    addi $t0, $t0, 1
    # Increment buffer pointer
    addi $a1, $a1, 1 #inc off buffer
    addi $a3, $a3, 1 #inc off ID
    beq $t0,7 , printLineO6
    b read7bytesO6
    #b newLineO5
    # Repeat loop
newLineO6:
    lb $t1, 0($a1)
    beq $t1, '\n', r2O6
    beq $t1,'\0',checkIDo6
    addi $a1, $a1, 1 
    j    newLineO6
printLineO6:
    li $t7, 7
    sub $a1,$a1,$t7
    addi $t3,$t3,1
    li $v0,1
    move $a0,$t3
    syscall 
    li $v0,11
    li $a0,'_'
    syscall
printLineO6S:
    lb $t1, 0($a1)
    beq $t1, '\n', r3O6
    beq $t1,'\0',exit
    addi $a1, $a1, 1 
    # Print ID
    li $v0, 11        # Print the character
    move $a0, $t1     # Move the character to $a0
    syscall
    j printLineO6S
    
r3O6:
    li $v0,11
    li $a0,10
    syscall
r2O6:    
    li $t7,1
    add $a1,$a1,$t7
    
    b r1O6
checkIDo6:
	bne $t3,0,choosenTestO6
	li $v0,4
	la $a0,notFoundID
	syscall 
	b readIDO6
   
choosenTestO6:
	li $v0,4
	la $a0,deleteTestNum
	syscall
	li $v0,5
	syscall 
	move $s0, $v0
	jal checkInputO6
	b searchTestUpdateO6
checkInputO6:
	beq $s0,0,choosCorrectTestO6
	bgt $s0,$t3,choosCorrectTestO6
	jr $ra
choosCorrectTestO6:
	li $v0,4
	la $a0 , invalidInputMsg
	syscall 
	b choosenTestO6
searchTestUpdateO6:
    # Load address of buffer into register $a1
    la $a1, buffer
    li $s3,0
    li $t3, 0
r1O62:
    # Load initial index (offset) of buffer into register $t0
    li $t0, 0
        # Load address of ID into register $a3
    la $a3, testIDBuffer
	
read7bytesO62:
    # Load byte from buffer at index $t0 into register $t1
    lb $t1, 0($a1) #buffer
    lb $t2,0($a3) #input ID
    bne $t1,$t2, newLineO62
    # Increment index
    addi $t0, $t0, 1
    # Increment buffer pointer
    addi $a1, $a1, 1 #inc off buffer
    addi $a3, $a3, 1 #inc off ID
    beq $t0,7 , isTestO6
    #beq $t1,'\n',linesCountO6
contLoopO6:
    b read7bytesO62
linesCountO6:
	addi $t3,$t3,1
	b r2O62
isTestO6: 
	move $a2,$t3
	addi $s3,$s3,1
	bne $s0,$s3 , read7bytesO62 #if not the chosen test
	li $v0,1
	move $a0,$t3
	syscall 
	la $a1,buffer
	la $a2,bufferCopy
	li $t2,0
	beq $t3,0,deleteLine
	b copyBuffer
copyBuffer:
	
	lb $t1,0($a1)
	sb $t1,0($a2)
	beq $t1,'\n',countToDelete
	beq $t1,'\0',printAfterDelete
backCopyO6:
	
	addi $a1,$a1,1
	addi $a2,$a2,1
	b copyBuffer
countToDelete:
	addi $t2,$t2,1
	beq $t2,$t3,deleteLine
	b backCopyO6
deleteLine:
	addi $a1,$a1,1
	lb $t1,0($a1)
	beq $t1,'\n',copyBuffer
	b deleteLine
printAfterDelete:
	li $v0,4
	la $a0,bufferCopy
	syscall 
	b saveToFileO6
newLineO62:
    lb $t1, 0($a1)
    beq $t1, '\n', linesCountO6
    beq $t1,'\0',isTestO6
    addi $a1, $a1, 1 
    j    newLineO62
r2O62:    
    li $t7,1
    add $a1,$a1,$t7
    b r1O62
    
saveToFileO6:
li $t0, 0             # Counter for length
la $t1, bufferCopy        # Load address of the buffer

# calculate the buffer length.
calculateLengthO6:
    lb $t2, ($t1)      # Load a byte from the buffer
    beqz $t2, doneO6     # If null terminator is found, exit loop
    addi $t0, $t0, 1   # Increment counter for length
    addi $t1, $t1, 1   # Move to the next byte in the buffer
    j calculateLengthO6  # Repeat loop
 doneO6:   
        #open file 
    	li $v0,13           	# open_file syscall code = 13
    	la $a0,file_name     	# get the file name
    	li $a1,1           	# file flag = write (1)
    	syscall
    	move $s1,$v0        	# save the file descriptor. $s0 = file
    	
    # Write buffer to the file
    li $v0, 15           # write_file syscall code = 15
    move $a0, $s1        # file descriptor
    la $a1, bufferCopy       # the string that will be written
    move $a2, $t0        # length of the toWrite string (without null terminator)
    syscall
        # Close the file
    li $v0, 16
    move $a0, $s1
    syscall
    
    li $v0,4
    la $a0,bufferCopy
    syscall 

    b main
   
