				PROCESSOR   16F887
				__CONFIG    0X2007,0X2BE4;10 1011 1110 0100
				__CONFIG    0X2008,0X3FFF
				INCLUDE     <P16F887.INC>
				ORG	    0X0000
				GOTO	    P_INICIO
				ORG	    0X0004
	
				INCLUDE     <C:\Users\diego\OneDrive\Documents\MechaBible\p_MPLAB (Ensamblador)\2.-Ejercicios PIC16F887\rescate.asm>
				
				GOTO	    RSI
P_INICIO:			MOVLW	    0XFF
				MOVWF	    PORTA
				CLRF	    PORTB
				CLRF	    PORTC
				MOVWF	    PORTD
				CLRF	    PORTE
				BSF	    STATUS,RP0
				BSF	    STATUS,RP1	    ;B3.
				CLRF	    ANSELH	    ;
				CLRF	    ANSEL	    ;PA,PB Y PE=DIGITALES.
				BSF	    ANSEL,7
				BCF	    STATUS,RP1	    ;B1


