.data
STRING: #vari�vel que vai receber o valor do input

.text

call REVERTENDO #vai pra REVERTENDO

TAMANHO:
	PARAMETROS:
		li a7, 8 #syscall de receber sttring, com endere�o de destino no a0 e m�ximo de caracteres indicado em a1
		li a1, 50 #determinando o numero m�ximo de caracteres
		la a0, STRING #a vari�vel vazia que foi criada agora receber� o valor do input
		ecall  
		li t0, 0 #t0 � o contador; contador = 0
		li s1, 10 #10 � o c�digo ascii do caractere '\n', o caractere final de todas as strings
	CONTAGEM:
		add t1, t0, a0 #t1 = contador + string (input) #no primeiro loop, t1 recebe a str cheia
		#a partir do segundo loop, o endere�o a ser buscado na mem�ria vai ser 1 endere�o ap�s o �ltimo, ou seja, 1 byte ap�s o �ltimo e, portanto, um caractere ap�s o �ltimo
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
		la t4, STRING #t4 recebe o input, t4 � o endre�o da string
		addi s5, s5, -1  #o nosso contador, que a gente alterou o valor em BREAK, agora deve ser decrementado em 1...
		# Esse decremento ocorre porque o nosso contador vai ser ponteiro de mem�ria..
		# O tamanho da string, que � o contador, come�a em 1
		# O ponteiro de mem�ria come�a em 0
		#Por isso a gente decrementa
		#ele aponta pro final da string
		add s5, s5, t4 #Endere�o + Tamanho da string = �ltimo endere�o
		#Aqui definimos que s5 � o endre�o do �ltimo caractere da string, sem contar o '\n'
		li t0, 0  #contador = 0; t0 vai ser o contador
		li a7, 11 #syscall de printar o tipo de dado 'char', um caractere ascii
	PRINT_LOOP:
		add t4, s5, t0  #Aqui, come�a a itera��o, no loop, t4 vai receber o �ltimo endere�o da string
		#t0 vai ser decrementado em 1, fazendo o o endre�o ser o �ltimo - 1
		#Como a mem�ria � byte-adressing, temos que uma mem�ria de cada vez vai ser lida pra t4 nesse loop
		lb t4, 0(t4) #pega somente 1 byte, ou seja, s� a mem�ria que cont�m o �ltimo caractere, explicado acima
		beq t4, zero, FIM #se chegar no fim da palavra, do final para o come�o, vai pra macro FIM
		mv  a0, t4 # pega o caractere que foi carregado na linha 47 e joga ele pro a0, que � o registrador padr�o pra printar string
		ecall #S� agora que vai carregar a syscall definida l� em cima de printar char
		addi t0, t0, -1
		j PRINT_LOOP #volta pro loop
	FIM:
		li a7, 10 #call de exit do sistema
		ecall
		
