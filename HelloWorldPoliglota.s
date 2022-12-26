.data #Diretiva de declaração de variável
INGLES: .string "Hello World \n" #LABEL: tipo da variável, variável 
ESPANHOL: .string "Hola mundo \n" #A \n funciona e tem que usar 
FRANCES: .string "Bonjour  monde \n" 
PORTUGUES: .string "Olá mundo \n "

.text
li a7, 4 #Determina a syscall que vai ser usada

la a0, INGLES #Carrega o endereço da LABEL INGLES pro a0. a0 é o determinado pra syscall
ecall #chama a rotina 

la a0, ESPANHOL #altera o valor de a0
ecall #chama a rotina

la a0, FRANCES #altera o valor de a0
ecall #chama a rotina

la a0, PORTUGUES #altera o valor de a0
ecall #chama a rotina