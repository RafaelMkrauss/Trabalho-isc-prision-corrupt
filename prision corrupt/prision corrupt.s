.data
.include "sprites/map.s"
.include "sprites/posTitle.s"
.include "sprites/score00.s"
.include "sprites/ataque1edit.s"
.include "sprites/floorCompleted.s"
.include "Sprites/policialPadrao.s"
.include "Sprites/grade.s"
.include "Sprites/policialAtaque.s"
.include "Sprites/presoPadrao.s"
.include "Sprites/presoAtaque.s"
.include "sprites/menu.s"
.include "sprites/instructions.s"
.include "sprites/screenCheats.s"
.include "Sprites/presoDano.s"
.include "Sprites/presoMorte.s"
.include "Sprites/policialMorte.s"
.include "Sprites/gameOver.s"
.include "Sprites/PolicialDano.s"
.include "Sprites/balaNormal.s"
var: .word 0
Music_config: 	.word 109,0,1,60  #notas total, nota atual, instrumento, volume	
Notas: 		.word 60,104,60,104,61,104,60,104,64,104,60,104,61,104,60,104,67,834,60,104,65,104,64,104,62,104,64,104,65,104,71,104,69,104,67,834,60,104,65,104,64,104,62,104,64,104,65,104,71,104,69,104,67,417,65,417,67,625,65,104,64,104,62,417,65,417,67,208,65,104,67,521,65,208,64,104,65,208,59,104,60,104,62,104,64,208,62,104,64,312,60,208,62,208,60,104,61,312,62,208,64,312,62,312,60,1042,60,834,61,834,60,104,60,104,61,104,60,104,64,104,60,104,61,104,60,104,67,834,60,104,65,104,64,104,62,104,64,104,65,104,71,104,69,104,67,834,60,104,65,104,64,104,62,104,64,104,65,104,71,104,69,104,67,417,65,417,67,312,65,312,64,208,62,417,65,417,67,208,65,104,67,1042,62,104,64,104,65,104,67,208,65,104,67,312,65,208,64,417,62,417,64,312,62,312,60,417,60,208,64,208,69,834,67,104,66,104,67,834
presos:
.space 20

policial:
.byte 15

fase:
.byte 0

vida:
.byte 4   #vida do personagem(arrumar melhor depois)

cont_mov:
.byte 0

lista_selecionados:
.space 20

espacos_dano:
.space 20


CHAR_POS:	.half 56,192			# x, y
OLD_CHAR_POS:	.half 56,192
PRES0_POS:      .half 232,140			# x, y

# Bullet data
bullet_pos:
.half 56, 36  # x, y positions of the bullet

bala:
.byte 0

old_bullet_pos:
.half 56, 36  # x, y positions of the bullet

bullet_active:
.byte 0  # 0 = inactive, 1 = active

bullet_speed:
.byte 52  # Speed of the bullet (pixels per frame)

.data
bullet_timer:   .word 0     # Initialize the timer to 0
TICKS_PER_SEC:  .word 10000  # Assuming 1 tick = 1 ms (adjust as needed)

.text
INICIO:
RESET_VARIAVEIS:
    # Reinicializa a vida do personagem
    la t0, vida
    li t1, 4
    sb t1, 0(t0)

    # Reinicializa o contador de movimentos
    la t0, cont_mov
    li t1, 0
    sb t1, 0(t0)

    # Reinicializa a posição do policial
    la t0, policial
    li t1, 15
    sb t1, 0(t0)

    # Reinicializa a fase
    la t0, fase
    li t1, 0
    sb t1, 0(t0)

    # Reinicializa a lista de selecionados
    la t0, lista_selecionados
    li t1, 20
    li t2, 0
    

    
FILL_LISTA_LOOP2:
    beqz t1, OUT_FILL_LISTA_LOOP2
    sb t2, 0(t0)
    addi t0, t0, 1
    addi t1, t1, -1
    j FILL_LISTA_LOOP2
OUT_FILL_LISTA_LOOP2:

    # Reinicializa os espaços de dano
    la t0, espacos_dano
    li t1, 20
    li t2, 0
FILL_DANO_LOOP3:
    beqz t1, OUT_FILL_DANO_LOOP3
    sb t2, 0(t0)
    addi t0, t0, 1
    addi t1, t1, -1
    j FILL_DANO_LOOP3
OUT_FILL_DANO_LOOP3:

    # Reinicializa a posição do personagem
    la t0, CHAR_POS
    li t1, 56
    sh t1, 0(t0)
    li t1, 192
    sh t1, 2(t0)

    # Reinicializa a posição antiga do personagem
    la t0, OLD_CHAR_POS
    li t1, 56
    sh t1, 0(t0)
    li t1, 192
    sh t1, 2(t0)
    
     # Initialize bullet
    la t0, bullet_pos
    li t1, 56
    sh t1, 0(t0)  # x = 56
    li t1, 36
    sh t1, 2(t0)  # y = 36
    
     la t0, old_bullet_pos
    li t1, 56
    sh t1, 0(t0)  # x = 56
    li t1, 36
    sh t1, 2(t0)  # y = 36


    la t0, bullet_active
    sb t1, 0(t0)  # bullet_active = 0
    
SETUP:		la a0,map			# carrega o endereco do sprite 'map' em a0
		li a1,0				# x = 0
		li a2,0				# y = 0
		li a3,0				# frame = 0
		call PRINT			# imprime o sprite
		li a3,1				# frame = 1
		call PRINT			# imprime o sprite
						# esse setup serve pra desenhar o "mapa" nos dois frames antes do "jogo" comecar
					
ESPACO:
        	call KEY2LOCK                  
        	li t0, ' '                 
        	li t1, 0xFF200000          
        	lw t2, 4(t1)               
        	beq t2, t0, MENU     
        	j ESPACO #fica esperando caso nÃ£o seja pressionado
        	
MENU: 		la a0,menu			# carrega o endereco do sprite 'map' em a0
		li a1,0				# x = 0
		li a2,0				# y = 0
		li a3,0				# frame = 0
		call PRINT			# imprime o sprite
		li a3,1				# frame = 1
		call PRINT			# imprime o sprite
						# esse setup serve pra desenhar o "mapa" nos dois frames antes do "jogo" comecar
		
PLAY:		call KEY2LOCK                  
        	li t0, '1'                 
        	li t1, 0xFF200000          
        	lw t2, 4(t1)               
        	beq t2, t0, SETUP2
        	
INSTRUCTIONS:	call KEY2LOCK                  
        	li t0, '2'                 
        	li t1, 0xFF200000          
        	lw t2, 4(t1)               
        	beq t2, t0, SCREEN_INSTRUCTIONS
        	j PLAY				 
						 
SCREEN_INSTRUCTIONS: 
		
		la a0,instructions		# carrega o endereco do sprite 'map' em a0
		li a1,0				# x = 0
		li a2,0				# y = 0
		li a3,0				# frame = 0
		call PRINT			# imprime o sprite
		li a3,1				# frame = 1
		call PRINT			# imprime o sprite
						        					        	      	
JUMP_CHEATS: 	call KEY2LOCK                  
        	li t0, ' '                 
        	li t1, 0xFF200000          
        	lw t2, 4(t1)               
        	beq t2, t0,SCREEN_CHEATS
        	j JUMP_CHEATS
        	
SCREEN_CHEATS:  la a0,screenCheats		# carrega o endereco do sprite 'map' em a0
		li a1,0				# x = 0
		li a2,0				# y = 0
		li a3,0				# frame = 0
		call PRINT			# imprime o sprite
		li a3,1				# frame = 1
		call PRINT			# imprime o sprite
		
RETURN_MENU:	call KEY2LOCK                  
        	li t0, ' '                 
        	li t1, 0xFF200000          
        	lw t2, 4(t1)               
        	beq t2, t0,MENU
        	j RETURN_MENU
        	j MENU		      	      	
        	     	
								
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
		
#acessa o array e carrega o numero 20 nele		
		la t0, lista_selecionados
		addi t1, t0, 20
		
FILL_LOOP:
		bgeu t0, t1, OUT_FILL_LOOP
		li t2, 0
		sb t2, 0(t0)
		addi t0, t0, 1
		j FILL_LOOP
		
OUT_FILL_LOOP:

li t0, 0
li t1, 0
li t2, 0
#acessa o array e carrega o numero 20 nele
	la t0, espacos_dano
		addi t1, t0, 20
		
FILL_DANO_LOOP:
		bgeu t0, t1, OUT_FILL_DANO_LOOP
		li t2, 0
		sb t2, 0(t0)
		addi t0, t0, 1
		j FILL_DANO_LOOP
		
OUT_FILL_DANO_LOOP:
		
   # Inicializações
li a7, 30
ecall
mv a1, a0
li a0, 1
li a7, 40
ecall

# Ponteiros para as listas e fase
la t0, lista_selecionados
la t2, fase
la t4, presos

# Carrega a fase atual
lb t6, 0(t2)

# Define o limite para o loop externo
addi t1, t0, 3
add t1, t1, t6

SET_PRESO_POS_LOOP:
    # Verifica o fim do loop externo
    bgeu t0, t1, OUT_SET_PRESO_POS_LOOP

    # Gera um número aleatório entre 0 e 19
    li a0, 1
    li a1, 19
    li a7, 42
    ecall
    mv s1, a0  # Salva o número aleatório em s1

    la t3, lista_selecionados  # Reinicia t3 para percorrer lista_selecionados

SET_PRESO_POS_LOOP_LOOP:
    # Verifica o fim do loop interno
    bgeu t3, t1, OUT_SET_PRESO_POS_LOOP_LOOP

    # Carrega um valor da lista de selecionados
    lb t5, 0(t3)
    
    # Se valor já existe, reinicia o loop externo
    beq t5, s1, SET_PRESO_POS_LOOP
    
    # Incrementa t3
    addi t3, t3, 1
    j SET_PRESO_POS_LOOP_LOOP

OUT_SET_PRESO_POS_LOOP_LOOP:
    # Armazena o número selecionado em presos
    sb s1, 0(t0)
    # Incrementa o ponteiro de presos
    addi t0, t0, 1

    # Marca como "vivo"
    li t5, 1
    sb t5, 0(t4)
    # Avança o ponteiro
    addi t4, t4, 1

    # Volta ao início do loop externo
    j SET_PRESO_POS_LOOP

OUT_SET_PRESO_POS_LOOP:
    # Finalização do código
		

GAME_LOOP:  
    call KEY2                   # Chama o procedimento de entrada do teclado
    xori s0, s0, 1              # XOR para alternar s0 entre 0 e 1
    
    
    addi sp, sp, -20
    sw a0, 0(sp)
    sw s0, 4(sp)
    sw a3, 8(sp)
    sw t0, 12(sp)
    sw a1, 16(sp)
    sw a2, 20(sp)
    
   
   mv a3, s0                      # Valor do frame em a3
    
    la t0,CHAR_POS			# carrega em t0 o endereco de CHAR_POS
		
		lh a1,0(t0)			# carrega a posicao x do personagem em a1
		lh a2,2(t0)
     
     
    la a0, grade
    call PRINT
    
    la t0,bullet_pos			# carrega em t0 o endereco de CHAR_POS
		
		lh a1,0(t0)			# carrega a posicao x do personagem em a1
		lh a2,2(t0)
     
     
    la a0, grade
    call PRINT
    
    la t0,old_bullet_pos			# carrega em t0 o endereco de CHAR_POS
		
		lh a1,0(t0)			# carrega a posicao x do personagem em a1
		lh a2,2(t0)
     
     
    la a0, grade
    call PRINT
    
  
    lw a0, 0(sp)
    lw s0, 4(sp)
    lw a3, 8(sp)
    lw t0, 12(sp)
    lw a1, 16(sp)
    lw a2, 20(sp)
    addi sp, sp, 20
    
    
    # Carregar endereços base
    la a4, presos                  # Endereço base da lista 'presos'
    la a5, fase                    # Endereço da variável 'fase'
    la s11, lista_selecionados     # Endereço base de 'lista_selecionados'
    la s5, cont_mov                # Endereço base de 'cont_mov'
    
    # Calcular limite para o loop
    lb a5, 0(a5)                   # Carrega o valor em 'fase'
    addi a5, a5, 3                 # Soma 3 ao valor de 'fase'
    add a5, a5, a4                 # Limite do loop (a4 + fase + 3)
    lb s5, 0(s5)                   # Carrega o valor de 'cont_mov'
    
SPAWN_PRESOS_LOOP:
    # Verifica se a4 >= a5 para sair do loop
    bgeu a4, a5, OUT_SPAWN_PRESOS_LOOP
    
    lb a6, 0(a4)                   # Carrega o valor atual da lista 'presos'
    li a7, 1                       # Valor a comparar
    
    blt a6, a7, SPAWN_PRESOS_NOT1  # Se for menor que 1, pula
    
    # Carregar valores de 'lista_selecionados'
    lb s10, 0(s11)                 # Carrega o valor de 'lista_selecionados'
    
    # Configurar sprite 'presoPadrao'
    li s9, 5
    div s8, s10, s9                # s8 = lista_selecionados / 5
    li s7, 52
    mul s6, s8, s7                 # s6 = (s8 * 52)
    addi s6, s6, 36                # Ajuste em X
    mv a2, s6                      # Valor de X em a2
    
    rem s8, s10, s9                # s8 = lista_selecionados % 5
    li s7, 44
    mul s6, s8, s7                 # s6 = (s8 * 44)
    addi s6, s6, 56                # Ajuste em Y
    mv a1, s6                      # Valor de Y em a1
    
    # Configurar frame
    mv a3, s0                      # Valor do frame em a3
    li a7, 3

    blt a6, a7, VIVO
    la a0, presoMorte
    li a7, -1
    sb a7, 0(a4)
    call PRINT                     # Chamar função PRINT
    
    la a0, policialAtaque
    call PRINT
    
    li a0, 150
    li a7, 32
    ecall
     
    j MORTO
    
VIVO:
    li a7, 3
    rem s4, s5, a7
    beq s5, zero, NAO_ATACANDO
    bne s4, zero, NAO_ATACANDO
    la a0,grade
    call PRINT
    la a0, presoAtaque
    call PRINT
    
    
    j ATACANDO
    
NAO_ATACANDO:
    la a0,grade
    call PRINT	
    la a0, presoPadrao 
    call PRINT                     # Chamar função PRINT
     
MORTO:
ATACANDO:

SPAWN_PRESOS_NOT1:
    addi a4, a4, 1                 # Incrementa o ponteiro de 'presos'
    addi s11, s11, 1               # Incrementa o ponteiro de 'lista_selecionados'
    j SPAWN_PRESOS_LOOP            # Volta para o início do loop

OUT_SPAWN_PRESOS_LOOP:
    # Zerando os registradores para evitar conflitos
    li a4, 0
    li a5, 0
    li a6, 0
    li a7, 0
    li s8, 0
    li s9, 0
    li s10, 0
    li s11, 0
    li s6, 0
    li s7, 0
   
    

    # Fim do loop

   # Increment the timer
    la   t4, bullet_timer  # Load address of bullet_timer
    lw   t5, 0(t4)         # Load current timer value
    addi t5, t5, 1         # Increment timer by 1 tick
    sw   t5, 0(t4)         # Store new timer value

    la   t6, TICKS_PER_SEC # Load address of TICKS_PER_SEC
    lw   t6, 0(t6)         # Load tick threshold (1000)
    blt  t5, t6, SKIP_UPDATE  # If timer < 1000, skip bullet update

    # Otherwise, one second has passed – reset the timer:
    li   t5, 0
    sw   t5, 0(t4)
    
    # Now update bullet position:
    la   t0, bullet_active
    lb   t1, 0(t0)
    beqz t1, BULLET_INACTIVE  # If bullet is inactive, skip
    
        la t0,bullet_pos		# carrega em t0 o endereco de bullet_pos
	la t1,old_bullet_pos		# carrega em t1 o endereco de old_bullet_pos
	lw t2,0(t0)
	sw t2,0(t1)

    la   t0, bullet_pos
    lh   t1, 2(t0)         # Load y position
    la   t2, bullet_speed
    lb   t3, 0(t2)         # Load bullet speed
    add  t1, t1, t3        # Update y position
    sh   t1, 2(t0)         # Save new y position


    # Check if bullet is out of bounds
    li t2, 240  # Assuming the screen height is 240 pixels
    bge t1, t2, DEACTIVATE_BULLET

SKIP_UPDATE:
    # Check for collision with player
    la t0, bullet_pos
    lh t1, 0(t0)  # Load x position
    lh t2, 2(t0)  # Load y position

    la t3, CHAR_POS
    lh t4, 0(t3)  # Load player x position
    lh t5, 2(t3)  # Load player y position
    
    bne t1, t4, NO_COLLISION

  
    bne t2, t5, NO_COLLISION

    # Collision detected, damage player
    
    la t0, bala
    lb t1, 0(t0)
    bnez t1, NO_BULLET_DMG
    
    li t1, 1
    sb t1, 0(t0)
    
    la t0, vida
    lb t1, 0(t0)
    addi t1, t1, -1
    sb t1, 0(t0)
    
    j PLAY_SOUND
   
    NO_BULLET_DMG:
    
    j DEACTIVATE_BULLET
    
    

NO_COLLISION:
    # Reprint the bullet
    
    
    
    
    la a0, balaNormal  # Load bullet sprite
    lh a1, 0(t0)  # x position
    lh a2, 2(t0)  # y position
    
    call PRINT
    
    la t0, bala
    li t1, 0
    sb t1,0(t0)

    j BULLET_ACTIVE

DEACTIVATE_BULLET:
    la t0, bullet_active
    li t1, 0
    sb t1, 0(t0)  # Deactivate bullet

BULLET_INACTIVE:
    # Randomly spawn a new bullet
    li a0, 1
    li a1, 2  # 1 in 8 chance to spawn a bullet
    li a7, 42
    ecall
    bnez a0, BULLET_ACTIVE

    # Spawn bullet at a random x position
    li a0, 1
    li a1, 5  # 5 possible columns
    li a7, 42
    ecall
    li t1, 44
    mul t1, t1, a0
    addi t1, t1, 56  # Adjust x position

    la t0, bullet_pos
    sh t1, 0(t0)  # Set x position
    li t1, 36
    sh t1, 2(t0)  # Set y position

    la t0, bullet_active
    li t1, 1
    sb t1, 0(t0)  # Activate bullet
    
    

BULLET_ACTIVE:

		
   
					
		
		la t0,CHAR_POS			# carrega em t0 o endereco de CHAR_POS
		
		la a4, vida
		lb a4, 0(a4)
		
		
		lh a1,0(t0)			# carrega a posicao x do personagem em a1
		lh a2,2(t0)			# carrega a posicao y do personagem em a2
		mv a3,s0
		
		ble a4, zero, JOGADOR_MORTO
		
		la a0,policialPadrao		# carrega o endereco do sprite 'char' em a0
		call PRINT			# imprime o sprite
		j JOGADOR_VIVO
		JOGADOR_MORTO:
		
		
		
		
		la a0, policialMorte
		call PRINT
		xori s0,s0,1
		mv a3, s0  
		call PRINT
		xori s0,s0,1
		mv a3, s0
		
		
		
		li t0,0xFF200604		# carrega em t0 o endereco de troca de frame
		sw s0,0(t0)			# mostra o sprite pronto para o usuario
		
		#####################################
		# Limpeza do "rastro" do personagem #
		#####################################
		la t0,OLD_CHAR_POS		# carrega em t0 o endereco de OLD_CHAR_POS
		
		la a0,grade			# carrega o endereco do sprite 'tile' em a0
		lh a1,0(t0)			# carrega a posicao x antiga do personagem em a1
		lh a2,2(t0)			# carrega a posicao y antiga do personagem em a2
		
		mv a3,s0	
				# carrega o frame atual (que esta na tela em a3)
					# inverte a3 (0 vira 1, 1 vira 0)
		call PRINT			# imprime
		

		li a0, 1000
		li a7, 32
		ecall
    		
		j GAME_OVER
		
		JOGADOR_VIVO:
		
		
		
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
		call TocarMusica
		j GAME_LOOP			# continua o loop
		
KEY2LOCK:	li t1,0xFF200000		# carrega o endereco de controle do KDMMIO
		lw t0,0(t1)			# Le bit de Controle Teclado
		andi t0,t0,0x0001		# mascara o bit menos significativo
   		beq t0,zero,FIM_KEY2LOCK   	   	# Se nao ha tecla pressionada entao vai para FIM
  		lw t2,4(t1)	
FIM_KEY2LOCK: ret    			

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

FIM: 		ret
				
		
CHEATS: 	call KEY2                  
        	li t0, 'x'                 
        	li t1, 0xFF200000          
        	lw t2, 4(t1)               
        	beq t2, t0, CHEAT1
        	j CHEATS 			#fica esperando caso nao seja pressionado
        	
CHEAT1:		la a0,floorCompleted		# carrega o endereco do sprite 'floorCompleted' em a0
		li a1,0				# x = 0
		li a2,0				# y = 0
		li a3,0				# frame = 0
		call PRINT			# imprime o sprite
		li a3,1				# frame = 1
		call PRINT			# imprime o sprite
						# esse setup serve pra desenhar o "mapa" nos dois frames antes do "jogo" comecar
		
		# condiÃ§Ã£o para que a tela de fase concluÃ­da sÃ³ seja pulada caso o espaco seja pressionado								
ESPERA: 	call KEY2                  
        	li t0, ' '                 
        	li t1, 0xFF200000          
        	lw t2, 4(t1)               
        	beq t2, t0, CHEAT2      
        	j ESPERA 			# fica esperando caso nÃ£o seja pressionado
        	
CHEAT2:		la a0,score00			# carrega o endereco do sprite 'score00' em a0
		li a1,0				# x = 0
		li a2,0				# y = 0
		li a3,0				# frame = 0
		call PRINT			# imprime o sprite
		li a3,1				# frame = 1
		call PRINT			# imprime o sprite
		j SETUP2			# pula para o setup 2 e recomeÃ§a a fase
		
	ret				# retorna

CHAR_ESQ:	la t0,CHAR_POS			# carrega em t0 o endereco de CHAR_POS
		la t1,OLD_CHAR_POS		# carrega em t1 o endereco de OLD_CHAR_POS
		lw t2,0(t0)
		sw t2,0(t1)			# salva a posicao atual do personagem em OLD_CHAR_POS
		
		lh t1,0(t0)			# carrega o x atual do personagem
		li t3, 88
		blt t1,t3, END
		addi t1,t1,-44		# decrementa 16 pixeis
		sh t1,0(t0)			# salva
		
		la t3, cont_mov
		lb t1,0(t3)
		addi t1, t1, 1
		sb t1, 0(t3)
		
		la t3, policial
		lb t1,0(t3)
		addi t1, t1, -1
		sb t1, 0(t3)
		
		call TOMAR_DANO
		
		j GAME_LOOP
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
		
		la t3, cont_mov
		lb t1,0(t3)
		addi t1, t1, 1
		sb t1, 0(t3)
		
		la t3, policial
		lb t1,0(t3)
		addi t1, t1, 1
		sb t1, 0(t3)
		
		call TOMAR_DANO
		
		j GAME_LOOP
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
		
		la t3, cont_mov
		lb t1,0(t3)
		addi t1, t1, 1
		sb t1, 0(t3)
		
		la t3, policial
		lb t1,0(t3)
		addi t1, t1, -5
		sb t1, 0(t3)
		
		call TOMAR_DANO
		
		j GAME_LOOP
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
		sh t1,2(t0)
		
		la t3, cont_mov
		lb t1,0(t3)
		addi t1, t1, 1
		sb t1, 0(t3)
		
		la t3, policial
		lb t1,0(t3)
		addi t1, t1, 5
		sb t1, 0(t3)	
		
		call TOMAR_DANO	
					
		j GAME_LOOP									# salva
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
		
# Carregar endereços base
la a4, presos                  # Endereço base da lista 'presos'
la a5, fase                    # Endereço da variável 'fase'
la s11, lista_selecionados     # Endereço base de 'lista_selecionados'

# Calcular limite para o loop
lb a5, 0(a5)                   # Carrega o valor em 'fase'
addi a5, a5, 3                 # Soma 3 ao valor de 'fase'
add a5, a5, a4                 # Limite do loop (a4 + fase + 3)

PRESOS_DMG_LOOP:
    # Verifica se a4 >= a5 para sair do loop
    bgeu a4, a5, OUT_PRESOS_DMG_LOOP

    lb a6, 0(a4)                   # Carrega o valor atual da lista 'presos'
    li a7, 1                       # Valor a comparar

    blt  a6, a7, PRESOS_DMG_NOT  # Se for menor que 1, pula

    # Carregar valores de 'lista_selecionados'
    lb s10, 0(s11)                 # Carrega o valor de 'lista_selecionados'

    # Configurar sprite 'presoDano'
    la a0, presoDano           # Endereço do sprite
    li s9, 5

    div s8, s10, s9                # s8 = lista_selecionados / 5
    li s7, 52
    mul s6, s8, s7                 # s6 = (s8 * 52)
    addi s6, s6, 36                # Ajuste em X
                       
    bne s6, a2, PRESOS_DMG_NOT                   

    rem s8, s10, s9                # s8 = lista_selecionados % 5
    li s7, 44
    mul s6, s8, s7                 # s6 = (s8 * 44)
    addi s6, s6, 56                # Ajuste em Y
    
    bne s6, a1, PRESOS_DMG_NOT
    
    #aumenta o dano no prisioneiro
    beq a6, a7, IGUAL1
    li s7, 3
    sb s7, 0(a4)
    j DIFERENTE1
    IGUAL1:
    li s7, 2
    sb s7, 0(a4)
    DIFERENTE1:
    

    # Configurar frame
    
    mv a3, s0                      # Valor do frame em a3
    call PRINT                     # Chamar função PRINT
    xori s0,s0,1
    
    addi sp, sp, -16
    sw a0, 0(sp)
    sw a1, 4(sp)
    sw a2, 8(sp)
    sw a3, 12(sp)
    sw a7, 16(sp)
    
    		  li a0, 50          # Nota musical 
   		  li a1, 500         # Duração do som em milissegundos
    		  li a2, 32          # Instrumento (32 = guitarra, por exemplo)
  		  li a3, 127         # Volume (127 = máximo)
  		  li a7, 31          # Syscall para tocar som
  		  ecall
  		  
    lw a0, 0(sp)
    lw a1, 4(sp)
    lw a2, 8(sp)
    lw a3, 12(sp)
    lw a7, 16(sp)
    addi sp, sp, 16

PRESOS_DMG_NOT:
    addi a4, a4, 1                 # Incrementa o ponteiro de 'presos'
    addi s11, s11, 1               # Incrementa o ponteiro de 'lista_selecionados'
    j PRESOS_DMG_LOOP            # Volta para o início do loop

OUT_PRESOS_DMG_LOOP:
    # Zerando os registradores para evitar conflitos
    li a4, 0
    li a5, 0
    li a6, 0
    li a7, 0
    li s8, 0
    li s9, 0
    li s10, 0
    li s11, 0
    li s6, 0
    li s7, 0
   
   
   
    

    # Fim do loop

		
				
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
	


TOMAR_DANO:
    # Save registers that will be modified
    addi sp, sp, -32
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)
    sw s5, 24(sp)
    sw s6, 28(sp)

    # Load cont_mov and calculate remainder
    la s5, cont_mov
    lb s5, 0(s5)
    li s1, 3
    rem s2, s5, s1

    # Check if the player should take damage
    bne s2, zero, SEM_PRIS_DANO
    li s1, 1
    j COM_PRIS_DANO
SEM_PRIS_DANO:
    li s1, 0
COM_PRIS_DANO:

# --- Nova lógica: marcar as grades perigosas com base nos prisioneiros ativos ---
    # Primeiro, zera o array espacos_dano para não ter marcas residuais
    la s7, espacos_dano       # base do array
    li s6, 20                 # quantidade de bytes
ZERAR_ESPACOS:
    beqz s6, MARCA_DANO_INI
    li t0, 0
    sb t0, 0(s7)
    addi s7, s7, 1
    addi s6, s6, -1
    j ZERAR_ESPACOS
    MARCA_DANO_INI:

# Marcação dos espaços de dano pelos prisioneiros
la s3, presos             # ponteiro para estados dos prisioneiros
la s4, lista_selecionados # ponteiro para as grades dos prisioneiros
li s7, 20                 # quantidade de prisioneiros

MARCA_DANO_LOOP:
    beqz s7, VERIFICA_DANO   # fim do loop se s7 == 0
    lb s2, 0(s3)             # estado do prisioneiro
    ble s2, zero, PROX_PRISIONEIRO  # se não ativo, pula

    lb s8, 0(s4)             # grade do prisioneiro
    la t0, espacos_dano      # base do array espacos_dano
    add t0, t0, s8           # desloca até a grade indicada
                    # marca com 1
    sb s1, 0(t0)

PROX_PRISIONEIRO:
    addi s3, s3, 1           # próximo prisioneiro (estado)
    addi s4, s4, 1           # próximo índice em lista_selecionados
    addi s7, s7, -1          # decrementa o contador
    j MARCA_DANO_LOOP

VERIFICA_DANO:
    # Verifica se o policial está em um espaço marcado
    la t2, policial    # endereço da variável policial
    lb t3, 0(t2)       # t3 ? índice da grade do policial
    la t0, espacos_dano
    add t0, t0, t3     # acesso à posição correspondente
    lb t4, 0(t0)      # valor na grade

    beq t4, zero, SEM_JOGADOR_DMG  # se zero, não há perigo

    # Aplica dano:
    la t5, vida
    lb t6, 0(t5)
    addi t6, t6, -1   # diminui a vida
    sb t6, 0(t5)
     j PLAY_SOUND


SEM_JOGADOR_DMG:
    # Restore saved registers
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    lw s5, 24(sp)
    lw s6, 28(sp)
    addi sp, sp, 32
    li t0, 0

    ret
    
    
    GAME_OVER:
    		la a0,gameOver			# carrega o endereco do sprite 'map' em a0
		li a1,0				# x = 0
		li a2,0				# y = 0
		li a3,0				# frame = 0
		call PRINT			# imprime o sprite
		li a3,1				# frame = 1
		call PRINT
		
		  li a0, 60          # Nota musical 
   		  li a1, 500         # Duração do som em milissegundos
    		  li a2, 32          # Instrumento (32 = guitarra, por exemplo)
  		  li a3, 127         # Volume (127 = máximo)
  		  li a7, 31          # Syscall para tocar som
  		  ecall
		
	GAME_OVER_LOOP:		
		call KEY2LOCK                  
        	li t0, ' '                 
        	li t1, 0xFF200000          
        	lw t2, 4(t1)               
        	beq t2, t0, INICIO
    
    j GAME_OVER_LOOP

#################################################
#	a0 = endereÃ§o imagem			#
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
		
		
		

PLAY_SOUND:
    li a0, 72          # Nota musical (72 = C5, por exemplo)
    li a1, 500         # Duração do som em milissegundos
    li a2, 32          # Instrumento (32 = guitarra, por exemplo)
    li a3, 127         # Volume (127 = máximo)
    li a7, 31          # Syscall para tocar som
    ecall
    ret
#parte internacional
TocarMusica:
					#s11 eh o contador de tempo
li a7,30					#coloca o horario atual em a0
ecall						#função não recebe entrada
 If_TM:						#apenas toca a proxima nota de Notas
 	la t0,var
 	lw t0,0(t0)
 	bltu a0,t0, Fim_If_TM
	la t2,Music_config
 	lw t0, 0(t2)
 	lw t1, 4(t2)
 	lw a2, 8(t2)
 	lw a3, 12(t2)
	If_TM1:
		bne t0,t1, Fim_If_TM1	# contador chegou no final? entÃƒÂ£o  vÃƒÂ¡ para SET_SONG para zerar o contador e as notas (loop infinito)
		sw zero, 4(t2)
		li t1, 0
	Fim_If_TM1:
	la t4, Notas
	li t3,8
	mul t1, t1,t3
	add t4,t4,t1
	lw a0,0(t4)		# le o valor da nota
	lw a1,4(t4)		# le a duracao da nota
	li a7,31		# define a chamada de syscall
	ecall			# toca a nota
	
	li a7,30		# coloca o horario atual em a0
	ecall
	
	lw t4, 4(t4)
	add a0,a0,t4
	la t0,var
	sw a0,0(t0)
	lw t6, 4(t2)
	addi t6,t6,1
	sw t6,4(t2)		# incrementa o contador de notas
Fim_If_TM:

ret
