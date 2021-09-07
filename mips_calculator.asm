.data
	options:	.asciiz "\n0: addition\n1: subtraction\n2: multiplication\n3: division\n4: factorial\n-1: quit\n"
	mainprompt:	.asciiz "Please select an option:\n"
	newline:	.asciiz "\n"
	goodbye:	.asciiz "Goodbye!\n"
	addprompt:	.asciiz "Enter two numbers:\n"
	subprompt:	.asciiz "Enter two numbers:\n"
	multprompt:	.asciiz "Enter two numbers:\n"
	divprompt:	.asciiz "Enter two numbers:\n"
	fibprompt:	.asciiz "Enter a number:\n"
	factprompt:	.asciiz "Enter a number:\n"
	
	addend:		.asciiz "The summation is:\n"
	subend:		.asciiz "The subtraction is:\n"
	
	fibend:		.asciiz "The fib value is:\n"
.text
	main:
		while:
			# print prompt
			jal printoptions
		
			# get the number, ret in $v1
			jal getnumber
			
			addi $t0, $zero, -1
			# if enter -1, exit
			beq $v1,$t0, exit
			# else, keep looping
			
			# check the selection
			addi $t0, $zero, 0
			beq $v1, $t0, handleadd
			
			addi $t0, $zero, 1
			beq $v1, $t0, handlesub
			
			addi $t0, $zero, 2
			beq $v1, $t0, handlemult
			
			addi $t0, $zero, 3
			beq $v1, $t0, handlediv
			
			addi $t0, $zero, 4
			beq $v1, $t0, handlefact
	endoperation:
		j while
			
	handleadd:
		addi $sp, $sp, -12
		sw $ra, 8($sp)
		sw $v0, 4($sp)
		sw $a0, 0($sp)
		
		# print the prompt
		li $v0, 4
		la $a0, addprompt
		syscall
		
		# get number
		# store the ra

		jal getnumber
		addi $t0, $v1, 0
		
		jal getnumber
		addi $t1, $v1, 0
		
		add $t2, $t0, $t1
		
		# print the prompt
		li $v0, 4
		la $a0, addend
		syscall

		addi $a1, $t2, 0
		jal printint


		lw $ra, 8($sp)
		lw $v0, 4($sp)
		lw $a0, 0($sp)
		addi $sp, $sp, 12
		
		j endoperation
		
	handlesub:
		addi $sp, $sp, -12
		sw $ra, 8($sp)
		sw $v0, 4($sp)
		sw $a0, 0($sp)
		
		# print the prompt
		li $v0, 4
		la $a0, subprompt
		syscall
		
		# get number
		# store the ra

		jal getnumber
		addi $t0, $v1, 0
		
		jal getnumber
		addi $t1, $v1, 0
		
		sub $t2, $t0, $t1
		
		# print the prompt
		li $v0, 4
		la $a0, subend
		syscall

		addi $a1, $t2, 0
		jal printint


		lw $ra, 8($sp)
		lw $v0, 4($sp)
		lw $a0, 0($sp)
		addi $sp, $sp, 12
		
		j endoperation
		
	handlemult:
		addi $sp, $sp, -12
		sw $v0, 8($sp)
		sw $a0, 4($sp)
		sw $ra, 0($sp)
		# print the prompt
		li $v0, 4
		la $a0, multprompt
		syscall
		
		# get number

		jal getnumber
		addi $t0, $v1, 0
		
		lw $v0, 8($sp)
		lw $a0, 4($sp)
		lw $ra, 0($sp)
		addi $sp, $sp, 12
		
		j endoperation
		
	handlediv:
		addi $sp, $sp, -12
		sw $ra, 8($sp)
		sw $v0, 4($sp)
		sw $a0, 0($sp)
		# print the prompt
		li $v0, 4
		la $a0, divprompt
		syscall
		
		# get number
		
		jal getnumber
		addi $a1, $v1, 0
		
		jal printint

		lw $ra, 8($sp)
		lw $v0, 4($sp)
		lw $a0, 0($sp)
		addi $sp, $sp, 12
		
		j endoperation
	
	handlefact:
		# print the prompt
		li $v0, 4
		la $a0, factprompt
		syscall
		
		# get the number in $v1
		addi $sp, $sp, -4
		sw $ra, 0($sp)
		jal getnumber

		# call fib with $a1 as the number we got from `getnumber`
		move $a1, $v1
		jal fact
		
		
		move $a1, $v1
		jal printint
		
		lw $ra, 0($sp)
		# pop stack
		addi $sp, $sp, 4

		j endoperation
		
		
	fact:
		# if $a1 > 1 recurse
		addi $t0, $zero, 1
		bgt $a1, $t0, fact_recurse
		# else return 1
		addi $v1, $zero, 1
		jr $ra
		
	
	fact_recurse:
		# store the arg and ra
		addi $sp, $sp, -8
		sw $ra, 4($sp)
		sw $a1, 0($sp)
		
		# call fib n-1
		addi $a1, $a1, -1
		jal fact
		# restore ra, n
		lw $ra, 4($sp)
		lw $a1, 0($sp)
		# pop stack
		addi $sp, $sp, 8
		# return fact(n-1) * n
		mul $v1, $v1, $a1
		
		jr $ra
				
		
	printoptions:
		addi $sp, $sp, -12
		sw $ra, 8($sp)
		sw $v0, 4($sp)
		sw $a0, 0($sp)
		
		# print the options
		li $v0, 4
		la $a0, options
		syscall
		
		# printline
		# store the ret address so nothing overwritten
		jal printnewline
		
		li $v0, 4
		la $a0, mainprompt
		syscall
		
		lw $ra, 8($sp)
		lw $v0, 4($sp)
		lw $a0, 0($sp)
		addi $sp, $sp, 12
		
		jr $ra
			
	getnumber:
		addi $sp, $sp, -4
		sw $v0, 0($sp)
		
		
		# read int
		li $v0, 5
		syscall
		
		# store the result in $v1; we use $v0 a lot for syscall, don't cross the streams
		addi $v1, $v0, 0
		
		
		lw $v0, 0($sp)
		addi $sp, $sp, 4


		
		jr $ra
		
	printnewline:
		addi $sp, $sp,-8
		sw $a0, 4($sp)
		sw $v0, 0($sp)
		
		
		# prints a new line
		li $v0, 4
		la $a0, newline
		syscall
		
		lw $a0, 4($sp)
		lw $v0, 0($sp)
		addi $sp, $sp, 8
		
		jr $ra
	
	printint:
		addi $sp, $sp, -8
		sw $v0, 4($sp)
		sw $a0, 0($sp)
		
		# prints the integer found in $a1
		li $v0, 1
		add $a0, $a1, $zero
		
		syscall
		
		lw $v0, 4($sp)
		lw $a0, 0($sp)
		addi $sp, $sp, 8
		
		jr $ra
		
	exit:

		
		# print new line before
		# note we don't need to store ret address here
		jal printnewline
		li $v0, 4
		la $a0, goodbye
		syscall

	
	# end the prog
	li $v0, 10
	syscall
		
		
