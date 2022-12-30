.text
RECEBE_INPUTS:
	li a7,5  #syscall de receber inteiro 
	ecall 	 #a0 = int(input())
	add t0, zero, a0   #t0 = a0**********    t0 = int(input())
	li a7,5  #syscall de receber inteiro 
	ecall 	 #a0 = int(input())
	add t1, zero, a0   #t1 = a0**********    t1 = int(input())
CONDICIONAL:
	bgt t1,t0, MDCT1T0 #se o de cima não for atendido, vai pra MDCT1T0
	bgt t0,t1, MDCT0T1  #Se t0 for Maior que t1, vai pra MDCT0T1
	
MDCT0T1:
	beq t1,zero, MDC
	rem t5, t0, t1  #t5 = t0%t1
	add t0, zero, t1  #t0 = t1   a = b
	add t1, zero, t5  #t1 = t5  t1 = t0%t1   b = a%b
	j MDCT0T1
MDCT1T0:
	beq t1, zero, MDC
	rem t6, t1, t0 #t5 = t1 % t0
	add t1, zero, t0  #t1 = t0; a = b
	add t0, zero, t6  #t0 = a%b
	j MDCT1T0
MDC:
	add a0, zero, t0  #a0 = t0
	li a7,1  #print int
	ecall
	li a7,10  #exit
	ecall
		