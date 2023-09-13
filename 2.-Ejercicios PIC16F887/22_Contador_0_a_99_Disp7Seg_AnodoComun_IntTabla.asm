;22.- Contador de 0 a 99 en dos displays de 7 segmentos de �nodo com�n con una 
;frecuencia de 1 Hz a trav�s de interrupciones y una tabla que contiene los 
;tiempos de las subrutinas.
;RA0 CONTROLA AL DISPLAY DE UNIDADES
;RA1 CONTROLA AL DISPLAY DE DECENAS
;PD ES EL BUS DE DATOS
		#DEFINE	    UNID_ON	BCF	PORTA,0
		#DEFINE	    UNID_OFF	BSF	PORTA,0		
		#DEFINE	    DECE_ON	BCF	PORTA,1
		#DEFINE	    DECE_OFF	BSF	PORTA,1		
		UNID	    EQU		0X20
		DECE	    EQU		0X21
		CONT60	    EQU		0X22
		W_R	    EQU		0X70
		ST_R	    EQU		0X71
		PC_R	    EQU		0X72
;OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO
		INCLUDE	    <C:\Users\diego\OneDrive\Documents\The_MechaBible\p_MPLAB (Ensamblador)_ESP\2.-Ejercicios PIC16F887\0.-Configuracion\Configuracion_PIC.asm>
		GOTO	    INICIO
SIETESEG:	ADDWF	    PCL,F
		DT	    0XC0,0XF9,0XA4,0XB0,0X99,0X92,0X82,0XF8,0X80,0X98,0X88,0X83,0XC6,0XA1,0X86,0X8E	;�NODO
		;DT	    0X3F,0X06,0X5B,0X4F,0X66,0X6D,0X7D,0X07,0X7F,0X6F,0X77,0X7C,0X39,0X5E,0X79,0X71	;C�TODO
INICIO:		MOVLW	    0XF0
		MOVWF	    TRISB
		BCF	    OPTION_REG,7
		MOVLW	    0XFF
		MOVWF	    IOCB		;TODOS LOS PINES DEL PB SON SENSIBLES A INT_ON_CHANGE					
		CLRF	    TRISD
		CLRF	    TRISA
		CLRF	    STATUS		;B0
		MOVF	    PORTB,W
		BCF	    INTCON,RBIF
		BSF	    INTCON,RBIE
		BSF	    INTCON,GIE		
;OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO
LIMPIADECE:	CLRF	    DECE
LIMPIAUNID:	CLRF	    UNID
CARGACONT60:	MOVLW	    .60
		MOVWF	    CONT60
;OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO
SACADATO:	MOVF	    UNID,W
		CALL	    SIETESEG
		MOVWF	    PORTD
		UNID_ON
		CALL	    T_1_120
		UNID_OFF
;OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO
		MOVF	    DECE,W
		CALL	    SIETESEG
		MOVWF	    PORTD
		DECE_ON	
		CALL	    T_1_120
		DECE_OFF
;OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO
		DECFSZ	    CONT60,F
		GOTO	    SACADATO
;OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO
		INCF	    UNID,F
		MOVLW	    .10
		XORWF	    UNID,W		
		BTFSS	    STATUS,Z
		GOTO	    CARGACONT60
;OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO
		INCF	    DECE,F
		MOVLW	    .10
		XORWF	    DECE,W		
		BTFSS	    STATUS,Z
		GOTO	    LIMPIAUNID				
		GOTO	    LIMPIADECE
;OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO
T_1_120:	MOVLW	    .1
		MOVWF	    0X64
		MOVLW	    .6
		MOVWF	    0X65
		MOVLW	    .208
		MOVWF	    0X66
		CALL	    ST3V		
		RETURN
;OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO
RSI:		UNID_OFF
		DECE_OFF
		CALL	    T25MS
		MOVF	    PORTB,W
		ANDLW	    0XF0
		MOVWF	    0X23
		BSF	    STATUS,RP0		;B1
		MOVLW	    0X0F
		MOVWF	    TRISB
		BCF	    OPTION_REG,RP0
		BCF	    STATUS,RP0		;B0
		CLRF	    PORTB
		MOVF	    PORTB,W
		ANDLW	    0X0F
		ADDWF	    0X23,F
		MOVF	    0X23,W
		XORLW	    0XEE
		BTFSC	    STATUS,Z
		GOTO	    R1C1
		MOVF	    0X23,W
		XORLW	    0XDE
		BTFSC	    STATUS,Z
		GOTO	    R1C2
		MOVF	    0X23,W
		XORLW	    0XBE
		BTFSC	    STATUS,Z
		GOTO	    R1C3
		MOVF	    0X23,W
		XORLW	    0X7E
		BTFSC	    STATUS,Z
		GOTO	    R1C4
		MOVF	    0X23,W
		XORLW	    0XED
		BTFSC	    STATUS,Z
		GOTO	    R2C1
		MOVF	    0X23,W
		XORLW	    0XDD
		BTFSC	    STATUS,Z
		GOTO	    R2C2
		MOVF	    0X23,W
		XORLW	    0XBD
		BTFSC	    STATUS,Z
		GOTO	    R2C3
		MOVF	    0X23,W
		XORLW	    0X7D
		BTFSC	    STATUS,Z
		GOTO	    R2C4
		MOVF	    0X23,W
		XORLW	    0XEB
		BTFSC	    STATUS,Z
		GOTO	    R3C1
		MOVF	    0X23,W
		XORLW	    0XDB
		BTFSC	    STATUS,Z
		GOTO	    R3C2
		MOVF	    0X23,W
		XORLW	    0XBB
		BTFSC	    STATUS,Z
		GOTO	    R3C3
		MOVF	    0X23,W
		XORLW	    0X7B
		BTFSC	    STATUS,Z
		GOTO	    R3C4
		MOVF	    0X23,W
		XORLW	    0XE7
		BTFSC	    STATUS,Z
		GOTO	    R4C1
		MOVF	    0X23,W
		XORLW	    0XD7
		BTFSC	    STATUS,Z
		GOTO	    R4C2
		MOVF	    0X23,W
		XORLW	    0XB7
		BTFSC	    STATUS,Z
		GOTO	    R4C3
		MOVF	    0X23,W
		XORLW	    0X77
		BTFSC	    STATUS,Z
		GOTO	    R4C4
		GOTO	    REGRE
;Introducir valores en la tabla a trav�s de sus renglones y columnas.
R1C1:		MOVLW	    0X00
		GOTO	    SACAV
R2C1:		MOVLW	    0X01
		GOTO	    SACAV
R3C1:		MOVLW	    0X02
		GOTO	    SACAV
R4C1:		MOVLW	    0X03
		GOTO	    SACAV
R1C2:		MOVLW	    0X04
		GOTO	    SACAV
R2C2:		MOVLW	    0X05
		GOTO	    SACAV
R3C2:		MOVLW	    0X06
		GOTO	    SACAV
R4C2:		MOVLW	    0X07
		GOTO	    SACAV

R1C3:		MOVLW	    0X08
		GOTO	    SACAV
R2C3:		MOVLW	    0X09
		GOTO	    SACAV
R3C3:		MOVLW	    0X0A
		GOTO	    SACAV
R4C3:		MOVLW	    0X0B
		GOTO	    SACAV

R1C4:		MOVLW	    0X0C
		GOTO	    SACAV
R2C4:		MOVLW	    0X0D
		GOTO	    SACAV
R3C4:		MOVLW	    0X0E
		GOTO	    SACAV
R4C4:		MOVLW	    0X0F
	

SACAV:		MOVWF	    0X24
REPITEVALOR	MOVF	    0X24,W
		CALL	    SIETESEG
		MOVWF	    PORTD
		UNID_ON
				
		MOVF	    PORTB,W
		ANDLW	    0X0F
		XORLW	    0X0F
		BTFSS	    STATUS,Z
		GOTO	    REPITEVALOR
		UNID_OFF
REGRE:		CALL	    T25MS
		BSF	    STATUS,RP0		;B1
		MOVLW	    0XF0
		MOVWF	    TRISB
		BCF	    OPTION_REG,7
		BCF	    STATUS,RP0		;B0

		MOVF	    PORTB,W	
		BCF	    INTCON,RBIF
		INCLUDE	    <C:\Users\diego\OneDrive\Documents\The_MechaBible\p_MPLAB (Ensamblador)_ESP\2.-Ejercicios PIC16F887\0.-Configuracion\TablaTiempoSubrutina.asm>
		INCLUDE	    <C:\Users\diego\OneDrive\Documents\The_MechaBible\p_MPLAB (Ensamblador)_ESP\2.-Ejercicios PIC16F887\0.-Configuracion\RecuperaInterrupcion.asm>
;OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO
T25MS:		MOVLW	    .88
		MOVWF	    0X61
		MOVLW	    .35
		MOVWF	    0X62
		CALL	    ST2V
		RETURN
;OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO
		INCLUDE	    <C:\Users\diego\OneDrive\Documents\The_MechaBible\p_MPLAB (Ensamblador)_ESP\2.-Ejercicios PIC16F887\0.-Configuracion\SubRutinaTiempo.asm>
		END