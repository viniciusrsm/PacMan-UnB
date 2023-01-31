.data
.include "sprites/menu/pacmanvs.data"
NUM: .word 42
# lista de nota,duração,nota,duração,nota,duração,...
NOTAS: 60,682,60,341,64,170,65,170,67,341,65,341,64,341,62,341,60,682,64,341,55,682,57,341,64,682,62,682,57,682,60,682,64,682,62,682,59,341,55,1023,55,682,60,682,60,341,64,170,65,170,67,341,65,341,64,341,62,341,60,682,64,341,55,682,57,341,64,682,62,682,57,682,60,682,64,682,62,682,59,341,55,1023,55,682

.text
MAIN_MENU:
		la t0, maze
		la t1, MAPA_ATUAL
		sw t0, (t1)
		
		la t0, MATRIZ_1
		la t1, MATRIZ_ATUAL
		sw t0, (t1)
		
		li t1,0xFF000000			# endereco inicial da Memoria VGA - Frame 0
		li t2,0xFF012C00			# endereco final 
		la s1,pacmanvs				# endereço dos dados da tela na memoria
		addi s1,s1,8				# primeiro pixels depois das informações de largura e altura
		
		la s4,NUM		# define o endereço do número de notas
		lw s5,0(s4)		# le o numero de notas
		la s4,NOTAS		# define o endereço das notas
		li t4,0			# zera o contador de notas
		li a2,1		# define o instrumento
		li a3,127		# define o volume
		
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
		beq t2,t0,INICIAR
		
		beq t4, s5, MENU_ENTER
		lw a0,0(s4)		# le o valor da nota
		lw a1,4(s4)		# le a duracao da nota
		li a7,31		# define a chamada de syscall
		ecall			# toca a nota
		mv a0,a1		# passa a duração da nota para a pausa
		li a7,32		# define a chamada de syscal 
		ecall			# realiza uma pausa de a0 ms
		addi s4,s4,8		# incrementa para o endereço da próxima nota
		addi t4,t4,1		# incrementa o contador de notas
		
		j MENU_ENTER
		
INICIAR:
		li a7, 31
		li a0, 40
		li a1, 100
		li a2, 112
		li a3, 50
		ecall
		
		j SETUP
