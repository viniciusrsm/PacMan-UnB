.data
STRING: #variável que vai receber o valor do input

.text

call REVERTENDO #vai pra REVERTENDO

TAMANHO:
	PARAMETROS:
		li a7, 8 #syscall de receber sttring, com endereço de destino no a0 e máximo de caracteres indicado em a1
		li a1, 50 #determinando o numero máximo de caracteres
		la a0, STRING #a variável vazia que foi criada agora receberá o valor do input
		ecall  
		li t0, 0 #t0 é o contador; contador = 0
		li s1, 10 #10 é o código ascii do caractere '\n', o caractere final de todas as strings
	CONTAGEM:
		add t1, t0, a0 #t1 = contador + string (input) #no primeiro loop, t1 recebe a str cheia
		#a partir do segundo loop, o endereço a ser buscado na memória vai ser 1 endereço após o último, ou seja, 1 byte após o último e, portanto, um caractere após o último
		#primeiro loop, busca o primeiro byte em Memoria[t1]
		#segundo loop, busca o primeiro byte em Memoria[t1 + 1]
		lb t1, 0(t1)    #pega o primeiro byte, ou seja, o primeiro caractere ascii da string
		beq t1, s1, BREAK #se o primeiro byte for '10', ou seja, '\n' encerra o LOOP
		addi t0, t0, 1 #t0 += 1, atualiza o contador
		j CONTAGEM
	BREAK:
		add s5, zero, t0 #s5 = contador; recebe o tamanho da string
		ret  #vai pra MACRO que estiver sendo chamada em 'call MACRO'
		#vai pra REVERTENDO
REVERTENDO:
	PARAMETROSR:
		call TAMANHO #Vai pra TAMANHO
		la t4, STRING #t4 recebe o input, t4 é o endreço da string
		addi s5, s5, -1  #o nosso contador, que a gente alterou o valor em BREAK, agora deve ser decrementado em 1...
		# Esse decremento ocorre porque o nosso contador vai ser ponteiro de memória..
		# O tamanho da string, que é o contador, começa em 1
		# O ponteiro de memória começa em 0
		#Por isso a gente decrementa
		#ele aponta pro final da string
		add s5, s5, t4 #Endereço + Tamanho da string = último endereço
		#Aqui definimos que s5 é o endreço do último caractere da string, sem contar o '\n'
		li t0, 0  #contador = 0; t0 vai ser o contador
		li a7, 11 #syscall de printar o tipo de dado 'char', um caractere ascii
	PRINT_LOOP:
		add t4, s5, t0  #Aqui, começa a iteração, no loop, t4 vai receber o último endereço da string
		#t0 vai ser decrementado em 1, fazendo o o endreço ser o último - 1
		#Como a memória é byte-adressing, temos que uma memória de cada vez vai ser lida pra t4 nesse loop
		lb t4, 0(t4) #pega somente 1 byte, ou seja, só a memória que contém o último caractere, explicado acima
		beq t4, zero, FIM #se chegar no fim da palavra, do final para o começo, vai pra macro FIM
		mv  a0, t4 # pega o caractere que foi carregado na linha 47 e joga ele pro a0, que é o registrador padrão pra printar string
		ecall #Só agora que vai carregar a syscall definida lá em cima de printar char
		addi t0, t0, -1
		j PRINT_LOOP #volta pro loop
	FIM:
		li a7, 10 #call de exit do sistema
		ecall
		
