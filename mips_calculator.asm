.data
	options:	.asciiz "0: addition\n1: subtraction\n2: multiplication\n3: division\n4: factorial\n-1: quit\n"
	mainprompt:	.asciiz "Please select an option: "
	newline:	.asciiz "\n"
	goodbye:	.asciiz "Goodbye!\n"
	addprompt:	.asciiz "Welcome to addition\n"
	subprompt:	.asciiz "Welcome to subtraction\n"
	multprompt:	.asciiz "Welcome to multiplication\n"
	divprompt:	.asciiz "Welcome to division\n"
	factprompt:	.asciiz "Welcome to factorial\n"
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
			
			j while
			
		endoperation:
			j while
			
	handleadd:
	
		# print the prompt
		li $v0, 4
		la $a0, addprompt
		syscall
		
		# get number
		# store the ra
		addi $sp, $sp, -4
		sw $ra, 0($sp)
		jal getnumber
		lw $ra, 0($sp)
		addi $sp, $sp, 4
		
		j endoperation
		
	handlesub:
		# print the prompt
		li $v0, 4
		la $a0, subprompt
		syscall
		
		# get number
		# store the ra
		addi $sp, $sp, -4
		sw $ra, 0($sp)
		jal getnumber
		lw $ra, 0($sp)
		addi $sp, $sp, 4
		
		j endoperation
		
	handlemult:
		# print the prompt
		li $v0, 4
		la $a0, multprompt
		syscall
		
		# get number
		# store the ra
		addi $sp, $sp, -4
		sw $ra, 0($sp)
		jal getnumber
		lw $ra, 0($sp)
		addi $sp, $sp, 4
		
		j endoperation
		
	handlediv:
		# print the prompt
		li $v0, 4
		la $a0, divprompt
		syscall
		
		# get number
		# store the ra
		addi $sp, $sp, -4
		sw $ra, 0($sp)
		jal getnumber
		lw $ra, 0($sp)
		addi $sp, $sp, 4
		
		j endoperation
	handlefact:
		# print the prompt
		li $v0, 4
		la $a0, factprompt
		syscall
		
		# get number
		# store the ra
		addi $sp, $sp, -4
		sw $ra, 0($sp)
		jal getnumber
		lw $ra, 0($sp)
		addi $sp, $sp, 4
		
		j endoperation
		
	printoptions:
		# print the options
		li $v0, 4
		la $a0, options
		syscall
		
		# printline
		# store the ret address so nothing overwritten
		addi $sp, $sp, -4
		sw $ra, 0($sp)
		jal printnewline
		
		# load from stack
		lw $ra, 0($sp)
		# pop stack
		addi $sp, $sp, 4
		
		li $v0, 4
		la $a0, mainprompt
		syscall
		
		jr $ra
			
	getnumber:
	
		# read int
		li $v0, 5
		syscall
		
		# store the result in $v1; we use $v0 a lot for syscall, don't cross the streams
		addi $v1, $v0, 0
		
		jr $ra
		
	printnewline:
		# prints a new line
		li $v0, 4
		la $a0, newline
		syscall
		
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
		
		
