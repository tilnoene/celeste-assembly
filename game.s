#.include "./MACROSv21.s"

.data
.include "./sprites.s"
.include "./screens.s"
.include "./musics.s" 

### JOGO ###
.text
### MENU INICIAL ###
MAIN_MENU:
    # carrega valores para a primeira execucao

    # reinicia os valores da musica
    li s8,0	    # contador de notas = 0

    # tracks da musica do menu inicial
    la s1,TRACK1
	la s2,TRACK2
	la s3,TRACK3

    # toca as primeiras notas de cada uma das tracks e salva o respectivo tempo
	csrr s5,3073	# ultimo tempo em que a nota da track s1 foi tocada (inicio = tempo atual)
	jal PLAY_NOTE_TRACK1
	
	csrr s6,3073	# ultimo tempo em que a nota da track s2 foi tocada (inicio = tempo atual)
	jal PLAY_NOTE_TRACK2
	
	csrr s7,3073	# ultimo tempo em que a nota da track s3 foi tocada (inicio = tempo atual)
	jal PLAY_NOTE_TRACK3

    # imprime a imagem de fundo
    jal IMPRIME_BACKGROUND_MAIN_MENU    # imprime o main_menu_background

LOOP_MAIN_MENU:
    # verifica e toca a nota de cada track da musica 
    csrr t0,3073	# tempo atual
	lw t2,-4(s1)	# duracao da nota anterior (s1)
	sub t1,t0,s5	# tempo ultima nota - tempo atual 
	bge t1,t2,PLAY_NOTE_TRACK1 # se for maior ou igual, toca a track1
	
	csrr t0,3073	# tempo atual
	lw t2,-4(s2)	# duracao da nota anterior (s2)
	sub t1,t0,s6	# tempo ultima nota - tempo atual 
	bge t1,t2,PLAY_NOTE_TRACK2 # se for maior ou igual, toca a track2

	csrr t0,3073	# tempo atual
	lw t2,-4(s3)	# duracao da nota anterior (s3)
	sub t1,t0,s7	# tempo ultima nota - tempo atual 
	bge t1,t2,PLAY_NOTE_TRACK3 # se for maior ou igual, toca a track3

    # verifica se uma tecla foi pressionada
    li t1,0xFF200000	        # carrega o endereco de controle do KDMMIO
	lw t0,0(t1)		            # le bit de Controle Teclado
   	andi t0,t0,0x0001	        # mascara o bit menos significativo
   	beqz t0,LOOP_MAIN_MENU	# nao tem tecla pressionada entao volta ao loop
   	lw t2,4(t1)		            # le o valor da tecla
    
	j GAME  # qualquer tecla foi pressionada, entao inicie o jogo

PLAY_NOTE_TRACK1: 	# toca a nota e avanca
	li a7,31	# MidiOut
	lw a0,0(s1)	# nota da melodia principal
	lw a1,4(s1)	# duracao da primeira nota
	li a2,INSTR_TRACK1	# instrumento
	li a3,VOL_TRACK1	# volume
	ecall

	addi s1,s1,8	# proxima nota
	csrr s5,3073	# reinicia o tempo atual
	
    addi s8,s8,1	# contador de notas += 1

    # como eh a maior, verifica se chegou no fim pra reiniciar
    li t0,NOTAS	    # numero de notas
	blt s8,t0,CONT_PLAY_NOTE_TRACK1	# verifica se contador < numero de notas

    # reinicia os valores da musica
    li s8,0	    # contador de notas = 0

    # tracks da musica do menu inicial
    la s1,TRACK1
	la s2,TRACK2
	la s3,TRACK3

    # toca as primeiras notas de cada uma das tracks e salva o respectivo tempo
	csrr s5,3073	# ultimo tempo em que a nota da track s1 foi tocada (inicio = tempo atual)
	#jal PLAY_NOTE_TRACK1
	li a7,31	# MidiOut
	lw a0,0(s1)	# nota da melodia principal
	lw a1,4(s1)	# duracao da primeira nota
	li a2,INSTR_TRACK1	# instrumento
	li a3,VOL_TRACK1	# volume
	ecall

	addi s1,s1,8	# proxima nota
	csrr s5,3073	# reinicia o tempo atual
	
    addi s8,s8,1	# contador de notas += 1

	csrr s6,3073	# ultimo tempo em que a nota da track s2 foi tocada (inicio = tempo atual)
	#jal PLAY_NOTE_TRACK2
    li a7,31	# MidiOut
	lw a0,0(s2)	# nota da melodia principal
	lw a1,4(s2)	# duracao da primeira nota
	li a2,INSTR_TRACK2	# instrumento
	li a3,VOL_TRACK2	# volume
	ecall

	addi s2,s2,8	# proxima nota
	csrr s6,3073	# reinicia o tempo atual
	
	csrr s7,3073	# ultimo tempo em que a nota da track s3 foi tocada (inicio = tempo atual)
	#jal PLAY_NOTE_TRACK3
    li a7,31	# MidiOut
	lw a0,0(s3)	# nota da melodia principal
	lw a1,4(s3)	# duracao da primeira nota
	li a2,INSTR_TRACK3	# instrumento
	li a3,VOL_TRACK3	# volume
	ecall

	addi s3,s3,8	# proxima nota
	csrr s7,3073	# reinicia o tempo atual

CONT_PLAY_NOTE_TRACK1:    ret

PLAY_NOTE_TRACK2:	# toca a nota e avanca
	li a7,31	# MidiOut
	lw a0,0(s2)	# nota da melodia principal
	lw a1,4(s2)	# duracao da primeira nota
	li a2,INSTR_TRACK2	# instrumento
	li a3,VOL_TRACK2	# volume
	ecall

	addi s2,s2,8	# proxima nota
	csrr s6,3073	# reinicia o tempo atual
	
	ret

PLAY_NOTE_TRACK3:    # toca a nota e avanca
	li a7,31	# MidiOut
	lw a0,0(s3)	# nota da melodia principal
	lw a1,4(s3)	# duracao da primeira nota
	li a2,INSTR_TRACK3	# instrumento
	li a3,VOL_TRACK3	# volume
	ecall

	addi s3,s3,8	# proxima nota
	csrr s7,3073	# reinicia o tempo atual
	
	ret

# imprime a tela de menu inicial
IMPRIME_BACKGROUND_MAIN_MENU:
    li t0,0xFF200604	# seleciona o frame 0
	sw zero,0(t0)

	li t1,0xFF000000	# endereco inicial da memoria VGA - Frame 0
	li t2,0xFF012C00	# endereco final da memoria VGA - Frame 0
	la t0,main_menu	# endereco da imagem
	addi t1,t1,8		# primeiro pixel depois das informacoes de nlin ncol

LOOP_IMPRIME_BACKGROUND_MAIN_MENU: 	
	beq t1,t2,CONT_IMPRIME_BACKGROUND_MAIN_MENU		# se for o ultimo endereco entao sai do loop
	lw t3,0(t0)		# le um conjunto de 4 pixels (word)
	sw t3,0(t1)		# escreve a word na memoria VGA
	addi t1,t1,4	# soma 4 ao endereco da memoria
	addi t0,t0,4	# soma 4 ao endereco da imagem
	j LOOP_IMPRIME_BACKGROUND_MAIN_MENU

CONT_IMPRIME_BACKGROUND_MAIN_MENU:
    ret

### INICIA O JOGO ###
GAME:
    # carrega valores para a primeira fase

    li a7,1
    li a0,777
    ecall

### FASE 1 ###
GAMELOOP_FASE1:

