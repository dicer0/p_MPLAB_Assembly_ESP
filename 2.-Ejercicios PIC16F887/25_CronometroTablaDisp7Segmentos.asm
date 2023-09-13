;24.-Cronómetro en seis displays de 7 segmentos y un controlador que tiene las 
;siguientes funciones:
;Se cuenta con 6 displays de 7 segmentos, el tiempo que debe tardar cada valor 
;desplegándose es de 1/100 s = 10 milisegundos = 10,000 us.
;Existen 3 push buttons, cada uno con su respectivo antirrebote.
    ;Push button A: Reset.
    ;Push button B: 
	;Si está presionado el conteo será descendente.
	;Si no está presionado se hace un conteo ascendente.
    ;Push button C: Se acciona cada vez que el programa termina de desplegar 
    ;las 6 cifras.
	;Si está presionado el contador se pondrá en pausa y se quedará 
	;desplegado el valor que se quedó antes de oprimir el botón, saldrá de 
	;este estado de pausa cuando se presione el botón de nuevo.
	
	;Si no está presionado pregunta si se ha presionado el botón 2 para 
	;hacer el conteo ascendente o descendente.

UNIS		EQU		0X20 ;UNIDAD ANTES DEL PUNTO
DECI		EQU		0X21 ;DECIMA ANTES DEL PUNTO	
UNID		EQU		0X22 ;UNIDAD DESPUES DEL PUNTO 
DECE		EQU		0X23 ;DECENA DESPUES DEL PUNTO	
CENT		EQU		0X24 ;CENTENA DESPUES DEL PUNTO 
UMIL		EQU		0X25 ;MILLARES DESPUES DEL PUNTO
CONT60		EQU		0X26 ;CONTADOR
	
		INCLUDE	    <C:\Users\diego\OneDrive\Documents\MechaBible\p_MPLAB (Ensamblador)\2.-Ejercicios PIC16F887\Configuracion_PIC.asm>
;Lo que hace la configuración es indicar el PIC que estoy usando, declarar las 
;2 palabras de configuración, usar otra directiva INCLUDE para jalar el archivo 
;P16F887.INC que incluye las 35 instrucciones del PIC junto con las directivas 
;EQU (los nombres) de sus registros, la directiva ORG que indica la dirección de 
;la memoria FLASH desde donde se empezará a guardar el código, el limpiado 
;(poner en 0) de todos los bits de los puertos (A, B, C, D y E) y hacer que los 
;puertos A, B y E (que son los únicos que pueden ser analógicos o digitales) 
;sean todos entradas o salidas digitales.
		GOTO		INICIO ;SALTA A EJECUTAR EL PRROGRAMA PRINCIPAL
		INCLUDE	    <C:\Users\diego\OneDrive\Documents\The_MechaBible\p_MPLAB (Ensamblador)_ESP\2.-Ejercicios PIC16F887\0.-Configuracion\TablaDisplay7Segmentos.asm> 
		;Tabla que enciende los leds DP, G, F, E, D, C, B y A de los displays de 7 segmentos.
		INCLUDE	    <C:\Users\diego\OneDrive\Documents\The_MechaBible\p_MPLAB (Ensamblador)_ESP\2.-Ejercicios PIC16F887\0.-Configuracion\SubRutinaTiempo.asm>
		;Subrutinas de tiempo de 1, 2 y 3 variables.

INICIO:		CLRF		TRISD ;El puerto D enciende los leds de los displays
		CLRF		TRISA ;El puerto A enciende cada display
		;Hace que todos los pines del puerto A y D sean salidas.
		CLRF		STATUS	;SE CAMBIA AL BANCO 0.
		CALL		REBOTE
		BTFSC		PORTB,0
		GOTO		INVERSA
		CALL		REBOTE
		
;Limpieza de los registros de propósito general 0X20 a 0X25 que guardarán el 
;valor binario que encenderá cada led del display para mostrar un dígito.
LIMPIATODO:	CLRF		UMIL
LIMPIACENT:	CLRF		CENT
LIMPIADECE:	CLRF		DECE
LIMPIAUNID:	CLRF		UNID
LIMPIADECI:	CLRF		DECI
LIMPIAUNIS:	CLRF		UNIS
		

RECARGA60:	BTFSC		PORTB,0
		GOTO		INVERSA
		;Esto sirve para poner pausa si es que ha sido presionado el 
		;boton 2.
		MOVLW		.1
		MOVWF		CONT60
		
SACADATO:	MOVF		UNIS,W
		CALL		SIETESEG
		MOVWF		PORTD
		BSF		PORTA,0		;.UNIDADES DECIMALES
		CALL		T1600U
		CALL		T45U
		NOP
		BCF		PORTA,0

		MOVF		DECI,W
		CALL		SIETESEG
		MOVWF		PORTD
		BSF		PORTA,1		;.DECENAS DECIMALES
		CALL		T1600U
		CALL		T45U
		NOP
		BCF		PORTA,1	

		MOVF		UNID,W
		CALL		SIETESEGP		
		MOVWF		PORTD
		BSF		PORTA,2		;UNIDADES
		CALL		T1600U
		CALL		T45U
		NOP
		BCF		PORTA,2	

		MOVF		DECE,W
		CALL		SIETESEG	
		MOVWF		PORTD
		BSF		PORTA,3		;DECENAS
		CALL		T1600U
		CALL		T45U
		BCF		PORTA,3
		
		MOVF		CENT,W
		CALL		SIETESEG		
		MOVWF		PORTD
		BSF		PORTA,4		;CENTENAS
		CALL		T1600U
		CALL		T45U	
		BCF		PORTA,4
		
		MOVF		UMIL,W
		CALL		SIETESEG		
		MOVWF		PORTD
		BSF		PORTA,5		;MILLARES
		CALL		T1600U
		CALL		T45U
		BCF		PORTA,5	
		
		BTFSC		PORTB,1
		CALL		PAUSA1
		BTFSC		PORTB,0
		GOTO		INVERSA
		DECFSZ		CONT60, F
		GOTO		SACADATO
		
CONTADOR_UNIS:	INCF		UNIS,F
		MOVLW		.10
		XORWF		UNIS,W
		;MÁSCARA XOR USADA PARA LIMITAR EL CONTEO HASTA 10 DECIMAL
		;Si se levanta la bandera ceros al usarse una máscara XOR es 
		;porque los dos números comparados son iguales.
		BTFSS		STATUS,Z
		GOTO		RECARGA60

CONTADOR_DECI:	INCF		DECI,F
		MOVLW		.10
		XORWF		DECI,W
		BTFSS		STATUS,Z
		GOTO		LIMPIAUNIS

CONTADOR_UNID:	INCF		UNID,F
		MOVLW		.10
		XORWF		UNID,W
		BTFSS		STATUS,Z
		GOTO		LIMPIADECI
		
CONTADOR_DECE:	INCF		DECE,F
		MOVLW		.10
		XORWF		DECE,W
		BTFSS		STATUS,Z
		GOTO		LIMPIAUNID
		
CONTADOR_CENT:	INCF		CENT,F
		MOVLW		.10
		XORWF		CENT,W
		BTFSS		STATUS,Z
		GOTO		LIMPIADECE
		
CONTADOR_UMIL:	INCF		UMIL,F
		MOVLW		.10
		XORWF		UMIL,W
		BTFSS		STATUS,Z
		GOTO		LIMPIACENT
		GOTO		LIMPIATODO

INVERSA:	CALL		RECARGA
		BTFSC		PORTB,0
		GOTO		$-1
		CALL		REBOTE
		
LIMPIATODOI:	MOVLW		.10
		MOVWF		UMIL	
LIMPIACENTI:	MOVLW		.10
		MOVWF		CENT
LIMPIADECEI:	MOVLW		.10
		MOVWF		DECE
LIMPIAUNIDI:	MOVLW		.10
		MOVWF		UNID
LIMPIADECII:	MOVLW		.10
		MOVWF		DECI
LIMPIAUNISI:	MOVLW		.10
		MOVWF		UNIS
		
RECARGA60I:	BTFSC		PORTB,0
		GOTO		INVERSA
		;Esto sirve para poner pausa si es que ha sido presionado el 
		;boton 2.
		MOVLW		.1
		MOVWF		CONT60

SACADATOI:	MOVF		UNIS,W
		CALL		SIETESEGI
		MOVWF		PORTD
		BSF		PORTA,0		;.UNIDADES DECIMALES
		CALL		T1600U
		CALL		T45U
		NOP
		BCF		PORTA,0	

		MOVF		DECI,W
		CALL		SIETESEGI	
		MOVWF		PORTD
		BSF		PORTA,1		;.DECENAS DECIMALES
		CALL		T1600U
		CALL		T45U
		NOP
		BCF		PORTA,1	

		MOVF		UNID,W
		CALL		SIETESEGPI			
		MOVWF		PORTD
		BSF		PORTA,2		;UNIDADES
		CALL		T1600U
		CALL		T45U
		NOP
		BCF		PORTA,2	

		MOVF		DECE,W
		CALL		SIETESEGI			
		MOVWF		PORTD
		BSF		PORTA,3		;DECENAS
		CALL		T1600U
		CALL		T45U
		BCF		PORTA,3
		
		MOVF		CENT,W
		CALL		SIETESEGI			
		MOVWF		PORTD
		BSF		PORTA,4		;CENTENAS
		CALL		T1600U
		CALL		T45U
		BCF		PORTA,4
		
		MOVF		UMIL,W
		CALL		SIETESEGI		
		MOVWF		PORTD
		BSF		PORTA,5		;MILLARES
		CALL		T1600U
		CALL		T45U
		BCF		PORTA,5	

		BTFSC		PORTB,1
		CALL		PAUSA1
		BTFSC		PORTB,0
		GOTO		RECARGA60I
		DECFSZ		CONT60, F
		GOTO		SACADATO

CONT_INV_UNIS:	DECF		UNIS,F
		MOVLW		.0
		XORWF		UNIS,W
		BTFSS		STATUS,Z
		GOTO		RECARGA60I

CONT_INV_DECI:	DECF		DECI,F
		MOVLW		.0
		XORWF		DECI,W
		BTFSS		STATUS,Z
		GOTO		LIMPIAUNISI

CONT_INV_UNID:	DECF		UNID,F
		MOVLW		.0
		XORWF		UNID,W
		BTFSS		STATUS,Z
		GOTO		LIMPIADECII
		
CONT_INV_DECE:	DECF		DECE,F
		MOVLW		.0
		XORWF		DECE,W
		BTFSS		STATUS,Z
		GOTO		LIMPIAUNIDI
		
CONT_INV_CENT:	DECF		CENT,F
		MOVLW		.0
		XORWF		CENT,W
		BTFSS		STATUS,Z
		GOTO		LIMPIADECEI
		
CONT_INV_UMIL:	DECF		UMIL,F
		MOVLW		.0
		XORWF		UMIL,W
		BTFSS		STATUS,Z
		GOTO		LIMPIACENTI
		GOTO		LIMPIATODOI
		

PAUSA1:		BTFSC		PORTB,1
		GOTO		$-1
		CALL		REBOTE
		
SACADATOP:	MOVF		UNIS,W
		CALL		SIETESEG
		MOVWF		PORTD
		BSF		PORTA,0		;.UNIDADES
		CALL		T1600U
		CALL		T45U
		NOP
		BCF		PORTA,0	

		MOVF		DECI,W
		CALL		SIETESEG	
		MOVWF		PORTD
		BSF		PORTA,1		;.DECENAS
		CALL		T1600U
		CALL		T45U
		NOP
		BCF		PORTA,1	

		MOVF		UNID,W
		CALL		SIETESEGP		
		MOVWF		PORTD
		BSF		PORTA,2		;UNIDADES
		CALL		T1600U
		CALL		T45U
		NOP
		BCF		PORTA,2	

		MOVF		DECE,W
		CALL		SIETESEG		
		MOVWF		PORTD
		BSF		PORTA,3		;DECENAS
		CALL		T1600U
		CALL		T45U
		BCF		PORTA,3
		
		MOVF		CENT,W
		CALL		SIETESEG		
		MOVWF		PORTD
		BSF		PORTA,4		;CENTENAS
		CALL		T1600U
		CALL		T45U
		BCF		PORTA,4
		
		MOVF		UMIL,W
		CALL		SIETESEG		
		MOVWF		PORTD
		BSF		PORTA,5		;UNIDADES DE MIL
		CALL		T1600U
		CALL		T45U
		BCF		PORTA,5
		CALL		T1600U
		CALL		T45U
		BCF		PORTA,5
		BTFSS		PORTB,1
		GOTO		SACADATOP
		BTFSC		PORTB,1
		GOTO		$-1	
		CALL		REBOTE
		RETURN

T1600U:		MOVLW		.2
		MOVWF		0X61
		MOVLW		.132
		MOVWF		0X62
		CALL		ST2V
		NOP
		RETURN			

T45U:		MOVLW		.5
		MOVWF		0X60
		CALL		ST1V
		NOP 
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		;45 microsegundos
		RETURN

REBOTE:		MOVLW		.176
		MOVWF		0X61
		MOVLW		.23
		MOVWF		0X62
		CALL		ST2V
		NOP
		RETURN
		
RECARGA:	BTFSC		PORTB,0
		GOTO		$-1
		;Esto sirve para poner pausa si es que ha sido presionado el 
		;boton 2.
		MOVLW		.1
		MOVWF		CONT60
		RETURN
		END