#.include "./MACROSv21.s"

.data
.include "./sprites.s"
.include "./screens.s"
.include "./musics.s"

COORD_P1:	.word	0,0	# (x, y) do jogador

### JOGO ###
.text
### MENU INICIAL ###
MAIN_MENU:
    # carrega valores para a primeira execucao
	j GAME

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
	la t0,main_menu		# endereco da imagem
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
	li s0,0		# alternar entre mapa / hitbox

	# coordenadas inicias do player 1
	li t1,100	# x do player 1
	li t2,180	# y do player 1
	la t0,COORD_P1
	sw t1,0(t0)	# t1 = x
	sw t2,4(t0)	# t2 = y

    jal IMPRIME_FASE1		# imprime o mapa1

### FASE 1 ###
GAMELOOP_FASE1:
	# verifica se ele pode cair (gravidade)
	
	# coordenadas atuais do jogador
	la t0,COORD_P1
	lw t1,0(t0)		# t1 = x
	lw t2,4(t0)		# t2 = y
	addi t2,t2,-1	# olha o pixel abaixo dele

	la t3,mapa1_hitbox
	addi t3,t3,8 	# primeiro 8 pixels depois das informacoes de nlin ncol
	mv a2,t3		# copia endereco do mapa da hitbox

	li t5,240
	sub a0,t5,t2	# y = 240 - y
	
	li t5,320
	mul a1,a0,t5	# y*320
	add a1,a1,t1	# a1 += x

	add t3,t3,a1	# parte da esquerda do sprite

	addi a1,a1,-16	
	add a2,a2,a1	# parte da direita do sprite

	lw t4,0(t3)
	lw t6,0(a2)

	#mv a0,t4
	#li a7,1
	#ecall

	#li a7,11
	#li a0,10
	#ecall

	li t5,-1061109568	# azul
	beq t4,t5,TMP	# eh azul = nao desce
	beq t6,t5,TMP	# eh azul = nao desce

	sw t2,4(t0)		# y--
TMP:
	# verifica se uma tecla foi pressionada
    li t1,0xFF200000	        # carrega o endereco de controle do KDMMIO
	lw t0,0(t1)		            # le bit de Controle Teclado
   	andi t0,t0,0x0001	        # mascara o bit menos significativo
   	beqz t0,CONT_GAMELOOP_FASE1		# nao tem tecla pressionada
   	lw t2,4(t1)		            # le o valor da tecla

	# QUAL TECLA
  	lw t2,4(t1)  			# le o valor da tecla tecla
	sw t2,12(t1)  			# escreve a tecla pressionada no display
	
	li t0,109	# m
	beq t2,t0,TROCA_MAPA

	li t0,97	# a
	beq t2,t0,ESQUERDA_FASE1
	
	li t0,100	# d
	beq t2,t0,DIREITA_FASE1
	
	# nenhuma dessas letras
	j CONT_GAMELOOP_FASE1

TROCA_MAPA:
	not s0,s0
	ret

ESQUERDA_FASE1:
	# verifica se é possível
	
	# coordenadas atuais do jogador
	la t0,COORD_P1
	lw t3,0(t0)		# t3 = x
	addi t3,t3,-4	# incrementa
	sw t3,0(t0)		# t3 = x

	ret

DIREITA_FASE1:
	# verifica se é possível

	# coordenadas atuais do jogador
	la t0,COORD_P1
	lw t3,0(t0)		# t3 = x
	addi t3,t3,4	# incrementa
	sw t3,0(t0)		# t3 = x

	ret

CONT_GAMELOOP_FASE1:
	jal IMPRIME_FASE1
	
	li t4,0xFF000000 # endereco inicial da memoria de video
	la a5,madeline_stop 	# carrega o sprite
	
	lw a1,4(a5)	# a1 = h (altura do sprite)
	lw a2,0(a5)	# a2 = w (largura do sprite)
	
	# coordenadas atuais do jogador
	la t0,COORD_P1
	lw a3,0(t0)	# a3 = x
	lw a4,4(t0)	# a4 = y
	
	addi a5,a5,8 	# primeiro 8 pixels depois das informacoes de nlin ncol
	
	li t0,240
	sub t1,t0,a4	# inverte a orientacao em relacao ao eixo X
	sub t0,t1,a1
	
	mv a4,t0	# t5 (ini) = x + 320 * (y - 1)
	mv t5,a3	# t5 = x
	li t1,320	
	mul t6,t1,a4	# t6 = 320 * y
	add t5,t5,t6	# t5 += t6
	
	add t4,t4,t5	# t4 += inicio
	
	li t3,320		# sum = 320 - w (quantidade para pular para a proxima linha)
	sub t3,t3,a2	# -w
	
	sub t4,t4,t3	# memoria -= inicio (afinal pula a cada LOOP_I, inclusive o primeiro)
	
	li t1,0 # i
	li t2,0 # j
	
	# escolhe o frame
	beqz s11,LOOP_I		# frame 0
	li t0,0x00100000
	add t4,t4,t0		# frame 1
	
LOOP_I:
	beq t1,a1,EXIT_LOOP
	addi t1,t1,1 	# i++
	li t2,0		# j = 0
	
	add t4,t4,t3
	
LOOP_J:
	beq t2,a2,LOOP_I
	addi t2,t2,1	# j++
	
	lb t0,0(a5)
	
	li a0,0xFFFFFFC7		# cor magenta
	beq t0,a0,CONT_LOOP_I	# se o pixel for magenta nao imprime nada

PRINT_IMG:	sb t0,0(t4)
	
CONT_LOOP_I:
	addi a5,a5,1	# sprite++
	addi t4,t4,1	# memoria++
	
	j LOOP_J

EXIT_LOOP:

	# SLEEP
	li a7,32
	li a0,10
	ecall

	j GAMELOOP_FASE1

# imprime a tela do mapa1
IMPRIME_FASE1:
    li t0,0xFF200604	# seleciona o frame 0
	sw zero,0(t0)

	li t1,0xFF000000	# endereco inicial da memoria VGA - Frame 0
	li t2,0xFF012C00	# endereco final da memoria VGA - Frame 0
	beqz s0,IMPRIME_FASE1_HITBOX
	la t0,mapa1_background	# endereco da imagem
	j CONT_IMPRIME_FASE1_HITBOX

IMPRIME_FASE1_HITBOX:
	la t0,mapa1_hitbox	# endereco da imagem

CONT_IMPRIME_FASE1_HITBOX:
	addi t1,t1,8		# primeiro pixel depois das informacoes de nlin ncol

LOOP_IMPRIME_FASE1: 	
	beq t1,t2,CONT_IMPRIME_FASE1		# se for o ultimo endereco entao sai do loop
	lw t3,0(t0)		# le um conjunto de 4 pixels (word)
	sw t3,0(t1)		# escreve a word na memoria VGA
	addi t1,t1,4	# soma 4 ao endereco da memoria
	addi t0,t0,4	# soma 4 ao endereco da imagem
	j LOOP_IMPRIME_FASE1

CONT_IMPRIME_FASE1:
    ret