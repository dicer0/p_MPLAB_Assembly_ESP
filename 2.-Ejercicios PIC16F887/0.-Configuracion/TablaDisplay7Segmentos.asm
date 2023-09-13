;En el display de 7 segmentos  hay 8 leds que se pueden encender para obtener un
;símbolo, estos son: DP, G, F, E, D, C, B y A.
;El órden en el que se colocó arriba es como se declarará en la tabla de abajo, 
;se puede colocar en forma hexadecimal o en forma binaria, como el display se 
;quiere que sea de ánodo común los leds se encenderían con 0 lógico pero como 
;en la placa son de cátodo común se encienden con 1 lógico.
	    ;ADDWF  F,D	(C, DC, Z): Suma el contenido del acumulador W con el 
	    ;contenido de un registro de RAM indicado por la dirección F y el 
	    ;resultado lo guarda en el acumulador W o en el mismo registro F.
	;EL REGISTRO PCL ES EL CONTADOR DEL PROGRAMA Y SE USA PARA ACCEDER A UNA
	;FILA ESPECÍFICA DE LA TABLA.
SIETESEG:	ADDWF		PCL,F ;PCL = PCL + W
		;El símbolo se pondra en forma binaria de la sig manera: 
		    ;B'DP + G + F + E + D + C + B + A'
		;Y alado se pondrá en su forma hexadecimal.
	    ;RETLW  K: Siempre se debe declarar dentro de una subrutina y lo que 
	    ;hace es cargar en el acumulador W el valor literal K declarado y 
	    ;luego saca al programa de la subrutina donde se encuentre.
	    ;RETLW = MOVLW + RETURN. Por lo que tarda 2 ciclos de máquina en 
	    ;ejecutarse.
		;0 en el display de ánodo común = 1100 0000 = 0XC0
		;0 en el display de cátodo común = 0011 1111 = 0X3F
		RETLW		B'00111111' ;W = 0X3F = 0 disp7seg
		;1 en el display de ánodo común = 1111 1001 = 0XF9
		;1 en el display de cátodo común = 0000 0110 = 0X06
		RETLW		B'00000110' ;W = 0X06 = 1 disp7seg
		;2 en el display de ánodo común = 1010 0100 = 0XA4
		;2 en el display de cátodo común = 0101 1011 = 0X5B
		RETLW		B'01011011' ;W = 0X5B = 2 disp7seg
		;3 en el display de ánodo común = 1011 0000 = 0XB0
		;3 en el display de cátodo común = 0100 1111 = 0X4F
		RETLW		B'01001111' ;W = 0X4F = 3 disp7seg
		;4 en el display de ánodo común = 1001 1001 = 0X99
		;4 en el display de cátodo común = 0110 0110 = 0X66
		RETLW		B'01100110' ;W = 0X66 = 4 disp7seg
		;5 en el display de ánodo común = 1001 0010 = 0X92
		;5 en el display de cátodo común = 0110 1101 = 0X6D
		RETLW		B'01101101' ;W = 0X6D = 5 disp7seg
		;6 en el display de ánodo común = 1000 0010 = 0X82
		;6 en el display de cátodo común = 0111 1101 = 0X7D
		RETLW		B'01111101' ;W = 0X7D = 6 disp7seg
		;7 en el display de ánodo común = 1111 1000 = 0XF8
		;7 en el display de cátodo común = 0000 0111 = 0X07
		RETLW		B'00000111' ;W = 0X07 = 7 disp7seg
		;8 en el display de ánodo común = 1000 0000 = 0X80
		;8 en el display de cátodo común = 0111 1111 = 0X7F
		RETLW		B'01111111' ;W = 0X7F = 8 disp7seg
		;9 en el display de ánodo común = 1001 1000 = 0X98
		;9 en el display de cátodo común = 0110 0111 = 0X67
		RETLW		B'01100111' ;W = 0X67 = 9 disp7seg
		
SIETESEGI:	ADDWF		PCL,F ;PCL = PCL + W
		;El símbolo se pondra en forma binaria de la sig manera: 
		    ;B'DP + G + F + E + D + C + B + A'
		;Y alado se pondrá en su forma hexadecimal.
	    ;RETLW  K: Siempre se debe declarar dentro de una subrutina y lo que 
	    ;hace es cargar en el acumulador W el valor literal K declarado y 
	    ;luego saca al programa de la subrutina donde se encuentre.
	    ;RETLW = MOVLW + RETURN. Por lo que tarda 2 ciclos de máquina en 
	    ;ejecutarse.
		RETLW		B'00000000'
		;0 en el display de ánodo común = 1100 0000 = 0XC0
		;0 en el display de cátodo común = 0011 1111 = 0X3F
		RETLW		B'00111111' ;W = 0X3F = 0 disp7seg
		;1 en el display de ánodo común = 1111 1001 = 0XF9
		;1 en el display de cátodo común = 0000 0110 = 0X06
		RETLW		B'00000110' ;W = 0X06 = 1 disp7seg
		;2 en el display de ánodo común = 1010 0100 = 0XA4
		;2 en el display de cátodo común = 0101 1011 = 0X5B
		RETLW		B'01011011' ;W = 0X5B = 2 disp7seg
		;3 en el display de ánodo común = 1011 0000 = 0XB0
		;3 en el display de cátodo común = 0100 1111 = 0X4F
		RETLW		B'01001111' ;W = 0X4F = 3 disp7seg
		;4 en el display de ánodo común = 1001 1001 = 0X99
		;4 en el display de cátodo común = 0110 0110 = 0X66
		RETLW		B'01100110' ;W = 0X66 = 4 disp7seg
		;5 en el display de ánodo común = 1001 0010 = 0X92
		;5 en el display de cátodo común = 0110 1101 = 0X6D
		RETLW		B'01101101' ;W = 0X6D = 5 disp7seg
		;6 en el display de ánodo común = 1000 0010 = 0X82
		;6 en el display de cátodo común = 0111 1101 = 0X7D
		RETLW		B'01111101' ;W = 0X7D = 6 disp7seg
		;7 en el display de ánodo común = 1111 1000 = 0XF8
		;7 en el display de cátodo común = 0000 0111 = 0X07
		RETLW		B'00000111' ;W = 0X07 = 7 disp7seg
		;8 en el display de ánodo común = 1000 0000 = 0X80
		;8 en el display de cátodo común = 0111 1111 = 0X7F
		RETLW		B'01111111' ;W = 0X7F = 8 disp7seg
		;9 en el display de ánodo común = 1001 1000 = 0X98
		;9 en el display de cátodo común = 0110 0111 = 0X67
		RETLW		B'01100111' ;W = 0X67 = 9 disp7seg
		
SIETESEGP:	ADDWF		PCL,F ;PCL = PCL + W
		;El símbolo se pondra en forma binaria de la sig manera: 
		    ;B'DP + G + F + E + D + C + B + A'
		;Y alado se pondrá en su forma hexadecimal.
	    ;RETLW  K: Siempre se debe declarar dentro de una subrutina y lo que 
	    ;hace es cargar en el acumulador W el valor literal K declarado y 
	    ;luego saca al programa de la subrutina donde se encuentre.
	    ;RETLW = MOVLW + RETURN. Por lo que tarda 2 ciclos de máquina en 
	    ;ejecutarse.
		;0 en el display de ánodo común = 1100 0000 = 0XC0
		;0 en el display de cátodo común = 0011 1111 = 0X3F
		RETLW		B'10111111' ;W = 0X3F = 0 disp7seg
		;1 en el display de ánodo común = 1111 1001 = 0XF9
		;1 en el display de cátodo común = 0000 0110 = 0X06
		RETLW		B'10000110' ;W = 0X06 = 1 disp7seg
		;2 en el display de ánodo común = 1010 0100 = 0XA4
		;2 en el display de cátodo común = 0101 1011 = 0X5B
		RETLW		B'11011011' ;W = 0X5B = 2 disp7seg
		;3 en el display de ánodo común = 1011 0000 = 0XB0
		;3 en el display de cátodo común = 0100 1111 = 0X4F
		RETLW		B'11001111' ;W = 0X4F = 3 disp7seg
		;4 en el display de ánodo común = 1001 1001 = 0X99
		;4 en el display de cátodo común = 0110 0110 = 0X66
		RETLW		B'11100110' ;W = 0X66 = 4 disp7seg
		;5 en el display de ánodo común = 1001 0010 = 0X92
		;5 en el display de cátodo común = 0110 1101 = 0X6D
		RETLW		B'11101101' ;W = 0X6D = 5 disp7seg
		;6 en el display de ánodo común = 1000 0010 = 0X82
		;6 en el display de cátodo común = 0111 1101 = 0X7D
		RETLW		B'11111101' ;W = 0X7D = 6 disp7seg
		;7 en el display de ánodo común = 1111 1000 = 0XF8
		;7 en el display de cátodo común = 0000 0111 = 0X07
		RETLW		B'10000111' ;W = 0X07 = 7 disp7seg
		;8 en el display de ánodo común = 1000 0000 = 0X80
		;8 en el display de cátodo común = 0111 1111 = 0X7F
		RETLW		B'11111111' ;W = 0X7F = 8 disp7seg
		;9 en el display de ánodo común = 1001 1000 = 0X98
		;9 en el display de cátodo común = 0110 0111 = 0X67
		RETLW		B'11100111' ;W = 0X67 = 9 disp7seg
		
SIETESEGPI:	ADDWF		PCL,F ;PCL = PCL + W
		;El símbolo se pondra en forma binaria de la sig manera: 
		    ;B'DP + G + F + E + D + C + B + A'
		;Y alado se pondrá en su forma hexadecimal.
	    ;RETLW  K: Siempre se debe declarar dentro de una subrutina y lo que 
	    ;hace es cargar en el acumulador W el valor literal K declarado y 
	    ;luego saca al programa de la subrutina donde se encuentre.
	    ;RETLW = MOVLW + RETURN. Por lo que tarda 2 ciclos de máquina en 
	    ;ejecutarse.
		RETLW		B'00000000'
		;0 en el display de ánodo común = 1100 0000 = 0XC0
		;0 en el display de cátodo común = 0011 1111 = 0X3F
		RETLW		B'10111111' ;W = 0X3F = 0 disp7seg
		;1 en el display de ánodo común = 1111 1001 = 0XF9
		;1 en el display de cátodo común = 0000 0110 = 0X06
		RETLW		B'10000110' ;W = 0X06 = 1 disp7seg
		;2 en el display de ánodo común = 1010 0100 = 0XA4
		;2 en el display de cátodo común = 0101 1011 = 0X5B
		RETLW		B'11011011' ;W = 0X5B = 2 disp7seg
		;3 en el display de ánodo común = 1011 0000 = 0XB0
		;3 en el display de cátodo común = 0100 1111 = 0X4F
		RETLW		B'11001111' ;W = 0X4F = 3 disp7seg
		;4 en el display de ánodo común = 1001 1001 = 0X99
		;4 en el display de cátodo común = 0110 0110 = 0X66
		RETLW		B'11100110' ;W = 0X66 = 4 disp7seg
		;5 en el display de ánodo común = 1001 0010 = 0X92
		;5 en el display de cátodo común = 0110 1101 = 0X6D
		RETLW		B'11101101' ;W = 0X6D = 5 disp7seg
		;6 en el display de ánodo común = 1000 0010 = 0X82
		;6 en el display de cátodo común = 0111 1101 = 0X7D
		RETLW		B'11111101' ;W = 0X7D = 6 disp7seg
		;7 en el display de ánodo común = 1111 1000 = 0XF8
		;7 en el display de cátodo común = 0000 0111 = 0X07
		RETLW		B'10000111' ;W = 0X07 = 7 disp7seg
		;8 en el display de ánodo común = 1000 0000 = 0X80
		;8 en el display de cátodo común = 0111 1111 = 0X7F
		RETLW		B'11111111' ;W = 0X7F = 8 disp7seg
		;9 en el display de ánodo común = 1001 1000 = 0X98
		;9 en el display de cátodo común = 0110 0111 = 0X67
		RETLW		B'11100111' ;W = 0X67 = 9 disp7seg