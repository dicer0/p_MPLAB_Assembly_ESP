;La configuración del PIC será jalada por una instrucción INCLUDE, para poder 
;hacerlo debo poner la dirección de la carpeta que llega hasta donde se 
;encuentra el archivo dentro de este proyecto de MPLABX en mi computadora, con 
;todo y el nombre del archivo que es Configuracion_PIC.asm de la siguiente 
;manera:
	    INCLUDE	<C:\Users\diego\OneDrive\Documents\The_MechaBible\p_MPLAB (Ensamblador)_ESP\2.-Ejercicios PIC16F887\0.-Configuracion\Configuracion_PIC.asm>
	    CLRF	TRISD
	    BCF		STATUS,RP0	    ;B0
CICLO:	    MOVLW	0X0F
	    ANDWF	PORTC,W
	    MOVWF	0X20
	    MOVLW	0XF0
	    ANDWF	PORTB,W
	    ADDWF	0X20,F
	    SWAPF	0X20,W
	    MOVWF	PORTD
	    GOTO	CICLO
	    END