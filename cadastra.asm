.data 
.align 4
ABASTECIMENTOS: .space 4400 #11(w)*4(B)*100(armazenamentos)
ULTIMO_ABASTECIMENTO: .word 0
ABASTECIMENTO_POINTER: .word 0
ABASTECIMENTO_COUNT: .word 0
# ESTRUTURA DE DADOS:
# [ dia  | mes  | ano  | nome |  km   | litro  |  preço  ]
# ( 01w  | 01w  | 01w  | 16b  |  01w  |  01w   |   01w   )
# ----------------------------------------------------
# OFFSETS INTERNOS:     (em bytes)
.eqv DIA_OFFSET 0	# dia:   0
.eqv MES_OFFSET 4	# mes:   4
.eqv ANO_OFFSET 8	# ano:   8
.eqv NOME_OFFSET 12	# nome:  12
.eqv KM_OFFSET 28	# km:    28
.eqv LITRO_OFFSET 32	# litro: 32
.eqv PRECO_OFFSET 36	# preço: 36
.eqv IS_DEAD 40		# exluido: 40
# ======================================================

MENU: .asciiz " 1 - Cadastrar Abastecimento\n 2 - Imprimir Abastecimentos\n 3 - Excluir Abastecimento\n Digite a opcao desejada: "
TXT_INVALIDO: .asciiz "Opcao invalida!\n"
PULA_LINHA: .asciiz "\n"  
TXT_DIA: .asciiz "Dia: "
TXT_MES: .asciiz "Mes: "
TXT_ANO: .asciiz "Ano(2 ultimos digitos): "
TXT_NOME: .asciiz "Nome do posto: "
TXT_KM: .asciiz "Quilometragem: "
TXT_COMBUSTIVEL: .asciiz "Quantidade de combustivel: "
TXT_PRECO: .asciiz "Preco: "
TXT_DEAD: .asciiz "Dead: "
DIVISOR: .asciiz "##########################################"


.text
.globl main 

main: 

printaMenu:
    addi 	    $v0, $zero, 4 
	la 	        $a0, DIVISOR 
	syscall
    
	jal	        println
	addi	    $v0, $zero, 4               # para printar uma string colocar o codigo 4 em v0
	la	        $a0, MENU                   # colocar o endereco da mensagem em a0
	syscall 

	addi	    $v0, $zero, 5               # para receber um inteiro colocar codigo 5
	syscall
	addi	    $s0, $v0, 0                 # o inteiro digitado fica salvo em v0 guardar em s0

	li	        $s1, 1 #                    colocar 1 em s1 para comparar se digitou opcao 1
	beq	        $s1, $s0, cadastraAbastecimentoPonte

    	li	        $s1, 2 #                    colocar 2 em s1 para comparar se digitou opcao 2
	beq	        $s1, $s0, imprimirTudo
	
	li	        $s1, 3 #                    colocar 2 em s1 para comparar se digitou opcao 2
	beq	        $s1, $s0, excluiAbastecimento

	addi	    $v0, $zero, 4               # para printar uma string colocar o codigo 4 em v0
	la	        $a0, TXT_INVALIDO           # colocar o endereço da mensagem em a0
	syscall 
	j	        voltaMenu

cadastraAbastecimentoPonte: j cadastraAbastecimento

############################################################################

cadastraAbastecimento:
    	addi 	    $v0, $zero, 4 
	la 	        $a0, DIVISOR 
	syscall

	la 	        $t1, ABASTECIMENTOS         # carrega endereço de ABASTECIMENTOS em t1
	lw	        $t0, ULTIMO_ABASTECIMENTO   #valor 0~99
	mul         $t0, $t0, 44
	add	        $t1, $t1, $t0               #endereço real do ultimo abastecimento em $t1
                                            # $t1 contem endereço do abastecimento em si (FIXO)

	jal 	println

#DIA
	addi 	    $v0, $zero, 4 
	la 	        $a0, TXT_DIA 
	syscall

	addi 	    $v0, $zero, 5               # para receber um inteiro colocar codigo 5
	syscall                                 # value in $v0
	
    sw 	        $v0, DIA_OFFSET($t1)

#MES
	addi 	    $v0, $zero, 4 
	la 	        $a0, TXT_MES
	syscall

	addi 	    $v0, $zero, 5               # para receber um inteiro colocar codigo 5
	syscall                                 # value in $v0
	sw 	        $v0, MES_OFFSET($t1)

#ANO
	addi 	    $v0, $zero, 4 
	la 	        $a0, TXT_ANO 
	syscall

	addi 	    $v0, $zero, 5               # para receber um inteiro colocar codigo 5
	syscall                                 # value in $v0
	sw 	        $v0, ANO_OFFSET($t1)

#NOME
	addi 	    $v0, $zero, 4 
	la 	        $a0, TXT_NOME 
	syscall 

	addi	    $v0,$zero,8
	la	        $a0,NOME_OFFSET($t1)
	addi	    $a1,$zero,16
	syscall

#KM
	addi 	    $v0, $zero, 4 
	la 	        $a0, TXT_KM
	syscall

	addi 	    $v0, $zero, 6               # para receber um float 6
	syscall                                 # value in $f0
	s.s	        $f0, KM_OFFSET($t1)

#QUANTIDADE COMBUSTIVEL
	addi 	    $v0, $zero, 4 
	la 	        $a0, TXT_COMBUSTIVEL
	syscall

	addi 	    $v0, $zero, 6               # para receber um float 6
	syscall                                 # value in $f0
	s.s	        $f0, LITRO_OFFSET($t1)

#PRECO
	addi 	    $v0, $zero, 4 
	la 	        $a0, TXT_PRECO
	syscall

	addi 	    $v0, $zero, 6               # para receber um float 6
	syscall                                 # value in $f0
	s.s 	    $f0, PRECO_OFFSET($t1)

	jal println

#ULTIMO_ABASTECIMENTO++

	lw	        $t0, ULTIMO_ABASTECIMENTO
	addi	    $t0, $t0, 1
	sw 	        $t0, ULTIMO_ABASTECIMENTO

#ABASTECIMENTO_COUNT = ULTIMO_ABASTECIMENTO
	sw 	        $t0, ABASTECIMENTO_COUNT

    j           voltaMenu

######################## VOLTA PARA O MENU #########################

voltaMenu:
	j           printaMenu

############################### PRINTA NOVA LINHA #########################
	println:
    
	addi	    $v0, $zero, 4 
	la	        $a0, PULA_LINHA 
	syscall
	
    	jr	        $ra 
	
	
imprimirAbastecimento:
	lw $t8, IS_DEAD($t1) 				# verifica se foi excluido
	bne $t8, $zero, exit_imprime_abastecimento	# se foi excluido, pula impress�o
	
    	addi 	    $v0, $zero, 4 
	la 	    $a0, DIVISOR 
	syscall

    	addi	    $sp, $sp, -4			   # $sp = $sp - 4 configure offset
    	sw          $ra, 0($sp)                # save on stack

	jal	        println

    #<------------DIA------------>
    	addi 	    $v0, $zero, 4 
	la 	        $a0, TXT_DIA 
	syscall

	lw	        $a0, DIA_OFFSET($t1)	    #carrega valor do teclado no $a0
	li	        $v0, 1                      # get print integers
	syscall 
    	jal		    println				        # jump to println and save position to $ra
    
    #<------------DIA------------>

    #<------------MES------------>
	addi 	    $v0, $zero, 4 
	la 	        $a0, TXT_MES
	syscall

	lw	        $a0, MES_OFFSET($t1)	    #carrega valor do teclado no $a0
	li	        $v0, 1                      # get print integers
	syscall 
    	jal		    println				        # jump to println and save position to $ra
    #<^^^^^^^^^^^^MES^^^^^^^^^^^^>

    #<------------ANO------------>
	addi 	    $v0, $zero, 4 
	la 	        $a0, TXT_ANO 
	syscall

	lw	        $a0, ANO_OFFSET($t1)	    #carrega valor do teclado no $a0
	li	        $v0, 1                      # get print integers
	syscall 
    jal		    println				        # jump to println and save position to $ra
    #<^^^^^^^^^^^^ANO^^^^^^^^^^^^>

    #<------------NOME------------>
	addi 	    $v0, $zero, 4 
	la 	        $a0, TXT_NOME 
	syscall 

	la	        $a0,NOME_OFFSET($t1)
	li 	        $v0, 4                      # print string
    syscall
    jal		    println				        # jump to println and save position to $ra
    #<^^^^^^^^^^^^NOME^^^^^^^^^^^^>

    #<------------KM------------>
	addi 	    $v0, $zero, 4 
	la 	        $a0, TXT_KM
	syscall

	l.s	        $f12, KM_OFFSET($t1)
	li	        $v0, 2                      # get print float
	syscall 
    	jal		    println				        # jump to println and save position to $ra
    #<^^^^^^^^^^^^KM^^^^^^^^^^^^>

    #<------------LITRO------------>
	addi 	    $v0, $zero, 4 
	la 	        $a0, TXT_COMBUSTIVEL
	syscall

	l.s	        $f12, LITRO_OFFSET($t1)
	li	        $v0, 2                      # get print float
	syscall 
    	jal		    println				        # jump to println and save position to $ra
    #<^^^^^^^^^^^^LITRO^^^^^^^^^^^^>

    #<------------PRECO------------>
	addi 	    $v0, $zero, 4 
	la 	        $a0, TXT_PRECO
	syscall
    
	l.s	        $f12, PRECO_OFFSET($t1)
	li	        $v0, 2                      # get print float
	syscall 
    	jal		    println				        # jump to println and save position to $ra'
    #<------------PRECO------------>

 exit_imprime_abastecimento:
    	lw		    $ra, 0($sp)		            # restore stack
    	jr		    $ra					        # jump to $ra

imprimirTudo:
	lw	        $t0, ULTIMO_ABASTECIMENTO       # valor 0~99
	la 	        $t1, ABASTECIMENTOS             # carrega endereço de ABASTECIMENTOS em t1
    	li		$t2, 0		                    # $t2 =0 

    	beq		$t0, $zero, exit	            # if $t0 == $t1 then exit    
    
    loop:
        jal		    imprimirAbastecimento	
        
        addi	    $t1, $t1, 44
        add		    $a0, $t1, $zero		        # $a0 = $t1 +zerot2

        addi	    $t2, $t2, 1			        # $t2 = $t2 + 1

        beq		    $t0, $t2, exit	            # if $t0 == $t1 then target
        jal		    println				        # jump to println and save position to $ra'
        j		    loop				        # jump to target        

    exit:
        j		    voltaMenu				    # jump to voltaMenu
        
#------------------------EXCLUI ABASTECIMENTO------------------------------#

excluiAbastecimento:
	addi $sp, $sp, -24
	lw $t1, 0($sp)
	lw $t2, 4($sp)
	lw $t3, 8($sp)
	lw $t4, 12($sp)
	lw $t5, 16($sp)
	lw $t6, 20($sp)
	
	#DIA
	addi 	    $v0, $zero, 4 
	la 	        $a0, TXT_DIA 
	syscall

	addi 	    $v0, $zero, 5               # para receber um inteiro colocar codigo 5
	syscall                                 # value in $v0
	move $t1, $v0

#MES
	addi 	    $v0, $zero, 4 
	la 	        $a0, TXT_MES
	syscall

	addi 	    $v0, $zero, 5               # para receber um inteiro colocar codigo 5
	syscall                                 # value in $v0
	move $t2, $v0
#ANO
	addi 	    $v0, $zero, 4 
	la 	    $a0, TXT_ANO 
	syscall

	addi 	    $v0, $zero, 5               # para receber um inteiro colocar codigo 5
	syscall                                 # value in $v0
        move $t3, $v0
        
        #--- loop ---#
        lw	        $t4, ULTIMO_ABASTECIMENTO       # valor 0~99
	la 	        $t5, ABASTECIMENTOS             # carrega endereço de ABASTECIMENTOS em t1
    	li		$t6, 0		                    # $t2 =0 

    	beq		$t4, $zero, excluir_exit	            # if $t0 == $t1 then exit    
    
    excluir_loop:
        #procurar por data
        jal exclui_por_data	
        
        addi	    $t5, $t5, 44
        add	    $a0, $t5, $zero		        # $a0 = $t1 +zerot2

        addi	    $t6, $t6, 1			        # $t2 = $t2 + 1

        beq		    $t4, $t6, exit	            # if $t0 == $t1 then target
        jal		    println				        # jump to println and save position to $ra'
        j		    excluir_loop				        # jump to target
        #--- loop ---#
        
excluir_exit:  
	sw 		$t1, 0($sp)
	sw 		$t2, 4($sp)
	sw 		$t3, 8($sp)
	sw 		$t4, 12($sp)
	sw 		$t5, 16($sp)
	sw 		$t6, 20($sp)
	addi 		$sp, $sp, 24
        j		voltaMenu


#------------------------EXCLUI ABASTECIMENTO POR DATA------------------------------#
exclui_por_data:
	addi	    $sp, $sp, -20			# $sp = $sp - 4 configure offset
	sw	    $ra, 0($sp)
    	sw          $a0, 4($sp)
    	sw          $a1, 8($sp)
    	sw          $a2, 12($sp)
    	sw	    $t9, 16($sp)
    	
    	lw          $a0, DIA_OFFSET($t5)	    #carrega valor do teclado no $a0
    	lw          $a1, MES_OFFSET($t5)	    #carrega valor do teclado no $a0
    	lw          $a2, ANO_OFFSET($t5)	    #carrega valor do teclado no $a0

	bne	$a0, $t1, exit_excluir_por_data
	bne	$a1, $t2, exit_excluir_por_data
	bne	$a2, $t3, exit_excluir_por_data
	
	add	$t9, $zero, $zero
	add 	$t9, $zero, 1
	sw 	$t9, IS_DEAD($t5)
	
exit_excluir_por_data:	
	lw		    $ra, 0($sp)		            # restore stack
	lw		    $a0, 4($sp)	
	lw		    $a1, 8($sp)	
	lw		    $a2, 12($sp)
	lw	    	    $t9, 16($sp)
	addi		    $sp, $sp, 20	
    	jr		    $ra
	
	
