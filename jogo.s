.data
BITMAP_POS:		.half 0, 0				# x, y
OLD_BITMAP_POS:		.half 0, 0				# x, y
MATRIZ_POS: 		.word 0

UPDATE_BITMAP_POS:	.half 148, 177
MATRIZ_ATUAL:		.word 0
MAPA_ATUAL:			.word 0
MAPA_ATUAL_INT: 	.byte 1

SPRITE_ATUAL:		.word 0
SPRITE_ATUAL_2: 	.word 0
SPRITE_ATUAL_3:		.word 0

PONTUACAO: 			.word 0
PONTUACAO_MAXIMA: 	.word 0
VIDAS:				.byte 3
FRUTAS:				.byte 0

PONTOS_COMIDOS: 	.half 0
PONTOS_TOTAIS:		.half 224

OLD_SEC_COUNTER: .word 1
ULTIMO_MOVIMENTO: .word 0
PROXIMO_MOVIMENTO: .word 0
INTEIRO_PROXIMO_MOVIMENTO: .byte 0

STR_PONTUACAO: .string "Score"
STR_MAX: .string "Max"
STR_VIDAS: .string "Vidas"
STR_FRUTAS: .string "Frutas"

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

.include "MACROSv21.s"

.text
call MAIN_MENU

SETUP:		
		# RESETA OS DADOS PARA PROXIMA FASE
		la t0, PONTOS_COMIDOS
		sh zero, (t0)

		la s1, BITMAP_POS
		la s2, OLD_BITMAP_POS
		la s3, UPDATE_BITMAP_POS
		
		lh t1, (s3) # t1 = x
		lh t2, 2 (s3) # t2 = y
		
		sh t1, (s1)
		sh t2, 2 (s1)
		sh t1, (s2)
		sh t2, 2 (s2)
		
		la t0, MATRIZ_POS
		sw zero, (t0)
		
		la t0, ULTIMO_MOVIMENTO	
		la t1, CHAR_ESQ				# comeca o jogo com pacman andando para a esquerda
		sw t1, (t0)
		
		la t0, SPRITE_ATUAL
		la t1, pacman_esq			# salva a sprite esquerda como a sprite atual
		sw t1, (t0)
		
		la t0, SPRITE_ATUAL_2
		la t1, pacman_esq_2			# salva a sprite esquerda como a sprite atual
		sw t1, (t0)
		
		la t0, SPRITE_ATUAL_3
		la t1, pacman_fechado			# salva a sprite esquerda como a sprite atual
		sw t1, (t0)

		# MATRIZ PACMAN
		la t0, MATRIZ_ATUAL
		lw s2, (t0)
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
		la t0, MAPA_ATUAL
		lw a0, (t0)
		#la a0,maze				# carrega o endereco do sprite 'maze' em a0
		li a1,0					# x = 0
		li a2,0					# y = 0
		li a3,0					# frame = 0
		call PRINT				# imprime o sprite
		li a3,1					# frame = 1
		call PRINT				# imprime o sprite
		# esse setup serve pra desenhar o "mapa" nos dois frames antes do "jogo" comecar


GAME_LOOP:	
		la t0, PONTOS_COMIDOS		
		lh t0, (t0)
		
		la t1, PONTOS_TOTAIS
		lh t1, (t1)
		
		beq t0, t1, TROCA_MAPA		# se todas as frutas foram comidas (224 frutas) -> volta para setup e inicia proxima fase
						
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
		la t1, SPRITE_ATUAL		
		lw a0, (t1)	
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
		
		############ MENU IN-GAME ###############
		la a0, STR_PONTUACAO	# display da string score
		li a1, 5 				# posicao x
		li a2, 30 				# posicao y
		li a3, 0x000000ff 		# Texto branco fundo preto
		mv a4, s0 				# frame s0 (alterna)
		li a7, 104 				# ecall do print int 
		ecall
		
		la t1, PONTOS_COMIDOS
		lh a0, (t1)			# display da pontuacao na tela
		li a1, 7 			# posicao x
		li a2, 45 			# posicao y
		li a7, 101 			# ecall do print int 
		ecall
		
		la a0, STR_MAX	# display da string score
		li a1, 280 				# posicao x
		li a2, 20 				# posicao y
		li a3, 0x000000ff 		# Texto branco fundo preto
		mv a4, s0 				# frame s0 (alterna)
		li a7, 104 				# ecall do print int 
		ecall
		
		la a0, STR_PONTUACAO	# display da string score
		li a1, 275 				# posicao x
		li a2, 30 				# posicao y
		li a3, 0x000000ff 		# Texto branco fundo preto
		mv a4, s0 				# frame s0 (alterna)
		li a7, 104 				# ecall do print int 
		ecall
		
		la t1, PONTUACAO_MAXIMA
		lh a0, (t1)			# display da pontuacao na tela
		li a1, 280 			# posicao x
		li a2, 40 			# posicao y
		li a7, 101 			# ecall do print int 
		ecall
		
		la a0, STR_VIDAS	# display da string score
		li a1, 0 				# posicao x
		li a2, 200 				# posicao y
		li a3, 0x000000ff 		# Texto branco fundo preto
		mv a4, s0 				# frame s0 (alterna)
		li a7, 104 				# ecall do print int 
		ecall
		
		la t1, VIDAS
		lb a0, (t1)			# display da pontuacao na tela
		li a1, 15 			# posicao x
		li a2, 215 			# posicao y
		li a7, 101 			# ecall do print int 
		ecall
		
		la a0, STR_FRUTAS	# display da string score
		li a1, 271				# posicao x
		li a2, 200 				# posicao y
		li a3, 0x000000ff 		# Texto branco fundo preto
		mv a4, s0 				# frame s0 (alterna)
		li a7, 104 				# ecall do print int 
		ecall
		
		la t1, FRUTAS
		lb a0, (t1)			# display da pontuacao na tela
		li a1, 290 			# posicao x
		li a2, 215 			# posicao y
		li a7, 101 			# ecall do print int 
		ecall
	
		j GAME_LOOP			# continua o loop

TROCA_MAPA:
		la t0, MAPA_ATUAL_INT
		lb s1, (t0)
		
		li t1, 1
		beq t1, s1, TROCA_MAPA_2
		
		li t1, 2
		beq t1, s1, TROCA_MAPA_3

		call VICTORY		
		
TROCA_MAPA_2:
		la a2, maze_2
		la a3, MATRIZ_2
		li a4, 150
		li a5, 178
		
		la t0, MAPA_ATUAL
		sw a2, (t0)			# store proximo mapa
		
		la t0, MATRIZ_ATUAL
		lw t1, (t0)
		
		sw a3, (t0)
		
		la t0, UPDATE_BITMAP_POS
		sh a4, (t0)
		sh a5, 2 (t0)
		
		la t0, MAPA_ATUAL_INT
		
		li t1, 2
		sb t1, (t0)
		
		la t0, PONTOS_TOTAIS	
		
		li t1, 238
		sh t1, (t0)
		
		j SETUP

TROCA_MAPA_3:
		la a2, maze_3
		la a3, MATRIZ_3
		li a4, 150
		li a5, 178
		
		la t0, MAPA_ATUAL
		sw a2, (t0)			# store proximo mapa
		
		la t0, MATRIZ_ATUAL
		lw t1, (t0)
		
		sw a3, (t0)
		
		la t0, UPDATE_BITMAP_POS
		sh a4, (t0)
		sh a5, 2 (t0)
		
		la t0, MAPA_ATUAL_INT
		
		li t1, 3
		sb t1, (t0)
		
		la t0, PONTOS_TOTAIS	
		
		li t1, 242
		sh t1, (t0)
		
		j SETUP

INPUT_TECLADO:
		li a7, 30				# syscall de tempo
		ecall

		la s2, OLD_SEC_COUNTER	# s2 = endereco de OLD_SEC_COUNTER
		lw s3, (s2)				# s3 = conteudo em s2
		
		beq a0, s3, FIM			# se o tempo em a0 ja tiver sido utilizado no loop -> FIM
		sw a0, (s2)				# se nao -> armazena o tempo atual em OLD_SEC_COUNTER
		
		slli s1, a0, 26	
		srli s1, s1, 26
		
		beqz s1, MOVIMENTACAO		# se o tempo atual formatado for = 0 -> JUMP_ULTIMO_MOVIMENTO
		
		li t1,0xFF200000		# carrega o endereco de controle do KDMMIO
		lw t0,0(t1)				# Le bit de Controle Teclado
		andi t0,t0,0x0001		# mascara o bit menos significativo
   		beq t0,zero,FIM   	   	# Se nao ha tecla pressionada entao vai para FIM
  		lw t2,4(t1)  			# le o valor da tecla
		
		li t0,'w'
		la a4, pacman_cima
		la a5, pacman_cima_2
		la a3, CHAR_CIMA
		li a2, -28
		beq t2,t0,STORE_ULTIMO_MOVIMENTO		# se tecla pressionada for 'w', chama CHAR_CIMA
		
		li t0,'a'
		la a4, pacman_esq
		la a5, pacman_esq_2
		la a3, CHAR_ESQ
		li a2, -1
		beq t2,t0,STORE_ULTIMO_MOVIMENTO		# se tecla pressionada for 'a', chama CHAR_CIMA
		
		li t0,'s'
		la a4, pacman_baixo
		la a5, pacman_baixo_2
		la a3, CHAR_BAIXO
		li a2, 28
		beq t2,t0,STORE_ULTIMO_MOVIMENTO		# se tecla pressionada for 's', chama CHAR_CIMA
		
		li t0,'d'
		la a4, pacman_dir
		la a5, pacman_dir_2
		la a3, CHAR_DIR
		li a2, 1
		beq t2,t0,STORE_ULTIMO_MOVIMENTO		# se tecla pressionada for 'd', chama CHAR_CIMA
		
		li t0, 'k'
		beq t2, t0, TROCA_MAPA

MOVIMENTACAO:
		jal s8 TROCA_SPRITE_ATUAL	# come come

		la t0, PROXIMO_MOVIMENTO	# t0 = endereco de PROXIMO_MOVIMENTO
		lw s1, (t0)					# t1 = word em t0 (endereco do proximo movimento)
		
		beqz s1, JUMP_ULTIMO_MOVIMENTO	# se s1 for = 0 
		
		jal s8, PRE_CHECK_MOVIMENTO		# checa o proximo movimento
		
		la t0, PROXIMO_MOVIMENTO	# t0 = endereco de PROXIMO_MOVIMENTO
		lw s1, (t0)					# t1 = word em t0 (endereco do proximo movimento)
		jr s1							# vai para o proximo movimento

TROCA_SPRITE_ATUAL:
		la s1, SPRITE_ATUAL
		la s2, SPRITE_ATUAL_2
		la s3, SPRITE_ATUAL_3
		lw t1, (s1)
		lw t2, (s2)
		lw t3, (s3)
		
		sw t1, (s2)
		sw t2, (s3)
		sw t3, (s1)
		
		jr s8
		
STORE_ULTIMO_MOVIMENTO:
		
		la t1, SPRITE_ATUAL
		sw a4, (t1) 				# muda a sprite atual para a4
		
		la t1, SPRITE_ATUAL_2
		sw a5, (t1)
		
		la t0, SPRITE_ATUAL_3
		la t1, pacman_fechado			# salva a sprite esquerda como a sprite atual
		sw t1, (t0)

 		jal s8, PRE_CHECK_COLISAO	# se elemento for parede -> nao armazena o input

		la t0, ULTIMO_MOVIMENTO		# t0 = endereco de ULTIMO_MOVIMENTO
		sw a3, (t0)					# armazena o endereco do ultimo movimento (a3) em ULTIMO_MOVIMENTO	
		
		la t1, PROXIMO_MOVIMENTO	# t0 = endereco de PROXIMO_MOVIMENTO
		sw zero, (t1)				# zera o conteudo de PROXIMO_MOVIMENTO
		
		ret

STORE_PROXIMO_MOVIMENTO:
		la t0, PROXIMO_MOVIMENTO	# t0 = endereco de PROXIMO_MOVIMENTO
		sw a3, (t0)					# armazena o proximo movimento viavel (a3) em PROXIMO_MOVIMENTO
		
		la t0, INTEIRO_PROXIMO_MOVIMENTO 	# t0 = endereco de INTEIRO_PROXIMO_MOVIMENTO
		sb a2, (t0)						 	# armazena a2 (-1, 1, -28, 28) em t0
		
		ret

JUMP_ULTIMO_MOVIMENTO:
		
		la t0, ULTIMO_MOVIMENTO		# t0 = endereco de ULTIMO_MOVIMENTO
		lw s1, (t0)					# t1 = word em t0 (endereco do ultimo movimento)
		jr s1						# jump para o endereco do ultimo movimento

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
		
		li t0, 7
		li t1, -7
		beq s3, t1, PORTAL_ESQUERDA	# se o destino na matriz for um portal na esquerda
		beq s3, t0, PORTAL_DIREITA	# se o destino na matriz for um portal na direita
		
		sw s2, 0(s1)			# se nao -> atualiza MATRIZ_POS com a nova posicao do pacman
		
		li t1, 2
		li t2, 0					
		sb t1, 0(s2)			# escreve 2 (numero do pacman) na nova posicao em MATRIZ
		sb t2, 0(s4)			# escreve 0 (numero do espaco vazio) na antiga posicao em MATRIZ
		
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

PRE_CHECK_MOVIMENTO:
		
		la t0, INTEIRO_PROXIMO_MOVIMENTO
		lb a2, (t0)							# a2 = -1 / 1 / -28 / 28

		la s1, MATRIZ_POS		# s1 = endereco de MATRIZ_POS
		lw s4, 0(s1)			# s4 = endereco do pacman
		add s2, s4, a2			# s2 = endereco na direcao a2 do pacman
		lb s3, 0(s2)			# s3 = numero do destino na matriz
		
		li t0, 1
		beq s3, t0, JUMP_ULTIMO_MOVIMENTO	# se for uma parede -> continua movimento normal
											
		li t0, 8		
		beq s3, t0, JUMP_ULTIMO_MOVIMENTO 	# se for uma parede -> continua movimento normal
		
		jr s8					# j s8
		
PORTAL_ESQUERDA:
		addi s2, s4, 24			# s1 = a4 (endereco do pacman na matriz) + 26
		
		sw s2, 0(s1)			# se nao -> atualiza MATRIZ_POS com a nova posicao do pacman
		
		li t1, 2
		li t2, 0					
		sb t1, 0(s2)			# escreve 2 (numero do pacman) na nova posicao em MATRIZ
		sb t2, 0(s4)			# escreve 0 (numero do espaco vazio) na antiga posicao em MATRIZ
		
		la t0,BITMAP_POS			# carrega em t0 o endereco de BITMAP_POS
		la t1,OLD_BITMAP_POS		# carrega em t1 o endereco de OLD_BITMAP_POS
		lw t2,0(t0)
		sw t2,0(t1)			# salva a posicao atual do personagem em OLD_BITMAP_POS
		
		la t0,BITMAP_POS
		lh t1,0(t0)			# carrega o x atual do personagem
		addi t1,t1,192			# incrementa 192 pixeis
		sh t1,0(t0)			# salva
		
		ret

PORTAL_DIREITA:
		addi s2, s4, -24			# s1 = a4 (endereco do pacman na matriz) + 26
		
		sw s2, 0(s1)			# se nao -> atualiza MATRIZ_POS com a nova posicao do pacman
		
		li t1, 2
		li t2, 0					
		sb t1, 0(s2)			# escreve 2 (numero do pacman) na nova posicao em MATRIZ
		sb t2, 0(s4)			# escreve 0 (numero do espaco vazio) na antiga posicao em MATRIZ
		
		la t0,BITMAP_POS			# carrega em t0 o endereco de BITMAP_POS
		la t1,OLD_BITMAP_POS		# carrega em t1 o endereco de OLD_BITMAP_POS
		lw t2,0(t0)
		sw t2,0(t1)			# salva a posicao atual do personagem em OLD_BITMAP_POS
		
		la t0,BITMAP_POS
		lh t1,0(t0)			# carrega o x atual do personagem
		addi t1,t1,-192			# remove 192 pixeis
		sh t1,0(t0)			# salva
		
		ret
	
COMIDA:
		la s1, PONTOS_COMIDOS		
		lh t1, (s1)
		addi t1, t1, 1
		sh t1, (s1)					# armazena + 1 em pontos comidos

		la s1, PONTUACAO 			# s1 = endereco de PONTUACAO
		lw t1, (s1)					# t1 = conteudo armazenado em PONTUACAO
	
		addi t1, t1, 10				# t1 = t1 + 10
		sw t1, (s1)					# adiciona 10 pontos em PONTUACAO
		
		jr s8
	
COMIDA_GRANDE:
		la s1, PONTOS_COMIDOS		
		lh t1, (s1)
		addi t1, t1, 1
		sh t1, (s1)					# armazena + 1 em pontos comidos

		la s1, PONTUACAO 			# s1 = endereco de PONTUACAO
		lw t1, (s1)					# t1 = conteudo armazenado em PONTUACAO
	
		addi t1, t1, 50				# t1 = t1 + 50
		sw t1, (s1)					# adiciona 50 pontos em PONTUACAO
	
		jr s8

COLISAO_FANTASMA:
		la s2, VIDAS
		lb t1, (s2)
		
		beqz t1, MORTE
		
		addi t1, t1, -1
		
		sb t1, (s2)
		
		la t0, MATRIZ_ATUAL
		lw s2, (t0)
		la t1, MATRIZ_POS
		addi s2, s2, 657		# carrega posicao inicial do pacman em t0
		sw s2, (t1)				# guarda t0 em MATRIZ_POS
		
		sw s2, 0(s1)			# se nao -> atualiza MATRIZ_POS com a nova posicao do pacman
		
		li t1, 2
		li t2, 0					
		sb t1, 0(s2)			# escreve 2 (numero do pacman) na nova posicao em MATRIZ
		sb t2, 0(s4)			# escreve 0 (numero do espaco vazio) na antiga posicao em MATRIZ
		
		la t0,BITMAP_POS			# carrega em t0 o endereco de BITMAP_POS
		la t1,OLD_BITMAP_POS		# carrega em t1 o endereco de OLD_BITMAP_POS
		lw t2,0(t0)
		sw t2,0(t1)			# salva a posicao atual do personagem em OLD_BITMAP_POS
		
		la t0, UPDATE_BITMAP_POS
		lh t2,0(t0)			# carrega o x atual do personagem
		lh t3,2(t0)			# carrega o y atual do personagem
		
		la t1,BITMAP_POS
		sh t2,0(t1)			# carrega o x atual do personagem
		sh t3,2(t1)			# carrega o y atual do personagem
		
		ret
		
MORTE:
		call GAME_OVER

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
.include "game_over.s"
.include "victory.s"
.include "matrizes.s"
.include "sprites/black.data"
.include "sprites/mapas/maze.data"
.include "sprites/mapas/maze_2.data"
.include "sprites/mapas/maze_3.data"
.include "sprites/pacman/pacman_esq.data"
.include "sprites/pacman/pacman_baixo.data"
.include "sprites/pacman/pacman_cima.data"
.include "sprites/pacman/pacman_dir.data"
.include "sprites/pacman/pacman_esq_2.data"
.include "sprites/pacman/pacman_baixo_2.data"
.include "sprites/pacman/pacman_cima_2.data"
.include "sprites/pacman/pacman_dir_2.data"
.include "sprites/pacman/pacman_fechado.data"
.include "SYSTEMv21.s"
