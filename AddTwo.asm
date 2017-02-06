; Julia de Moura Caetano - R.A.: 619655
; Letícia Yumi Katsurada - R.A.:

TITLE CharRunner.asm

INCLUDE Irvine32.inc

xmin = 25
xmax = 50
ymin = 0
ymax = 15

;player  = 2

.data
	strinicial BYTE "----CHAR_RUNNER----", 0 ;título da tela inicial
	strinstrucao1 BYTE "# Aperte a barra de Espaco para pular os obstaculos",0
	strinstrucao2 BYTE "_____APERTE ESPACO PARA INICIAR_____",0
	player BYTE "@" ;jogador
	obst BYTE "Y" ;obstaculo
	chao BYTE "." ;caractaer de chão
	strscore BYTE "MAIOR PONTUAÇÃO", 0
	score DWORD 0; pontuação
	stracabou BYTE "GAME OVER", 0
	velocidade DWORD 500 ;delay
	player_curr BYTE xmin ;posição atual do player	

.code

;----------------------------------------
;------------MENU DO JOGO----------------
	menu PROC
		CALL ClrScr ;limpa a tela

		MOV eax, green ;coloca 'verde' no eax
		CALL SetTextColor ;pega valor no eax e "setta" a cor das letras

		MOV dl, xmin+15 ;posição x do cursor
		MOV dh, ymin ;posição y inicial do cursor
		CALL Gotoxy ; coloca o cursor em dl,dh

		MOV edx, OFFSET strinicial
		CALL WriteString
		MOV al, 10 ;10 é o "código" para o caractere "próxima linha"
		CALL WriteChar

		MOV dl, xmin ;posição x do cursor
		MOV dh, ymin+1 ;posição y inicial do cursor
		CALL Gotoxy ; coloca o cursor em dl,dh

		MOV edx, OFFSET strinstrucao1
		CALL Gotoxy
		CALL WriteString
		CALL WriteChar

		MOV dl, xmin+5 ;posição x do cursor
		MOV dh, ymin+2 ;posição y inicial do cursor
		CALL Gotoxy ; coloca o cursor em dl,dh

		MOV edx, OFFSET strinstrucao2
		CALL WriteString
		CALL WriteChar

		;lê tecla
	LE1:
		MOV eax, 50
		CALL Delay
		CALL Readkey ;lê tecla
		cmp al,32 ;compara o código ascii da tecla lida com o imediato e subtrai
		jz ESPACO
		jnz LE1

	ESPACO:
		MOV al, 10
		CALL WriteChar
		CALL jogo
		ret
	menu ENDP
;----------------------------FIM DO MENU DO JOGO-----------------------------------
;----------------------------------------------------------------------------------

;-------------------------------------------------
;----------MÉTODO QUE CUIDA DA PARTIDA------------
jogo PROC
		CALL ClrScr
		MOV dl, xmin+15 ;posição x do cursor
		MOV dh, ymin ;posição y inicial do cursor
		CALL Gotoxy ; coloca o cursor em dl,dh
		MOV edx, OFFSET strinicial
		CALL WriteString
		MOV al, 10 ;10 é o "código" para o caractere "próxima linha"
		CALL WriteChar
 
JOJO:
		CALL draw_chao ;aqui chama o método de desenhar chão
		CALL dmj ;aqui chama de desenhar e mover player
		CMP edx,1
		JNZ JOJO

SAI:
		ret
	jogo ENDP
;---------------------FIM DO MÉTODO DA PARTIDA-------------------
;----------------------------------------------------------------

;----------------------------------------------------------------
;-------------------------DESENHA O CHÃO-------------------------
	draw_chao PROC
SET_CHAO: ;zera contador que define até onde desenha, define início do cursor e alimenta o random
		MOV cl,0 ;atuará como contador
		MOV dl, xmin ;xmin no x destino do cursor
		MOV dh, ymax
		CALL Gotoxy
		CALL Randomize;"Randomiza o seed"
		
DESENHA_CHAO:
		cmp cl, 25 ;se está no meio do campo
		jne E_CHAO
		MOV al, obst
		jmp CONTINUA
		E_CHAO:
			MOV al, chao

CONTINUA:
		CALL WriteChar
;		MOV eax, 100
;		CALL Delay
		INC cl
		CMP cl,50
		jnz DESENHA_CHAO

		ret
	draw_chao ENDP
;----------------FIM DO MÉTODO QUE DESENHA O CHÃO------------------------
;------------------------------------------------------------------------

;------------------------------------------------------------------------
;---------------------DESENHA E MOVE O JOGADOR---------------------------
	dmj PROC
		MOV cl,0
		MOV dl, xmin
		MOV dh, ymax
		CALL Gotoxy

ESCREVE:
		CMP al, 32
		JZ PULO
C_E:	MOV al, player
		CALL WriteChar
		CMP cl, 25
		JZ COLISAO
		MOV eax, velocidade
		CALL Delay

		
		MOV player_curr, xmin
		ADD player_curr, cl
		CALL rastro
		INC cl
		cmp cl,46
		jnz ESCREVE
		sub velocidade, 200
		JMP SAIR_DMJ

PULO:
	MOV player_curr, xmin
	add cl, 3 ;três posições no campo
	add player_curr, cl
	MOV dl, player_curr
	MOV dh, ymax
	CALL Gotoxy
	JMP C_E

SAIR_DMJ:
		MOV edx, 0
		ret

COLISAO:
		MOV edx, 1
		ret

	dmj ENDP
;-------------------FIM DE DESENHA E MOVE JOGADOR------------------------
;------------------------------------------------------------------------

;------------------------------------------------------------------------
;-------------------MÉTODO QUE DESENHA PONTO ATRÁS-----------------------
rastro PROC
	SUB player_curr,1
	MOV dl, player_curr
	MOV dh, ymax
	CALL Gotoxy
	MOV al, chao
	CALL WriteChar
	ADD player_curr,1
	MOV dl, player_curr
	CALL Gotoxy
	ret
rastro ENDP
;----------------FIM DO MÉTODO QUE DESENHA PONTO ATRÁS-------------------
;------------------------------------------------------------------------

;------------------------------------------------------------------------
;-------------------------------MAIN-------------------------------------
	main PROC

		CALL menu

		CALL ClrScr
		;MOV al, stracabou
		;CALL WriteString
		;MOV al, 10
		;CALL WriteChar

		exit

	main ENDP
	END MAIN
