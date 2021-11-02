#.include "./MACROSv21.s"
.eqv ALTURA_PULO 24
.eqv FASE_INIMIGO 2	# numero da fase em que o inimigo aparece

.data
.include "./sprites.s"
.include "./screens.s"
.include "./musics.s"

COORD_P1:	.word	0,0	# (x, y) do jogador

COORD_P2:	.word	0,0	# (x, y) do inimigo

# coordenada inicial em de cada mapa (X, Y)
COORD_INICIAL_MAPAS:	.word	32,68, 36,46, 18,92, 36,72, 36,58

# coordenada do item em cada mapa (X, Y)
COORD_ITEM:	.word	218,140, 126,80, 30,170, 132,112, 210,126

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
   	beqz t0,LOOP_MAIN_MENU		# nao tem tecla pressionada entao volta ao loop
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
	li s4,0		# fase atual [0, 4]

# reinicia os valores a cada fase
RESET_VALUES:
	li s1,0		# "estado" do pulo (> 0 ele vai subindo até ser 0)
	li s2,0		# quantidade de pulos (max: 2)
	li s5,1		# existe o item?
	li s11,0	# frame atual
	#la s10,mapa1_hitbox	# hitbox do mapa atual
	li s9,1		# sprite atual [0 - stop0, 1 - stop1, 2 - walk0, 3 - walk1, 4 - wall0, 5 - wall2]
	# s8 = orientação do sprite
	li s7,0		# orientação do inimigo

	# coordenadas inicias do player 1
	la t0,COORD_INICIAL_MAPAS
	li t1,8
	mul t1,t1,s4	# mapa_atual * 2 (2 coord.) * 4 (1 word)
	add t0,t0,t1

	lw t1,0(t0)	# x do player 1
	lw t2,4(t0)	# y do player 1

	la t0,COORD_P1	# armazena as coordenadas
	sw t1,0(t0)	# t1 = x
	sw t2,4(t0)	# t2 = y

	# coordenadas iniciais do player 2
	li t1,84	# x do player 2
	li t2,160	# y do player 2

	la t0,COORD_P2	# armazena as coordenadas
	sw t1,0(t0)	# t1 = x
	sw t2,4(t0)	# t2 = y

	# som de morte
	#li a7,33	# MidiOutSync
	#li a0,100
	#ecall

	li t0,0
	beq s4,t0,MAPA_1_GLOBAL_HITBOX
	li t0,1
	beq s4,t0,MAPA_2_GLOBAL_HITBOX
	li t0,2
	beq s4,t0,MAPA_3_GLOBAL_HITBOX
	li t0,3
	beq s4,t0,MAPA_4_GLOBAL_HITBOX
	li t0,4
	beq s4,t0,MAPA_5_GLOBAL_HITBOX

MAPA_1_GLOBAL_HITBOX:
	la s10,mapa1_hitbox	# endereco da imagem
	j CONT_RESET_VALUES_HITBOX

MAPA_2_GLOBAL_HITBOX:
	la s10,mapa2_hitbox	# endereco da imagem
	j CONT_RESET_VALUES_HITBOX

MAPA_3_GLOBAL_HITBOX:
	la s10,mapa3_hitbox	# endereco da imagem
	j CONT_RESET_VALUES_HITBOX

MAPA_4_GLOBAL_HITBOX:
	la s10,mapa4_hitbox	# endereco da imagem
	j CONT_RESET_VALUES_HITBOX

MAPA_5_GLOBAL_HITBOX:
	la s10,mapa5_hitbox	# endereco da imagem
	j CONT_RESET_VALUES_HITBOX

CONT_RESET_VALUES_HITBOX:
    jal IMPRIME_FASE		# imprime o mapa1

### FASE X ###
GAMELOOP_FASE:
	# Switch frame
	li t0,0xFF200604	# escolhe o frame 0 ou 1
	sw s11,0(t0)		# troca de frame

	not s11,s11		# inverte o frame atual

	jal IMPRIME_FASE

	# verifica se ele está pulando (s1)
	beqz s1 GRAVIDADE

	# decrementa o estado do pulo
	addi s1,s1,-1

	# esta pulando, verifica se e possivel subir
	# coordenadas atuais do jogador
	la t0,COORD_P1
	lw t1,0(t0)		# t1 = x
	lw t2,4(t0)		# t2 = y
	addi t2,t2,16	# olha o pixel acima dele

	mv t3,s10		# endereco da hitbox do mapa atual
	addi t3,t3,8 	# primeiro 8 pixels depois das informacoes de nlin ncol
	mv a2,t3		# copia endereco do mapa da hitbox

	li t5,240
	sub a0,t5,t2	# y = 240 - y
	
	li t5,320
	mul a1,a0,t5	# y * 320
	add a1,a1,t1	# a1 += x

	add t3,t3,a1	# parte da esquerda do sprite

	addi a1,a1,-16
	add a2,a2,a1	# parte da direita do sprite

	lw t4,0(t3)
	lw t6,0(a2)

	li t5,-1061109568	# azul
	beq t4,t5,NAO_SOBE	# eh azul = nao sobe
	beq t6,t5,NAO_SOBE	# eh azul = nao sobe

	# incrementa o y
	la t0,COORD_P1
	lw t2,4(t0)		# t2 = y
	addi t2,t2,1	# y++
	sw t2,4(t0)		# y = t2

	j CONT_GRAVIDADE

NAO_SOBE:
	li s1,0		# reseta estado do pulo

GRAVIDADE:	
	# verifica se ele pode cair (gravidade)

	# verifica se ele esta grudado numa parede
	
	# esquerda
	# coordenadas atuais do jogador
	la t0,COORD_P1
	lw t1,0(t0)		# t1 = x
	lw t2,4(t0)		# t2 = y
	addi t1,t1,-4	# olha o pixel esquerda

	mv t3,s10		# endereco da hitbox do mapa atual
	addi t3,t3,8 	# primeiro 8 pixels depois das informacoes de nlin ncol
	mv a2,t3		# copia endereco do mapa da hitbox

	li t5,240
	sub a0,t5,t2	# y = 240 - y
	
	li t5,320
	mul a1,a0,t5	# y * 320
	add a1,a1,t1	# a1 += x
	addi a1,a1,-16

	add t3,t3,a1	# parte de baixo_esquerda

	addi a1,a1,-5120	# y - 320 * 16
	add a2,a2,a1	# parte de cima_esquerda

	lw t4,0(t3)
	lw t6,0(a2)
	
	li s8,4	# parede da esquerda
	li t5,-1061158912	# preto
	beq t4,t5,RESETA_PULO	# eh preto = nao desce
	beq t6,t5,RESETA_PULO	# eh preto = nao desce
	li t5,-1061109568	# azul
	beq t4,t5,RESETA_PULO	# eh azul = nao sobe
	beq t6,t5,RESETA_PULO	# eh azul = nao sobe

	# direita
	# coordenadas atuais do jogador
	la t0,COORD_P1
	lw t1,0(t0)		# t1 = x
	lw t2,4(t0)		# t2 = y
	addi t1,t1,4	# olha o pixel direita

	mv t3,s10		# endereco da hitbox do mapa atual
	addi t3,t3,8 	# primeiro 8 pixels depois das informacoes de nlin ncol
	mv a2,t3		# copia endereco do mapa da hitbox

	li t5,240
	sub a0,t5,t2	# y = 240 - y
	
	li t5,320
	mul a1,a0,t5	# y * 320
	add a1,a1,t1	# a1 += x

	add t3,t3,a1	# parte de baixo_direita

	addi a1,a1,-5120	# y - 320 * 16
	add a2,a2,a1	# parte de cima_direita

	lw t4,0(t3)
	lw t6,0(a2)

	li s8,5		# parede da direita
	li t5,-1061109568	# azul
	beq t4,t5,RESETA_PULO	# eh azul = nao desce
	beq t6,t5,RESETA_PULO	# eh azul = nao desce
	li t5,-1061158912	# preto
	beq t4,t5,RESETA_PULO	# eh preto = nao desce
	beq t6,t5,RESETA_PULO	# eh preto = nao desce

	li s8,0		# parado

	# verifica se o pixel abaixo nao eh azul

	# coordenadas atuais do jogador
	la t0,COORD_P1
	lw t1,0(t0)		# t1 = x
	lw t2,4(t0)		# t2 = y
	addi t2,t2,-1	# olha o pixel abaixo dele

	mv t3,s10		# endereco da hitbox do mapa atual
	addi t3,t3,8 	# primeiro 8 pixels depois das informacoes de nlin ncol
	mv a2,t3		# copia endereco do mapa da hitbox

	li t5,240
	sub a0,t5,t2	# y = 240 - y
	
	li t5,320
	mul a1,a0,t5	# y * 320
	add a1,a1,t1	# a1 += x

	add t3,t3,a1	# parte da esquerda do sprite

	addi a1,a1,-16
	add a2,a2,a1	# parte da direita do sprite

	lw t4,0(t3)
	lw t6,0(a2)

	# DEBUG
	#mv a0,t4
	#li a7,1
	#ecall

	#li a7,11
	#li a0,10
	#ecall

	li t5,-1061109568	# azul
	beq t4,t5,RESETA_PULO	# eh azul = nao desce
	beq t6,t5,RESETA_PULO	# eh azul = nao desce
	
	sw t2,4(t0)		# y--

	j CONT_GRAVIDADE

RESETA_PULO:
	li s2,2		# reinicia os pulos (2 pulos)
	j CONT_GRAVIDADE

CONT_GRAVIDADE:
	# s8 = sprite do anteiror
	beqz s8,CONT_SEM_TROCAR_SPRITE
	mv s9,s8

CONT_SEM_TROCAR_SPRITE:
	# verifica se uma tecla foi pressionada
    li t1,0xFF200000	        # carrega o endereco de controle do KDMMIO
	lw t0,0(t1)		            # le bit de Controle Teclado
   	andi t0,t0,0x0001	        # mascara o bit menos significativo
   	beqz t0,CONT_GAMELOOP_FASE		# nao tem tecla pressionada
   	lw t2,4(t1)		            # le o valor da tecla

	# qual tecla
  	lw t2,4(t1)  			# le o valor da tecla tecla
	sw t2,12(t1)  			# escreve a tecla pressionada no display
	
	li t0,109	# m
	beq t2,t0,TROCA_MAPA

	li t0,97	# a
	beq t2,t0,ESQUERDA_FASE
	
	li t0,100	# d
	beq t2,t0,DIREITA_FASE

	li t0,119	# w
	beq t2,t0,PULO_FASE

	li t0,113	# q
	beq t2,t0,PULO_DIAGONAL_ESQUERDA_FASE

	li t0,101	# e
	beq t2,t0,PULO_DIAGONAL_DIREITA_FASE

	li t0,108	# l
	beq t2,t0,DASH_DIREITA_FASE

	li t0,106	# j
	beq t2,t0,DASH_ESQUERDA_FASE

	li t0,107	# k
	beq t2,t0,DASH_BAIXO_FASE

	li t0,111	# o
	beq t2,t0,DASH_DIAGONAL_DIREITA_FASE

	li t0,105	# i
	beq t2,t0,DASH_CIMA_FASE

	li t0,117	# u
	beq t2,t0,DASH_DIAGONAL_ESQUERDA_FASE
	
	li t0,98	# b (back = fase anterior)
	beq t2,t0,BACK_FASE

	li t0,110	# n (next = proxima fase)
	beq t2,t0,NEXT_FASE

	# nenhuma dessas letras
	j CONT_GAMELOOP_FASE

BACK_FASE:
	addi s4,s4,-1
	j RESET_VALUES

NEXT_FASE:
	addi s4,s4,1
	j RESET_VALUES

TROCA_MAPA:
	not s0,s0
	ret

PULO_DIAGONAL_ESQUERDA_FASE:
	blez s2,CONT_PULO_DIAGONAL_ESQUERDA_FASE #sai da funcao se nao puder pular mais
	addi s2,s2,-1
	# verifica se é possível
	# coordenadas atuais do jogador
	la t0,COORD_P1
	lw t1,0(t0)		# t1 = x
	lw t2,4(t0)		# t2 = y
	addi t1,t1,-2568	# olha o pixel esquerda  t1 = (8*320 + 8) = 2560

	la t3,mapa1_hitbox
	addi t3,t3,8 	# primeiro 8 pixels depois das informacoes de nlin ncol
	mv a2,t3		# copia endereco do mapa da hitbox

	li t5,240
	sub a0,t5,t2	# y = 240 - y
	
	li t5,320
	mul a1,a0,t5	# y * 320
	add a1,a1,t1	# a1 += x
	addi a1,a1,-16

	add t3,t3,a1	# parte de baixo_esquerda

	addi a1,a1,-5120	# y - 320 * 16
	add a2,a2,a1	# parte de cima_esquerda

	lw t4,0(t3)
	lw t6,0(a2)

	li t5,-1061109568	# azul
	beq t4,t5,CONT_PULO_DIAGONAL_ESQUERDA_FASE	# eh azul = nao desce
	beq t6,t5,CONT_PULO_DIAGONAL_ESQUERDA_FASE	# eh azul = nao desce

	sw t1,0(t0)		# t1 = x
CONT_PULO_DIAGONAL_ESQUERDA_FASE:
	ret

PULO_DIAGONAL_DIREITA_FASE:
	blez s2,CONT_PULO_DIAGONAL_DIREITA_FASE
	addi s2,s2,-1

	# verifica se é possível
	# coordenadas atuais do jogador
	la t0,COORD_P1
	lw t1,0(t0)		# t1 = x
	lw t2,4(t0)		# t2 = y
	addi t1,t1,-2552	# olha o pixel direita  t1 = (8*320 - 8) = (2560 - 8)

	la t3,mapa1_hitbox
	addi t3,t3,8 	# primeiro 8 pixels depois das informacoes de nlin ncol
	mv a2,t3		# copia endereco do mapa da hitbox

	li t5,240
	sub a0,t5,t2	# y = 240 - y
	
	li t5,320
	mul a1,a0,t5	# y * 320
	add a1,a1,t1	# a1 += x

	add t3,t3,a1	# parte de baixo_direita

	addi a1,a1,-5120	# y - 320 * 16
	add a2,a2,a1	# parte de cima_direita

	lw t4,0(t3)
	lw t6,0(a2)

	li t5,-1061109568	# azul
	beq t4,t5,CONT_PULO_DIAGONAL_DIREITA_FASE	# eh azul = nao desce
	beq t6,t5,CONT_PULO_DIAGONAL_DIREITA_FASE	# eh azul = nao desce

	sw t1,0(t0)		# t1 = x

CONT_PULO_DIAGONAL_DIREITA_FASE:
	ret

DASH_DIAGONAL_DIREITA_FASE:

CONT_DASH_DIAGONAL_DIREITA_FASE:
	ret

DASH_DIAGONAL_ESQUERDA_FASE:

CONT_DASH_DIAGONAL_ESQUERDA_FASE:
	ret

DASH_DIREITA_FASE:
	li s3,4 #Contador do dash
DASH_DIREITA_LOOP:
	blez s3,CONT_DASH_DIREITA_FASE
	addi,s3,s3,-1

	li s9,3	# walk1

	# verifica se é possível
	# coordenadas atuais do jogador
	la t0,COORD_P1
	lw t1,0(t0)		# t1 = x
	lw t2,4(t0)		# t2 = y
	addi t1,t1,4	# olha o pixel direita

	mv t3,s10		# endereco da hitbox do mapa atual
	addi t3,t3,8 	# primeiro 8 pixels depois das informacoes de nlin ncol
	mv a2,t3		# copia endereco do mapa da hitbox

	li t5,240
	sub a0,t5,t2	# y = 240 - y
	
	li t5,320
	mul a1,a0,t5	# y * 320
	add a1,a1,t1	# a1 += x

	add t3,t3,a1	# parte de baixo_direita

	addi a1,a1,-5120	# y - 320 * 16
	add a2,a2,a1	# parte de cima_direita

	lw t4,0(t3)
	lw t6,0(a2)

	li t5,-1061109568	# azul
	beq t4,t5,CONT_DIREITA_FASE	# eh azul = nao desce
	beq t6,t5,CONT_DIREITA_FASE	# eh azul = nao desce
	li t5,-1061158912	# preto
	beq t4,t5,CONT_DIREITA_FASE	# eh preto = nao desce
	beq t6,t5,CONT_DIREITA_FASE	# eh preto = nao desce

	sw t1,0(t0)		# t1 = x

	j DASH_DIREITA_LOOP
CONT_DASH_DIREITA_FASE:
	ret

DASH_ESQUERDA_FASE:
	li s3,4 #Contador do dash
DASH_ESQUERDA_LOOP:
	blez s3,CONT_DASH_ESQUERDA_FASE
	addi,s3,s3,-1

	li s9,2	# walk0

	# verifica se é possível
	# coordenadas atuais do jogador
	la t0,COORD_P1
	lw t1,0(t0)		# t1 = x
	lw t2,4(t0)		# t2 = y
	addi t1,t1,-4	# olha o pixel esquerda

	mv t3,s10		# endereco da hitbox do mapa atual
	addi t3,t3,8 	# primeiro 8 pixels depois das informacoes de nlin ncol
	mv a2,t3		# copia endereco do mapa da hitbox

	li t5,240
	sub a0,t5,t2	# y = 240 - y
	
	li t5,320
	mul a1,a0,t5	# y * 320
	add a1,a1,t1	# a1 += x
	addi a1,a1,-16

	add t3,t3,a1	# parte de baixo_esquerda

	addi a1,a1,-5120	# y - 320 * 16
	add a2,a2,a1	# parte de cima_esquerda

	lw t4,0(t3)
	lw t6,0(a2)

	li t5,-1061109568	# azul
	beq t4,t5,CONT_ESQUERDA_FASE	# eh azul = nao desce
	beq t6,t5,CONT_ESQUERDA_FASE	# eh azul = nao desce
	li t5,-1061158912	# preto
	beq t4,t5,CONT_ESQUERDA_FASE	# eh preto = nao desce
	beq t6,t5,CONT_ESQUERDA_FASE	# eh preto = nao desce


	sw t1,0(t0)		# t1 = x

	j DASH_ESQUERDA_LOOP
CONT_DASH_ESQUERDA_FASE:
	ret

DASH_BAIXO_FASE:

CONT_DASH_BAIXO_FASE:
	ret

DASH_CIMA_FASE:

CONT_DASH_CIMA_FASE:
	ret

ESQUERDA_FASE:
	li s9,2	# walk0

	# verifica se é possível
	# coordenadas atuais do jogador
	la t0,COORD_P1
	lw t1,0(t0)		# t1 = x
	lw t2,4(t0)		# t2 = y
	addi t1,t1,-4	# olha o pixel esquerda

	mv t3,s10		# endereco da hitbox do mapa atual
	addi t3,t3,8 	# primeiro 8 pixels depois das informacoes de nlin ncol
	mv a2,t3		# copia endereco do mapa da hitbox

	li t5,240
	sub a0,t5,t2	# y = 240 - y
	
	li t5,320
	mul a1,a0,t5	# y * 320
	add a1,a1,t1	# a1 += x
	addi a1,a1,-16

	add t3,t3,a1	# parte de baixo_esquerda

	addi a1,a1,-5120	# y - 320 * 16
	add a2,a2,a1	# parte de cima_esquerda

	lw t4,0(t3)
	lw t6,0(a2)

	li t5,-1061109568	# azul
	beq t4,t5,CONT_ESQUERDA_FASE	# eh azul = nao desce
	beq t6,t5,CONT_ESQUERDA_FASE	# eh azul = nao desce
	li t5,-1061158912	# preto
	beq t4,t5,CONT_ESQUERDA_FASE	# eh preto = nao desce
	beq t6,t5,CONT_ESQUERDA_FASE	# eh preto = nao desce


	sw t1,0(t0)		# t1 = x

CONT_ESQUERDA_FASE:
	ret

DIREITA_FASE:
	li s9,3	# walk1

	# verifica se é possível
	# coordenadas atuais do jogador
	la t0,COORD_P1
	lw t1,0(t0)		# t1 = x
	lw t2,4(t0)		# t2 = y
	addi t1,t1,4	# olha o pixel direita

	mv t3,s10		# endereco da hitbox do mapa atual
	addi t3,t3,8 	# primeiro 8 pixels depois das informacoes de nlin ncol
	mv a2,t3		# copia endereco do mapa da hitbox

	li t5,240
	sub a0,t5,t2	# y = 240 - y
	
	li t5,320
	mul a1,a0,t5	# y * 320
	add a1,a1,t1	# a1 += x

	add t3,t3,a1	# parte de baixo_direita

	addi a1,a1,-5120	# y - 320 * 16
	add a2,a2,a1	# parte de cima_direita

	lw t4,0(t3)
	lw t6,0(a2)

	li t5,-1061109568	# azul
	beq t4,t5,CONT_DIREITA_FASE	# eh azul = nao desce
	beq t6,t5,CONT_DIREITA_FASE	# eh azul = nao desce
	li t5,-1061158912	# preto
	beq t4,t5,CONT_DIREITA_FASE	# eh preto = nao desce
	beq t6,t5,CONT_DIREITA_FASE	# eh preto = nao desce

	sw t1,0(t0)		# t1 = x

CONT_DIREITA_FASE:
	ret

PULO_FASE:
	beqz s2,CONT_PULO_FASE	# verifica se pode pular
	li s1,ALTURA_PULO		# altura do pulo
	addi s2,s2,-1			# diminui um pulo
CONT_PULO_FASE:
	ret

CONT_GAMELOOP_FASE:
### MORTE ###
	# verifica se o pixel abaixo é vermelho (morte)

	# coordenadas atuais do jogador
	la t0,COORD_P1
	lw t1,0(t0)		# t1 = x
	lw t2,4(t0)		# t2 = y
	addi t2,t2,-1	# olha o pixel abaixo dele

	mv t3,s10		# endereco da hitbox do mapa atual
	addi t3,t3,8 	# primeiro 8 pixels depois das informacoes de nlin ncol
	mv a2,t3		# copia endereco do mapa da hitbox

	li t5,240
	sub a0,t5,t2	# y = 240 - y
	
	li t5,320
	mul a1,a0,t5	# y * 320
	add a1,a1,t1	# a1 += x

	add t3,t3,a1	# parte da esquerda do sprite

	addi a1,a1,-16
	add a2,a2,a1	# parte da direita do sprite

	lw t4,0(t3)
	lw t6,0(a2)

	li t5,117901063 # vermelho
	beq t4,t5,RESET_VALUES	# eh vermelho = reseta
	beq t6,t5,RESET_VALUES	# eh vermelho = reseta

	# não morreu

### VENCEU ###
	# verifica se ele passou de fase (pixel na altura é branco)

	# coordenadas atuais do jogador
	la t0,COORD_P1
	lw t1,0(t0)		# t1 = x
	lw t2,4(t0)		# t2 = y
	#addi t2,t2,-1	# olha o pixel abaixo dele (na altura nesse caso)

	mv t3,s10		# endereco da hitbox do mapa atual
	addi t3,t3,8 	# primeiro 8 pixels depois das informacoes de nlin ncol
	mv a2,t3		# copia endereco do mapa da hitbox

	li t5,240
	sub a0,t5,t2	# y = 240 - y
	
	li t5,320
	mul a1,a0,t5	# y * 320
	add a1,a1,t1	# a1 += x

	add t3,t3,a1	# parte da esquerda do sprite

	addi a1,a1,-16
	add a2,a2,a1	# parte da direita do sprite

	lw t4,0(t3)
	lw t6,0(a2)

	li t5,-1 # branco
	bne t4,t5,NAO_PASSA_FASE	# nao eh branco = nao passa de fase
	bne t6,t5,NAO_PASSA_FASE	# nao eh branco = nao passa de fase

	# passa para a proxima fase
	addi s4,s4,1	# proximo mapa
	j RESET_VALUES	# reinicia os valores

NAO_PASSA_FASE:
	# nao venceu

	# verifica se tem item
	beqz s5,CONT_ITEM	# 0 = nao tem item

	# verifica se consegue pegar o item

	# coordenadas atuais do jogador
	la t0,COORD_P1
	lw a1,0(t0)	# a3 = x
	lw a2,4(t0)	# a4 = y

	la t0,COORD_ITEM
	li t1,8
	mul t1,t1,s4	# mapa_atual * 2 (2 coord.) * 4 (1 word)
	add t0,t0,t1

	lw t1,0(t0)	# x do item 1
	lw t2,4(t0)	# y do item 1

	# -8 <= dist_manhattan <= 8
	sub t4,a1,t1
	sub t5,a2,t2

	li t3,-8
	blt t4,t3,IMPRIME_ITEM	# nao pega
	blt t5,t3,IMPRIME_ITEM	# nao pega
	li t3,8
	bgt t4,t3,IMPRIME_ITEM	# nao pega
	blt t5,t3,IMPRIME_ITEM	# nao pega

	addi s2,s2,1	# +1 pulo
	li s5,0			# peguei o item

	# som do item
	li a7,33	# MidiOutSync
	li a0,100
	ecall

	j CONT_ITEM

IMPRIME_ITEM:
	# imprime o item
	li t4,0xFF000000 # endereco inicial da memoria de video
	la a5,morango 	# carrega o sprite
	
	lw a1,4(a5)	# a1 = h (altura do sprite)
	lw a2,0(a5)	# a2 = w (largura do sprite)
	
	# coordenadas atuais do item
	la t0,COORD_ITEM
	li t1,8
	mul t1,t1,s4	# mapa_atual * 2 (2 coord.) * 4 (1 word)
	add t0,t0,t1
	
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
	
	sub t4,t4,t3	# memoria -= inicio (afinal pula a cada LOOP_I2, inclusive o primeiro)
	
	li t1,0 # i
	li t2,0 # j
	
	# escolhe o frame
	beqz s11,LOOP_I2	# frame 0
	li t0,0x00100000
	add t4,t4,t0		# frame 1
	
LOOP_I2:
	beq t1,a1,CONT_ITEM
	addi t1,t1,1 	# i++
	li t2,0			# j = 0
	
	add t4,t4,t3
	
LOOP_J2:
	beq t2,a2,LOOP_I2
	addi t2,t2,1	# j++
	
	lb t0,0(a5)
	
	li a0,0xFFFFFFC7		# cor magenta
	beq t0,a0,CONT_LOOP_I2	# se o pixel for magenta nao imprime nada

PRINT_IMG2:	sb t0,0(t4)
	
CONT_LOOP_I2:
	addi a5,a5,1	# sprite++
	addi t4,t4,1	# memoria++
	
	j LOOP_J2

CONT_ITEM:
	# imprime o player 1
	li t4,0xFF000000 # endereco inicial da memoria de video
	
	# s9 [0 - stop0, 1 - stop1, 2 - walk0, 3 - walk1, 4 - wall0, 5 - wall2]
	li t0,0
	beq s9,t0,SPRITE_STOP0
	li t0,1
	beq s9,t0,SPRITE_STOP1
	li t0,2
	beq s9,t0,SPRITE_WALK0
	li t0,3
	beq s9,t0,SPRITE_WALK1
	li t0,4
	beq s9,t0,SPRITE_WALL0
	li t0,5
	beq s9,t0,SPRITE_WALL1

SPRITE_STOP0:
	la a5,madeline_stop0 	# carrega o sprite
	j CONT_SPRITE_PLAYER1

SPRITE_STOP1:
	la a5,madeline_stop1 	# carrega o sprite
	j CONT_SPRITE_PLAYER1

SPRITE_WALK0:
	la a5,madeline_stop0 	# carrega o sprite
	j CONT_SPRITE_PLAYER1

SPRITE_WALK1:
	la a5,madeline_stop1 	# carrega o sprite
	j CONT_SPRITE_PLAYER1

SPRITE_WALL0:
	la a5,madeline_wall0 	# carrega o sprite
	j CONT_SPRITE_PLAYER1

SPRITE_WALL1:
	la a5,madeline_wall1 	# carrega o sprite
	j CONT_SPRITE_PLAYER1

CONT_SPRITE_PLAYER1:
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
	# verifica se eh a fase pra imprimir o inimigo
	li t0,FASE_INIMIGO
	bne s4,t0,EXIT_LOOP1

	# move o player 2
	li a7,42	# randIntRange
	li a0,1		# index of pseudorandom number generator
	li a1,10	# [0, a1]
	ecall

	# 90% de chance de não mover
	li t0,9
	blt a0,t0,CONT_PLAYER2	# nao move

	# move (verifica na mao ou testa a distancia manhattan incrementando pras 4 direcoes)

	la t0,COORD_P1
	lw t1,0(t0)	# t1 = x
	lw t2,4(t0)	# t2 = y

	la t0,COORD_P2
	lw t3,0(t0)	# a3 = x
	lw t4,4(t0)	# a4 = y

	# x_inimigo < x_player
	blt t3,t1,SOMA_X
	beq t3,t1,CONT_SOMA_X
	# subtrai X
	addi t3,t3,-4
	li s7,0	# orientacao = esquerda

	j CONT_SOMA_X

SOMA_X:
	addi t3,t3,4
	li s7,1	# orientacao = direita

CONT_SOMA_X:
	# y_inimigo < y_player
	blt t4,t2,SOMA_Y
	beq t4,t2,CONT_SOMA_Y
	# subtrai Y
	addi t4,t4,-2

	j CONT_SOMA_Y

SOMA_Y:
	addi t4,t4,2

CONT_SOMA_Y:
	# salva os valores das coordenadas do player 2
	la t0,COORD_P2	# armazena as coordenadas
	sw t3,0(t0)	# t3 = x
	sw t4,4(t0)	# t4 = y

	# ela matou a personagem? (-8 <= dist_manhattan <= 8)
	sub t1,t1,t3
	sub t2,t2,t4

	li t3,-8
	blt t1,t3,CONT_PLAYER2
	blt t2,t3,CONT_PLAYER2
	li t3,8
	bgt t1,t3,CONT_PLAYER2
	bgt t2,t3,CONT_PLAYER2

	# ela matou

	j RESET_VALUES

CONT_PLAYER2:
	# imprime o player 2
	li t4,0xFF000000 # endereco inicial da memoria de video
	
	la a5,inimigo_stop0 	# carrega o sprite
	beqz s7,CONT_ESCOLHA_PLAYER2
	la a5,inimigo_stop1 	# carrega o sprite

CONT_ESCOLHA_PLAYER2:
	lw a1,4(a5)	# a1 = h (altura do sprite)
	lw a2,0(a5)	# a2 = w (largura do sprite)
	
	# coordenadas atuais do inimigo
	la t0,COORD_P2
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
	
	sub t4,t4,t3	# memoria -= inicio (afinal pula a cada LOOP_I1, inclusive o primeiro)
	
	li t1,0 # i
	li t2,0 # j
	
	# escolhe o frame
	beqz s11,LOOP_I1	# frame 0
	li t0,0x00100000
	add t4,t4,t0		# frame 1
	
LOOP_I1:
	beq t1,a1,EXIT_LOOP1
	addi t1,t1,1 	# i++
	li t2,0		# j = 0
	
	add t4,t4,t3
	
LOOP_J1:
	beq t2,a2,LOOP_I1
	addi t2,t2,1	# j++
	
	lb t0,0(a5)
	
	li a0,0xFFFFFFC7		# cor magenta
	beq t0,a0,CONT_LOOP_I11	# se o pixel for magenta nao imprime nada

PRINT_IMG1:	sb t0,0(t4)
	
CONT_LOOP_I11:
	addi a5,a5,1	# sprite++
	addi t4,t4,1	# memoria++
	
	j LOOP_J1

EXIT_LOOP1:
	# SLEEP
	li a7,32
	li a0,10
	ecall

	j GAMELOOP_FASE

# imprime a tela do mapa1
IMPRIME_FASE:
	li t1,0xFF000000	# endereco inicial da memoria VGA - Frame 0
	li t2,0xFF012C00	# endereco final da memoria VGA - Frame 0
	
	# escolhe o frame
	beqz s11,CONT_ESCOLHA		# frame 0
	li t0,0x00100000
	add t1,t1,t0	# frame 1
	add t2,t2,t0	# frame 1

CONT_ESCOLHA:
	beqz s0,IMPRIME_FASE_HITBOX
	
	li t0,0
	beq s4,t0,MAPA_1_BACKGROUND
	li t0,1
	beq s4,t0,MAPA_2_BACKGROUND
	li t0,2
	beq s4,t0,MAPA_3_BACKGROUND
	li t0,3
	beq s4,t0,MAPA_4_BACKGROUND
	li t0,4
	beq s4,t0,MAPA_5_BACKGROUND

	#j CONT_IMPRIME_FASE_HITBOX

MAPA_1_BACKGROUND:
	la t0,mapa1_background	# endereco da imagem
	j CONT_IMPRIME_FASE_HITBOX

MAPA_2_BACKGROUND:
	la t0,mapa2_background	# endereco da imagem
	j CONT_IMPRIME_FASE_HITBOX

MAPA_3_BACKGROUND:
	la t0,mapa3_background	# endereco da imagem
	j CONT_IMPRIME_FASE_HITBOX

MAPA_4_BACKGROUND:
	la t0,mapa4_background	# endereco da imagem
	j CONT_IMPRIME_FASE_HITBOX

MAPA_5_BACKGROUND:
	la t0,mapa5_background	# endereco da imagem
	j CONT_IMPRIME_FASE_HITBOX

IMPRIME_FASE_HITBOX:
	li t0,0
	beq s4,t0,MAPA_1_HITBOX
	li t0,1
	beq s4,t0,MAPA_2_HITBOX
	li t0,2
	beq s4,t0,MAPA_3_HITBOX
	li t0,3
	beq s4,t0,MAPA_4_HITBOX
	li t0,4
	beq s4,t0,MAPA_5_HITBOX

MAPA_1_HITBOX:
	la t0,mapa1_hitbox	# endereco da imagem
	j CONT_IMPRIME_FASE_HITBOX

MAPA_2_HITBOX:
	la t0,mapa2_hitbox	# endereco da imagem
	j CONT_IMPRIME_FASE_HITBOX

MAPA_3_HITBOX:
	la t0,mapa3_hitbox	# endereco da imagem
	j CONT_IMPRIME_FASE_HITBOX

MAPA_4_HITBOX:
	la t0,mapa4_hitbox	# endereco da imagem
	j CONT_IMPRIME_FASE_HITBOX

MAPA_5_HITBOX:
	la t0,mapa5_hitbox	# endereco da imagem
	j CONT_IMPRIME_FASE_HITBOX

CONT_IMPRIME_FASE_HITBOX:
	addi t1,t1,8		# primeiro pixel depois das informacoes de nlin ncol

LOOP_IMPRIME_FASE: 	
	beq t1,t2,CONT_IMPRIME_FASE		# se for o ultimo endereco entao sai do loop
	lw t3,0(t0)		# le um conjunto de 4 pixels (word)
	sw t3,0(t1)		# escreve a word na memoria VGA
	addi t1,t1,4	# soma 4 ao endereco da memoria
	addi t0,t0,4	# soma 4 ao endereco da imagem
	j LOOP_IMPRIME_FASE

CONT_IMPRIME_FASE:
    ret
