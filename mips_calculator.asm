.data
	welcome:	.asciiz "Welcome to the integer calculator!\nAll calculations are done using integers.\nThis means division may cut off, and factorial might overflow!\n"
	options:	.asciiz "\n0: addition\n1: subtraction\n2: multiplication\n3: division\n4: factorial\n-1: quit\n"
	mainprompt:	.asciiz "Please select an option:\n"
	newline:	.asciiz "\n"
	goodbye:	.asciiz "Goodbye!\n"
	addprompt:	.asciiz "Welcome to addition.\nEnter two integers:\n"
	subprompt:	.asciiz "Welcome to subtraction.\nEnter two integers:\n"
	multprompt:	.asciiz "Welcome to mulitiplication.\nEnter two integers:\n"
	divprompt:	.asciiz "Welcome to division.\nEnter two numbers:\n"
	factprompt:	.asciiz "Welcome to factorial.\nEnter an integer:\n"
	finalvalue:	.asciiz "The final value is:\n"
.text
	main:
			jal printwelcome
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

		addi $a1, $t2, 0
		jal printfinalvalue


		lw $ra, 8($sp)
		lw $v0, 4($sp)
		lw $a0, 0($sp)
		addi $sp, $sp, 12
		
		j while
		
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
		

		addi $a1, $t2, 0
		jal printfinalvalue



		lw $ra, 8($sp)
		lw $v0, 4($sp)
		lw $a0, 0($sp)
		addi $sp, $sp, 12
		
		#j endoperation
		j while
		
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
		
		jal getnumber
		addi $t1, $v1, 0
		
		# multiply
		mul $t0, $t0, $t1
		

		
		# call "printfinalvalue" with $a1
		addi $a1, $t0, 0
		jal printfinalvalue

		
		lw $v0, 8($sp)
		lw $a0, 4($sp)
		lw $ra, 0($sp)
		addi $sp, $sp, 12
		
		#j endoperation
		j while
		
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
		addi $t0, $v1, 0
		
		jal getnumber
		addi $t1, $v1, 0
		
		div $t0, $t0, $t1
		
		# print the value in $a1
		addi $a1, $t0, 0
		jal printfinalvalue

		lw $ra, 8($sp)
		lw $v0, 4($sp)
		lw $a0, 0($sp)
		addi $sp, $sp, 12
		
		j while
	
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

		j while
		
		
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
		
	printfinalvalue:
		addi $sp, $sp, -12
		sw $a1, 0($sp)
		sw $ra, 4($sp)
		sw $a0, 8($sp)
		
		# print "the final value is"
		li $v0, 4
		la $a0, finalvalue
		syscall
		
		# call print int with $a1, passed to function
		jal printint
		
		jal printnewline
		
		lw $a1,0($sp)
		lw $ra, 4($sp)
		lw $a0, 8($sp)
		addi $sp, $sp, 12
		
		jr $ra
		
	printwelcome:
		addi $sp, $sp, -8
		sw $a0, 0($sp)
		sw $v0, 4($sp)
		
		li $v0, 4
		la $a0, welcome
		syscall
		
		lw $a0, 0($sp)
		lw $v0, 4($sp)
		addi $sp, $sp, 8
		
	printnewline:
		addi $sp, $sp,-12
		sw $ra, 8($sp)
		sw $a0, 4($sp)
		sw $v0, 0($sp)
		
		
		# prints a new line
		li $v0, 4
		la $a0, newline
		syscall
		
		lw $ra, 8($sp)
		lw $a0, 4($sp)
		lw $v0, 0($sp)
		addi $sp, $sp, 12
		
		jr $ra
	
	printint:
		addi $sp, $sp, -12
		sw $ra, 8($sp)
		sw $v0, 4($sp)
		sw $a0, 0($sp)
		
		# prints the integer found in $a1
		li $v0, 1
		add $a0, $a1, $zero
		syscall
		
		lw $ra, 8($sp)
		lw $v0, 4($sp)
		lw $a0, 0($sp)
		addi $sp, $sp, 12
		
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
		
		
