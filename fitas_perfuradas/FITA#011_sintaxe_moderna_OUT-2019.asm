;
;     PROGRAMA  -  LIGACAO ENTRE PATO E SINTETIZADOR
;
;   Autor: prof. Guido Stolfi por volta da metade da década de 70
;
;   Este arquivo contém uma adaptação do código original usando uma
;  sintaxe mais familiar para linguagens assembly nos dias de hoje.
;
;  Felipe Sanches, OUT/2019
;

	EQU	CANAL_4	4
	EQU	CANAL_6	6
	EQU	CANAL_7	7
	EQU	DECWRITER	11
	EQU	CANAL_D	13
	EQU	LEITORA_DE_FITA	14

	ORG /4 

entry_point:
	SALTA canal=4 func=4 ; Salta prox. instr. se ff de pedido de interrupcao estiver desligado
	PULA int

	SALTA canal=13 func=4 ; Salta prox. instr. se ff de pedido de interrupcao estiver desligado
	PULA ilo

	CARI 4
	TRI		; guarda no registrador indexador o valor 4 (seria isso o endereço de entry_point ?!)
	CARI /2E	; coloca 0x2E (caractere '.') no acumulador para ser impresso
	PULA decwriter_print_char


int:
	FUNC canal=4 func=4	; LIMPA F.F. PED. INT.
	ARM ACC
	TRI
	ARM RI
 
	SALTA canal=4, func=3	; SALTA SE NAO FOR PULSO DE SINCRONISMO
	PULA sinc		; É PULSO DE SINCRONISMO

	SUS CSQ
	PULA nsq		; CSQ NAO CHEGOU A ZERO AINDA

csq_zero:
	CAR CEM		; CSQ E ZERO 
	ARM CSQ		; ACERTEI O VALOR DO CSQ 

nsq:
	CHAMA verifica_hora_de_mandar
	CAR RI
	TRI
	CAR ACC
	PULA


sinc:
	FUNC canal=4, func=3	; LIMPA F.F. PULSO SINC. 
	CAR CSQ			; É PULSO DE SINCRONISMO 
	PULA_Z csq_zero		; CSQ == 0 , TUDO BEM.
	SOMI -31		; CSQ != 0 , HOUVE PERDA OU GANHO DE PULSOS. CORRIGIR.
	PULA_N perda_de_pulsos	; VAI P/ SUBROTINA - N (PERDA DE PULSOS)
				;                      ( 1 <= CSQ <= 30 )
	CMP2
	SOMI 38
	PULA_N pulsos_a_mais	; VAI P/ SUBROTINA + N (CONTOU PULSOS A MAIS)
				;                      ( 70 <= CSQ <= 99 )

	CARI 9			; ERRO (GANHOU OU PERDEU MUITOS PULSOS) 

;       ( 31 <= CSQ <= 69 ) 
	PULA igual


pulsos_a_mais:
	SOMI 31
	SOM CTEMP
	ARM CTEMP
	PULA csq_zero


perda_de_pulsos:
	SOMI 30
	ARM CSQ
.:
	CHAMA verifica_hora_de_mandar
	SUS CSQ
	PULA .-1
	PULA csq_zero


[ROTINA] ; VERIFICA SE E HORA DE MANDAR ALGO P/ O SINTETIZADOR
verifica_hora_de_mandar:
	SUS CTEMP
	RET [verifica_hora_de_mandar]	; CTEMP != 0 POR TANTO, VOLTA AO PROG PRINC

	CAR TEMP
	ARM CTEMP

vpdi:
	UNEG
	SOM PER
	ARM PER
	CAR PERI
	SV 1
	SOMI -1
	ARM PERI
	PULA_N ppz
	RET [verifica_hora_de_mandar]


ppz:
	CAR S
	SOMI -2
	TRI
	CARX BUF
	SAI canal=6, func=2	;  SAI NO CANAL 6 (8 BITS)
	SUS 0
	CARX BUF
	SAI canal=6, func=3	;  SAI NO CANAL 6 (8 BITS)
	SAI canal=6, func=4	;  MANDA DADOS.
	SALTA canal=6, func=1	;  WAIT - FOR - FLAG.
	PULA *-2
	SUS 0
	PULA nzs
	CARI 79
	TRI

nzs:
	CAR 0
	ARM S
	CMP2
	SOM L
	PULA_Z vcfim
	CARX BUF
	ARM PERI
	SUS 0
	CARX BUF
	ARM PER
	PULA vpdi


vcfim:
	TRI
	CMP2
	SOM F
	PULA_N escreve	; ATRAZO

vparar:
	FUNC canal=4, func=7	; LIMPA CONTROLE       (TBGEN) 
	FUNC canal=4, func=0	; NAO PERM. INT.       (TBGEN) 
	CAR Y
	ARM 2
	CAR Y+1
	ARM 3
	PULA


escreve:
	CARI 5

igual:
	TRI
.:
	CARX ATRAZO
	SAI canal=DECWRITER, func=0		; SAIDA PELA DEC 
.:
	SALTA canal=DECWRITER, func=1		; SAIDA PELA DEC
	PULA .-1
	SUS 0
	PULA .-2
	PULA vparar


ilo:
	CAR /3
	CMP2
	SOM X+1
	PULA_Z ads
	INC
	PULA_Z aum
	FUNC canal=LEITORA_DE_FITA, func=1	; LIMPA ESTADO       ( L. O. ) 
	FUNC canal=LEITORA_DE_FITA, func=4	; LIMPA PED. DE INT. ( L. O. ) 
	FUNC canal=LEITORA_DE_FITA, func=0	; NAO PERM. INT.     ( L. O. )

	CARI 3
	TRI
.:
	CARX ERRO 

decwriter_print_char:
	SAI canal=DECWRITER, func=0 ; SAIDA PELA DEC
.:
	SALTA canal=DECWRITER, func=1 ; aguarda o f.f. de ESTADO ser desligado (indicando que o dado foi recebido com sucesso)
	PULA .-1
	SUS 0
	PULA .-2
	PULA vparar


ads:
	INC 

aum:
	SOMI 2
	SOM /3 
	ARM /3 
	ENTRA canal=LEITORA_DE_FITA, func=0	; ENTRA C/ DADOS E PARA FITA
	FUNC canal=LEITORA_DE_FITA, func=1	; LIMPA ESTADO 
	FUNC canal=LEITORA_DE_FITA, func=4	; LIMPA PED. DE INT. ( L. O. ) 


	ORG /300
pri:
	LIMP0
	ARM F
.:
	CHAMA le_dado_da_fita
	PULA_Z .-1
	ARM ACC
	CHAMA le_dado_da_fita
	ARM TEMP
	ARM CTEMP
	CHAMA le_dado_da_fita
	ARM TEMPI
	CARI 79
	ARM L
	ARM S
	TRI
	PULA snln

cont:
	SUS TRES 
	PULA leo

snln:
	CHAMA le_dado_da_fita
	PULA_N acab
	ARMX BUF 
	CARI 3 
	ARM TRES 
	PLA .+1

leo:
	CHAMA le_dado_da_fita
	ARMX BUF 
.:
	SUS 0 
	PULA cont 
	CHAMA armp 
	PULA csl


[ROTINA]
le_dado_da_fita:
	FUNC canal=LEITORA_DE_FITA, func=6	; LIMPA ESTADO,SETA CONTROLE E CORRE FITA
.:
	SALTA canal=LEITORA_DE_FITA, func=1
	PULA .-1
	ENTRA canal=LEITORA_DE_FITA, func=0	; ENTRA DADOS E PARA FITA 
	RET [le_dado_da_fita]


liz:
	FUNC canal=4, func=1	; AVISA QUE A INTERFACE MANDA 
	CAR TEMPI
	SAI canal=4, func=0	; SAI DADO, SETA CONTROLE E COMECA A CONTAR TEMPO REAL 
	PULA C


[ROTINA]
armp:
	CARI 79
	TRI
	CARX BUF
	ARM PERI
	SUS 0
	CARX BUF
	ARM PER
	FUNC canal=6, func=8	; MODO SERIE PARA CANAL 6
	FUNC canal=7, func=8	; MODO SERIE PARA CANAL 7
	FUNC canal=7, func=10	; MODO ACOPLADO 
	UNEG
	SOMA ACC
	PULA_Z liz
	FUNC canal=4, func=2	; AVISA QUE O SINTETIZADOR MANDA    (TBGEN)

c:
	FUNC canal=4, func=5	; PERM. INT.                        (TBGEN) 
	PERM
	RET (armp)


acab:
	TRI
	ARM L
	ARM F
	CHAMA armp
	PULA edai


nzl:
	SUS TRES
	PULA ncfim
	TRI

arml:
	ARM L

csl:
	CAR L		;*
	CMP2		;*
	SOMA S		;*
	PULA_Z csl	;*
	CAR L
	TRI
	CARI 3
	ARM TRES

ncfim:
	FUNC canal=LEITORA_DE_FITA, func=6	; LIMPA ESTADO, SETA CONTROLE E CORRE FITA
	FUNC canal=LEITORA_DE_FITA, func=5	; PERM. INT.      ( L. O. )

esp:
	ESP
	PULA esp
	ARMX BUF
	CAR TRES
	SOMI -3
	PULA_Z vsa

jjj:
	SUS 0 
	PULA nzl
	CARI 79
	PULA arml


vsa:
	CARX BUF
	PULA_N cfim
	PULA jjj


cfim:
	CAR L
	ARM F

edai:
	FUNC canal=LEITORA_DE_FITA, func=0	; NAO PERM. INT.      ( L. O. )
	PULA esp


pare:
	PARE
	INIBE
	PULA pri


ACC:
	DEFC 0
ATRAZO:
	DEFC @O
	DEFC @Z
	DEFC @A
	DEFC @R
	DEFC @T
	DEFC @A
ERRO:
	DEFC @O
	DEFC @R
	DEFC @R
	DEFC @E
CEM:	DEFC 99		; GUARDA O NO. 99 
CSQ:	DEFC 0		; CONTA DE 0 A 99
CTEMP:	DEFC 0
F:	DEFC 0
L:	DEFC 0
PERI:	DEFC 0
PER:	DEFC 0
RI:	DEFC 0
S:	DEFC 0
TEMPI:	DEFC 0
TEMP:	DEFC 0
TRES:	DEFC 0
X:	DEFE ESP
Y:	DEFE PARE
BUF:	BLOC 80


	FIM 0
