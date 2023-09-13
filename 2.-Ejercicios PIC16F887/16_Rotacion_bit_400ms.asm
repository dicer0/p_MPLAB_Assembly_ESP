;16.- Rota un 1 por el puerto C con espacios de tiempo de 400 milisegundos.
		
;La configuración del PIC será jalada por una instrucción INCLUDE, para poder 
;hacerlo debo poner la dirección de la carpeta que llega hasta donde se 
;encuentra el archivo dentro de este proyecto de MPLABX en mi computadora, con 
;todo y el nombre del archivo que es Configuracion_PIC.asm de la siguiente 
;manera:
		INCLUDE	    <C:\Users\diego\OneDrive\Documents\The_MechaBible\p_MPLAB (Ensamblador)_ESP\2.-Ejercicios PIC16F887\0.-Configuracion\Configuracion_PIC.asm>
		CLRF	    TRISA
		CLRF	    STATUS	    ;B0
		BSF	    PORTA,0
ROTA:		CALL	    T400MS
		RLF	    PORTA,F
		BTFSC	    STATUS,C
		RLF	    PORTA,F    
		GOTO	    ROTA
T400MS:		MOVLW	    .199
		MOVWF	    0X64
		MOVLW	    .5
		MOVWF	    0X65
		MOVLW	    .59
		MOVWF	    0X66
		CALL	    ST3V
		RETURN
		INCLUDE     <C:\Users\diego\OneDrive\Documents\The_MechaBible\p_MPLAB (Ensamblador)_ESP\2.-Ejercicios PIC16F887\0.-Configuracion\SubRutinaTiempo.asm>
		END