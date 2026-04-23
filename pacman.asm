; ------- TABELA DE CORES -------
; adicione ao caracter para Selecionar a cor correspondente

; 0 branco							0000 0000
; 256 marrom						0001 0000
; 512 verde							0010 0000
; 768 oliva							0011 0000
; 1024 azul marinho					0100 0000
; 1280 roxo							0101 0000
; 1536 teal							0110 0000
; 1792 prata						0111 0000
; 2048 cinza						1000 0000
; 2304 vermelho						1001 0000
; 2560 lima							1010 0000
; 2816 amarelo						1011 0000
; 3072 azul							1100 0000
; 3328 rosa							1101 0000
; 3584 aqua							1110 0000
; 3840 preto						1111 0000

pre_main:

;--- ZERA O MAPA DE RASTRO ---
    loadn r0, #0
    loadn r1, #mapaRastro
    loadn r2, #1200
loop_zera_rastro:
    storei r1, r0
    inc r1
    dec r2
    jnz loop_zera_rastro
    ; ----------------------------

    loadn r0, #0 ; numero para zerar a pontuacao
    store pontuacao, r0 ; zera a pontuação na memoria

    loadn r1, #tela4Linha0  ; Carrega a tela de pause
    loadn r0, #0 
    call ImprimeTela2
    loadn r2, #32 ;numero ascii do espaço
    loadn r3, #255 ; Valor de nenhuma tecla no simulador
    call loop_de_espera 
    loadn r0, #51 ;numero 3 na tabela ascii
    store vidas, r0 ; guarda o numero 0 de pontuacao na memoria
    loadn r1, #posInicialFans
    loadn r0, #545        ; Posição inicial Fan 1
    storei r1, r0
    inc r1
    loadn r0, #548        ; Posição inicial Fan 2
    storei r1, r0
    inc r1
    loadn r0, #538        ; Posição inicial Fan 3
    storei r1, r0
    inc r1
    loadn r0, #541        ; Posição inicial Fan 4
    storei r1, r0

main:

; --- Inicializa Fantasmas ---
    loadn r0, #600
    store posPacman, r0   ; Pac-man começa no 600

    loadn r1, #posFans    ; Endereço do vetor de posições
    loadn r0, #545        ; Posição inicial Fan 1
    storei r1, r0
    inc r1
    loadn r0, #548        ; Posição inicial Fan 2
    storei r1, r0
    inc r1
    loadn r0, #538        ; Posição inicial Fan 3
    storei r1, r0
    inc r1
    loadn r0, #541        ; Posição inicial Fan 4
    storei r1, r0

    loadn r1, #coresFans  ; Endereço do vetor de cores
    loadn r0, #1280       ; roxo ;ok
    storei r1, r0
    inc r1
    loadn r0, #3328       ; Rosa
    storei r1, r0
    inc r1
    loadn r0, #768       ; oliva ;ok
    storei r1, r0
    inc r1
    loadn r0, #3584       ; Aqua ;nao
    storei r1, r0
    
   loadn r0, #0
    store atrasoFans, r0

    loadn r1, #tela1Linha0 ;enderço do vetor que contem a mensagem
    loadn r0, #0 ; posição na tela que a mensagem será escrita

    call ImprimeTela

;coloca as vidas e a pontuacao na tela

    load r0, vidas
    loadn r2, #11  ;vai colocar na posicao 11 da tela
    loadn r3, #2816 ;A cor das letras
    add r0,r0,r3
    outchar r0, r2

;------- precisa acabar de desenhar o cenario ------ 

    ; 2. Configura o Pac-Man 
    loadn r0, #600     ; Começa no meio da tela
    loadn r2, #'C'     
    loadn r3, #' '     ; Espaço para apagar rastro
    loadn r4, #2816       ; Cor amarela
    add r2, r2, r4
    add r3, r3, r4
    loadn r6, #1 ; começa andando pra direita
    call loop_andar     ; Inicia o jogo

loop_de_espera:
    inchar r0   ;le o teclado
    cmp r0,r3 ;compara com 255
    jeq loop_de_espera ;se for igual continua no loop
    cmp r0,r2 ; compara com 32(espaço)
    jne loop_de_espera ;se for diferente continua no loop
    rts

loop_andar:

; --- 1. Gerencia Timer do Power (Rápido e Seguro) ---
    load r5, flagPower
    loadn r4, #0            
    cmp r5, r4              
    jeq Segue_Loop          
    
    load r5, timerPower
    dec r5
    store timerPower, r5
    
    loadn r4, #0            
    cmp r5, r4              
    jnz Segue_Loop          
    
    store flagPower, r4     ; Se chegou em 0, desativa o poder

Segue_Loop:

    call delay
    outchar r3, r0                       ; desenha o pacman
    store posPacman, r0
    inchar r7          ; Lê teclado

    loadn r5, #'d' 
    cmp r5, r7
    jeq set_dir_direita

    loadn r5, #'a'
    cmp r5, r7
    jeq set_dir_esquerda

    loadn r5, #'s'
    cmp r5, r7
    jeq set_dir_baixo

    loadn r5, #'w'
    cmp r5, r7
    jeq set_dir_cima

    loadn r5, #'z'
    cmp r5, r7
    jeq pause

    jmp mover

; ================= DIREÇÃO =================

set_dir_direita:
    loadn r6, #1
    jmp mover

set_dir_esquerda:
    loadn r6, #2
    jmp mover

set_dir_baixo:
    loadn r6, #3
    jmp mover

set_dir_cima:
    loadn r6, #4
    jmp mover

mover:
    loadn r5, #1
    cmp r5,r6
    jeq mov_direita

    loadn r5, #2
    cmp r5,r6
    jeq mov_esquerda

    loadn r5, #3
    cmp r5,r6
    jeq mov_baixo

    loadn r5, #4
    cmp r5,r6
    jeq mov_cima

    jmp loop_andar

mov_direita:
    loadn r5, #1        
    call ChecaColisao   
    loadn r7, #0
    cmp r5, r7
    jeq finaliza_mov      
          
    inc r0
    jmp finaliza_mov

mov_esquerda:
    loadn r5, #1        ; Usa valor positivo
    call ChecaColisaoEsquerdaCima ; Sub-rotina especial para subtração
    loadn r7, #0
    cmp r5, r7
    jeq finaliza_mov
    
    dec r0
    jmp finaliza_mov 

mov_baixo:
    loadn r5, #40       
    call ChecaColisao   
    loadn r7, #0
    cmp r5, r7
    jeq finaliza_mov
    
    loadn r5, #40
    add r0, r0, r5
    jmp finaliza_mov

mov_cima:
    loadn r5, #40       ; Usa valor positivo
    call ChecaColisaoEsquerdaCima ; Sub-rotina especial para subtração
    loadn r7, #0
    cmp r5, r7
    jeq finaliza_mov
    
    loadn r5, #40
    sub r0, r0, r5
    jmp finaliza_mov

finaliza_mov:
; --- LOGICA DE RASTRO (PAC-MAN DEIXA CHEIRO) ---
    push r0
    push r1
    push r2
    loadn r1, #mapaRastro
    add r1, r1, r0         ; r0 tem a posição do Pac-Man
    loadn r2, #100         ; Intensidade do rastro
    storei r1, r2
    pop r2
    pop r1
    pop r0
    ; ----------------------------------------------
;desenha o pacman na posição nova
    outchar r2, r0 ; apaga o pacman
    call MoveFantasmas
    jmp loop_andar

pause:
    push r0
    push r1
    push r2
    push r3
    push r4
    push r5
    push r6
    push r7

    loadn r1, #tela2Linha0  ; Carrega a tela de pause
    loadn r0, #0 
    call ImprimeTela2

    loadn r3, #'y'          ; Tecla para voltar (Yes)
    loadn r4, #'n'          ; Tecla para sair (No)

loop_espera:
    inchar r2               ; Lê o teclado
    
    loadn r5, #255          ; No simulador, 255 geralmente significa "nenhuma tecla"
    cmp r2, r5
    jeq loop_espera         ; Se não apertou nada, volta e lê de novo (trava aqui)

    cmp r2, r3
    jeq sai_pause           ; Se apertou 'y', sai da sub-rotina e volta pro jogo

    cmp r2, r4
    jeq antes_pre_main      ; Se apertou 'n', vai para o halt (fim de jogo)
    
    jmp loop_espera         ; Se apertou qualquer outra tecla, continua travado

sai_pause:
    ; Antes de voltar, precisamos redesenhar a tela do jogo original
    loadn r1, #tela1Linha0
    loadn r0, #0
    call ImprimeTela

    pop r7
    pop r6
    pop r5
    pop r4
    pop r3
    pop r2
    pop r1
    pop r0
    jmp main

game_over:
    push r0
    push r1
    push r2
    push r3
    push r4
    push r5
    push r6
    push r7

    loadn r1, #tela3Linha0 ;enderço do vetor que contem a mensagem
    loadn r0, #0 ; posição na tela que a mensagem será escrita

    call ImprimeTela2

    loadn r5, #pontuacao_final
    loadi r6, r5
    loadn r7, #348
    outchar r6,r7
    inc r5

    loadi r6, r5
    loadn r7, #349
    outchar r6,r7
    inc r5

    loadi r6, r5
    loadn r7, #350
    outchar r6,r7

    loadn r2, #32 ;numero ascii do espaço
    loadn r3, #255 ; Valor de "nenhuma tecla" no simulador

    call loop_de_espera 

    pop r7
    pop r6
    pop r5
    pop r4
    pop r3
    pop r2
    pop r1
    pop r0

    jmp antes_pre_main

venceu_jogo:

    push r0
    push r1
    push r2
    push r3
    push r4
    push r5
    push r6
    push r7

    loadn r1, #tela5Linha0 ;enderço do vetor que contem a mensagem
    loadn r0, #0 ; posição na tela que a mensagem será escrita

    call ImprimeTela2

    loadn r5, #pontuacao_final
    loadi r6, r5
    loadn r7, #348
    outchar r6,r7
    inc r5

    loadi r6, r5
    loadn r7, #349
    outchar r6,r7
    inc r5

    loadi r6, r5
    loadn r7, #350
    outchar r6,r7

    loadn r2, #32 ;numero ascii do espaço
    loadn r3, #255 ; Valor de "nenhuma tecla" no simulador

    call loop_de_espera 

    pop r7
    pop r6
    pop r5
    pop r4
    pop r3
    pop r2
    pop r1
    pop r0

    jmp antes_pre_main

; --- sub rotinas ---

; ------ delay para o personagem nao andar tao rapido

delay:
    push r0
    push r1
    loadn r0, #1150
loop_externo:
    loadn r1, #1150
loop_interno:
    dec r1
    jnz loop_interno
    dec r0
    jnz loop_externo
    pop r1
    pop r0
    rts

;********************************************************
;                       IMPRIME TELA
;********************************************************	

ImprimeTela: 	;  Rotina de Impresao de Cenario na Tela Inteira
		;  r1 = endereco onde comeca a primeira linha do Cenario
		;  r2 = cor do Cenario para ser impresso

	push fr		; Protege o registrador de flags
	push r0	; protege o r3 na pilha para ser usado na subrotina
	push r1	; protege o r1 na pilha para preservar seu valor
	push r2	; protege o r1 na pilha para preservar seu valor
	push r3	; protege o r3 na pilha para ser usado na subrotina
	push r4	; protege o r4 na pilha para ser usado na subrotina
	push r5	; protege o r4 na pilha para ser usado na subrotina

	loadn R0, #0  	; posicao inicial tem que ser o comeco da tela!
	loadn R2, #0 ; cor dos outros caracteres sao brancas
        loadn R3, #40  	; Incremento da posicao da tela!
	loadn R4, #41  	; incremento do ponteiro das linhas da tela
	loadn R5, #1200 ; Limite da tela!
	
   ImprimeTela_Loop:
		call ImprimeStr
		add r0, r0, r3  	; incrementaposicao para a segunda linha na tela -->  r0 = R0 + 40
		add r1, r1, r4  	; incrementa o ponteiro para o comeco da proxima linha na memoria (40 + 1 porcausa do /0 !!) --> r1 = r1 + 41
		cmp r0, r5		; Compara r0 com 1200
		jne ImprimeTela_Loop	; Enquanto r0 < 1200

		pop r5	; Resgata os valores dos registradores utilizados na Subrotina da Pilha
		pop r4
		pop r3
		pop r2
		pop r1
		pop r0
		pop fr
		rts

;---------------------------	
;********************************************************
;                   IMPRIME STRING
;********************************************************
	
;********************************************************
;               IMPRIME STRING COM CORES ESPECÍFICAS
;********************************************************

ImprimeStr:     
        push fr         
        push r0 
        push r1 
        push r2 
        push r3 
        push r4 
        push r5 ; Registrador auxiliar para a cor

        loadn r3, #'\0' 

   ImprimeStr_Loop:     
                loadi r4, r1
                cmp r4, r3
                jeq ImprimeStr_Sai
                
                ; --- Lógica de Seleção de Cor ---
                
                ; Verifica se é '-'
                loadn r5, #'-'
                cmp r4, r5
                jeq Cor_AzulMarinho
                
                ; Verifica se é '|'
                loadn r5, #'|'
                cmp r4, r5
                jeq Cor_AzulMarinho
		
		; Verifica se é '_'
		loadn r5, #'_'
		cmp r4, r5
		jeq Cor_AzulMarinho
                
                ; Verifica se é '.'
                loadn r5, #'.'
                cmp r4, r5
                jeq Cor_Amarelo
                
		; Verifica se é '*'
		loadn r5, #'*'
		cmp r4, r5
		jeq Cor_Vermelha                

                ; Se não for nenhum dos acima, usa a cor padrão (r2)
                mov r5, r2
                jmp Print_Char

   Cor_AzulMarinho:
                loadn r5, #1024  ; Valor para Azul Marinho
                jmp Print_Char

   Cor_Amarelo:
                loadn r5, #2816  ; Valor para Amarelo
                jmp Print_Char
   
   Cor_Vermelha:
		loadn r5, #2304  ; Valor para Vermelho
                jmp Print_Char

   Print_Char:
                add r4, r5, r4   ; Combina a cor escolhida com o caractere ASCII
                outchar r4, r0
                inc r0
                inc r1
                jmp ImprimeStr_Loop

   ImprimeStr_Sai:      
        pop r5
        pop r4  
        pop r3
        pop r2
        pop r1
        pop r0
        pop fr
        rts

; Declara e preenche tela linha por linha (40 caracteres):
tela1Linha0  : string "|----vidas: ------SCORE:     ----------|"
tela1Linha1  : string "|. |_______|    | |  |---____ .  ___  .|"
tela1Linha2  : string "|. |  |. . |    | |  |. |    | .|   | .|"
tela1Linha3  : string "|*  --     ------  -- . ------  ----- .|"
tela1Linha4  : string "|. . . . . . . .  . . . . . . . . . . .|"
tela1Linha5  : string "|. ---------   ---------- . ---------  |"
tela1Linha6  : string "|. |       | . |---  ---| . |       |  |"
tela1Linha7  : string "|. --------- . |  |  |  | . ---------  |"
tela1Linha8  : string "| . . . . . .  |--|  |--| . . . . . .  |"
tela1Linha9  : string "|-----. . .  .  .  .  .  .  .  .  -----|"
tela1Linha10 : string "|   ||. ------  -------  ------. ||    |"
tela1Linha11 : string "|   ||. |    |  |     |  |    |. ||    |"
tela1Linha12 : string "|   ||. ------  -------  ------  ||    |"
tela1Linha13 : string "|-----. . . . . . . . . . . . .   -----|"
tela1Linha14 : string "      .   .     |---  ---|  . .  . . .  "
tela1Linha15 : string "      .   .     |        |  .   .       "
tela1Linha16 : string "|-----  . . . . |________|  . . . -----|"
tela1Linha17 : string "|    || . . .  ___     ___  .  . ||    |"
tela1Linha18 : string "|    || . . .  | |  *  | |  .  . ||    |"
tela1Linha19 : string "|    ||  ---   ---     ---  ---  ||    |"
tela1Linha20 : string "|----- . | | . . . . . . .  | | . -----|"
tela1Linha21 : string "| . . .  ---  ----------  . --- .  *   |"
tela1Linha22 : string "|-----  .   . |        |  . . . . -----|"
tela1Linha23 : string "|  ___  . . . |        |  .     . ___  |"
tela1Linha24 : string "|  . . . |--| ---------- . |--| .      |"
tela1Linha25 : string "|  .     |  |   .  .  .  . |  | . . . .|"
tela1Linha26 : string "|  . ----|  |----  . . ----|  |----   .|"
tela1Linha27 : string "|  . . . . . . . . . . . . . . . . . . |"
tela1Linha28 : string "|  . _____________________   *        .|"
tela1Linha29 : string "|----|toque z para pausar|-------------|"



; Declara e preenche tela linha por linha (40 caracteres):
tela1Linha0mestre  : string "|----vidas: ------SCORE:     ----------|"
tela1Linha1mestre  : string "|. |_______|    | |  |---____ .  ___  .|"
tela1Linha2mestre  : string "|. |  |. . |    | |  |. |    | .|   | .|"
tela1Linha3mestre  : string "|*  --     ------  -- . ------  ----- .|"
tela1Linha4mestre  : string "|. . . . . . . .  . . . . . . . . . . .|"
tela1Linha5mestre  : string "|. ---------   ---------- . ---------  |"
tela1Linha6mestre  : string "|. |       | . |---  ---| . |       |  |"
tela1Linha7mestre  : string "|. --------- . |  |  |  | . ---------  |"
tela1Linha8mestre  : string "| . . . . . .  |--|  |--| . . . . . .  |"
tela1Linha9mestre  : string "|-----. . .  .  .  .  .  .  .  .  -----|"
tela1Linha10mestre : string "|   ||. ------  -------  ------. ||    |"
tela1Linha11mestre : string "|   ||. |    |  |     |  |    |. ||    |"
tela1Linha12mestre : string "|   ||. ------  -------  ------  ||    |"
tela1Linha13mestre : string "|-----. . . . . . . . . . . . .   -----|"
tela1Linha14mestre : string "      .   .     |---  ---|  . .  . . .  "
tela1Linha15mestre : string "      .   .     |        |  .   .       "
tela1Linha16mestre : string "|-----  . . . . |________|  . . . -----|"
tela1Linha17mestre : string "|    || . . .  ___     ___  .  . ||    |"
tela1Linha18mestre : string "|    || . . .  | |  *  | |  .  . ||    |"
tela1Linha19mestre : string "|    ||  ---   ---     ---  ---  ||    |"
tela1Linha20mestre : string "|----- . | | . . . . . . .  | | . -----|"
tela1Linha21mestre : string "| . . .  ---  ----------  . --- .  *   |"
tela1Linha22mestre : string "|-----  .   . |        |  . . . . -----|"
tela1Linha23mestre : string "|  ___  . . . |        |  .     . ___  |"
tela1Linha24mestre : string "|  . . . |--| ---------- . |--| .      |"
tela1Linha25mestre : string "|  .     |  |   .  .  .  . |  | . . . .|"
tela1Linha26mestre : string "|  . ----|  |----  . . ----|  |----   .|"
tela1Linha27mestre : string "|  . . . . . . . . . . . . . . . . . . |"
tela1Linha28mestre : string "|  . _____________________   *        .|"
tela1Linha29mestre : string "|----|toque z para pausar|-------------|"





tela2Linha0  : string "________________________________________"
tela2Linha1  : string "|                                      |"
tela2Linha2  : string "|                                      |"
tela2Linha3  : string "|                                      |"
tela2Linha4  : string "|                                      |"
tela2Linha5  : string "|                                      |"
tela2Linha6  : string "|                                      |"
tela2Linha7  : string "|                                      |"
tela2Linha8  : string "|                                      |"
tela2Linha9  : string "|                                      |"
tela2Linha10 : string "|                                      |"
tela2Linha11 : string "|                                      |"
tela2Linha12 : string "|                                      |"
tela2Linha13 : string "|                                      |"
tela2Linha14 : string "      DESEJA RECOMECAR O JOGO(y/n)      "
tela2Linha15 : string "                                        "
tela2Linha16 : string "|                                      |"
tela2Linha17 : string "|                                      |"
tela2Linha18 : string "|                                      |"
tela2Linha19 : string "|                                      |"
tela2Linha20 : string "|                                      |"
tela2Linha21 : string "|                                      |"
tela2Linha22 : string "|                                      |"
tela2Linha23 : string "|                                      |"
tela2Linha24 : string "|                                      |"
tela2Linha25 : string "|                                      |"
tela2Linha26 : string "|                                      |"
tela2Linha27 : string "|                                      |"
tela2Linha28 : string "|                                      |"
tela2Linha29 : string "|--------------------------------------|"


tela3Linha0  : string "________________________________________"
tela3Linha1  : string "|                                      |"
tela3Linha2  : string "|                                      |"
tela3Linha3  : string "|                                      |"
tela3Linha4  : string "|                                      |"
tela3Linha5  : string "|                                      |"
tela3Linha6  : string "|                                      |"
tela3Linha7  : string "|                                      |"
tela3Linha8  : string "|        Sua pontuacao foi:            |"
tela3Linha9  : string "|                                      |"
tela3Linha10 : string "|                                      |"
tela3Linha11 : string "|                                      |"
tela3Linha12 : string "|                                      |"
tela3Linha13 : string "|                                      |"
tela3Linha14 : string "|              GAME OVER               |"
tela3Linha15 : string "|                                      |"
tela3Linha16 : string "|                                      |"
tela3Linha17 : string "|                                      |"
tela3Linha18 : string "|                                      |"
tela3Linha19 : string "|       Clique espaco para jogar       |"
tela3Linha20 : string "|               de novo                |"
tela3Linha21 : string "|                                      |"
tela3Linha22 : string "|                                      |"
tela3Linha23 : string "|                                      |"
tela3Linha24 : string "|                                      |"
tela3Linha25 : string "|                                      |"
tela3Linha26 : string "|                                      |"
tela3Linha27 : string "|                                      |"
tela3Linha28 : string "|                                      |"
tela3Linha29 : string "|--------------------------------------|"



tela4Linha0  : string "________________________________________"
tela4Linha1  : string "|                                      |"
tela4Linha2  : string "|                                      |"
tela4Linha3  : string "|                                      |"
tela4Linha4  : string "|                                      |"
tela4Linha5  : string "|                                      |"
tela4Linha6  : string "|                                      |"
tela4Linha7  : string "|                                      |"
tela4Linha8  : string "|                                      |"
tela4Linha9  : string "|                                      |"
tela4Linha10 : string "|                                      |"
tela4Linha11 : string "|                                      |"
tela4Linha12 : string "|     Clique espaco para comecar       |"
tela4Linha13 : string "|                                      |"
tela4Linha14 : string "|           teclas w s d a             |"
tela4Linha15 : string "|                                      |"
tela4Linha16 : string "|                                      |"
tela4Linha17 : string "|                                      |"
tela4Linha18 : string "|                                      |"
tela4Linha19 : string "|                                      |"
tela4Linha20 : string "|                                      |"
tela4Linha21 : string "|                                      |"
tela4Linha22 : string "|                                      |"
tela4Linha23 : string "|                                      |"
tela4Linha24 : string "|                                      |"
tela4Linha25 : string "|                                      |"
tela4Linha26 : string "|                                      |"
tela4Linha27 : string "|                                      |"
tela4Linha28 : string "|                                      |"
tela4Linha29 : string "|--------------------------------------|"

tela5Linha0  : string "________________________________________"
tela5Linha1  : string "|                                      |"
tela5Linha2  : string "|                                      |"
tela5Linha3  : string "|                                      |"
tela5Linha4  : string "|                                      |"
tela5Linha5  : string "|                                      |"
tela5Linha6  : string "|                                      |"
tela5Linha7  : string "|                                      |"
tela5Linha8  : string "|        Sua pontuacao foi:            |"
tela5Linha9  : string "|                                      |"
tela5Linha10 : string "|                                      |"
tela5Linha11 : string "|                                      |"
tela5Linha12 : string "|                                      |"
tela5Linha13 : string "|                                      |"
tela5Linha14 : string "|           VOCE VENCEU !              |"
tela5Linha15 : string "|                                      |"
tela5Linha16 : string "|                                      |"
tela5Linha17 : string "|                                      |"
tela5Linha18 : string "|                                      |"
tela5Linha19 : string "|      Clique espaco para jogar        |"
tela5Linha20 : string "|              de novo                 |"
tela5Linha21 : string "|                                      |"
tela5Linha22 : string "|                                      |"
tela5Linha23 : string "|                                      |"
tela5Linha24 : string "|                                      |"
tela5Linha25 : string "|                                      |"
tela5Linha26 : string "|                                      |"
tela5Linha27 : string "|                                      |"
tela5Linha28 : string "|                                      |"
tela5Linha29 : string "|--------------------------------------|"



; --- Variáveis dos Fantasmas ---
posPacman: var #1     ; Guarda a posição do Pac-Man para os fantasmas seguirem
posFans: var #4       ; Vetor com as posições dos 4 fantasmas
coresFans: var #4     ; Vetor com as cores dos 4 fantasmas
atrasoFans: var #1    ; Contador para os fantasmas serem mais lentos
fanAtual: var #1      ; Índice do fantasma que está sendo processado
posAntigaFan: var #1  ; Auxiliar para apagar o rastro
flagPower: var #1       ; 0 = Normal, 1 = Fantasmas Azuis
timerPower: var #1      ; Contador para o efeito acabar
posInicialFans: var #4 ; Guarde as posições de início

posHomeFans: var #4     ; Posições de retorno dos fantasmas
static posHomeFans + #0, #545
static posHomeFans + #1, #548
static posHomeFans + #2, #538
static posHomeFans + #3, #541

pontuacao : var #1
pontuacao_final : var #3
vidas : var #1
mapaRastro : var #1200 ; Cria memoria para o "cheiro" do rastro
 
; --- Versão para Direita e Baixo (Soma) ---
ChecaColisao:
    push r0
    push r1
    push r2
    push r3
    push r4
    add r0, r0, r5      ; SOMA para ver a posição à frente
    jmp LogicaBusca

; --- Versão para Esquerda e Cima (Subtração) ---
ChecaColisaoEsquerdaCima:
    push r0
    push r1
    push r2
    push r3
    push r4
    sub r0, r0, r5      ; SUBTRAI para ver a posição atrás/acima
    jmp LogicaBusca

; --- Lógica compartilhada de busca na memória ---
LogicaBusca:
    loadn r1, #40
    div r2, r0, r1    ; r2 = r0/r1  
    mod r3, r0, r1    ; r3 = r0 % r1  
    loadn r1, #tela1Linha0 
    loadn r4, #41          
    mul r2, r2, r4      
    add r1, r1, r2      
    add r1, r1, r3      
            
; --- MUDANÇA AQUI ---
    loadi r4, r1        ; r4 recebe o caractere

    loadn r2, #'.'
    cmp r2,r4
    jeq chama_pontuacao
    
    loadn r2, #'-'
    cmp r4, r2
    jeq EhParede
    loadn r2, #'|'
    cmp r4, r2
    jeq EhParede

    loadn r2, #'_'
    cmp r4,r2
    jeq EhParede

    loadn r2, #'*'
    cmp r4,r2
    jeq ComeuDoce

    pop r4
    pop r3
    pop r2
    pop r1
    pop r0
    rts
    
EhParede:
    loadn r5, #0        
    pop r4
    pop r3
    pop r2
    pop r1
    pop r0
    rts

ComeuDoce:
    loadn r2, #1
    store flagPower, r2     ; Ativa modo Power
    loadn r2, #50          ; REDUZIDO: Duração do poder reduzida (era 300)
    store timerPower, r2
    loadn r2, #' '          ; Apaga o doce
    storei r1, r2
    outchar r2, r0
    jmp continua_busca

;------------ A parte de aumentar pontuação -------------------------------

chama_pontuacao:
    push r2
    push r3
    
    ; 1. Apaga no Vetor (RAM) - para a lógica de colisão não ler de novo
    loadn r2, #' '
    storei r1, r2      
    
    ; 2. Apaga na Tela (VGA) - r0 contém a posição atual do movimento
    loadn r3, #' '
    outchar r3, r0     
    
    pop r3
    pop r2
    call aumentar_pontuacao
    jmp continua_busca

aumentar_pontuacao:
    push r0 
    push r1
    push r2    
    push r3
    push r4
    push r5
    push r6
    push r7

    ; 1. Atualiza a pontuação na memória
    load r1, pontuacao 
    loadn r2, #169 ;pontuacao maxima possivel
    inc r1
    store pontuacao, r1 
    cmp r1,r2
    jeq venceu_jogo             

    ; 2. Decomposição Matemática Única (Serve para qualquer valor)
    loadn r2, #100
    div r0, r1, r2      ; r0 = Centena
    mod r1, r1, r2      ; r1 = O que sobrou (Dezena + Unidade)

    loadn r2, #10
    div r4, r1, r2      ; r4 = Dezena
    mod r5, r1, r2      ; r5 = Unidade

    ; 3. Preparação de Estilo
    loadn r7, #48       ; ASCII '0'
    loadn r3, #2816     ; Cor Amarela

    ; 4. Impressão na Tela (Posições fixas 24, 25, 26)
    
    ; Centena (Posição 24)
    add r0, r0, r7      
    add r0, r0, r3      
    loadn r2, #24       
    outchar r0, r2
    loadn r6, #pontuacao_final    
    storei r6, r0
    inc r6

    ; Dezena (Posição 25)
    add r4, r4, r7      
    add r4, r4, r3      
    loadn r2, #25       
    outchar r4, r2
    storei r6, r4
    inc r6

    ; Unidade (Posição 26)
    add r5, r5, r7      
    add r5, r5, r3      
    loadn r2, #26       
    outchar r5, r2
    storei r6, r5 

    ; 5. Limpa a pilha corretamente e volta
    pop r7
    pop r6
    pop r5
    pop r4
    pop r3
    pop r2
    pop r1
    pop r0
    rts

continua_busca:
    pop r4
    pop r3
    pop r2
    pop r1
    pop r0
    rts

; ********************************************************
; IA CORRIGIDA - SEM MAGNETISMO NO CANTO 0
; ********************************************************

CalculaDirecaoGreedy:
    push r0 
    push r1 
    push r2 
    push r3 
    push r5 
    push r6
    push r7

    load r0, posPacman    
    load r5, flagPower
    loadn r7, #0            
    cmp r5, r7              
    jeq InitPersegue
    loadn r6, #0          ; Modo FUGA
    jmp InitFim
InitPersegue:
    loadn r6, #32767      ; Modo PERSEGUE
InitFim:
    mov r4, r2            ; Default: parado
    loadn r7, #0          

T_Dir: ; --- DIREITA ---
    loadn r3, #1
    mov r5, r3
    call ChecaColisaoFan
    cmp r5, r7            
    jeq T_Esq             
    add r1, r2, r3        
    call CalculaDistancia 
    load r5, flagPower
    loadn r7, #0            
    cmp r5, r7              
    jeq DirPersegue
    ; MODO FUGA:
    cmp r3, r6
    jle T_Esq             
    jmp DirAtu
DirPersegue:
    ; MODO PERSEGUE:
    cmp r3, r6
    jgr T_Esq             
DirAtu:
    mov r6, r3
    mov r4, r1
    loadn r7, #0            

T_Esq: ; --- ESQUERDA ---
    loadn r3, #1
    mov r5, r3
    call ChecaColisaoFanEsqCima
    cmp r5, r7
    jeq T_Baixo
    sub r1, r2, r3
    call CalculaDistancia
    load r5, flagPower
    loadn r7, #0            
    cmp r5, r7              
    jeq EsqPersegue
    cmp r3, r6
    jle T_Baixo           
    jmp EsqAtu
EsqPersegue:
    cmp r3, r6            
    jgr T_Baixo           
EsqAtu:
    mov r6, r3 
    mov r4, r1
    loadn r7, #0            

T_Baixo: ; --- BAIXO ---
    loadn r5, #40
    call ChecaColisaoFan
    cmp r5, r7
    jeq T_Cima
    add r1, r2, r5
    call CalculaDistancia
    load r5, flagPower
    loadn r7, #0            
    cmp r5, r7              
    jeq BaiPersegue
    cmp r3, r6
    jle T_Cima            
    jmp BaiAtu
BaiPersegue:
    cmp r3, r6            
    jgr T_Cima           
BaiAtu:
    mov r6, r3 
    mov r4, r1
    loadn r7, #0            

T_Cima: ; --- CIMA ---
    loadn r5, #40
    call ChecaColisaoFanEsqCima
    cmp r5, r7
    jeq FimG
    sub r1, r2, r5
    call CalculaDistancia
    load r5, flagPower
    loadn r7, #0            
    cmp r5, r7              
    jeq CimPersegue
    cmp r3, r6
    jle FimG              
    jmp CimAtu
CimPersegue:
    cmp r3, r6            
    jgr FimG
CimAtu:
    mov r6, r3 
    mov r4, r1

FimG:
    pop r7
    pop r6 
    pop r5
    pop r3
    pop r2
    pop r1
    pop r0
    rts

; ********************************************************
;                     MOVE FANTASMAS (COMPLETO)
; ********************************************************
MoveFantasmas:
    push r0
    push r1
    push r2
    push r3
    push r4
    push r5
    push r6

    ; --- Controle de Velocidade ---
    load r0, atrasoFans
    inc r0
    store atrasoFans, r0
    loadn r1, #2            
    cmp r0, r1
    jne FimMoveFantasmas
    loadn r0, #0
    store atrasoFans, r0

    loadn r6, #0            ; Inicia contador de fantasmas (0 a 3)

LoopCadaFantasma:
    store fanAtual, r6
    
    ; 1. Pega posição atual do Fantasma
    loadn r1, #posFans
    add r1, r1, r6
    loadi r2, r1            ; r2 = Posição Atual

    ; --- CHECK DE COLISÃO ANTES DE MOVER (Pacman foi até o fantasma) ---
    load r0, posPacman
    cmp r2, r0
    jeq Colidiu_Power_Check

    ; 2. Define a Cor (Azul se flagPower == 1)
    load r5, flagPower
    loadn r1, #0            
    cmp r5, r1
    jeq CorOriginalFan
    loadn r3, #3072         ; Cor Azul (Vulnerável)
    jmp ApagaRastroFan

CorOriginalFan:
    loadn r1, #coresFans
    add r1, r1, r6
    loadi r3, r1            ; r3 = Cor original

ApagaRastroFan:
    ; 3. Apaga o fantasma da posição antiga restaurando o fundo
    mov r0, r2
    call RedesenhaCaractereMapa

    ; 4. Calcula o movimento (Greedy)
    call CalculaDirecaoGreedy ; r4 retorna a nova posição

    ; 5. Atualiza a posição no vetor posFans na memória
    loadn r1, #posFans
    load r6, fanAtual
    add r1, r1, r6
    storei r1, r4           
    
    ; 6. Desenha o Fantasma na nova posição
    loadn r5, #'F'
    add r5, r5, r3
    outchar r5, r4 

    ; --- CHECK DE COLISÃO DEPOIS DE MOVER (Fantasma foi até o Pacman) ---
    load r0, posPacman
    cmp r4, r0
    jne ProximoFantasma

Colidiu_Power_Check:
    load r5, flagPower
    loadn r1, #0            
    cmp r5, r1
    jeq decrementa_vida     ; Se power for 0, o Pacman morre

    ; --- SE COMEU O FANTASMA (PAC-MAN COM POWER) ---
    
    ; Limpa o fantasma de onde ele colidiu (r2 ou r4)
    load r6, fanAtual
    loadn r1, #posFans
    add r1, r1, r6
    loadi r0, r1            ; Pega a posição onde ele está agora
    call RedesenhaCaractereMapa 

    ; Faz o fantasma voltar para a Home (Posição de Nascimento)
    loadn r1, #posHomeFans  
    add r1, r1, r6
    loadi r2, r1            ; r2 = Posição inicial (ex: 545)
    
    ; Atualiza o vetor posFans com a posição Home
    loadn r1, #posFans      
    add r1, r1, r6
    storei r1, r2           
    
    ; Desenha o fantasma na base imediatamente (cor azul)
    loadn r5, #'F'
    loadn r3, #3072
    add r5, r5, r3
    outchar r5, r2

ProximoFantasma:
    load r6, fanAtual
    inc r6
    loadn r5, #4
    cmp r6, r5
    jne LoopCadaFantasma

FimMoveFantasmas:
    pop r6
    pop r5
    pop r4
    pop r3
    pop r2
    pop r1
    pop r0
    rts
;-------------funcao para decrementar vida--------------

decrementa_vida:
    push r0
    push r1
    push r2

    load r0, vidas
    dec r0
    store vidas, r0

    loadn r1, #48           
    cmp r0, r1              
    jeq game_over_pop       

    pop r2                  
    pop r1
    pop r0
    jmp main

game_over_pop:              
    pop r2
    pop r1
    pop r0
    jmp game_over

; ********************************************************
; CALCULA DISTANCIA MANHATTAN
; ********************************************************

CalculaDistancia:
    push r0
    push r1
    push r4
    push r5
    push r7
    
    loadn r7, #40
    
    mod r4, r1, r7    ; Coluna Alvo
    mod r5, r0, r7    ; Coluna Pacman
    cmp r4, r5
    jgr DX_Positivo
    sub r3, r5, r4    
    jmp Calc_DY
DX_Positivo:
    sub r3, r4, r5    
    
Calc_DY:
    push r3           

    div r4, r1, r7    ; Linha Alvo
    div r5, r0, r7    ; Linha Pacman
    cmp r4, r5
    jgr DY_Positivo
    sub r3, r5, r4    
    jmp Fim_Dist
DY_Positivo:
    sub r3, r4, r5    

Fim_Dist:
    pop r4            
    add r3, r3, r4    
    
    pop r7
    pop r5
    pop r4
    pop r1
    pop r0
    rts

; ********************************************************
;           REDESENHA O MAPA
; ********************************************************
RedesenhaCaractereMapa:
    push r1
    push r2
    push r3
    push r4
    push r5

    loadn r1, #40
    div r2, r0, r1
    mod r3, r0, r1
    loadn r1, #tela1Linha0
    loadn r4, #41
    mul r2, r2, r4
    add r1, r1, r2
    add r1, r1, r3
    
    loadi r4, r1         
    
    loadn r5, #'.'
    cmp r4, r5
    jeq CaractereAmarelo
    
    outchar r4, r0       
    jmp FimRedesenha

CaractereAmarelo:
    loadn r5, #2816
    add r4, r4, r5
    outchar r4, r0       

FimRedesenha:
    pop r5
    pop r4
    pop r3
    pop r2
    pop r1
    rts

; ********************************************************
;           COLISAO PARA FANTASMAS
; ********************************************************
ChecaColisaoFan:
    push r0
    push r1
    add r0, r2, r5        
    jmp LogicaBuscaGeral

ChecaColisaoFanEsqCima:
    push r0
    push r1
    sub r0, r2, r5        
    jmp LogicaBuscaGeral

LogicaBuscaGeral:
    push r2
    push r3
    push r4
    loadn r1, #posFans    
    loadn r2, #0          

LoopCheckOutros:
    load r3, fanAtual     
    cmp r2, r3            
    jeq ProximoCheckFan
    
    loadi r4, r1          
    cmp r0, r4            
    jeq ParedeEncontrada  
    
ProximoCheckFan:
    inc r1                
    inc r2
    loadn r3, #4
    cmp r2, r3
    jne LoopCheckOutros   
    
    loadn r1, #40
    div r2, r0, r1        
    mod r3, r0, r1        
    loadn r1, #tela1Linha0
    loadn r4, #41         
    mul r2, r2, r4        
    add r1, r1, r2
    add r1, r1, r3
    loadi r4, r1          
    
    loadn r2, #'-'
    cmp r4, r2            
    jeq ParedeEncontrada
    loadn r2, #'|'
    cmp r4, r2
    jeq ParedeEncontrada
    loadn r2, #'_'
    cmp r4, r2
    jeq ParedeEncontrada

    pop r4
    pop r3
    pop r2
    pop r1
    pop r0
    rts

ParedeEncontrada:
    loadn r5, #0          
    pop r4
    pop r3
    pop r2
    pop r1
    pop r0
    rts

;********************************************************
;                       IMPRIME TELA 2
;********************************************************	

ImprimeTela2: 	
	push r0	
	push r1	
	push r2	
	push r3	
	push r4	
	push r5	

	loadn R0, #0  	
	loadn R3, #40  	
	loadn R4, #41  	
	loadn R5, #1200 
	
   ImprimeTela_Loop2:
		call ImprimeStr2
		add r0, r0, r3  	
		add r1, r1, r4  	
		cmp r0, r5			
		jne ImprimeTela_Loop2	

	pop r5	
	pop r4
	pop r3
	pop r2
	pop r1
	pop r0
	rts
				
;********************************************************
;                   IMPRIME STRING 2
;********************************************************
	
ImprimeStr2:	
	push r0	
	push r1	
	push r2	
	push r3	
	push r4	
	loadn r2, #2816
	loadn r3, #'\0'	

   ImprimeStr_Loop2:	
		loadi r4, r1
		cmp r4, r3		
		jeq ImprimeStr_Sai2
		add r4, r2, r4	
		outchar r4, r0	
		inc r0			
		inc r1			
		jmp ImprimeStr_Loop2
	
   ImprimeStr_Sai2:	
	pop r4	
	pop r3
	pop r2
	pop r1
	pop r0
	rts

restaurar_mapa:
    loadn r0, #tela1Linha0mestre    
    loadn r1, #tela1Linha0     
    loadn r2, #1200             
    loadn r3, #0                

loop_restaura:
    loadi r4, r0                
    storei r1, r4               
    inc r0
    inc r1
    inc r3
    cmp r3, r2
    jne loop_restaura           
    rts

antes_pre_main:
    push r0
    push r1
    push r2
    push r3
    push r4
    call restaurar_mapa
    pop r4
    pop r3
    pop r2
    pop r1
    pop r0
    jmp pre_main
