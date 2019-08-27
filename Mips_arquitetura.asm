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
	table: .asciiz "\t"
	new_line: .asciiz "\n"
	opcaodedia: .asciiz "Dia/mes/ano:  "
	barra: .asciiz "/"
	opcaodecategoria: .asciiz "\nDigite a categoria:  "
	opcaodevalor: .asciiz "\nDigite o valor da despesa:"
	opcaodeid: .asciiz "\nDigite um numero para o id:  "
	continuardigitando: .asciiz "\nDeseja continuar cadastrando?  (1) SIM  (2)NÃO"
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
	beq $t0, 6, L6
################################################################   1 PARTE #########################################################
L1:
	#pegar o valor do ultimo na pilha
	lw $s0, contador($0)

	#chamar a string de ID
	addi $v0, $zero, 4
	la $a0, opcaodeid
	syscall
	#chamar a leitura da data
	addi $v0, $zero, 5
	syscall
	#salva a leitura em um registrador temporario S1
	addi $s1, $v0, 0

	#salvar no meu vetor
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

	la $t8, vetor($s0)
	li $v0, 4
	la $a0, ($t8)
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
	la $a0, opcaodedia
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
	la $a0, barra
	syscall
	#chamar a leitura do mes
	addi $v0, $zero, 5
	syscall
	addi $s1, $v0, 0
	addi $s0,$s0,4   #28
	sw $s1, vetor($s0)

	addi $v0, $zero, 4
	la $a0, barra
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
	lw $a0, contador($0)
	addi $v0, $zero, 1
	addi $a0, $a0, 0
	syscall

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

L4:
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
	addi $s4,$s4,-4
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
	addi $s4,$s4,-8
	addi $s0,$s0,44

	bgt $t2,$0,l4_loop	 #if tamanho do vetor > 0

	#printar vetor aux
	print:
	addi $s0,$zero,8
	lw $t0,cont_vetf4($0)
	loop_print:

	addi $v0,$0,1
	lw $a0,vetor_f4($s0)
	syscall
	addi $s0,$s0,12

	addi $t0,$t0,-1
	bgt $t0,$0,loop_print

	addi $s0,$0,0
	sw $s0,cont_vetf4($0)
	j Inicio

l4_soma:
	addi $s0,$s0,-12
	addi $s4,$s4,4
	lw $t5,vetor($s0)
	lw $t6,vetor_f4($s4)
	add $s1,$t6,$t5
	sw $s1,vetor_f4($s4)
	addi $s0,$s0,44
	addi $s4,$s4,-8
	#addi $t2,$t2,-36
	bgt $t2,$0,l4_loop
	j print
	addi $s0,$0,0
	sw $s0,cont_vetf4($0)
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
	addi $s4,$s4,-16
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

	addi $s4,$s4,-16
	addi $s1,$s1,20

	bgt $s0,0,l6_loopi
	j printar_f6
	j Inicio

L6_cont:

	lw $t1, vetor($s1)#pegar dispesas do vet principal
	lw $t2, vet_f6($s4)#pegar dispesas do aux
	add $t1,$t1,$t2 # somar as 2
	sw $t1,vet_f6($s4) #jogar em vetL6

	addi $s4,$s4,-16
	addi $s1,$s1,20
	addi $s2,$0,0
	bgt $s0,0,l6_loopi

	 	#bora
		#printa a categoria (STRING)
printar_f6:
	addi $s0, $0, 0
	lw $t1,cont_vetf6($0)
#	addi $t1,$t1,2
	la $t0,vet_f6    # aqui
	loop_printar_f6:
	add $s4, $0, $s0
	add $s0,$t0,$s0
	la $t0, 0($s0)
	li $v0, 4
	la $a0, ($t0)
	syscall 
	
	addi $s4, $s4, 16
	
	li $v0, 1
	lw $a0, vet_f6($s4)
	syscall
	addi $s4,$s4,4
	add $s0,$0,$s4
	addi $t1,$t1,-1
	bgt $t1,0,loop_printar_f6

	j Inicio
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
