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
				BSF	    STATUS,RP1	    ;B3.
				CLRF	    ANSELH	    ;
				CLRF	    ANSEL	    ;PA,PB Y PE=DIGITALES.
				BCF	    STATUS,RP1	    ;B1
				CLRF	    TRISC	    ;SALIDA PC
				BCF	    TRISB,7	    ;SALIDA B7
				BCF	    STATUS,RP0	    ;B0
				CLRF	    PORTC	    ;LIMPIAR PC
				BCF	    PORTB,7	    ;LIMPIAR B7

CICLO				BTFSS	    PORTB,0	    ;B0=1?
				GOTO	    CICLO				
				MOVF	    PORTD,W	    			
				MOVWF	    PORTC	    ;C=D(DATO 1)
				MOVWF	    0X20	    ;D(DATO 1) SE GUARDA EN 0X20


REPETIRB1			BTFSS	    PORTB,1	    ;B1=1?
				GOTO	    REPETIRB2			
				GOTO	    SUMA

REPETIRB2			BTFSS	    PORTB,2	    ;B2=1?
				GOTO	    REPETIRB3
				GOTO	    RESTA

REPETIRB3			BTFSS	    PORTB,3	    ;B3=1?
				GOTO	    REPETIRB1
				GOTO	    MULTIPLICACION

;--------------------------SUMA---------------------------------------------
SUMA				MOVF	    PORTD,W	    ;LEE PD Y GUARDA EN W
				MOVWF	    0X30	    ;D(DATO 2) LO GUARDA EN 0X25
				ADDWF	    0X20,W	    ;SUMA D(DATO 1)+D(DATO 2)
				BTFSS	    STATUS,C	    ;C=1?
				GOTO	    MOSTRAR	    ;MOSTRAR POR PC AL MIMIR
				BSF	    PORTB,7	    ;B7 ENCIENDE
				GOTO	    MOSTRAR	    ;MOSTRAR POR PC AL MIMIR
;--------------------------RESTA--------------------------------------------
RESTA				MOVF	    PORTD,W	    ;LEE PD Y GUARDA EN W
				MOVWF	    0X30	    ;D(DATO 2) LO GUARDA EN 0X26
				SUBWF	    0X20,W	    ;RESTA D(DATO 1)-D(DATO 2)
				BTFSS	    STATUS,C	    ;C=1?
				GOTO	    MAGNITUD		
				GOTO	    MOSTRAR	    ;MOSTRAR POR PC AL MIMIR
MAGNITUD			SUBLW	    0X00	    ;PC=|PD(DATO 1)-PD(DATO 2)|
				BSF	    PORTB,7	    ;MOSTRAR POR PC AL MIMIR
				GOTO	    MOSTRAR			

;----------------------------MULTIPLICACION-----------------------------------
MULTI_O				EQU	    0X21	    ;DATO A SUMAR (MULTIPLICANDO).
MULTI_R				EQU	    0X22	    ;VECES A SUMAR(MULTIPLICADOR).
SUMAT				EQU	    0X23	    ;SUMA DE LOS DATOS
;------------------------------------------------------------------------
				CLRF	    MULTI_O	    ;LIMPIAR DATOS SUMAR.
				CLRF	    MULTI_R	    ;LIMPIAR VECES A SUMAR.
				CLRF	    SUMAT	    ;LIMPIAR SUMA TOTAL.
MULTIPLICACION			MOVF	    PORTD,W
				MOVWF	    0X30	    ;D(DATO 2) LO GUARDA EN 0X27
				MOVWF	    MULTI_R	    ;MULIT_R A W
				MOVF	    0X20,W	    ;MOVEMOS MULTI_R A 0X20.
				MOVWF	    MULTI_O	    ;MUEVE W A REG MULTI_O
				CLRF	    W		    ;LIMPIAMOS ACUMULADOR
				MOVF	    MULTI_O,F	    ;F=MULTI_O
				BTFSS	    STATUS,Z	    ;Z=0?.
CONDICION2:			GOTO	    CONDICION1	
				GOTO	    MOSTRAR	    ;MOSTRAR POR PC AL MIMIR
CONDICION1:			MOVF	    MULTI_R,F	
				BTFSS	    STATUS,Z	    ;MULTI_R = 0?.
				GOTO	    MULTIPLICAR
				GOTO	    CONDICION3
MULTIPLICAR			MOVF	    MULTI_O,W	    ;MUEVE MULTI_O A WREG.
				ADDWF	    SUMAT,F	    ;SUMAT = SUMAT + MULTI_O.
				BTFSC	    STATUS,C	    ;C=O?.
				BSF	    PORTB,7
				DECF	    MULTI_R,F	    ;DECREMENTA EN 1 Y GUARDA EN EL MISMO.
				GOTO	    CONDICION2
CONDICION3:			MOVF	    SUMAT,W	    ;MUEVE ST A WREG.
				GOTO	    MOSTRAR	    ;MOSTRAR POR PC AL MIMIR
				
;----------------------------DIVISION----------------------------------------
DIVIDENDO			EQU	    0X31	    ;DATO DIVIDENDO.
DIVISOR				EQU	    0X32	    ;DATO DIVISOR.
COCIENTE			EQU	    0X33	    ;DATO DIVISION TOTAL.	    	
;----------------------------------------------------------------------------------
				CLRF	    DIVIDENDO
				CLRF	    DIVISOR
				CLRF	    COCIENTE
		
MOSTRAR:			MOVWF	    PORTC	    ;SALIDA DE WREG A PC.		
				BTFSS	    PORTB,0	    ;PB.0 = 1?.
				GOTO	    MOSTRAR	
				MOVF	    0X20,0	    ;MUEVE A WREG.
				MOVWF	    DIVIDENDO	    ;MUEVE A DIVIDENDO.
				MOVF	    0X30,0	    ;MUEVE A WREG.
				MOVWF	    DIVISOR	    ;MUEVE A DIVISOR.
				CLRF	    W		    ;LIMPIA WREG.
				MOVF	    DIVISOR,1	    
				BTFSS	    STATUS,Z	    ;DIVISOR=0?.
				GOTO	    DIVISION
				GOTO	    MIMIR
		
DIVISION:			MOVF	    DIVISOR,0
				SUBWF	    DIVIDENDO,0	    ;WREG=DIVISOR-DIVIDENDO.
				BTFSC	    STATUS,C	    ;C=0? DIVIDENDO=<DIVISOR?.
				GOTO	    DIVIDIR
				GOTO	    DIV_ACA
DIVIDIR:			MOVF	    DIVISOR,0	    ;MUEVE DIVISOR A WREG.
				SUBWF	    DIVIDENDO,1	    ;DIVIDENDO=DIVIDENDO-DIVISOR.
				INCF	    COCIENTE,1	    ;SE INCREMENTA A 1 Y SE GUARDA AHI.
				GOTO	    DIVISION
DIV_ACA:			MOVF	    DIVIDENDO,1	    ;PARA PREGUNTAR SI AÚN CONTIENE ALGO.
				BTFSS	    STATUS,Z	    ;DIVIDENDO = 0?.
				BSF	    PORTB,7
				MOVF	    COCIENTE,0	    ;MUEVELO A W
				GOTO	    MIMIR
;------------------------------------------------------------------------------				
MIMIR				MOVWF	    PORTC
				GOTO 	$
				END