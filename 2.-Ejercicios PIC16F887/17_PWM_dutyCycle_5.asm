;17.- PWM con frecuencia de 1kHz con ciclo de trabajo de 5%.
;El periodo de 1 milisegundo es de la frecuencia de 1kHz, el 5 por ciento de 
;esto es de 50 microsegundos.
		
;La configuración del PIC será jalada por una instrucción INCLUDE, para poder 
;hacerlo debo poner la dirección de la carpeta que llega hasta donde se 
;encuentra el archivo dentro de este proyecto de MPLABX en mi computadora, con 
;todo y el nombre del archivo que es Configuracion_PIC.asm de la siguiente 
;manera:
	    INCLUDE	    <C:\Users\diego\OneDrive\Documents\The_MechaBible\p_MPLAB (Ensamblador)_ESP\2.-Ejercicios PIC16F887\0.-Configuracion\Configuracion_PIC.asm>
	    CLRF	    TRISA
	    CLRF	    STATUS	    ;B0
CICLO:	    BSF		    PORTA,0
	    MOVLW	    .2
	    MOVWF	    0X64
	    MOVLW	    .2
	    MOVWF	    0X65
	    MOVLW	    .1
	    MOVWF	    0X66
	    CALL	    ST3V	    ;T50US;49US;
	    BCF		    PORTA,0
	    MOVLW	    .157
	    MOVWF	    0X60
	    CALL	    ST1V	    ;T950US;947
	    GOTO	    CICLO	    
	    ;Banco 1. PA, PB Y PE = DIGITALES.
	    INCLUDE	    <C:\Users\diego\OneDrive\Documents\The_MechaBible\p_MPLAB (Ensamblador)_ESP\2.-Ejercicios PIC16F887\0.-Configuracion\SubRutinaTiempo.asm>
	    END