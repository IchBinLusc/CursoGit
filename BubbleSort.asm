.data
	a: .word 8 50 32 71 45 79 15 2 5 48 29 84 29 27 63
	nao_organizado: .asciiz "Vetor não organizado: "
	organizado: .asciiz "Array organizado: "
	mensagem_de_saida: .asciiz "Fechando código\n"
	compararcaçao: .asciiz "\tComparando: "
	novalinha: .asciiz "\n"
	espaço: .asciiz " "
.text
	
	# printa o vetor não organizado
	la $a0 nao_organizado
	li $v0 4
	syscall
	jal PRINT_VETOR

	jal ORGANIZA_VETOR
	
	# printa o vetor organizado
	la $a0 organizado
	li $v0 4
	syscall
	jal PRINT_VETOR

	
	jal EXIT	


	ORGANIZA_VETOR:
		sw $ra, 0($sp)
			
		li $t0 0 	# equivalente ao i 
		li $t1 0	# equivalente ao k 
		li $t2 4	# equivalente ao k+1 
		li $t4 56	# aequivalente ao tamanho
		li $t5 0	# equivalente a variavel temporaria
		li $t6 0	# equivalente ao a[k]
		li $t7 0	# equivalente ao a[k+1]
		
		# comparando com um código em outra liguagem

		ORGANIZA_VETOR_LOOP1:
			# verifica se ainda estamos nos limites
			beq $t0 $t4 ORGANIZA_VETOR_FIM

			ORGANIZA_VETOR_LOOP2:
				beq $t1 $t4 ORGANIZA_VETOR_LOOP4
				
				# dá load nos valores de a[k] e a[k+1] nos registradores
				lw $t6 a($t1)	# $t6 = a[k]
				lw $t7 a($t2)	# $t7 = a[k+1]

				# Se a[k] >= a[k+1]
				bge $t6 $t7 ORGANIZA_SEMTROCA
				
				ORGANIZA_TROCA:
					sw $t7 a($t1)	# a[k] = a[k+1]
					sw $t6 a($t2)	# a[k+1] = variavel temporaria

				ORGANIZA_SEMTROCA:		

			ORGANIZA_VETOR_LOOP3:
				add $t1 $t1 4 	# iteração do k
				add $t2 $t2 4 	# iteração k+1
				j ORGANIZA_VETOR_LOOP2	# volta para o loop que carrega os valores nos registradores
			
		ORGANIZA_VETOR_LOOP4:
			add $t0 $t0 4 # iteração do i
			li $t1 0	# Determina k 
			li $t2 4	# Determina k+1 
			j ORGANIZA_VETOR_LOOP1	# Volta para o LOOP1



	ORGANIZA_VETOR_FIM:
		lw $ra, 0($sp)
		jr $ra
	


	PRINT_VETOR:
		sw $ra, 0($sp)
		li $t0 60 # Tamanho do vetor em bytes
		li $t1 0
		
		PRINT_VETOR_LOOP1:
			# printa o valor que está guardado naquela posição do vetor
			lw $a0 a($t1)		
			li $v0 1
			syscall  			

			# printa um espaço entre os números
			la $a0 espaço
			li $v0 4
			syscall  			
			add $t1 $t1 4
			
			# volta para o começo do loop 
			beq $t0 $t1 PRINT_VETOR_LOOP2
			j PRINT_VETOR_LOOP1
		
		PRINT_VETOR_LOOP2:
			la $a0 novalinha
			li $v0 4
			syscall

			lw $ra, 0($sp)
			jr $ra



	EXIT:
 	   
 	   # printa nova_linha
		la $a0 novalinha
		li $v0 4
		syscall 
	
   		# printa saída
		la $a0 mensagem_de_saida
		li $v0 4
		syscall
		
   		# exit do programa
		li $v0, 10
		syscall
