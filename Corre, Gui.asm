.data 
#velocidade da avó (normalizada)
#tempo até o início da prova 
#distância (normalizada)
POXAGUI: .string "Poxa, Gui."
CORREGUI: .string "Corre, Gui!"
.text
INPUTS:

    li a7, 5
    ecall
    add t0, a0, zero   #t0 = V
    add a0, zero, zero  #zerando a0

    li a7, 5
    ecall
    add t1, a0, zero  #t1 = t
    add a0, zero, zero  #zerando a0

    li a7, 5
    ecall
    add t2, a0, zero  #t2 = S
    add a0, zero, zero  #zerando a0

CALCULO:
    div a1, t2, t0   #a1 = S/V   #a1 = tempo até a casa da vó
    bge t1, a1, CORRE_GUI  #vai pra CORREGUI se o tempo for maior ou igual ao necessário
    la a0, POXAGUI  #a0 = POXAGUI
    li a7,4  #print(a0)
    ecall
    li a7, 10
    ecall
CORRE_GUI:
    la a0, CORREGUI
    li a7, 4
    ecall
    li a7, 10
    ecall

