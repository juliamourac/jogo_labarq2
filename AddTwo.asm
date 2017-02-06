; Julia de Moura Caetano - R.A.: 619655
; Let�cia Yumi Katsurada - R.A.:

TITLE CharRunner.asm

INCLUDE Irvine32.inc

xmin = 25
xmax = 50
ymin = 0
ymax = 15

;player  = 2

.data
	strinicial BYTE "----CHAR_RUNNER----", 0 ;t�tulo da tela inicial
	strinstrucao1 BYTE "# Aperte a barra de Espaco para pular os obstaculos",0
	strinstrucao2 BYTE "_____APERTE ESPACO PARA INICIAR_____",0
	player BYTE "@" ;jogador
	obst BYTE "Y" ;obstaculo
	chao BYTE "." ;caractaer de ch�o
	strscore BYTE "MAIOR PONTUA��O", 0
	score DWORD 0; pontua��o
	stracabou BYTE "Game Over!", 0
	x_player BYTE ? ;fixo, sempre no mesmo x
	y_player BYTE ? ;vari�vel, pois pode pular
	x_chao BYTE ? ;vari�vel
	y_chao equ ? ;fixo
	velocidade DWORD 100
	msg BYTE "E espaco",0

.code
	
	menu PROC
		CALL ClrScr ;limpa a tela

		MOV eax, green ;coloca 'verde' no eax
		CALL SetTextColor ;pega valor no eax e "setta" a cor das letras

		MOV dl, xmin+15 ;posi��o x do cursor
		MOV dh, ymin ;posi��o y inicial do cursor
		CALL Gotoxy ; coloca o cursor em dl,dh

		MOV edx, OFFSET strinicial
		CALL WriteString
		MOV al, 10 ;10 � o "c�digo" para o caractere "pr�xima linha"
		CALL WriteChar

		MOV dl, xmin ;posi��o x do cursor
		MOV dh, ymin+1 ;posi��o y inicial do cursor
		CALL Gotoxy ; coloca o cursor em dl,dh

		MOV edx, OFFSET strinstrucao1
		CALL Gotoxy
		CALL WriteString
		CALL WriteChar

		MOV dl, xmin+5 ;posi��o x do cursor
		MOV dh, ymin+2 ;posi��o y inicial do cursor
		CALL Gotoxy ; coloca o cursor em dl,dh

		MOV edx, OFFSET strinstrucao2
		CALL WriteString
		CALL WriteChar

		;l� tecla
	LE1:
		MOV eax, 50
		CALL Delay
		CALL Readkey ;l� tecla
		cmp al,32 ;compara o c�digo ascii da tecla lida com o imediato e subtrai
		jz ESPACO
		jnz LE1

	ESPACO:
		MOV edx, OFFSET msg
		CALL WriteString
		MOV al, 10
		CALL WriteChar
		CALL jogo
		ret
	menu ENDP

	jogo PROC
		CALL ClrScr
		MOV dl, xmin+15 ;posi��o x do cursor
		MOV dh, ymin ;posi��o y inicial do cursor
		CALL Gotoxy ; coloca o cursor em dl,dh
		MOV edx, OFFSET strinicial
		CALL WriteString
		MOV al, 10 ;10 � o "c�digo" para o caractere "pr�xima linha"
		CALL WriteChar
		
SET_CHAO:
		MOV cl,0 ;atuar� como contador
		MOV dl, xmin ;;xmin no x destino do cursor
		MOV dh, ymax
		CALL Gotoxy
		CALL Randomize;"Randomiza o seed"
		
DESENHA_CHAO:
		MOV eax, 25;
		CALL RandomRange ; Define o "range" com o m�ximo em eax-1
		cmp eax, 17 ;compara o n�mero gerado com 23, se for aparece "Y"
		jne E_CHAO
		MOV al, obst
		jmp CONTINUA
		E_CHAO:
			MOV al, chao

		CONTINUA:
			CALL WriteChar
			MOV eax, 100
			CALL Delay
			inc cl
			cmp cl,50
			jz SET_CHAO
			CALL ReadKey
			cmp al, 32
			jnz DESENHA_CHAO
		MOV al,10
		CALL WriteChar
		exit


	jogo ENDP

	
	main PROC
		CALL menu

		exit

	main ENDP
	END MAIN

END