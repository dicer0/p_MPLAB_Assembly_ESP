		PROCESSOR   16F887
		__CONFIG    0X2007,0X2BC4
		__CONFIG    0X2008,0X3FFF
		INCLUDE     <P16F887.INC>
		ORG	    0X0000
		CLRF	    PORTA
		CLRF	    PORTB
		CLRF	    PORTC
		CLRF	    PORTD
		CLRF	    PORTE
		BSF	    STATUS,RP0
		BSF	    STATUS,RP1
		CLRF	    ANSELH
		CLRF	    ANSEL
		BCF	    STATUS,RP1
;*******************************CONFIGURACION DE PUERTOS PIC16F887**************
		CLRF	    STATUS
		ADDLW	    0XEE
		ADDLW	    0XEE
		ADDLW	    0XEE
		MOVLW	    .1
		MOVWF	    0X62
		MOVLW	    .5
		MOVWF	    0X61
		CALL	    ST2V
