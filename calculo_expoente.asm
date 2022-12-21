.data
	numero: .string "Declare seu número: "
	expoente: .string "Declare seu expoente: "
	numeroTotal: .string "Seu número final é: "

.text
main:
	la a0, numero # print str numero
	li a7, 4
	ecall
	li a7, 5 # input do numero
	ecall
	mv a2, a0
	
	la a0, expoente # print str expoente
	li a7, 4
	ecall
	li a7, 5 # input do expoente
	ecall
	mv a3, a0 

	mv s0, a2 # valor total
	li t1, 1
	jal potencia
	li a7, 1
	ecall
	li a7, 10
	ecall
potencia:
	mul s0, s0, a2 # multiplica
	sub a3, a3, t1 # diminui a quantidade de vezes a ser multiplicada
	bne a3, t1, potencia # se a3 != 1 volta ao loop
	mv a0, s0
	ret