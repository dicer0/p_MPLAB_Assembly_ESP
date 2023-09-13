;20.- Contador de 0 a 99 en dos displays de 7 segmentos de �nodo com�n con una 
;frecuencia de 1 Hz.
;RA0 CONTROLA AL DISPLAY DE UNIDADES
;RA1 CONTROLA AL DISPLAY DE DECENAS
;PD ES EL BUS DE DATOS
		;#DEFINE: Esta directiva sirve para guardar una operaci�n que se 
		;vaya a utilizar varias veces en un mismo c�digo en una 
		;variable, as� cuando la deba utilizar solo debo declarar el 
		;nombre de la variable. El nombre de la variable se debe 
		;declarar despu�s de la directiva #DEFINE.
		#DEFINE	    UNID_ON	BCF	PORTA,0
		#DEFINE	    UNID_OFF    BSF	PORTA,0		
		#DEFINE	    DECE_ON	BCF	PORTA,1
		#DEFINE	    DECE_OFF    BSF	PORTA,1
		;EQU: Esta directiva sirve para asociar alg�n registro de 
		;prop�sito general de la RAM con un nombre. La directiva EQU se
		;debe declarar despu�s del nombre.
		UNID	    EQU		0X20
		DECE	    EQU		0X21
		CONT60	    EQU		0X22
;OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO
		INCLUDE	    <C:\Users\diego\OneDrive\Documents\The_MechaBible\p_MPLAB (Ensamblador)_ESP\2.-Ejercicios PIC16F887\0.-Configuracion\Configuracion_PIC.asm>
		GOTO	    INICIO
SIETESEG:	ADDWF	    PCL,F ;PCL = PCL + W.
		;Se hace una suma para que no importando donde 
		;se encuentre la tabla, pueda acceder a cada 
		;una de sus filas.
		DT	    0XC0,0XF9,0XA4,0XB0,0X99,0X92,0X82,0XF8,0X80,0X98,0X88,0X83,0XC6,0XA1,0X86,0X8E
INICIO:		CLRF	    TRISD
		CLRF	    TRISA
		CLRF	    STATUS			;B0
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
		INCLUDE	    <C:\Users\diego\OneDrive\Documents\The_MechaBible\p_MPLAB (Ensamblador)_ESP\2.-Ejercicios PIC16F887\0.-Configuracion\SubRutinaTiempo.asm>
		END