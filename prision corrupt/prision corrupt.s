.data
.include "sprites/map.s"
.include "sprites/posTitle.s"
.include "sprites/score00.s"
.include "sprites/ataque1edit.s"
.include "Sprites/policialPadrao.s"
.include "Sprites/grade.s"
.include "Sprites/policialAtaque.s"
.include "Sprites/presoPadrao.s"
.include "Sprites/presoAtaque.s"

presos:
.space 100

fase:
.word 1

lista_selecionados:
.space 20



CHAR_POS:	.half 56,192	# x, y
OLD_CHAR_POS:	.half 56,192
PRES0_POS:      .half 232,140			# x, y

.text
SETUP:		la a0,map			# carrega o endereco do sprite 'map' em a0
		li a1,0				# x = 0
		li a2,0				# y = 0
		li a3,0				# frame = 0
		call PRINT			# imprime o sprite
		li a3,1				# frame = 1
		call PRINT			# imprime o sprite
		# esse setup serve pra desenhar o "mapa" nos dois frames antes do "jogo" comecar
		
ESPACO:
        	call KEY2                  
        	li t0, ' '                 
        	li t1, 0xFF200000          
        	lw t2, 4(t1)               
        	beq t2, t0, SETUP2      
        	j ESPACO #fica esperando caso não seja pressionado
        	
		
SETUP2:		la a0,posTitle			# carrega o endereco do sprite 'map' em a0
		li a1,0				# x = 0
		li a2,0				# y = 0
		li a3,0				# frame = 0
		call PRINT			# imprime o sprite
		li a3,1				# frame = 1
		call PRINT			# imprime o sprite
		# esse setup serve para desenhar o mapa depois da 
SETUP3:		la a0, score00			# carrega o endereco do sprite 'map' em a0
		li a1,0				# x = 0
		li a2,0				# y = 0
		li a3,0				# frame = 0
		call PRINT			# imprime o sprite
		li a3,1				# frame = 1
		call PRINT
		
		
		la t0, lista_selecionados
		addi t1, t0, 20
		
		FILL_LOOP:
		bgeu t0, t1, OUT_FILL_LOOP
		li t2, -1
		sb t2, 0(t0)
		addi t0, t0, 1
		j FILL_LOOP
		OUT_FILL_LOOP:
		
		
		li a7, 30
		ecall
		mv a1, a0
		li a0, 0
		li a7, 40
		ecall
		
		la t0, lista_selecionados
		la t2, fase
		la t4, presos
		addi, t1, t0, 3
		add, t1, t1,t2
		
		SET_PRESO_POS_LOOP:
		bgeu t0, t1, OUT_SET_PRESO_POS_LOOP
		
		li a0, 0
		li a1, 19
		li a7, 42
		ecall
		
		mv s1, a0
		
		la t3, lista_selecionados
		SET_PRESO_POS_LOOP_LOOP:
		bgeu t3, t1, OUT_SET_PRESO_POS_LOOP_LOOP
		
		lw t4, 0(t3)
		
		beq t4,s1, SET_PRESO_POS_LOOP
		addi t3, t3, 1
		j SET_PRESO_POS_LOOP_LOOP
		
		OUT_SET_PRESO_POS_LOOP_LOOP:
		
		sb s1, 0(t0)
		sb s1, 0(t4)
		addi t0, t0, 1
		addi t4, t4, 2
		
		OUT_SET_PRESO_POS_LOOP:
		
		
		
		

GAME_LOOP:	call KEY2			# chama o procedimento de entrada do teclado
		
		xori s0,s0,1	
		
		la t0,PRES0_POS			# carrega em t0 o endereco de CHAR_POS
		
		la a0,presoPadrao		# carrega o endereco do sprite 'char' em a0
		lh a1,0(t0)			# carrega a posicao x do personagem em a1
		lh a2,2(t0)			# carrega a posicao y do personagem em a2
		mv a3,s0			# carrega o valor do frame em a3
		call PRINT				# inverte o valor frame atual (somente o registrador)
		
		la t0,CHAR_POS			# carrega em t0 o endereco de CHAR_POS
		
		la a0,policialPadrao		# carrega o endereco do sprite 'char' em a0
		lh a1,0(t0)			# carrega a posicao x do personagem em a1
		lh a2,2(t0)			# carrega a posicao y do personagem em a2
		mv a3,s0			# carrega o valor do frame em a3
		call PRINT			# imprime o sprite
		
		li t0,0xFF200604		# carrega em t0 o endereco de troca de frame
		sw s0,0(t0)			# mostra o sprite pronto para o usuario
		
		#####################################
		# Limpeza do "rastro" do personagem #
		#####################################
		la t0,OLD_CHAR_POS		# carrega em t0 o endereco de OLD_CHAR_POS
		
		la a0,grade			# carrega o endereco do sprite 'tile' em a0
		lh a1,0(t0)			# carrega a posicao x antiga do personagem em a1
		lh a2,2(t0)			# carrega a posicao y antiga do personagem em a2
		
		mv a3,s0			# carrega o frame atual (que esta na tela em a3)
		xori a3,a3,1			# inverte a3 (0 vira 1, 1 vira 0)
		call PRINT			# imprime

		j GAME_LOOP			# continua o loop

KEY2:		li t1,0xFF200000		# carrega o endereco de controle do KDMMIO
		lw t0,0(t1)			# Le bit de Controle Teclado
		andi t0,t0,0x0001		# mascara o bit menos significativo
   		beq t0,zero,FIM   	   	# Se nao ha tecla pressionada entao vai para FIM
  		lw t2,4(t1)  			# le o valor da tecla tecla
		
		li t0,'w'
		beq t2,t0,CHAR_CIMA		# se tecla pressionada for 'w', chama CHAR_CIMA
		
		li t0,'a'
		beq t2,t0,CHAR_ESQ		# se tecla pressionada for 'a', chama CHAR_CIMA
		
		li t0,'s'
		beq t2,t0,CHAR_BAIXO		# se tecla pressionada for 's', chama CHAR_CIMA
		
		li t0,'d'
		beq t2,t0,CHAR_DIR		# se tecla pressionada for 'd', chama CHAR_CIMA
	
		li t0,'f'
		beq t2,t0,ATAQUE
		
		
FIM:		ret				# retorna

CHAR_ESQ:	la t0,CHAR_POS			# carrega em t0 o endereco de CHAR_POS
		la t1,OLD_CHAR_POS		# carrega em t1 o endereco de OLD_CHAR_POS
		lw t2,0(t0)
		sw t2,0(t1)			# salva a posicao atual do personagem em OLD_CHAR_POS
		
		lh t1,0(t0)			# carrega o x atual do personagem
		li t3, 88
		blt t1,t3, END
		addi t1,t1,-44		# decrementa 16 pixeis
		sh t1,0(t0)			# salva
		ret

CHAR_DIR:	la t0,CHAR_POS			# carrega em t0 o endereco de CHAR_POS
		la t1,OLD_CHAR_POS		# carrega em t1 o endereco de OLD_CHAR_POS
		lw t2,0(t0)
		sw t2,0(t1)			# salva a posicao atual do personagem em OLD_CHAR_POS
		
		la t0,CHAR_POS
		lh t1,0(t0)			# carrega o x atual do personagem
		li t3, 230
		bgt t1,t3, END
		addi t1,t1,44			# incrementa 16 pixeis
		sh t1,0(t0)			# salva
		ret

CHAR_CIMA:	la t0,CHAR_POS			# carrega em t0 o endereco de CHAR_POS
		la t1,OLD_CHAR_POS		# carrega em t1 o endereco de OLD_CHAR_POS
		lw t2,0(t0)
		sw t2,0(t1)			# salva a posicao atual do personagem em OLD_CHAR_POS
		
		la t0,CHAR_POS
		lh t1,2(t0)			# carrega o y atual do personagem
		li t3, 60
		blt t1,t3, END
		addi t1,t1,-52			# decrementa 16 pixeis
		sh t1,2(t0)			# salva
		ret

CHAR_BAIXO:	la t0,CHAR_POS			# carrega em t0 o endereco de CHAR_POS
		la t1,OLD_CHAR_POS		# carrega em t1 o endereco de OLD_CHAR_POS
		lw t2,0(t0)
		sw t2,0(t1)			# salva a posicao atual do personagem em OLD_CHAR_POS
		
		la t0,CHAR_POS
		lh t1,2(t0)		# carrega o y atual do personagem
		li t3, 180
		bgt t1,t3, END		#impede que o personagem va demai para baixo
		addi t1,t1,52  	# incrementa 16 pixeis
		sh t1,2(t0)			# salva
		ret
		
ATAQUE:		la t0,CHAR_POS			# carrega em t0 o endereco de CHAR_POS
		la t1,OLD_CHAR_POS		# carrega em t1 o endereco de OLD_CHAR_POS
		lw t2,0(t0)
		sw t2,0(t1)			# salva a posicao atual do personagem em OLD_CHAR_POS
		
		la t0,CHAR_POS
		lh t1,2(t0)		# carrega o y atual do personagem
		sh t1,2(t0)
		
				# carrega o endereco do sprite 'char' em a0
		lh a1,0(t0)			# carrega a posicao x do personagem em a1
		lh a2,2(t0)			# carrega a posicao y do personagem em a2
		mv a3,s0
		la a0,grade			# carrega o valor do frame em a3
		call PRINT	
		la a0,policialAtaque		# carrega o endereco do sprite 'char' em a0			# carrega o valor do frame em a3
		call PRINT
		li a0, 150
		li a7, 32
		ecall
		
		la a0,grade			# carrega o valor do frame em a3
		call PRINT
		
		
		
		j GAME_LOOP		
		ret

		
END: ret		
		

#################################################
#	a0 = endereço imagem			#
#	a1 = x					#
#	a2 = y					#
#	a3 = frame (0 ou 1)			#
#################################################
#	t0 = endereco do bitmap display		#
#	t1 = endereco da imagem			#
#	t2 = contador de linha			#
# 	t3 = contador de coluna			#
#	t4 = largura				#
#	t5 = altura				#
#################################################

PRINT:		li t0,0xFF0			# carrega 0xFF0 em t0
		add t0,t0,a3			# adiciona o frame ao FF0 (se o frame for 1 vira FF1, se for 0 fica FF0)
		slli t0,t0,20			# shift de 20 bits pra esquerda (0xFF0 vira 0xFF000000, 0xFF1 vira 0xFF100000)
		
		add t0,t0,a1			# adiciona x ao t0
		
		li t1,320			# t1 = 320
		mul t1,t1,a2			# t1 = 320 * y
		add t0,t0,t1			# adiciona t1 ao t0
		
		addi t1,a0,8			# t1 = a0 + 8
		
		mv t2,zero			# zera t2
		mv t3,zero			# zera t3
		
		lw t4,0(a0)			# carrega a largura em t4
		lw t5,4(a0)			# carrega a altura em t5
		
PRINT_LINHA:	lw t6,0(t1)			# carrega em t6 uma word (4 pixeis) da imagem
		sw t6,0(t0)			# imprime no bitmap a word (4 pixeis) da imagem
		
		addi t0,t0,4			# incrementa endereco do bitmap
		addi t1,t1,4			# incrementa endereco da imagem
		
		addi t3,t3,4			# incrementa contador de coluna
		blt t3,t4,PRINT_LINHA		# se contador da coluna < largura, continue imprimindo

		addi t0,t0,320			# t0 += 320
		sub t0,t0,t4			# t0 -= largura da imagem
		# ^ isso serve pra "pular" de linha no bitmap display
		
		mv t3,zero			# zera t3 (contador de coluna)
		addi t2,t2,1			# incrementa contador de linha
		bgt t5,t2,PRINT_LINHA		# se altura > contador de linha, continue imprimindo
		
		ret				# retorna


