.data 
	TEXTO: .asciiz "\n1 - Cadastrar Abastecimento;\n2 - Excluir Abastecimento;\n3 - Exibir Abastecimento;\n4 - Exibir Consumo Medio; \n5 - Exibir Preco Medio\n6 - Sair; \n\nEscolha uma opcao: "
	TEXTO_INVALIDO: .asciiz "\nOpcao Invalida!\n"
	##### textos usados como auxiliar de teste #########
	TEXTO1: .asciiz "\nTexto 1\n"
	TEXTO2: .asciiz "\nTexto 2\n"
	TEXTO3: .asciiz "\nTexto 3\n"
	TEXTO4: .asciiz "\nTexto 4\n"	
	TEXTO5: .asciiz "\nTexto 5\n"
	####################################################
	
.text
main: 
	jal		get_option				# jump to target and save position to $ra
	move 	$s0, $v0				# $s0 = $v0

get_option:
	li		$v0, 4		# $v0 = 4
	la		$a0, TEXTO		# 
	syscall

	#le um inteiro do teclado

	li		$v0, 5		# $v0 = 5
	syscall 
	
	bne		$v0, 1, opcao_2	# if $v0 != 1 then opcao_2
	
# opcao 1 - cadastrar abastecimento
	### chamar cadastrar abastecimento ####

	li		$v0, 4		# $v0 = 4
	la		$a0, TEXTO1		# 
	syscall
	j		volta				# jump to volta
	
opcao_2: # 2 - excluir abastecimento

	bne		$v0, 2, opcao_3	# if $v0 != 2 then opcao_3
	
	##### chamar excluir abastecimento #####

	li		$v0, 4		# $v0 = 4
	la		$a0, TEXTO2		# 
	syscall
	j		volta				# jump to volta
	
opcao_3: # 3 - exibir abastecimento

	bne		$v0, 3, opcao_4	# if $v0 != 3 then opcao_4
	
	##### chamar exibir abastecimento #######
	li		$v0, 4		# $v0 = 4
	la		$a0, TEXTO3		# 
	syscall
	j		volta				# jump to volta
	
opcao_4: # 4 - exibir consumo medio

	bne		$v0, 4, opcao_5	# if $v0 != 4 then opcao_5

	##### chamar exibir consumo medio #######
	li		$v0, 4		# $v0 = 4
	la		$a0, TEXTO4		# 
	syscall
	j		volta				# jump to volta

opcao_5: # 5 - exibir preco medio

	bne		$v0, 5, opcao_6	# if $v0 != 5 then opcao_6
	
	##### chamar exibir preco medio #######
	li		$v0, 4		# $v0 = 4
	la		$a0, TEXTO5		# 
	syscall
	j		volta				# jump to volta
	
opcao_6: # 6 -  Sai do programa

	bne		$v0, 6, opcao_invalido	# if $v0 != 6 then opcao_invalido

	li		$v0, 10		# $v0 = 10
	syscall

opcao_invalido:

	li		$v0, 4		# $v0 = 4
	la		$a0, TEXTO_INVALIDO		# 
	syscall

volta:	
	jr		$ra					# jump to $ra