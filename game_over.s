.data
.include "sprites/menu/game_over.data"

.text
GAME_OVER:	
		li t1,0xFF000000			# endereco inicial da Memoria VGA - Frame 0
		li t2,0xFF012C00			# endereco final 
		la s1,game_over				# endere�o dos dados da tela na memoria
		addi s1,s1,8				# primeiro pixels depois das informa��es de largura e altura
		
LOOP_GAME_OVER: 	
		beq t1,t2,GAME_OVER_ENTER			# Se for o �ltimo endere�o ent�o sai do loop
		lw t3,0(s1)					# le um conjunto de 4 pixels : word
		sw t3,0(t1)					# escreve a word na mem�ria VGA
		addi t1,t1,4				# soma 4 ao endere�o
		addi s1,s1,4
		j LOOP_GAME_OVER					# volta a verificar

GAME_OVER_ENTER:	
		li t1,0xFF200000		# carrega o endereco de controle do KDMMIO
		lw t0,0(t1)			# Le bit de Controle Teclado
		andi t0,t0,0x0001		# mascara o bit menos significativo
  		lw t2,4(t1)  			# le o valor da tecla tecla
		
		li t0,10
		bne t2,t0,GAME_OVER_ENTER
		li a7, 10
		ecall