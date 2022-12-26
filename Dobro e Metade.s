.data 
DOBRO: .string "Dobro:"
BREAK: .string " \n"                  #string vazia só com o 'contra-barra n'
METADE: .string "Metade:"

.text
li a7, 5                              #SYSCALL de leitura de um número inteiro #int(input())
ecall                                 #a0 recebe o valor do input acima

add t0, zero, a0                      #t0 recebe o valor de a0, só pra armazenar
slli t0, t0, 1                        #t0 = t0 * 2^1
la a0, DOBRO                          #a0 recebe a string 'DOBRO:'
li a7, 4                              #SYSCALL de print do a0 (STRING)
ecall                                 #PRINT DOBRO

add a0, zero, t0                      #a0 = t0 #DOBRO DO INPUT
li a7, 1                              #SYSCALL de print do a0 #
ecall                                 #SYSCALL DE print do DOBRO concatenado com o string

la a0, BREAK                          #Armazena a variável BREAK no registrador a0
li a7, 4                              #Chama a SYSCALL de printar a string BREAK
ecall

la a0, METADE                         #Armazena a variável METADE no registrador a0
li a7,4                               #SYSCALL de printar string no a0
ecall

srai t0,t0,2                          #Pega o registrador t0, que está atualizado na linha 11, e divide por 4 para achar a metade (Ver linha 11 pra entender) #a0 = t0/4
add a0, zero, t0                      #Armazena em a0 o valor de t0, ou seja, a metade. #a0 = t0
li a7, 1                              #SYSCALL de printar inteiro da metade do número         
ecall 

li a7,10			      # syscall de exit
ecall

