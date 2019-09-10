.data
		string1: .space 16
	string2: .space 16
	vetor: .space 400
	vetor_f4: .space 400
	cont_vetf4: .word 0
	vet_f6: .space 400
	cont_vetf6: .word 0
	vetor_meses: .space 48
	contador: .word -4
	ler: .space 16
	contid: .word 0
	table: .asciiz "\t"
	new_line: .asciiz "\n"
	dia: .asciiz "Dia:  "
	mes: .asciiz "mes:  "
	ano: .asciiz "ano:  "
	barra: .asciiz "/"
	opcaodecategoria: .asciiz "\nDigite a categoria:  "
	opcaodevalor: .asciiz "\nDigite o valor da despesa:"
	opcaodeid: .asciiz "\nDigite um numero para o id:  "
	continuardigitando: .asciiz "\nDeseja continuar cadastrando?  (1) SIM  (2)NÃO:\t"
	opcaodeidexclusao: .asciiz "\nDigite um numero para o id exclusão:  "
	mes_ano: .asciiz "\ndigite o mes e ano: "
	menu: .asciiz "		ESCOLHA UMA DAS OPÇÕES ABAIXO\n1- REGISTRAR DESPESAS PESSOAIS\n2- LISTAR DESPESAS\n3- EXCLUIR DESPESAS\n4- EXIBIR GASTOS MENSAIS\n5- EXIBIR GASTOS POR CATEGORIA\n6- EXIBIR RANKING DE DESPESAS"
	digitar: .asciiz "\n\nDigite a opção: "


.text
Inicio:
	#PRINTAR O MENU

	addi $v0, $zero, 4
	la $a0, menu
	syscall

	#ESCOLHA DA OPÇÃO
	addi $v0, $zero, 4
	la $a0, digitar
	syscall
	addi $v0, $zero, 5
	syscall
	addi $t0, $v0, 0

	beq $t0, 1, L1
	beq $t0, 2, L2
	beq $t0, 3, L3
	beq $t0, 4, L4
	beq $t0, 5, L5
	beq $t0, 6, L6
################################################################   1 PARTE #########################################################
L1:
	#pegar o valor do ultimo na pilha
	lw $s0, contador($0)

	lw $s1,contid($0)
	addi $s1,$s1,1
	sw $s1,contid($0)
	addi $s0, $s0, 4
	sw $s1, vetor($s0) #salva na posição 0
#-----------------------------------------------------------------------------------------------
	#chamar a string de categoria
	addi $v0, $zero, 4
	la $a0, opcaodecategoria
	syscall
	#chamar a leitura da categoria
	#la $a0, ler
	addi $s0,$s0,4 #salva a partir da posi 4
	li $v0, 8
  li $a1, 16
  la $a0,vetor($s0)
  syscall
#--------------------------------------------------------------------------------------------
	#chamar a string de valor
	addi $v0, $zero, 4
	la $a0, opcaodevalor
	syscall
	#chamar a leitura do valor
	addi $v0, $zero, 5
	syscall
	#salva a leitura em um registrador temporario S1
	addi $s1, $v0, 0
	#salvar no meu vetor
	addi $s0, $s0, 16 #20
	sw $s1, vetor($s0)
#--------------------------------------------------------------------------------------------
	#chamar a string de data
	addi $v0, $zero, 4
	la $a0,dia
	syscall
	#chamar a leitura do dia
	addi $v0, $zero, 5
	syscall
	#salva a leitura em um registrador temporario S1
	addi $s1, $v0, 0
	#salvar no meu vetor
	addi $s0, $s0, 4 #24
	sw $s1, vetor($s0)

	addi $v0, $zero, 4
	la $a0,mes
	syscall

	#chamar a leitura do mes
	addi $v0, $zero, 5
	syscall
	addi $s1, $v0, 0
	addi $s0,$s0,4   #28
	sw $s1, vetor($s0)

	addi $v0, $zero, 4
	la $a0, ano
	syscall

	#chamar a leitura do ano
	addi $v0, $zero, 5
	syscall
	addi $s1, $v0, 0
	addi $s0,$s0,4  #32
	sw $s1, vetor($s0)

	#------------------------------------------------------------
	#Jogar o ultimo valor variavel
	sw $s0, contador($0)
	#adicionei para testes printar o contador
	#lw $a0, contador($0)
	#addi $v0, $zero, 1
	#addi $a0, $a0, 0
	#syscall

	#Fazer a escolha se deseja cadastrar mais
Escolha_errada:
	addi $v0, $zero, 4
	la $a0, continuardigitando
	syscall
	#leitura para escolha
	addi $v0, $zero, 5
	syscall

	addi $s0, $v0, 0
	beq $s0, 1, L1
	beq $s0, 2, Inicio
	j Escolha_errada

#################################################################  2 PARTE  ########################################################
	#printaaaaa vetor
L2: #printar o vetor
	lw $t0, contador($0)
	li $t1,-4
	beq $t0, $t1, print_fim

	addi $s0, $zero, -4
l2_1:
  #printa o ID
  addi $s0, $s0, 4
	lw $t1, vetor($s0)
	#printtt
	addi $v0, $zero, 1
	addi $a0, $t1, 0
	syscall
	addi $v0, $zero, 4
	la $a0, table
	syscall
  #printa a categoria (STRING)
	addi $s0, $s0, 4
	add $s4, $zero, $s0
  la $t0,vetor    # aqui
 	add $s0,$t0,$s0
	la $t0, 0($s0)
	li $v0, 4
	la $a0, ($t0)
	syscall

	li $v0, 4
	la $a0, table
	syscall

   #printar o valor da despeza
	addi $s4, $s4, 16
	addi $s0, $s4, 0
	la $t0, vetor
	add $s0,$t0,$s0
	lw $t0, 0($s0)

	li $v0, 1
	la $a0, ($t0)
	syscall

	addi $v0, $zero, 4
	la $a0, table
	syscall
  #printar a dia
 	addi $s4, $s4, 4
	addi $s0,$s4,0
	lw $t1, vetor($s0)
	addi $v0, $zero, 1
	addi $a0, $t1, 0
	syscall

	addi $v0, $zero, 4
	la $a0, barra
	syscall

#printar mes

	addi $s4, $s4, 4
	addi $s0,$s4,0
	lw $t1, vetor($s0)
	addi $v0, $zero, 1
	addi $a0, $t1, 0
	syscall

	addi $v0, $zero, 4
	la $a0, barra
	syscall

#printar ano

	addi $s4, $s4, 4
  addi $s0,$s4,0
	lw $t1, vetor($s0)
	addi $v0, $zero, 1
	addi $a0, $t1, 0
	syscall

	addi $v0, $zero, 4
	la $a0, new_line
	syscall
  addi $s0,$s4,0

print_fim:
#condição para continuar if maior que
	lw $t4, contador($0)
	blt $s4, $t4, l2_1
	j Inicio

#--\-\\-\-\-\--\\\\--\-PARTE 3--\-\-\-\-\-\-\-\-\-\-\-\-\--\-\-\-\-
#------------------exclusão----------------------------

L3:
	lw $s4, contador($0) #add
	addi $s4, $s4, 4 #add
	addi $v0, $zero, 4
	la $a0, opcaodeid
	syscall

	addi $v0,$zero,5
	syscall
	add $a0,$v0,$zero

	addi $s0,$zero,0
	l3_loop:

	lw $t0,vetor($s0)
	beq $a0,$t0,excluir
	addi $s0,$s0,36
	addi $s4, $s4, -36 #add
	ble $s4, 0, sair_fora #add

	j l3_loop


excluir:

	lw $t2,contador($0)
	addi $t2,$t2,-32
	addi $t6,$t2,-4
	sw $t6,contador($0)
	addi $t3,$zero,36

excluir_loop:

	lb $t4,vetor($t2)
	sb $t4,vetor($s0)

	addi $t3,$t3,-1
	addi $t2,$t2,1
	addi $s0,$s0,1
	bgt $t3,0,excluir_loop
	#qq coisa usar flag

excluir_fim:
j Inicio

sair_fora:#add
	j Inicio

##################################### PARTE 4 #############################################

L4:# vetor=mes, ano, despesa
	addi $s1,$zero,0 #zerar vetor para usar mais para frente
	addi $s2,$zero,0 #contador do vetor_f4

	addi $s0,$zero,28
	lw $t2,contador($0)
	addi $t2,$t2,4 #tamanho do vetor principal em t2

	lw $t3,vetor($s0)#tirar mes do vetor
	sw $t3,vetor_f4($s2)#colocarmes no aux
	addi $s0,$s0,4
	addi $s2,$s2,4
	lw $t4,vetor($s0)#tirar ano do vetor
	sw $t4,vetor_f4($s2)#colocar no aux

	addi $s2,$zero,1
	sw $s2,cont_vetf4($0)
	addi $s0,$zero,28
	addi $s4,$zero,0 # i do vetor auxiliar
l4_loop:

	lw $t3,vetor($s0)#tirar mes do vetor
	addi $s0,$s0,4
	lw $t4,vetor($s0)#tirar ano do vetor

	j l4_loopinterno

	correc:
	addi $s4,$s4,8
	addi $t2,$t2,36

l4_loopinterno:
	addi $s2,$s2,-1
	lw $t5,vetor_f4($s4)#t5 mes
	addi $s4,$s4,4
	lw $t6,vetor_f4($s4)#t6 ano
	addi $t2,$t2,-36

	beq $t5,$t3,And #(if t0==t3 && t1==t4)[]...
	j continua_and
	And:#[]...
		beq $t6,$t4,l4_soma #if true go l4_soma.

continua_and:

	bgt $s2,0,correc
	addi $s4,$s4,8
	#adionar na proxima posição do vet aux
	sw $t3,vetor_f4($s4)
	addi $s4,$s4,4
	sw $t4,vetor_f4($s4)
	addi $s4,$s4,4
	addi $s0,$s0,-12 #pegar despesa vetor principal
	lw $t5,vetor($s0)
	sw $t5,vetor_f4($s4)
	lw $s2,cont_vetf4($0)
	addi $s2,$s2,1# continua dando ruim
	sw $s2,cont_vetf4($0)
	addi $s4,$0,0
	addi $s0,$s0,44

	bgt $t2,$0,l4_loop	 #if tamanho do vetor > 0

	#printar vetor aux
	print:
	addi $s0,$zero,8#valor da despesa
	lw $t0,cont_vetf4($0)
	loop_print:
	addi $s7, $s0, -4#ano
	addi $s6, $s7, -4#mes


	addi $v0,$0,1
	lw $a0,vetor_f4($s6)
	syscall

	addi $v0, $zero, 4
	la $a0, barra
	syscall

	addi $v0,$0,1
	lw $a0,vetor_f4($s7)
	syscall

	addi $v0, $zero, 4
	la $a0, table
	syscall

	addi $v0,$0,1
	lw $a0,vetor_f4($s0)
	syscall

	addi $v0, $zero, 4
	la $a0, new_line
	syscall

	addi $s0,$s0,12

	addi $t0,$t0,-1
	bgt $t0,$0,loop_print

	addi $s0,$0,0
	sw $s0,cont_vetf4($0)

#--------------------------------------

	zerar_f4:
	addi $s4, $0, 0
	addi	$s3, $0,0

	lw $0, cont_vetf4($0)
	addi $t0,$0,400
	addi $t1,$0,0
	zerarf4:

#	sb $t1, 0($s1)		#
	sb $t1, vetor_f4($s4)
	addi $s4, $s4,1
	addi $t0,$t0,-1
	bge $t0, $0, zerarf4


	j Inicio

l4_soma:
	addi $s0,$s0,-12
	addi $s4,$s4,4
	lw $t5,vetor($s0)
	lw $t6,vetor_f4($s4)
	add $s1,$t6,$t5
	sw $s1,vetor_f4($s4)
	addi $s0,$s0,44
	addi $s4,$0,0
	lw $s2,cont_vetf4($0)
	#addi $t2,$t2,-36
	bgt $t2,$0,l4_loop
	j print
	addi $s0,$0,0
	sw $s0,cont_vetf4($0)
	j Inicio
##################################FUNÇAO 5###########################
L5:
	lw $s0,contador($0)
	addi $s0, $s0, 4 	 #tamanho do vetor principal
	addi $s1,$zero,4 #contador importante guarda posição do vetor principal
	addi $s2,$zero,0 #contador para N funções
	addi $s3,$zero,1 #vetor auxiliar, contador tamanho
	sw $s3,cont_vetf6($0)
	addi $s4,$zero,0 #contador importante guarda posição do vetor aux
	addi $s5,$zero,0 #auxiliar para salvar s3

	loop_trasnf1_5: #passar do vetor principal pro vetor auxiliar
	lb $t0,vetor($s1)
	sb $t0,vet_f6($s2) #passa para o vetor aux
	addi $s2,$s2,1
	addi $s1,$s1,1 #registrador s1 conmtador parar vetor principal
	blt $s2,16,loop_trasnf1_5


	addi $s2,$zero,0
	addi $s1,$zero,4

	##-----inicio da função
l5_loopi: #passar do vetor para varivel aux1 []...
	lb $t0,vetor($s1)
	sb $t0,string1($s2)
	addi $s2,$s2,1
	addi $s1,$s1,1
	blt $s2,16, l5_loopi#...[]

  addi $s2,$zero,0

j L5_loopcomp_aux
correc_f5:
	addi $s4,$s4,4

	addi $s2,$0,0
	addi $s0,$s0,36

L5_loopcomp_aux:
	addi $s3,$s3,-1
	l5_loopi_aux: #passar do vetor aux para a varivel aux2 []...
	lb $t0,vet_f6($s4)
	sb $t0,string2($s2)
	addi $s2,$s2,1
	addi $s4,$s4,1
	blt $s2,16,l5_loopi_aux #...[]
	addi $s2,$zero,0
	addi $s0,$s0,-36

	jal strcmp

	beq $t5,1,L5_cont

	bgt $s3,0,correc_f5


	addi $s4,$s4,4
addi $s2,$zero,0
l5_loop_aux_in_vet: #passar da aux1 para vet aux []...
	lb $t0,string1($s2)
	sb $t0,vet_f6($s4)
	addi $s4,$s4,1
	addi $s2,$s2,1
	blt $s2,16,l5_loop_aux_in_vet#...[]
	addi $s2,$zero,0
	lw $t0,vetor($s1)
	sw $t0,vet_f6($s4)

	lw $s3,cont_vetf6($0)
	addi $s3,$s3,1#incrementar no tamanho do vetor aux
	sw $s3,cont_vetf6($0)

	addi $s4,$0,0
	addi $s1,$s1,20

	bgt $s0,0,l5_loopi
	j printar_f5
	j Inicio

L5_cont:

	lw $t1, vetor($s1)#pegar dispesas do vet principal
	lw $t2, vet_f6($s4)#pegar dispesas do aux
	add $t1,$t1,$t2 # somar as 2
	sw $t1,vet_f6($s4) #jogar em vetL6
	lw $s3,cont_vetf6($0)
	addi $s4,$0,0
	addi $s1,$s1,20
	addi $s2,$0,0
	bgt $s0,0,l5_loopi

	 	#bora
		#printa a categoria (STRING)
printar_f5:
	jal bubble_da_fun5

	addi $s0, $0, 0

	lw $t1,cont_vetf6($0)
#	addi $t1,$t1,2
	la $t0,vet_f6    # aqui
	loop_printar_f5:
	add $s4, $0, $s0
	add $s0,$t0,$s0
	la $t3, 0($s0)

	addi $s4, $s4, 16

	li $v0, 1
	lw $a0, vet_f6($s4)
	syscall

	li $v0, 4
	la $a0, table
	syscall

	li $v0, 4
	la $a0, ($t3)
	syscall

	addi $s4,$s4,4
	add $s0,$0,$s4
	addi $t1,$t1,-1
	bgt $t1,0,loop_printar_f5

	jal zerar_f6

	j Inicio
###################################função 6########################
L6:

	lw $s0,contador($0)
	addi $s0, $s0, 4 	 #tamanho do vetor principal
	addi $s1,$zero,4 #contador importante guarda posição do vetor principal
	addi $s2,$zero,0 #contador para N funções
	addi $s3,$zero,1 #vetor auxiliar, contador tamanho
	sw $s3,cont_vetf6($0)
	addi $s4,$zero,0 #contador importante guarda posição do vetor aux
	addi $s5,$zero,0 #auxiliar para salvar s3

	loop_trasnf1: #passar do vetor principal pro vetor auxiliar
	lb $t0,vetor($s1)
	sb $t0,vet_f6($s2) #passa para o vetor aux
	addi $s2,$s2,1
	addi $s1,$s1,1 #registrador s1 conmtador parar vetor principal
	blt $s2,16,loop_trasnf1


	addi $s2,$zero,0
	addi $s1,$zero,4

	##-----inicio da função
l6_loopi: #passar do vetor para varivel aux1 []...
	lb $t0,vetor($s1)
	sb $t0,string1($s2)
	addi $s2,$s2,1
	addi $s1,$s1,1
	blt $s2,16, l6_loopi#...[]

  addi $s2,$zero,0

j L6_loopcomp_aux
correc_f6:
	addi $s4,$s4,4

	addi $s2,$0,0
	addi $s0,$s0,36

L6_loopcomp_aux:
	addi $s3,$s3,-1
	l6_loopi_aux: #passar do vetor aux para a varivel aux2 []...
	lb $t0,vet_f6($s4)
	sb $t0,string2($s2)
	addi $s2,$s2,1
	addi $s4,$s4,1
	blt $s2,16,l6_loopi_aux #...[]
	addi $s2,$zero,0
	addi $s0,$s0,-36

	jal strcmp

	beq $t5,1,L6_cont

	bgt $s3,0,correc_f6


	addi $s4,$s4,4
addi $s2,$zero,0
l6_loop_aux_in_vet: #passar da aux1 para vet aux []...
	lb $t0,string1($s2)
	sb $t0,vet_f6($s4)
	addi $s4,$s4,1
	addi $s2,$s2,1
	blt $s2,16,l6_loop_aux_in_vet#...[]
	addi $s2,$zero,0
	lw $t0,vetor($s1)
	sw $t0,vet_f6($s4)

	lw $s3,cont_vetf6($0)
	addi $s3,$s3,1#incrementar no tamanho do vetor aux
	sw $s3,cont_vetf6($0)

	addi $s4,$0,0
	addi $s1,$s1,20

	bgt $s0,0,l6_loopi
	j printar_f6
	j Inicio

L6_cont:

	lw $t1, vetor($s1)#pegar dispesas do vet principal
	lw $t2, vet_f6($s4)#pegar dispesas do aux
	add $t1,$t1,$t2 # somar as 2
	sw $t1,vet_f6($s4) #jogar em vetL6
	lw $s3,cont_vetf6($0)
	addi $s4,$0,0
	addi $s1,$s1,20
	addi $s2,$0,0
	bgt $s0,0,l6_loopi

	 	#bora
		#printa a categoria (STRING)
printar_f6:
	jal bubble_da_fun6

	addi $s0, $0, 0

	lw $t1,cont_vetf6($0)
#	addi $t1,$t1,2
	la $t0,vet_f6    # aqui
	loop_printar_f6:
	add $s4, $0, $s0
	add $s0,$t0,$s0

	addi $s4, $s4, 16

	li $v0, 1
	lw $a0, vet_f6($s4)
	syscall

	li $v0, 4
	la $a0, table
	syscall

	la $t3, 0($s0)
	li $v0, 4
	la $a0, ($t3)
	syscall

	addi $s4,$s4,4
	add $s0,$0,$s4
	addi $t1,$t1,-1
	bgt $t1,0,loop_printar_f6


	# ---------- zerar
 jal zerar_f6

	j Inicio
	#################################FUNÇAO
	#--------------------------------------------
	#---------Função STRCMP----------------------
strcmp:
	add $t6,$zero,$s2
	add $t4,$zero,$s3
	la $s2,string1
	la $s3,string2

# string compare loop (just like strcmp)
cmploop:
	lb $t2,($s2)                   # get next char from str1
	lb $t3,($s3)                   # get next char from str2
	bne $t2,$t3,cmpne               # are they different? if yes, fly

	beq $t2,$zero,cmpeq             # at EOS? yes, fly (strings equal)

	addi $s2,$s2,1                   # point to next char
	addi $s3,$s3,1                   # point to next char
	j cmploop


cmpne:
	add $s2,$zero,$t6
	add $s3,$zero,$t4
	addi $t5,$zero,0
	jr $ra

cmpeq:
	add $s2,$zero,$t6
	add $s3,$zero,$t4
	addi $t5,$zero,1
	jr $ra
#-------------------ZERA A 5 E A 6#######################
zerar_f6:
addi $s4, $0, 0
addi	$s3, $0,0

lw $0, cont_vetf6($0)
addi $t0,$0,400
addi $t1,$0,0
zerarf6:

#	sb $t1, 0($s1)		#
sb $t1, vet_f6($s4)
addi $s4, $s4,1
addi $t0,$t0,-1
bge $t0, $0, zerarf6
jr $ra
	#-------------------------------BUBBLE 5 --------------------------
	bubble_da_fun5:

			addi $s5, $0, -1 #k
	   	addi $s0, $0, 0 #j
			addi $s1, $0,	4	#j + 1
			addi $t5, $0, 0
			lw $t8, cont_vetf6
			addi $t8, $t8, -1#5

			for1:

			addi $s0, $0, 0   # j 0-16 16-20 20-36
			addi $s1, $0, 20   # j+1
			addi $t9, $0, 0   #

			  for2:

			  lb $s2, vet_f6($s0) #essa parte aqui é o if
			  lb $s3, vet_f6($s1)

				blt $s2, $s3, cont_2
				bgt $s2, $s3, troca#ate aqui

				addi $s0, $s0, 1
				addi $s1, $s1, 1
				addi $t5, $t5, 1
				blt $t5, 16, for2
				j cont

			      troca:
						sub $s1, $s1, $t5
						sub $s0, $s0, $t5
						addi $t7, $0, 16
						addi $t6, $0, 0

						string_troca:
							lb $s6, vet_f6($s0)
							lb $s7, vet_f6($s1)
							sb $s7, vet_f6($s0)
							sb $s6, vet_f6($s1)
							addi $s0, $s0, 1
							addi $s1, $s1, 1
							addi $t6, $t6, 1
						blt $t6, $t7, string_troca

						lw $s6, vet_f6($s0)
						lw $s7, vet_f6($s1)
			      sw $s7, vet_f6($s0)
			      sw $s6, vet_f6($s1)
						j cont
						cont_2:
						sub $s0, $s0, $t5
						sub $s1, $s1, $t5
						addi $s0, $s0, 16
						addi $s1, $s1, 16

			      cont:
			      addi $s0, $s0, 4
			      addi $s1, $s1, 4
			      addi $t9, $t9, 1
			      addi $t5, $0, 0
			      blt  $t9, $t8, for2
				#saida_for2:



			  addi $s5, $s5, 1
			  blt $s5, $t8, for1
				jr $ra

#--------------------------BUBBLE 6 --------------------------
bubble_da_fun6:

addi $s5, $0, 0 #k
addi $s0, $0, 0 #j
addi $s1, $0,	4	#j + 1

lw $t8, cont_vetf6
addi $t8, $t8, -1#5

for1_6:

addi $s0, $0, 16   # j 0-16 16-20 20-36
addi $s1, $0, 36   # j+1
addi $t9, $0, 0    #

  for2_6:
  # if
lw $s2, vet_f6($s0) #essa parte aqui é o if
  lw $s3, vet_f6($s1)

  blt $s2, $s3, troca_6#ate aqui

  j cont_6
      troca_6:
      sw $s2, vet_f6($s1)
      sw $s3, vet_f6($s0)
      addi $t7, $zero, 16
      addi $t6, $zero, 0
      # Para string
      addi $s0, $s0, -16
      addi $s1, $s1, -16
        string_troca_6:
	        lw $s6, vet_f6($s0)
	        lw $s7, vet_f6($s1)
	        sw $s7, vet_f6($s0)
	        sw $s6, vet_f6($s1)
	        addi $s0, $s0, 4
	        addi $s1, $s1, 4
	        addi $t6, $t6, 4
	        blt $t6, $t7, string_troca_6

      cont_6:
      addi $s0, $s0, 20
      addi $s1, $s1, 20
      addi $t9, $t9, 1
  blt  $t9, $t8, for2_6

  addi $s5, $s5, 1
  blt $s5, $t8, for1_6
  jr $ra
