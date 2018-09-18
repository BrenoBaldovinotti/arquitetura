#Manda msg, Le do teclado um float e printa
.data # Data declaration section
	prompt_float: .asciiz "Enter an float value:\n"
	newLine: .asciiz "\n"
.text
main: # Start of code section
	jal get_float # Call procedure
	move $s0, $v0 # Put returned value in "save" reg

get_float:
	#printa texto
	li $v0, 4 # system call code for printing a, string = 4
	la $a0, prompt_float # address of string is argument 0 to, print_string
	syscall # call operating system to perform

	#le um float do teclado
	li $v0, 6 # get ready to read in float
	syscall # system waits for input, puts the
	# value in $f0

	#printa float
	mov.s $f12, $f0
	li  $v0, 2 # get print float
	syscall 

	#printa uma nova linha
	li $v0, 4 
	la $a0, newLine
	syscall
	
	jr $ra
