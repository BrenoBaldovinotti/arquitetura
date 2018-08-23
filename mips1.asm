#TUDO ISSO É DEBUG, NADA FUNCIONA DIREITO.

.data
 MEMORY_STACK: .double 10
 LIST_COUNT: .double 0
 LIST:	.space 4096
.text

main:
 la  $t1, LIST         		# put address of list into $t1
 
 li $t2, 0           		 # put the index into $t2
 
 sw $t2,0($t1)			#Guarda o valor no vetor, posicao 1

 lw $a0, 0($t1)       		# Carrega o valor do vetor na posicao 1
 
 l.d $f12, MEMORY_STACK       	# guarda o valor no registrador f12
 
 li $v0, 3			# Chamada de sistema para imprimir double
 
 syscall			#duh
 
 li $v0, 10			# system call code for exit = 10
 
 syscall			# call operating sys