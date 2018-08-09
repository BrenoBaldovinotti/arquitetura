.text 				
.globl main 		

main:			# Programa Principal
li $a0, 5		# Parametro = 5
jal Fatorial		# Chama a fun��o fatorial, 
			# armazenando o endereco da proxima instrucao em $ra
move $s0, $v0		# Registrador $s0 recebe o valor resultado

li  $v0, 10		# Servi�o do sistema no. 10 : Exit
syscall			# Chamada de servi�o do sistema
			# Obs. Isto � necess�rio para encerrar aqui o programa

#########################################################################

Fatorial:		# Fun��o Fatorial. Retorna o fatorial de n ($a0)
			# Calcula no m�ximo o fatorial de 12, pois utiliza
			# apenas um registrador ($v0) para o resultado.
			# Isto pode ser mudado, basta que se utilize os
			# registradores $lo e $hi (onde s�o colocados os 
			# resultados da multiplica��o) para o resultado.

sub $sp,$sp,4		# Abre espa�o para armazenar 1 item na pilha
sw $ra, 0($sp) 		# Armazena o conte�do do registrador $ra
			# Obs: Caso os registradores $s0 - $s9 fossem
			# alterados, seria necess�rio guard�-los na pilha
			# tamb�m, e restaur�-los ao fim do procedimento
			# Por conven��o, os registradores tempor�rios 
			# $t* n�o precisam ser guardados

li $t1, 1	 	# $t1 = 1
slti $t0, $a0, 2 	# Seta $t0 se $a0 < 2
beq $t0, $zero, Calcula # Se $t0 n�o setado, $a0 > 1, portanto Calcula
add $v0, $zero, $zero 	# Se n�o, $v0 = 0
beq $a0, $zero, Sai	# Se $a0 = 0, Sai
add $v0, $t1, $zero	# Se n�o, $v0 = 1

Sai:
lw $ra, 0($sp) 		# Carrega o registrador $ra da pilha
add $sp, $sp, 4 	# Elimina 1 item da pilha
jr $ra 			# Retorna ao programa principal

Calcula:
add $a1, $a0, $zero 	# $a1 = $a0

Loop:
sub $a1, $a1, $t1	# $a1 = $a1 - 1
jal Multiplica		# Multiplica $a0 por $a1
add $a0, $v0, $zero	# $a0 = resultado da multiplica��o
bne $a1, $t1, Loop 	# Enquanto $a1 for diferente de 1, Loop
j Sai 

Multiplica:
mult $a0, $a1 		# Multiplica $a0 por $a1
mflo $v0 		# resultado em $v0
			# Obs:. O resultado da instru��o mult fica armazenado nos registradores
			# $hi e $lo. Para buscar os seus valores, utiliza-se mflo e mfhi. Para
			# podermos trabalhar com valores maiores em nosso programa bastaria
			# retornar o $lo em $v0 e o $hi em $v1.
jr $ra 			# Retorna