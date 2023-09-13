;24.-Temporizador de 0 a 99 utilizando un ADC.
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
		INCLUDE	    <C:\Users\diego\OneDrive\Documents\The_MechaBible\p_MPLAB (Ensamblador)_ESP\2.-Ejercicios PIC16F887\0.-Configuracion\ConfiguracionTemporizador.asm>
		GOTO	    INICIO
SIETESEG:	ADDWF	    PCL,F
		DT	    0XC0,0XF9,0XA4,0XB0,0X99,0X92,0X82,0XF8,0X80,0X98,0X88,0X83,0XC6,0XA1,0X86,0X8E	;�NODO
		;DT	    0X3F,0X06,0X5B,0X4F,0X66,0X6D,0X7D,0X07,0X7F,0X6F,0X77,0X7C,0X39,0X5E,0X79,0X71	;C�TODO
INICIO:		CLRF	    TRISB
		CLRF	    TRISD
		CLRF	    TRISA
		BSF	    PIE1,ADIE
		CLRF	    ADCON1	    ;AJUSTE IZQUIERDA, LIMITES =VDD Y VSS.
		CLRF	    STATUS	    ;B0
		MOVLW	    B'11011101'	    ;RELOJ=RC, CANAL=RE2/AN7,DONE, ADC=ON.
		MOVWF	    ADCON0

		MOVLW	    .7
		MOVWF	    0X20
		DECFSZ	    0X20,F
		GOTO	    $-1

		BCF	    PIR1,ADIF
		BSF	    INTCON,PEIE
		BSF	    INTCON,GIE		

		BSF	    ADCON0,1	    ;INICIA LA CAD.
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
RSI:		MOVF	    ADRESH,W
		MOVWF	    PORTB
		BSF	    STATUS,RP0	    ;B1
		MOVF	    ADRESL,W
		BCF	    STATUS,RP0	    ;B0
		MOVWF	    0X25
		BTFSS	    0X25,7
		GOTO	    SIETE0			
		BSF	    PORTA,7
		BTFSS	    0X25,6
		GOTO	    SEIS0			
		BSF	    PORTA,6
		GOTO	    INIADC
SIETE0:		BCF	    PORTA,7
		GOTO	    INIADC
SEIS0:		BCF	    PORTA,6
INIADC:		BCF	    PIR1,ADIF
		BSF	    ADCON0,1	    ;INICIA LA CAD
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