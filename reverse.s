.data
str:

.text

call strrev

strlen:
	MAIN_LEN:
		li a7, 8 			# inpu
		li a1, 50 			# quantidade max de caracteres
		la a0, str 			# a0 = endereco da str
		ecall
		li t0, 0			# contagem = 0
		li s2, 10 			# string termina em caractere "a"(10)
	LOOP_LEN:
		add t1, t0, a0		# comeca a iteracao a partir do primeiro endereco
		lb  t1, 0(t1) 		# pega o caractere ascii (1 byte)
		beq t1, s2, DONE_LEN
		addi t0, t0, 1
		j LOOP_LEN
	DONE_LEN:
		mv s0, t0 
		ret
		
strrev:
	MAIN_REV:
		call strlen
		la t1, str 			# t1 = endereco string
		addi s0, s0 -1 		# len vai de 1 a 3 e a memoria de 0 a 2, portanto tem que diminuir 1
		add s0, s0, t1 		# len + endereco = ultimo endereco
		li t0, 0			# contagem = 0
		li a7, 11			# syscall print ascii
	LOOP_REV:
		add t1, t0, s0 		# comeca a iteracao a partir do ultimo endereco
		lb t1, 0(t1) 		# pega o caractere ascii (1 byte)
		beq t1, zero, DONE_REV
		mv a0, t1 			# printa o caractere
		ecall
		addi t0, t0, -1		# vai para o endereco anterior
		j LOOP_REV
	DONE_REV:
		li a7, 10
		ecall 