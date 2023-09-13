;19.- Crea un contador hexadecimal que cuente de 0 a F y muestre el resultado en 
;un display de 7 segmentos.
		
;La configuraci�n del PIC ser� jalada por una instrucci�n INCLUDE, para poder 
;hacerlo debo poner la direcci�n de la carpeta que llega hasta donde se 
;encuentra el archivo dentro de este proyecto de MPLABX en mi computadora, con 
;todo y el nombre del archivo que es Configuracion_PIC.asm de la siguiente 
;manera:
				INCLUDE		<C:\Users\diego\OneDrive\Documents\The_MechaBible\p_MPLAB (Ensamblador)_ESP\2.-Ejercicios PIC16F887\0.-Configuracion\Configuracion_PIC.asm>
				GOTO		INICIO
				
;En el display de 7 segmentos  hay 8 leds que se pueden encender para obtener un
;s�mbolo, estos son: DP, G, F, E, D, C, B y A.
;El �rden en el que se coloc� arriba es como se declarar� en la tabla de abajo, 
;se puede colocar en forma hexadecimal o en forma binaria, como el display se 
;quiere que sea de �nodo com�n los leds se encender�an con 0 l�gico pero como 
;en la placa son de c�todo com�n se encienden con 1 l�gico.
	    ;ADDWF  F,D	(C, DC, Z): Suma el contenido del acumulador W con el 
	    ;contenido de un registro de RAM indicado por la direcci�n F y el 
	    ;resultado lo guarda en el acumulador W o en el mismo registro F.
	;EL REGISTRO PCL ES EL CONTADOR DEL PROGRAMA Y SE USA PARA ACCEDER A UNA
	;FILA ESPEC�FICA DE LA TABLA.
SIETESEG:			ADDWF		PCL,F ;PCL = PCL + W
			;El s�mbolo se pondra en forma binaria de la sig manera: 
			    ;B'DP + G + F + E + D + C + B + A'
			;Y alado se pondr� en su forma hexadecimal
	    ;RETLW  K: Siempre se debe declarar dentro de una subrutina y lo que 
	    ;hace es cargar en el acumulador W el valor literal K declarado y 
	    ;luego saca al programa de la subrutina donde se encuentre.
	    ;RETLW = MOVLW + RETURN. Por lo que tarda 2 ciclos de m�quina en 
	    ;ejecutarse.
				;0 en el display de �nodo com�n = 1100 0000 = 0XC0
				;0 en el display de c�todo com�n = 0011 1111 = 0X3F
				RETLW		B'11000000' ;W = 0X3F = 0 disp7seg
				;1 en el display de �nodo com�n = 1111 1001 = 0XF9
				;1 en el display de c�todo com�n = 0000 0110 = 0X06
				RETLW		B'11111001' ;W = 0X06 = 1 disp7seg
				;2 en el display de �nodo com�n = 1010 0100 = 0XA4
				;2 en el display de c�todo com�n = 0101 1011 = 0X5B
				RETLW		B'10100100' ;W = 0X5B = 2 disp7seg
				;3 en el display de �nodo com�n = 1011 0000 = 0XB0
				;3 en el display de c�todo com�n = 0100 1111 = 0X4F
				RETLW		B'10110000' ;W = 0X4F = 3 disp7seg
				;4 en el display de �nodo com�n = 1001 1001 = 0X99
				;4 en el display de c�todo com�n = 0110 0110 = 0X66
				RETLW		B'10011001' ;W = 0X66 = 4 disp7seg
				;5 en el display de �nodo com�n = 1001 0010 = 0X92
				;5 en el display de c�todo com�n = 0110 1101 = 0X6D
				RETLW		B'10010010' ;W = 0X6D = 5 disp7seg
				;6 en el display de �nodo com�n = 1000 0010 = 0X82
				;6 en el display de c�todo com�n = 0111 1101 = 0X7D
				RETLW		B'10000010' ;W = 0X7D = 6 disp7seg
				;7 en el display de �nodo com�n = 1111 1000 = 0XF8
				;7 en el display de c�todo com�n = 0000 0111 = 0X07
				RETLW		B'11111000' ;W = 0X07 = 7 disp7seg
				;8 en el display de �nodo com�n = 1000 0000 = 0X80
				;8 en el display de c�todo com�n = 0111 1111 = 0X7F
				RETLW		B'10000000' ;W = 0X7F = 8 disp7seg
				;9 en el display de �nodo com�n = 1001 1000 = 0X98
				;9 en el display de c�todo com�n = 0110 0111 = 0X67
				RETLW		B'10011000' ;W = 0X67 = 9 disp7seg
				;A en el display de �nodo com�n = 1000 1000 = 0X88
				RETLW		B'10001000' ;W = 0X88 = A disp7seg
				;b en el display de �nodo com�n = 1000 0011 = 0X83
				RETLW		B'10000011' ;W = 0X83 = b disp7seg
				;C en el display de �nodo com�n = 1100 0110 = 0XC6
				RETLW		B'11000110' ;W = 0XC6 = C disp7seg
				;d en el display de �nodo com�n = 1010 0001 = 0XA1
				RETLW		B'10100001' ;W = 0XA1 = d disp7seg
				;E en el display de �nodo com�n = 1000 0110 = 0X86
				RETLW		B'10000110' ;W = 0X86 = E disp7seg
				;F en el display de �nodo com�n = 1000 0110 = 0X8E
				RETLW		B'10000110' ;W = 0X8E = F disp7seg
				
INICIO:	    ;CLRF   F	(Z): Llena de ceros la direcci�n F del registro RAM 
	    ;indicado. Siempre levanta la bandera ceros, Z = 1.
				CLRF		TRISD
			;Hace todos los pines del puerto D sean salidas.
				CLRF		STATUS 
				;Con esto ya estoy en el banco 0
				;Banco 0: RP1 = 0, RP0 = 0
				;Banco 1: RP1 = 0, RP0 = 1
				;Banco 2: RP1 = 1, RP0 = 0
				;Banco 3: RP1 = 1, RP0 = 1
	    ;CLRF   F	(Z): Llena de ceros la direcci�n F del registro RAM 
	    ;indicado, como en este caso se usa un registro de prop�sito 
	    ;espec�fico (los puertos) en vez de poner un n�mero hexadecimal 
	    ;para indicar el registro F, pondr� su directiva EQU (osea su 
	    ;nombre). Esta instrucci�n siempre levanta la bandera ceros, Z = 1.
				CLRF		0X20 ; 0X20 = B'00000000' = 0X00
				;Limpia el registro general 20 de la RAM
	    
	    ;MOVF   F, D: Lee el contenido de un registro de la RAM indicado 
	    ;por la direcci�n F y lo coloca en el mismo registro F o en el 
	    ;acumulador W, dependiendo de la directiva EQU que ponga en donde 
	    ;dice D.
SACADATO:			MOVF		0X20,W ;W = 0X20 = B'00000000'
	    ;CALL   k: Sirve para llamar una subrutina por su nombre y ejecutar 
	    ;una acci�n que se pueda repetir varias dentro del mismo c�digo, de 
	    ;esta manera esa acci�n no la debo escribir varias veces.
				CALL		SIETESEG
	    ;MOVWF  F: Lee el contenido del acumulador W y lo coloca en un 
	    ;registro de la RAM indicado por la direcci�n F.
				MOVWF		PORTD
	    ;LLAMA LA SUBRUTINA DE TIEMPO QUE TARDA 1 SEGUNDO
				CALL		T1S
	    ;INCF   F, D (Z): Le suma 1 (incrementa) a lo que haya almacenado 
	    ;en la direcci�n F del registro de RAM indicado y el resultado lo 
	    ;coloca en el mismo registro F o en el acumulador W, dependiendo de 
	    ;la directiva EQU que ponga en donde dice D. 
	    ;Solo afecta a la bandera Z = ceros. 
	    ;Si se incrementa en 1 al valor m�ximo que puede adoptar un n�mero 
	    ;binario, lo empujar� a volverse cero y se repetir� el conteo.
				INCF		0X20,F ;0X20 = 0X20 + 1

;AHORA SE COLOCAR� UNA M�SCARA AND CON EL VALOR 0F PARA QUE SE PUEDA HACER UN 
;CONTEO SOLAMENTE CON LOS SEGUNDOS BITS DEL N�MERO BINARIO DE 8 BITS EN EL 
;REGISTRO, YA QUE ESTOS SON LOS QUE DAR�N LOS DIGITOS DE 0 A F.
	    ;MOVLW  K: Coloca directamente en el acumulador W un n�mero binario 
	    ;cualquiera de 8 bits dado por el valor literal K indicado en 
	    ;hexadecimal, poniendo 0Xn�mero_hexadecimal.
				MOVLW		0X0F ;W = 0F = B'0000 1111'
	    ;ANDWF  F, D (Z): Realiza la funci�n l�gica AND entre lo que haya 
	    ;en la direcci�n F del registro RAM y el acumulador W, guardando su 
	    ;resultado en el mismo registro F o en el acumulador W, dependiendo 
	    ;de lo que se ponga en el par�metro D.
	    ;A esto se le llama m�scara AND y lo que har� es obligar a ciertos 
	    ;bits del registro F que se vuelvan 0, dejando a los dem�s intactos. 
	    ;La m�scara en este caso se colocar�a previamente en el acumulador 
	    ;W, poniendo un n�mero binario de 8 bits que tenga un 0 donde quiera 
	    ;que se obligue a los bits del registro F que se vuelvan cero y 
	    ;dejando un 1 en la posici�n de los bits del registro f que no 
	    ;quiero afectar.
		;Funciones de los bits en la m�scara:
		    ;0: obliga a los bits a volverse 0.
		    ;1: No afecta en nada, deja los bits en su forma inicial.
	    ;Solo se afecta a la bandera Z = ceros.
				ANDWF		0X20,F
				GOTO		SACADATO
T1S:				MOVLW		.1	;var 3
				MOVWF		0X64
				MOVLW		.213	;var 2
				MOVWF		0X65
				MOVLW		.78	;var 1
				MOVWF		0X66
				CALL		ST3V
				RETURN
				INCLUDE		<C:\Users\diego\OneDrive\Documents\The_MechaBible\p_MPLAB (Ensamblador)_ESP\2.-Ejercicios PIC16F887\0.-Configuracion\SubRutinaTiempo.asm>
				END