.data
str:

.text
MAIN:
	li a7, 8 	# INPUT DE STRING
	li a1, 10 	# QUANTIDADE MÁXIMA DE CHAR
	la a0, str 	# ONDE ARMAZENAR A STR
	ecall
	li t0, 0	# CONTAGEM = 0
LOOP:
	add t1, t0, a0	# PEGAR PRIMEIRO ENDEREÇO
	lb  t1, 0(t1)
	beq t1, zero, DONE
	addi t0, t0, 1
	j LOOP
DONE:
	mv a0, t0
	addi a0, a0, -1
	li a7, 1
	ecall