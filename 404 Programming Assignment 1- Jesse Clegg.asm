#Jesse Clegg-Assignment 1 
#404 Spring 2022
.data 
	myArray: .space 16
	firstPrompt: .asciiz "Enter 0 to sort in descending order.\n"
	secondPrompt: .asciiz "Any number different than 0 will sort in ascending order.\n"
	beforeSort: .asciiz "Before Sort:\n"
	emptyspace: .asciiz " "
	afterSort: .asciiz "\n\nAfter Sort:\n"
	newline: .asciiz "\n"

.text
.globl main

	main:
	
	#store the length of the array
	addi $t1, $zero, 0
	addi $t1, $zero, 9
	
	#store all the numbers in the array
	#moves offset of 4 each time
	addi $t0, $zero, 0 
	addi $s0, $zero, 7
	sw $s0, myArray($t0) 
		addi $t0, $t0, 4 
	
	addi $s0, $zero, 9
	sw $s0, myArray($t0) 
		addi $t0, $t0, 4
	
	addi $s0, $zero, 4
	sw $s0, myArray($t0) 
		addi $t0, $t0, 4 
	
	addi $s0, $zero, 3
	sw $s0, myArray($t0) 
		addi $t0, $t0, 4 
	
	addi $s0, $zero, 8
	sw $s0, myArray($t0) 
		addi $t0, $t0, 4 
	
	addi $s0, $zero, 1
	sw $s0, myArray($t0) 
		addi $t0, $t0, 4 
		
	addi $s0, $zero, 6
	sw $s0, myArray($t0) 
		addi $t0, $t0, 4 
		
	addi $s0, $zero, 2
	sw $s0, myArray($t0) 
		addi $t0, $t0, 4 
	
	addi $s0, $zero, 5
	sw $s0, myArray($t0) 
	
	#display user prompts
	li $v0, 4 
	la $a0, firstPrompt
	syscall 

	li $v0, 4 
	la $a0, secondPrompt
	syscall

	#scan user input 
	li $v0, 5
	syscall 
	move $s2, $v0
	
	#display prompt before printing unsorted data
	li $v0, 4 
	la $a0, beforeSort
	syscall
	
	#calls function to print the data	
	jal printData
	
	#set $t3 to zero for int k=0
	addi $s3, $zero, 0
	
	#multiply length by 4, then subtract 4 to use as outter loop counter
	addi $t4, $zero, 0
	add $t4, $t4, $t1
	sll $t4, $t4, 2
	addi $t4, $t4, -4
	
	#multiply length by 4 use as inner loop counter
	addi $t0, $zero, 0
	add $t0, $t0, $t1
	sll $t0, $t0, 2
	
	OutterLoop:
		beq $s3, $t4, breakOutterLoop 
			#set $t5 to be min=k;
			addi $t5, $zero, 0
			addi $t5, $s3, 0
		
			#set $s4 to be j=k+1;
			addi $s4, $zero, 0
			addi $s4, $s3, 4
			
			innerloop:
				beq $s4, $t0, breakInnerLoop
					#load myArray[min] into $t8
					lw $t8, myArray($t5)
			
					#load myArray[j] into $t7
					lw $t7, myArray($s4)
					addi $a0, $t7, 0
			
					#call check() Function
					jal checkFunction
			
					# $s6 holds return value from check, if 1, set min=j
					# else continue
					beq $s6, $zero, noInnerSwap
				
					#set $t5 to be min=j
					addi $t5, $zero, 0
					add $t5, $s4, $zero

				noInnerSwap:
					#increment loop counter j regardless of swap
					addi $s4, $s4, 4
					j innerloop
		breakInnerLoop:
		beq $s3, $t5, noOutterSwap
			#int temp=0
			addi $t9, $zero, 0
			
			#load list[min] into $t8
			lw $t8, myArray($t5)					
		
			#temp=list[min], now stored in $t9
			add $t9, $t8, 0
			
			#load list[k] into $t8
			addi $t8, $zero, 0
			lw $t8, myArray($s3)
		
			#store $t8 conents to list[min]
			sw $t8, myArray($t5)
		
			#store temp $t9 into list[k]
			sw $t9, myArray($s3)
		
		noOutterSwap:
			#incement loop counter k
			addi $s3, $s3, 4
			j OutterLoop
breakOutterLoop:		
	#print afterSort prompt
	li $v0, 4 
	la $a0, afterSort
	syscall
	
	#print not sorted list
	jal printData
	
	#prints newline
	li $v0, 4 
	la $a0, newline
	syscall

	# code for exit
	li $v0, 10 
	syscall	

checkFunction:
	#clear out $t6
	addi $s6, $zero, 0

	#$s2 holds value for user input
	beq $s2, $zero isDescending	
		isAscending:
			#return 1 if j < min
			slt $s6, $t7, $t8
			jr $ra
			
		isDescending:
			#return 1 if j > min
			slt $s6, $t8, $t7
			jr $ra

printData:
	#set $t3 to int k=0
	addi $t3, $zero, 0
	
	#set $t4 to length*4
	addi $t4, $zero, 0
	add $t4, $t4, $t1
	sll $t4, $t4, 2
	
	printwhile:
		beq $t3, $t4, leavePrintLoop
			#loads array element into t6
			lw $t6, myArray($t3) 
			addi $a0, $t6, 0
		
			#prints that element
			li $v0, 1 
			move $a0, $t6
			syscall
		
			#prints blank space
			li $v0, 4 
			la $a0, emptyspace
			syscall	
	
			#increments counter
			addi $t3, $t3, 4
			j printwhile
	
leavePrintLoop:
jr $ra



	
	







