.data #Diretiva de declara��o de vari�vel
INGLES: .string "Hello World \n" #LABEL: tipo da vari�vel, vari�vel 
ESPANHOL: .string "Hola mundo \n" #A \n funciona e tem que usar 
FRANCES: .string "Bonjour  monde \n" 
PORTUGUES: .string "Ol� mundo \n "

.text
li a7, 4 #Determina a syscall que vai ser usada

la a0, INGLES #Carrega o endere�o da LABEL INGLES pro a0. a0 � o determinado pra syscall
ecall #chama a rotina 

la a0, ESPANHOL #altera o valor de a0
ecall #chama a rotina

la a0, FRANCES #altera o valor de a0
ecall #chama a rotina

la a0, PORTUGUES #altera o valor de a0
ecall #chama a rotina