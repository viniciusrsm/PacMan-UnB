.data
a: .string "Digite o valor de a: "
bb: .string "\nDigite o valor de b: "
c: .string "\nDigite o valor de c: "
deltapos: .string "Delta maior que zero: "
deltaneg: .string "Delta menor que zero: "
deltazer: .string "Delta igual a zero: "
.text
PRINT_a:
	la a0,a
	li a7,4
	ecall
	add a0, zero, zero  #zerando a0 so por medo
INPUT_a:
	li a7, 5
	ecall
	add t0, a0, zero    #t0 = a
	add a0, zero, zero #zerando a0 so por medo
PRINT_b:
	la a0,bb
	li a7,4
	ecall
	add a0, zero, zero  #zerando a0 so por medo
Input_b:
	li a7, 5
	ecall
	add t1, a0, zero #t1 = b
	add a0, zero, zero   #zerando a0 so por medo
PRINT_c:
	la a0,c
	li a7,4
	ecall
	add a0, zero, zero  #zerando a0 so por medo
Input_c:
	li a7, 5
	ecall
	add t2, a0, zero #t2 = c
	add a0, zero, zero   #zerando a0 so por medo
CALCULA_DELTA:
	li a1, 4
	mul t6, t1,t1    #t6 = t1*t1   #t6 = b^2
	mul t5, t0,t2    #t5 = a*c
	mul t4, t5, a1   #t4 = 4*a*c
	sub t3, t6, t4   #t3 = b^2 - 4*a*c = DELTA
CONDICIONAIS:
	li s3, 0
	bgt t3, s3, POSITIVO   #delta maior ou igual a zero 
	blt t3, s3, DELTANEG   #delta menor ou igual a zero
	#se n é maior que zero nem menor que zero, tem q ser zero (eu acho)
	la a0, deltazer
	li a7, 4
	ecall
	li a7, 10
	ecall
DELTANEG:
	la a0, deltaneg
	li a7, 4
	ecall
	li a7, 10
	ecall
POSITIVO:
	la a0, deltapos
	li a7, 4
	ecall
	li a7, 10
	ecall
