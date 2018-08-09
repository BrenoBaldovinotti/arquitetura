	.text 				
	.globl main 		

main:
	move $s0,$gp		
	addi $s0,$s0,5000 	# Ponteiro para os dados do array fonte ($gp + 5000)
	move $s2,$s0
	addi $s2,$s2,400	# Marcador para indicar o final do array $s0 + (100posi��es de 4bytes)

	li $t0,9		# Carrega no reg. tempor�rio $t0 um valor para ser armazenado no array
dados:
	sw $t0,0($s0)		# Armazena o valor na posi��o do array apontada por $s0
	addi $s0,$s0,4		# Aponta para a pr�xima posi��o no array (incrementa em 4 o ponteiro)
	addi $t0,$t0,9		# Altera o valor a ser armazenado no array (incrementa em 9)
	bne $s0,$s2,dados	# Enquanto n�o chegar ao fim do array, repete o la�o

	move $s0,$gp	
	addi $s0,$s0,5000	# Definimos novamente o ponteiro para os dados do array fonte ($gp + 5000)
	move $s1,$gp	
	addi $s1,$s1,6000	# # Ponteiro para os dados do array destino ($gp + 6000)
transfere:
	lw $t0,0($s0)		# Armazena em t0 o conte�do da posi��o apontada por $s0 (array fonte)
	sw $t0,0($s1)		# Armazena no array destino (apontado por $s1) o valor carregado
	addi $s0,$s0,4		# Incrementa s0 em 4 (para chegar-se ao pr�ximo elemento no array fonte)
	addi $s1,$s1,4		# Incrementa s1 em 4 (para chegar-se ao pr�ximo elemento no array destino)
	bne $s0,$s2,transfere	# Enquanto s0 n�o chegar em 400 (100 elementos), repete o la�o