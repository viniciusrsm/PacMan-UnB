.data
.include "sprites/menu/pacmanvs.data"

.text
MAIN_MENU:
		li t1,0xFF000000			# endereco inicial da Memoria VGA - Frame 0
		li t2,0xFF012C00			# endereco final 
		la s1,pacmanvs				# endereço dos dados da tela na memoria
		addi s1,s1,8				# primeiro pixels depois das informações de largura e altura
		
LOOP_MENU: 	
		beq t1,t2,MENU_ENTER			# Se for o último endereço então sai do loop
		lw t3,0(s1)					# le um conjunto de 4 pixels : word
		sw t3,0(t1)					# escreve a word na memória VGA
		addi t1,t1,4				# soma 4 ao endereço
		addi s1,s1,4
		j LOOP_MENU					# volta a verificar

MENU_ENTER:	
		li t1,0xFF200000		# carrega o endereco de controle do KDMMIO
		lw t0,0(t1)			# Le bit de Controle Teclado
		andi t0,t0,0x0001		# mascara o bit menos significativo
  		lw t2,4(t1)  			# le o valor da tecla tecla
		
		li t0,10
		beq t2,t0,SETUP
		j MENU_ENTER