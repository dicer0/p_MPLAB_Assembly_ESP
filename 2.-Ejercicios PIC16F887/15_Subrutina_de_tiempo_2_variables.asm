;15.- Realiza una subrutina de tiempo de 2 variables que cree un retardo de 
;17 us (microsegundos) a 394.247 ms (milisegundos) ya que var1 y var2 en su 
;ecuación solo puede adoptar valores de 1 a 256.
	    
;La configuración del PIC será jalada por una instrucción INCLUDE, para poder 
;hacerlo debo poner la dirección de la carpeta que llega hasta donde se 
;encuentra el archivo dentro de este proyecto de MPLABX en mi computadora, con 
;todo y el nombre del archivo que es Configuracion_PIC.asm de la siguiente 
;manera:
		INCLUDE	    <C:\Users\diego\OneDrive\Documents\The_MechaBible\p_MPLAB (Ensamblador)_ESP\2.-Ejercicios PIC16F887\0.-Configuracion\Configuracion_PIC.asm>
		CLRF	    STATUS
		ADDLW	    0XEE
		ADDLW	    0XEE
		ADDLW	    0XEE
;***********************************************************************		
		MOVLW	    .248
		MOVWF	    0X62
		MOVLW	    .67
		MOVWF	    0X61
		CALL	    ST2V
		MOVLW	    .4
		MOVWF	    0X60
		CALL	    ST1V
;***********************************************************************
		ADDLW	    0XEE
		ADDLW	    0XEE
		ADDLW	    0XEE
		GOTO	    $
;***********************************************************************		
ST1V:		NOP
		NOP
                NOP
                DECFSZ      0X60,F
                GOTO        ST1V
                RETURN
;***********************************************************************
;SUBRUTINA DE TIEMPO DE DOS VARIABLES                
ST2V:		MOVF	    0X62,W
		MOVWF	    0X63
DECRE2V		NOP
		NOP
		NOP
                DECFSZ      0X63,F
                GOTO        DECRE2V
		DECFSZ	    0X61,F
		GOTO	    ST2V
                RETURN			
;***********************************************************************
		END