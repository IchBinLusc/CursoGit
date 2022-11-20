		.text
		# Jump para a rotina main
		j	main			

		.data
insira:		.asciiz "Insira o tamanho do vetor \n"
valores:		.asciiz "Insira os valores a serem colocados no vetor \n"
organizado:		.asciiz "Vetor organizado:: \n"
pula_linha:		.asciiz "\n"

		.text
		.globl	main
main: 
                # Printa a subrotina insira
		la	$a0, insira		
		li	$v0, 4			
		syscall				
                # Pega o tamanho do array e coloca no $v0
		li	$v0, 5			
		syscall				
		move	$s2, $v0		# $s2=n
		sll	$s0, $v0, 2		# $s0=n*4
		# Cria uma pilha que cabe o vetor
		sub	$sp, $sp, $s0		
		# Printa a subrotina valores
		la	$a0, valores		
		li	$v0, 4		
		syscall				

		move	$s1, $zero		# i=0
		# se i>=n vai para exit_for_get
loop_get:	bge	$s1, $s2, exit_get	
		sll	$t0, $s1, 2		# $t0=i*4
		add	$t1, $t0, $sp		# $t1=$sp+i*4
		# Pega um elemento do vetor
		li	$v0, 5			
		syscall	
		# O elemento fica guardado em $t1			
		sw	$v0, 0($t1)		
		la	$a0, pula_linha
		li	$v0, 4
		syscall
		addi	$s1, $s1, 1		# i=i+1
		j	loop_get
exit_get:	move	$a0, $sp		# $a0=endereço inicial do vetor
		move	$a1, $s2		# $a1=tamanho do vetor
		jal	lsort			# llsort(a,n)
						
		# O vetor foi organizado na pilha
		#Printa organizado
		la	$a0, organizado		
		li	$v0, 4
		syscall

		move	$s1, $zero		# i=0
loop_print:	bge	$s1, $s2, exit_print	# se i>=n vai para exit_print
		sll	$t0, $s1, 2		# $t0=i*4
		add	$t1, $sp, $t0		# $t1=endereço de  a[i]
		lw	$a0, 0($t1)		#
		li	$v0, 1			# printa o valor de a[i]
		syscall				#

		la	$a0, pula_linha
		li	$v0, 4
		syscall
		addi	$s1, $s1, 1		# i=i+1
		j	loop_print
exit_print:	add	$sp, $sp, $s0		# acaba com a pilha
              
		li	$v0, 10			# dá exit no código
		syscall			#
		
		
# selection_sort
lsort:		addi	$sp, $sp, -20		# salva os valores na pilha
		sw	$ra, 0($sp)
		sw	$s0, 4($sp)
		sw	$s1, 8($sp)
		sw	$s2, 12($sp)
		sw	$s3, 16($sp)

		move 	$s0, $a0		# endereço inicial do vetor
		move	$s1, $zero		# i=0

		subi	$s2, $a1, 1		# tamanho -1
lsort_loop:	bge 	$s1, $s2, lsort_exit	# se i >= tamanho-1 -> sai do loop
		
		move	$a0, $s0		# endereco inicial
		move	$a1, $s1		# i
		move	$a2, $s2		# tamanko - 1
		
		jal	mini
		move	$s3, $v0		# retorna o valor de mini
		
		move	$a0, $s0		# vetor
		move	$a1, $s1		# i
		move	$a2, $s3		# mini
		
		jal	troca

		addi	$s1, $s1, 1		# i += 1
		j	lsort_loop		# volta paraa o começo do loop
		
lsort_exit:	lw	$ra, 0($sp)		# restaura os valores da pilha
		lw	$s0, 4($sp)
		lw	$s1, 8($sp)
		lw	$s2, 12($sp)
		lw	$s3, 16($sp)
		addi	$sp, $sp, 20		# restaura o ponteiro da pilha
		jr	$ra			# volta para antes dessa rotina


# posicao minima
mini:		move	$t0, $a0		# inicio do vetor
		move	$t1, $a1		# mini = primeiro = i
		move	$t2, $a2		# ultimo
		
		sll	$t3, $t1, 2		# primeiro * 4
		add	$t3, $t3, $t0		# posiçao = inicio do vetor + primeiro * 4		
		lw	$t4, 0($t3)		# mini = v[primeiro]
		
		addi	$t5, $t1, 1		# i = 0
mini_loop:	bgt	$t5, $t2, mini_end	# vai para mini_end

		sll	$t6, $t5, 2		# i * 4
		add	$t6, $t6, $t0		# posiçao = inicio do vetor + i * 4		
		lw	$t7, 0($t6)		# v[posicao]

		bge	$t7, $t4, mini_if_exit	# pula o if, caso v[i] >= mini
		
		move	$t1, $t5		# mini = i
		move	$t4, $t7		# mini = v[i]

mini_if_exit:	addi	$t5, $t5, 1		# i += 1
		j	mini_loop

mini_end:	move 	$v0, $t1		# retorna mini
		jr	$ra


# rotina de troca
troca:		sll	$t1, $a1, 2		# i * 4
		add	$t1, $a0, $t1		# v + i * 4
		
		sll	$t2, $a2, 2		# j * 4
		add	$t2, $a0, $t2		# v + j * 4

		lw	$t0, 0($t1)		# v[i]
		lw	$t3, 0($t2)		# v[j]

		sw	$t3, 0($t1)		# v[i] = v[j]
		sw	$t0, 0($t2)		# v[j] = $t0

		jr	$ra
