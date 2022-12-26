.data 
LADO1: .string "Lado 1: "
LADO2: .string "Lado 2: "
LADO3: .string "Lado 3: "
LADO4: .string "Lado 4: "
PERIMETRO: .string "Perímetro: "

.text
la a0,LADO1 #Carrega a string em a0
li a7,4     #printa a String de a0
ecall
li a7,5     #Lê o inteiro, que vai pra a0
ecall 
add t0,zero,a0    #Valor do lado 1 vai pra t0 (lado1 = t0)

la a0, LADO2 #Carrega a string em a0
li a7, 4     #printa a string de a0
ecall
li a7, 5     #lê um inteiro, que vai pra a0
ecall
add t1,zero,a0     #Valor do lado 2 vai pra t1 (lado2 = t1)

la a0, LADO3  #Carrega a string em a0
li a7, 4      #printa a string de a0
ecall
li a7, 5      #lê um inteiro, que vai pra a0
ecall
add t2,zero,a0      #valor do lado3 vai pra t2 (lado3 = t2)

la a0, LADO4  #Carrega a string em a0
li a7, 4      #printa a string de a0
ecall
li a7, 5      #lê um inteiro, que vai pra a0
ecall
add t3,zero,a0      #valor do lado4 vai pra t4 (lado4 = t3)

add t0, t0, t1    #t0 = t0 + t1 (lado1 + lado2)
add t1, t2, t3    #t1 = t2 + t3 (lado3 + lado 4)
add t2, t0, t1    #t2 = t0 + ti + t2 + t3 (perímetro)
la a0, PERIMETRO  #a0 = PERIMETRO
li a7, 4          #PRINT STRING EM a0
ecall 
add a0, zero, t2 #a0 = t2
li a7, 1        #PRINT INTEIRO EM a0
ecall
li a7,10        # syscall de exit
ecall
	
#lógica do código em python
#a = int(input('Lado 1:'))
#b = int(input('Lado 2:'))
#c = int(input('Lado 3: '))
#d = int(input('Lado 4: '))
#e = a + b + c + d
#print(f'Perimetro: {e}')


