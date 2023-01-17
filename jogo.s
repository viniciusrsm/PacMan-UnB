.data
BITMAP_POS:		.half 148,177				# x, y
OLD_BITMAP_POS:	.half 148,177				# x, y
MATRIZ_POS: 	.word 0
PONTUACAO: 		.word 0
VIDAS:			.half 3

OLD_SEC_COUNTER: .word 1
ULTIMO_MOVIMENTO: .word 0
PROXIMO_MOVIMENTO: .word 0


########## .data FANTASMAS #############

BITMAP_POS_AZUL:		.half 140,81				# x, y
OLD_BITMAP_POS_AZUL:	.half 140,81				# x, y
MATRIZ_POS_AZUL: 		.word 0
	
BITMAP_POS_VERMELHO:		.half 164, 81			# x, y
OLD_BITMAP_POS_VERMELHO:	.half 164, 81				# x, y
MATRIZ_POS_VERMELHO:	 	.word 0

BITMAP_POS_ROSA:		.half 140,105				# x, y
OLD_BITMAP_POS_ROSA:	.half 140,105				# x, y
MATRIZ_POS_ROSA: 		.word 0
	
BITMAP_POS_AMARELO:		.half 164, 105				# x, y
OLD_BITMAP_POS_AMARELO:	.half 164, 105				# x, y
MATRIZ_POS_AMARELO: 	.word 0

.text
call MAIN_MENU

SETUP:		
		la t0, ULTIMO_MOVIMENTO
		la t1, CHAR_ESQ
		sw t1, (t0)

		# MATRIZ PACMAN
		la s2, MATRIZ_1
		la t1, MATRIZ_POS
		addi t2, s2, 657		# carrega posicao inicial do pacman em t0
		sw t2, (t1)				# guarda t0 em MATRIZ_POS
		
		# MATRIZ AZUL
		la t1, MATRIZ_POS_AZUL
		addi t2, s2, 321
		sw t2, (t1)
		
		# MATRIZ VERMELHO
		la t1, MATRIZ_POS_VERMELHO
		addi t2, s2, 404
		sw t2, (t1)
		
		# MATRIZ ROSA
		la t1, MATRIZ_POS_ROSA
		addi t2, s2, 405
		sw t2, (t1)
		
		# MATRIZ AMARELO
		la t1, MATRIZ_POS_AMARELO
		addi t2, s2, 407
		sw t2, (t1)
		
		# LABIRINTO
		la a0,maze				# carrega o endereco do sprite 'maze' em a0
		li a1,0					# x = 0
		li a2,0					# y = 0
		li a3,0					# frame = 0
		call PRINT				# imprime o sprite
		li a3,1					# frame = 1
		call PRINT				# imprime o sprite
		# esse setup serve pra desenhar o "mapa" nos dois frames antes do "jogo" comecar

GAME_LOOP:	
		call INPUT_TECLADO			# chama o procedimento de entrada do teclado
		
		xori s0,s0,1			# inverte o valor frame atual (somente o registrador)
		
		la a2, BITMAP_POS_AZUL		# a2 = endereco bitmap do fantasma azul
		la a0, azul_direita		# carrega o endereco do sprite 'azul_direita' em a0
		jal s8, CHAR_PRINT			# chama CHAR_PRINT
		
		la a2, BITMAP_POS_VERMELHO	# a2 = endereco bitmap do fantasma vermelho
		la a0, vermelho_direita		# carrega o endereco do sprite 'vermelho_direita' em a0
		jal s8, CHAR_PRINT			# chama CHAR_PRINT
		
		la a2, BITMAP_POS_ROSA		# a2 = endereco bitmap do fantasma rosa
		la a0, rosa_direita		# carrega o endereco do sprite 'rosa_direita' em a0
		jal s8, CHAR_PRINT			# chama CHAR_PRINT
		
		la a2, BITMAP_POS_AMARELO	# a2 = endereco bitmap do fantasma amarelo
		la a0, amarelo_direita		# carrega o endereco do sprite 'amarelo_direita' em a0
		jal s8, CHAR_PRINT			# chama CHAR_PRINT
		
		la a2, BITMAP_POS			# a2 = endereco bitmap do pacman
		la a0, pacman				# carrega o endereco do sprite 'pacman' em a0
		jal s8, CHAR_PRINT
		
		
		li t0,0xFF200604		# carrega em t0 o endereco de troca de frame
		sw s0,0(t0)			# mostra o sprite pronto para o usuario
		
		#####################################
		# Limpeza do "rastro" do personagem #
		#####################################
		la t0,OLD_BITMAP_POS		# carrega em t0 o endereco de OLD_BITMAP_POS
		
		la a0,black			# carrega o endereco do sprite 'black' em a0
		lh a1,0(t0)			# carrega a posicao x antiga do personagem em a1
		lh a2,2(t0)			# carrega a posicao y antiga do personagem em a2
		
		mv a3,s0			# carrega o frame atual (que esta na tela em a3)
		xori a3,a3,1			# inverte a3 (0 vira 1, 1 vira 0)
		call PRINT			# imprime
	
		j GAME_LOOP			# continua o loop

INPUT_TECLADO:	
		
		li a7, 30				# syscall de tempo
		ecall

		la s2, OLD_SEC_COUNTER	# s2 = endereco de OLD_SEC_COUNTER
		lw s3, (s2)				# s3 = conteudo em s2
		
		beq a0, s3, FIM			# se o tempo em a0 ja tiver sido utilizado no loop -> FIM
		sw a0, (s2)				# se nao -> armazena o tempo atual em OLD_SEC_COUNTER
		
		slli s1, a0, 26	
		srli s1, s1, 26
	
		
		beqz s1, JUMP_ULTIMO_MOVIMENTO		# se o tempo atual formatado for = 0 -> JUMP_ULTIMO_MOVIMENTO
		
		li t1,0xFF200000		# carrega o endereco de controle do KDMMIO
		lw t0,0(t1)				# Le bit de Controle Teclado
		andi t0,t0,0x0001		# mascara o bit menos significativo
   		beq t0,zero,FIM   	   	# Se nao ha tecla pressionada entao vai para FIM
  		lw t2,4(t1)  			# le o valor da tecla
		
		li t0,'w'
		la a3, CHAR_CIMA
		li a2, -28
		beq t2,t0,STORE_ULTIMO_MOVIMENTO		# se tecla pressionada for 'w', chama CHAR_CIMA
		
		li t0,'a'
		la a3, CHAR_ESQ
		li a2, -1
		beq t2,t0,STORE_ULTIMO_MOVIMENTO		# se tecla pressionada for 'a', chama CHAR_CIMA
		
		li t0,'s'
		la a3, CHAR_BAIXO
		li a2, 28
		beq t2,t0,STORE_ULTIMO_MOVIMENTO		# se tecla pressionada for 's', chama CHAR_CIMA
		
		li t0,'d'
		la a3, CHAR_DIR
		li a2, 1
		beq t2,t0,STORE_ULTIMO_MOVIMENTO		# se tecla pressionada for 'd', chama CHAR_CIMA
		
STORE_ULTIMO_MOVIMENTO:
		jal s8, PRE_CHECK_COLISAO	# se elemento for parede -> nao armazena o input

		la t0, ULTIMO_MOVIMENTO		# t0 = endereco de ULTIMO_MOVIMENTO
		sw a3, (t0)					# armazena o endereco do ultimo movimento (a3) em ULTIMO_MOVIMENTO
		
		la t1, PROXIMO_MOVIMENTO	# t0 = endereco de PROXIMO_MOVIMENTO
		sw zero, (t1)				# zera o conteudo de PROXIMO_MOVIMENTO
		ret

STORE_PROXIMO_MOVIMENTO:
		la t0, PROXIMO_MOVIMENTO	# t0 = endereco de PROXIMO_MOVIMENTO
		sw a3, (t0)					# armazena o proximo movimento viavel (a3) em PROXIMO_MOVIMENTO
		ret

JUMP_ULTIMO_MOVIMENTO:
		#la t0, PROXIMO_MOVIMENTO
		#lw s1, (t0)
		#bnez s1, JUMP_PROXIMO_MOVIMENTO
		
		#jal s7, PRE_CHECK_COLISAO2

		la t0, ULTIMO_MOVIMENTO		# t0 = endereco de ULTIMO_MOVIMENTO
		lw s1, (t0)					# t1 = word em t0 (endereco do ultimo movimento)
		jr s1						# jump para o endereco do ultimo movimento
		
JUMP_PROXIMO_MOVIMENTO:
		la t0, PROXIMO_MOVIMENTO	# t0 = endereco de ULTIMO_MOVIMENTO
		lw s1, (t0)					# t1 = word em t0 (endereco do ultimo movimento)
		jr s1

FIM:
		ret				# retorna

CHAR_ESQ:
		li a2, -1					# a2 = direcao do movimento na matriz
		la a3, CHAR_ESQ
		jal s8, COLISAO				# pula para colisao e coloca em s8 o endereco de retorno
		
		la s8, CHAR_ESQ
		
		la t0, ULTIMO_MOVIMENTO
		sw s8, (t0)					# guarda CHAR_ESQ em ULTIMO_MOVIMENTO
		
		la t0,BITMAP_POS			# carrega em t0 o endereco de BITMAP_POS
		la t1,OLD_BITMAP_POS		# carrega em t1 o endereco de OLD_BITMAP_POS
		lw t2,0(t0)
		sw t2,0(t1)			# salva a posicao atual do personagem em OLD_BITMAP_POS
		
		lh t1,0(t0)			# carrega o x atual do personagem
		addi t1,t1,-8			# decrementa 8 pixeis
		sh t1,0(t0)			# salva
		ret

CHAR_DIR:	
		li a2, 1					# a2 = direcao do movimento na matriz
		la a3, CHAR_DIR
		jal s8, COLISAO				# pula para colisao e coloca em s8 o endereco de retorno

		la s8, CHAR_DIR
		
		la t0, ULTIMO_MOVIMENTO
		sw s8, (t0)					# guarda CHAR_DIR em ULTIMO_MOVIMENTO
		
		la t0,BITMAP_POS			# carrega em t0 o endereco de BITMAP_POS
		la t1,OLD_BITMAP_POS		# carrega em t1 o endereco de OLD_BITMAP_POS
		lw t2,0(t0)
		sw t2,0(t1)			# salva a posicao atual do personagem em OLD_BITMAP_POS
		
		la t0,BITMAP_POS
		lh t1,0(t0)			# carrega o x atual do personagem
		addi t1,t1,8			# incrementa 8 pixeis
		sh t1,0(t0)			# salva
		ret

CHAR_CIMA:
		li a2, -28					# a2 = direcao do movimento na matriz
		la a3, CHAR_CIMA
		jal s8, COLISAO				# pula para colisao e coloca em s8 o endereco de retorno
		
		la s8, CHAR_CIMA
		
		la t0, ULTIMO_MOVIMENTO
		sw s8, (t0)					# guarda CHAR_CIMA em ULTIMO_MOVIMENTO
		
		la t0,BITMAP_POS			# carrega em t0 o endereco de BITMAP_POS
		la t1,OLD_BITMAP_POS		# carrega em t1 o endereco de OLD_BITMAP_POS
		lw t2,0(t0)
		sw t2,0(t1)			# salva a posicao atual do personagem em OLD_BITMAP_POS
		
		la t0,BITMAP_POS
		lh t1,2(t0)			# carrega o y atual do personagem
		addi t1,t1,-8			# decrementa 8 pixeis
		sh t1,2(t0)			# salva
		ret

CHAR_BAIXO:		
		li a2, 28
		la a3, CHAR_BAIXO					# a2 = direcao do movimento na matriz
		jal s8, COLISAO				# pula para colisao e coloca em s8 o endereco de retorno
		
		la s8, CHAR_BAIXO
		
		la t0, ULTIMO_MOVIMENTO
		sw s8, (t0)					# guarda CHAR_BAIXO em ULTIMO_MOVIMENTO
		
		la t0,BITMAP_POS			# carrega em t0 o endereco de BITMAP_POS
		la t1,OLD_BITMAP_POS		# carrega em t1 o endereco de OLD_BITMAP_POS
		lw t2,0(t0)
		sw t2,0(t1)				# salva a posicao atual do personagem em OLD_BITMAP_POS
		
		la t0,BITMAP_POS
		lh t1,2(t0)				# carrega o y atual do personagem
		addi t1,t1,8			# incrementa 8 pixeis
		sh t1,2(t0)				# salva
		ret
		
#################COLISAO#########################
# a2 = direcao do movimento (1,-1,28,-28)
# a3 = endereco do ultimo movimento (CHAR_BAIXO / CHAR_CIMA / CHAR_ESQ / CHAR_DIR)
COLISAO:
		la s1, MATRIZ_POS		# s1 = endereco de MATRIZ_POS
		lw s4, 0(s1)			# s4 = endereco do pacman
		add s2, s4, a2			# s2 = endereco na direcao a2 do pacman
		lb s3, 0(s2)			# s3 = numero do destino na matriz
		
		li t0, 1		
		beq s3, t0, FIM			# se o destino na matriz (s3) for uma parede (1) -> FIM
		
		li t0, 8		
		beq s3, t0, FIM			# se o destino na matriz (s3) for o portao da base fantasma (8) -> FIM
		
		li t0, 3
		beq s3, t0, COLISAO_FANTASMA		
		
		sw s2, 0(s1)			# se nao -> atualiza MATRIZ_POS com a nova posicao do pacman
		
		li t1, 2
		li t2, 0					
		sb t1, 0(s2)			# escreve 2 (numero do pacman) na nova posicao em MATRIZ
		sb t2, 0(s4)			# escreve 0 (numero do espaco vazio) na antiga posicao em MATRIZ
		
		li t0, 7
		li t1, -7
		#beq s3, t1, PORTAL_ESQUERDA	# se o destino na matriz for um portal na esquerda
		#beq s3, t2, PORTAL_DIREITA	# se o destino na matriz for um portal na direita
		
		li t0, 4
		beq s3, t0, COMIDA		
		# come a comida
		
		li t0, 5
		beq s3, t0, COMIDA_GRANDE
		# come a comida grande
		
		li t0, 6
		# come a cereja
		
		jr s8					# salta de volta para s8 (registrador de retorno nas funcoes de movimentacao)
		
PRE_CHECK_COLISAO:
		la s1, MATRIZ_POS		# s1 = endereco de MATRIZ_POS
		lw s4, 0(s1)			# s4 = endereco do pacman
		add s2, s4, a2			# s2 = endereco na direcao a2 do pacman
		lb s3, 0(s2)			# s3 = numero do destino na matriz
		
		li t0, 1		
		beq s3, t0, STORE_PROXIMO_MOVIMENTO			# se o destino na matriz (s3) for uma parede (1) -> FIM
		
		li t0, 8		
		beq s3, t0, STORE_PROXIMO_MOVIMENTO			# se o destino na matriz (s3) for o portao da base fantasma (8) -> FIM
		
		jr s8
		
PORTAL:
		# multiplicar distancia a ser andada por a2 pra definir se é pra frente ou pra tras
		
		jr s8
	
COMIDA:
		la s1, PONTUACAO 			# s1 = endereco de PONTUACAO
		lw t1, (s1)					# t1 = conteudo armazenado em PONTUACAO
	
		addi t1, t1, 10				# t1 = t1 + 10
		sw t1, (s1)					# adiciona 10 pontos em PONTUACAO
		
		jr s8
	
COMIDA_GRANDE:
		la s1, PONTUACAO 			# s1 = endereco de PONTUACAO
		lw t1, (s1)					# t1 = conteudo armazenado em PONTUACAO
	
		addi t1, t1, 50				# t1 = t1 + 50
		sw t1, (s1)					# adiciona 50 pontos em PONTUACAO
	
		jr s8
		
COLISAO_FANTASMA:
		ret

############## FANTASMAS ########################
	
MOVIMENTACAO_AZUL:
		#li a7, 30
		#ecall
	
		#slli s0, a0, 20
		#srli s0, s0, 20
		
		#beqz s0, FIM
		
		#li a7, 42			# syscall de rand int range 
		#li a0, 0			# index
		#li a1, 4			# limite do range
		#ecall
		
		#li t0, 0
		#beq a0, t0, CHAR_ESQ_FANTASMA
		#j CHAR_ESQ_FANTASMA
	
MOVIMENTACAO_VERMELHO:
	
MOVIMENTACAO_ROSA:
	
MOVIMENTACAO_AMARELO:
	

####

CHAR_ESQ_FANTASMA:
		#li a2, -1					# a2 = direcao do movimento na matriz
		#jal s8, COLISAO				# pula para colisao e coloca em s8 o endereco de retorno
		
		la s8, CHAR_ESQ_FANTASMA
		la t0,BITMAP_POS_AZUL			# carrega em t0 o endereco de BITMAP_POS
		la t1,OLD_BITMAP_POS_AZUL		# carrega em t1 o endereco de OLD_BITMAP_POS
		lw t2,0(t0)
		sw t2,0(t1)			# salva a posicao atual do personagem em OLD_BITMAP_POS
		
		lh t1,0(t0)			# carrega o x atual do personagem
		addi t1,t1,-8			# decrementa 8 pixeis
		sh t1,0(t0)			# salva
		ret

#################################################
#	a0 = endereço imagem			
#	a1 = x					
#	a2 = y					
#	a3 = frame (0 ou 1)			
#################################################
#	t0 = endereco do bitmap display		
#	t1 = endereco da imagem			
#	t2 = contador de linha			
# 	t3 = contador de coluna			
#	t4 = largura				
#	t5 = altura				
#################################################

PRINT:			
		li t0,0xFF0				# carrega 0xFF0 (frame 0) em t0
		add t0,t0,a3			# adiciona o frame ao FF0 (se o frame for 1 vira FF1, se for 0 fica FF0)
		slli t0,t0,20			# shift de 20 bits pra esquerda (0xFF0 vira 0xFF000000, 0xFF1 vira 0xFF100000)
		
		add t0,t0,a1			# adiciona x ao t0
		
		li t1,320				# t1 = 320
		mul t1,t1,a2			# t1 = 320 * y
		add t0,t0,t1			# adiciona t1 ao t0
		
		addi t1,a0,8			# t1 = a0 + 8
		
		mv t2,zero				# zera t2
		mv t3,zero				# zera t3
		
		lw t4,0(a0)				# carrega a largura da imagem em t4
		lw t5,4(a0)				# carrega a altura da imagem em t5
		
PRINT_LINHA:	
		lw t6,0(t1)				# carrega em t6 uma word (4 pixeis) da imagem
		sw t6,0(t0)				# imprime no bitmap a word (4 pixeis) da imagem
		
		addi t0,t0,4			# incrementa endereco do bitmap
		addi t1,t1,4			# incrementa endereco da imagem
		
		addi t3,t3,4			# incrementa contador de coluna
		blt t3,t4,PRINT_LINHA		# se contador da coluna < largura, continue imprimindo

		addi t0,t0,320			# t0 += 320
		sub t0,t0,t4			# t0 -= largura da imagem
		# ^ isso serve pra "pular" de linha no bitmap display
		
		mv t3,zero				# zera t3 (contador de coluna)
		addi t2,t2,1			# incrementa contador de linha
		bgt t5,t2,PRINT_LINHA		# se altura > contador de linha, continue imprimindo
		
		ret				# retorna
		
CHAR_PRINT:
# a0 = endereco imagem
# a2 = BITMAP_POS
	lh a1,0(a2)			# carrega a posicao x do personagem em a1
	lh a2,2(a2)			# carrega a posicao y do personagem em a2
	mv a3,s0			# carrega o valor do frame em a3
	call PRINT			# imprime o sprite
	
	jr s8

		

.data
.include "sprites/vermelho_direita.data"
.include "sprites/azul_direita.data"
.include "sprites/rosa_direita.data"
.include "sprites/amarelo_direita.data"
.include "menu.s"
.include "matrizes.s"
.include "sprites/black.data"
.include "sprites/mapas/maze.data"
.include "sprites/pacman.data"
