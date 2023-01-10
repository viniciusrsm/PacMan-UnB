.data
.include "sprites/menu/pacmanvs.data"

.text
MAIN_MENU:
		li t1,0xFF000000			# endereco inicial da Memoria VGA - Frame 0
		li t2,0xFF012C00			# endereco final 
		la s1,pacmanvs				# endere�o dos dados da tela na memoria
		addi s1,s1,8				# primeiro pixels depois das informa��es de nlin ncol
LOOP_MENU: 	
		beq t1,t2,FIM_MENU			# Se for o �ltimo endere�o ent�o sai do loop
		lw t3,0(s1)					# le um conjunto de 4 pixels : word
		sw t3,0(t1)					# escreve a word na mem�ria VGA
		addi t1,t1,4				# soma 4 ao endere�o
		addi s1,s1,4
		j LOOP_MENU					# volta a verificar


FIM_MENU: li a7,10					# syscall de exit
	ecall