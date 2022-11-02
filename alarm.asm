LED EQU P1.7
GLOSNIK EQU P1.5

;********* Ustawienie TIMERów *********

						;TIMER 0

T0_G EQU 0				;GATE
T0_C EQU 0 				;COUNTER/-TIMER
T0_M EQU 1 				;MODE (0..3)
TIM0 EQU T0_M+T0_C*4+T0_G*8

						;TIMER 1

T1_G EQU 0 				;GATE
T1_C EQU 0 				;COUNTER/-TIMER
T1_M EQU 0 				;MODE (0..3)
TIM1 EQU T1_M+T1_C*4+T1_G*8
TMOD_SET EQU TIM0+TIM1*16

						;10[ms] = 10 000[uS]*(11.0592[MHz]/12) = 9216 cykli = 36 * 256

TH0_SET EQU 256-36
TL0_SET EQU 0

;**************************************

	LJMP START
	ORG 100H
START:
	LCALL LCD_INIT
	CLR RS0
	
	LCALL GZEGARA
	LCALL MZEGARA
	LCALL SZEGARA

	LCALL GALARMU
	LCALL MALARMU

	MOV TMOD,#TMOD_SET 	;Timer 0 liczy czas
	MOV TH0,#TH0_SET 	;Timer 0 na 10ms
	MOV TL0,#TL0_SET
	SETB TR0 			;start Timera
LOOP: 					;Pętla mrugania diody TEST
	MOV A, R3
	CJNE A, #59, LICZS
	MOV R3, #0

	MOV A, R2
	CJNE A, #59, LICZM
	MOV R2, #0

	MOV A, R1
	CJNE A, #23, LICZG
	MOV R1, #0
	LCALL POKAZCZAS

	MOV R7,#100 		;odczekaj czas 100*10ms=1s
TIME_N10:
	JNB TF0,$			;czekaj, aż Timer 0
						;odliczy 10ms
	MOV TH0,#TH0_SET 	;TH0 na 10ms
	CLR TF0 			;zerowanie flagi timera 0
	DJNZ R7,TIME_N10 	;odczekanie N*10ms
	
	SJMP LOOP
BCD:
	MOV B,#10
	DIV AB
	SWAP A
	ORL A, B
	LCALL WRITE_HEX
	RET
LICZS:
	INC R3
	LCALL POKAZCZAS

	MOV A, R2			;minuta alarmu
	CJNE A, 5H, NASTEPNA
	MOV A, R1			;godzina alarmu
	CJNE A, 4H, NASTEPNA
	LCALL ALARM

	MOV R7,#100 
	LJMP TIME_N10
LICZM:
	INC R2
	LCALL POKAZCZAS
	MOV R7,#100 
	LJMP TIME_N10
LICZG:
	INC R1
	LCALL POKAZCZAS
	MOV R7,#100 
	LJMP TIME_N10
NASTEPNA:
	MOV R7,#100 
	LJMP TIME_N10
ALARM:
	LCALL LCD_CLR
	LCALL SPACJA
	MOV A, #'P'	
	LCALL WRITE_DATA
	MOV A, #'O'	
	LCALL WRITE_DATA
	MOV A, #'B'	
	LCALL WRITE_DATA
	MOV A, #'U'	
	LCALL WRITE_DATA
	MOV A, #'D'	
	LCALL WRITE_DATA
	MOV A, #'K'	
	LCALL WRITE_DATA
	MOV A, #'A'	
	LCALL WRITE_DATA
	MOV A, #'!'	
	LCALL WRITE_DATA
	LCALL SPACJA
	CLR LED
	CLR GLOSNIK
	MOV A,#20
	LCALL DELAY_100MS
	SETB GLOSNIK
	SETB LED
	LJMP STOP
POKAZCZAS:
	LCALL LCD_CLR		;wyczysc ekran
	MOV A, R1			;wyswietl godzine
	LCALL BCD
	MOV A, #':'			;wyswietl :
	LCALL WRITE_DATA
	MOV A, R2			;wyswietl minute
	LCALL BCD
	MOV A, #':'			;wyswietl :
	LCALL WRITE_DATA
	MOV A, R3			;wyswietl sekunde
	LCALL BCD
	RET
GZEGARA:
	LCALL WAIT_KEY
	MOV R1, A
	LCALL WRITE_HEX
	LCALL WAIT_KEY
	MOV R2, A
	LCALL WRITE_HEX
	MOV A, R1
	MOV B, #10
	MUL AB
	ADD A, R2
	MOV R1, A
	LCALL WAIT_ENTER_NW
	LCALL LCD_CLR
	RET
MZEGARA:
	LCALL WAIT_KEY
	MOV R2, A
	LCALL WRITE_HEX
	LCALL WAIT_KEY
	MOV R3, A
	LCALL WRITE_HEX
	MOV A, R2
	MOV B, #10
	MUL AB
	ADD A, R3
	MOV R2, A
	LCALL WAIT_ENTER_NW
	LCALL LCD_CLR
	RET
SZEGARA:
	LCALL WAIT_KEY
	MOV R3, A
	LCALL WRITE_HEX
	LCALL WAIT_KEY
	MOV R4, A
	LCALL WRITE_HEX
	MOV A, R3
	MOV B, #10
	MUL AB
	ADD A, R4
	MOV R3, A
	LCALL WAIT_ENTER_NW
	LCALL LCD_CLR
	DEC R3
	RET
GALARMU:
	LCALL WAIT_KEY
	MOV R4, A
	LCALL WRITE_HEX
	LCALL WAIT_KEY
	MOV R5, A
	LCALL WRITE_HEX
	MOV A, R4
	MOV B, #10
	MUL AB
	ADD A, R5
	MOV R4, A
	LCALL WAIT_ENTER_NW
	LCALL LCD_CLR
	RET
MALARMU:
	LCALL WAIT_KEY
	MOV R5, A
	LCALL WRITE_HEX
	LCALL WAIT_KEY
	MOV R6, A
	LCALL WRITE_HEX
	MOV A, R5
	MOV B, #10
	MUL AB
	ADD A, R6
	MOV R5, A
	LCALL WAIT_ENTER_NW
	LCALL LCD_CLR
	RET
SPACJA:
	MOV A, #' '	
	LCALL WRITE_DATA
	MOV A, #' '	
	LCALL WRITE_DATA
	MOV A, #' '	
	LCALL WRITE_DATA
	MOV A, #' '	
	LCALL WRITE_DATA
	RET
STOP:
	LJMP STOP
	NOP