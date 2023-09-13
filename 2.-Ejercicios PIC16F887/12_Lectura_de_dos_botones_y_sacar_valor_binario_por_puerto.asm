;12.- Lea el pin 0 del puerto A (PORTA.0) y el pin 3 del puerto C (PORTC.3):
;Si el PORTA.0 = 0 y el PORTC.3 = 0, el PORTD debe sacar 0XF3 y el PORTB debe sacar 0X89.
;Si el PORTA.0 = 0 y el PORTC.3 = 1, el PORTD debe sacar 0X45 y el PORTB debe sacar 0X7C.
;Si el PORTA.0 = 1 y el PORTC.3 = 0, el PORTD debe sacar 0X94 y el PORTB debe sacar 0X42.
;Si el PORTA.0 = 1 y el PORTC.3 = 1, el PORTD debe sacar 0XFF y el PORTB debe sacar 0XDE.
	    
;La configuraci�n del PIC ser� jalada por una instrucci�n INCLUDE, para poder 
;hacerlo debo poner la direcci�n de la carpeta que llega hasta donde se 
;encuentra el archivo dentro de este proyecto de MPLABX en mi computadora, con 
;todo y el nombre del archivo que es Configuracion_PIC.asm de la siguiente 
;manera:
	    INCLUDE	<C:\Users\diego\OneDrive\Documents\The_MechaBible\p_MPLAB (Ensamblador)_ESP\2.-Ejercicios PIC16F887\0.-Configuracion\Configuracion_PIC.asm>
;Lo que hace la configuraci�n es indicar el PIC que estoy usando, declarar las 
;2 palabras de configuraci�n, usar otra directiva INCLUDE para jalar el archivo 
;P16F887.INC que incluye las 35 instrucciones del PIC junto con las directivas 
;EQU (los nombres) de sus registros, la directiva ORG que indica la direcci�n de 
;la memoria FLASH desde donde se empezar� a guardar el c�digo, el limpiado 
;(poner en 0) de todos los bits de los puertos (A, B, C, D y E) y hacer que los 
;puertos A, B y E (que son los �nicos que pueden ser anal�gicos o digitales) 
;sean todos entradas o salidas digitales.
	    
;Ahora si ya puedo resolver el ejercicio:
;12.- Lea el pin 0 del puerto A (PORTA.0) y el pin 3 del puerto C (PORTC.3):
;Si el PORTA.0 = 0 y el PORTC.3 = 0, el PORTD debe sacar 0XF3 y el PORTB debe sacar 0X89.
;Si el PORTA.0 = 0 y el PORTC.3 = 1, el PORTD debe sacar 0X45 y el PORTB debe sacar 0X7C.
;Si el PORTA.0 = 1 y el PORTC.3 = 0, el PORTD debe sacar 0X94 y el PORTB debe sacar 0X42.
;Si el PORTA.0 = 1 y el PORTC.3 = 1, el PORTD debe sacar 0XFF y el PORTB debe sacar 0XDE.

;PUERTOS COMO ENTRADAS O SALIDAS
;Para indicar si los distintos pines de los puertos son entradas o salidas debo
;cambiar los bits de los registros TRISA, TRISB, TRISC, TRISD y TRISE, indicando
;de la siguiente manera si son entradas o salidas:
	    ;Bit del registro TRIS: 1 = Entrada (Input)
	    ;Bit del registro TRIS: 0 = Salida (Output)
;De esta manera se indica para cada registro TRIS, que est� asociado a cada 
;puerto A, B, C, D o E si su pin es de entrada o salida. 
;Por default todos los bits de los registros TRIS despu�s de un reset se ponen 
;en 1 l�gico, osea que son entradas, por lo que solo debo cambiar y poner en 0 
;los bits asociados a los pines de los puertos que quiero que se vuelvan salidas.

;En este caso los puertos B y C son de entrada, el A y D son de salida, por lo 
;que solo debo cambiar al registro TRIS asociado al puerto A y D:
	    ;CLRF   F	(Z): Llena de ceros la direcci�n F del registro RAM 
	    ;indicado. Siempre levanta la bandera ceros, Z = 1.
	    CLRF	TRISB ;Hace todos los pines del puerto B sean salidas.
	    CLRF	TRISD ;Hace todos los pines del puerto D sean salidas.

;LUEGO ME DEBO REGRESAR AL BANCO 0 PARA QUE PUEDA MANIPULAR LOS PUERTOS
	    BCF		STATUS, RP1 ;RP1 = 0
	    BCF		STATUS, RP0 ;RP0 = 0
	    ;Con esto ya estoy en el banco 0
	    ;Banco 0: RP1 = 0, RP0 = 0
	    ;Banco 1: RP1 = 0, RP0 = 1
	    ;Banco 2: RP1 = 1, RP0 = 0
	    ;Banco 3: RP1 = 1, RP0 = 1

;AHORA VAMOS A USAR UNA DE LAS 35 OPERACIONES QUE ME PERMITEN REALIZAR 
;CONDICIONALES PARECIDOS A UN IF.
;NO CONFUNDIR BTFSS (BRINCA CON B = 1) CON BTFSC (BRINCA CON B = 0).
    ;BTFSS   F, B: Esta operaci�n es lo m�s parecido a un condicional if que 
    ;existe en el idioma ensamblador, su condici�n eval�a si el bit B del 
    ;registro F es uno o cero y si es 1 se brinca la siguiente instrucci�n, 
    ;sino sigue la ejecuci�n normal:
	;Si el bit B es cero (0):
	    ;Sigue la ejecuci�n normal del c�digo.
	    ;Tarda 1 ciclo de m�quina en ejecutarse.
	    
	;Si el bit B es uno (1): 
	    ;SE BRINCA LA SIGUIENTE INSTRUCCI�N QUE HAYA EN EL C�DIGO (aumenta 
	    ;en 1 al contador de programa o PC).
	    ;Tarda 2 ciclos de m�quina en ejecutarse.
	    
    ;La posici�n del bit B en el registro F se puede indicar poniendo el nombre 
    ;del bit (osea su directiva EQU) o contando desde cero en decimal, osea 
    ;poniendo 0, 1, 2, 3, 4, 5, 6 o 7. En este caso queremos checar el estado de 
    ;uno de los pines del puerto A, por lo que debemos acceder al registro de 
    ;prop�sito espec�fico por su nombre o directiva EQU (osea PORTA) en vez de 
    ;poner un n�mero hexadecimal para indicar el registro F y pondr� un n�mero 
    ;decimal como B para indicar el PIN que quiero alcanzar del puerto, en este 
    ;como en la instrucci�n del ejercicio dice PORTA.0, pondr� el n�mero cero.
CHECA:	    BTFSS	PORTA, 0 ;Checa el valor del PIN 0 del Puerto A
	;Si PORTA.0 = 0:
	    ;Sigue la ejecuci�n normal del c�digo.
	    ;Salta con un GOTO a una parte del c�digo donde se analiza el valor 
	    ;de PORTC.3 ya sabiendo que PORTA.0 = 0, osea PA0.
		;PORTA.0 = 0 y PORTC.3 = 0
		    ;PORTD = 0XF3.
		    ;PORTB = 0X89.
		;PORTA.0 = 0 y PORTC.3 = 1
		    ;PORTD = 0X45.
		    ;PORTB = 0X7C.
	    
	;Si PORTA.0 = 1:
	    ;SE SALTA LA SIGUIENTE L�NEA DEL C�DIGO.
	    ;Salta con un GOTO a una parte del c�digo donde se analiza el valor 
	    ;de PORTC.3 ya sabiendo que PORTA.0 = 1, osea PA1.
		;PORTA.0 = 1 y PORTC.3 = 0
		    ;PORTD = 0X94.
		    ;PORTB = 0X42.
		;PORTA.0 = 1 y PORTC.3 = 1
		    ;PORTD = 0XFF.
		    ;PORTB = 0XDE.
	    
;CON INSTRUCCIONES GOTO PUEDO SALTAR A UNAS PARTES DEL C�DIGO DONDE SE EVAL�A EL
;ESTADO DEL PIN 3 DEL PUERTO C YA SABIENDO EL VALOR DE PORTA.0:
	    ;GOTO   k: Sirve para hacer que el programa brinque a otra parte del 
	    ;c�digo, indicado por un signo de pesos seguido de un signo menos y 
	    ;el n�mero de instrucciones hacia atr�s que quiero que brinque el 
	    ;programa o por una directiva EQU que tenga el nombre de la parte 
	    ;del c�digo a donde quiero que brinque el programa que se debe poner
	    ;en el lugar del valor literal k.
	    GOTO	PA0
	    ;Si PORTA.0 = 0 se ejecuta este GOTO.
	    ;Si PORTA.0 = 1 se lo brinca.
	    
	    GOTO	PA1
	    ;Si PORTA.0 = 1 se ejecuta este GOTO porque se habr� brincado el 
	    ;anterior.

;YA SABIENDO QUE PORTA.0 = 0, PRIMERO CARGA EN EL ACUMULADOR W EL VALOR QUE 
;PUEDE ADOPTAR EL PUERTO D SI PORTC.3 = 0, OSEA W = 0XF3, LUEGO EVAL�A EL VALOR 
;DE PORTC.3 Y SI ES 0, SE BRINCAR� EL GOTO PARA ASIGNAR W = 0X89 = PORTB, SI 
;PORTC.3 ES 1, CON UN GOTO SE BRINCAR� A LA PARTE PA0_PC1.
    ;PORTA.0 = 0 y PORTC.3 = 0
	;PORTD = 0XF3.
	;PORTB = 0X89.
	    ;MOVLW  K: Coloca directamente en el acumulador W un n�mero binario 
	    ;cualquiera de 8 bits dado por el valor literal K indicado en 
	    ;hexadecimal, poniendo 0Xn�mero_hexadecimal.
PA0:	    MOVLW	0XF3 ;W = 0XF3
    ;BTFSC   F, B: Esta operaci�n es lo m�s parecido a un condicional if que 
    ;existe en el idioma ensamblador, su condici�n eval�a si el bit B del 
    ;registro F es uno o cero y si es 0 se brinca la siguiente instrucci�n, 
    ;sino sigue la ejecuci�n normal:
	;Si el bit B es cero (0):
	    ;SE BRINCA LA SIGUIENTE INSTRUCCI�N QUE HAYA EN EL C�DIGO (aumenta 
	    ;en 1 al contador de programa o PC).
	    ;Tarda 2 ciclos de m�quina en ejecutarse.
	    
	;Si el bit B es uno (1): 
	    ;Sigue la ejecuci�n normal del c�digo.
	    ;Tarda 1 ciclo de m�quina en ejecutarse.
    	    BTFSC	PORTC, 3 ;Checa el valor del PIN 3 del Puerto C

	    ;GOTO   k: Sirve para hacer que el programa brinque a otra parte del 
	    ;c�digo, indicado por una directiva EQU que tenga el nombre de la 
	    ;parte del c�digo a donde quiero que brinque el programa.
	    GOTO	PA0_PC1
	    ;Si PORTC.3 = 0 se lo brinca al GOTO.
	    ;Si PORTC.3 = 1 se ejecuta este GOTO.
	    	    
	    ;MOVWF   F: Lee el contenido del acumulador W y lo coloca en un 
	    ;registro de la RAM indicado por la direcci�n F.
	    MOVWF	PORTD ;PORTD = W = 0XF3
	    ;MOVLW  K: Coloca directamente en el acumulador W un n�mero binario 
	    ;cualquiera de 8 bits dado por el valor literal K indicado en forma
	    ;hexadecimal, poniendo 0Xn�mero_hexadecimal.
	    MOVLW	0X89 ;W = 0X89
	    ;MOVWF   F: Lee el contenido del acumulador W y lo coloca en un 
	    ;registro de la RAM indicado por la direcci�n F.
	    MOVWF	PORTB ;PORTB = W = 0X89
	    ;PORTA.0 = 0 y PORTC.3 = 0
		;PORTD = 0XF3.
		;PORTB = 0X89.
	    ;GOTO   k: Sirve para hacer que el programa brinque a otra parte del 
	    ;c�digo, indicado por una directiva EQU que tenga el nombre de la 
	    ;parte del c�digo a donde quiero que brinque el programa.
	    GOTO	CHECA
	    ;Con esto se termina la funcionalidad del c�digo para cuando se 
	    ;cumpli� la condici�n PORTA.0 = 0 y PORTC.3 = 0, el GOTO hace que el 
	    ;PIC vuelva a buscar en los pines de los puertos B y C para ver si 
	    ;esta condici�n se sigue cumpliendo.

;CUANDO SE CUMPLI� EN LA PARTE ANTERIOR QUE PORTC.3 = 1, SE REESCRIBE EL VALOR 
;QUE TEN�A CARGADO EL ACUMULADOR W PARA CARGARSE AL PUERTO D, SE ASIGNA UN 
;NUEVO VALOR AL ACUMULADOR W Y ESTE NUEVO VALOR SE CARGA AL PUERTO B.
    ;PORTA.0 = 0 y PORTC.3 = 1
	;PORTD = 0X45.
	;PORTB = 0X7C.
	    ;MOVLW  K: Coloca directamente en el acumulador W un n�mero binario 
	    ;cualquiera de 8 bits dado por el valor literal K indicado en 
	    ;hexadecimal, poniendo 0Xn�mero_hexadecimal.
PA0_PC1:    MOVLW	0X45 ;W = 0X45
	    ;MOVWF   F: Lee el contenido del acumulador W y lo coloca en un 
	    ;registro de la RAM indicado por la direcci�n F.
	    MOVWF	PORTD ;PORTD = W = 0X45
	    ;MOVLW  K: Coloca directamente en el acumulador W un n�mero binario 
	    ;cualquiera de 8 bits dado por el valor literal K indicado en 
	    ;hexadecimal, poniendo 0Xn�mero_hexadecimal.
	    MOVLW	0X7C ;W = 0X7C
	    ;MOVWF   F: Lee el contenido del acumulador W y lo coloca en un 
	    ;registro de la RAM indicado por la direcci�n F.
	    MOVWF	PORTB ;PORTB = W = 0X7C
	    ;PORTA.0 = 0 y PORTC.3 = 1
		;PORTD = 0X45.
		;PORTB = 0X7C.
	    ;GOTO   k: Sirve para hacer que el programa brinque a otra parte del 
	    ;c�digo, indicado por una directiva EQU que tenga el nombre de la 
	    ;parte del c�digo a donde quiero que brinque el programa.
	    GOTO	CHECA
	    ;Con esto se termina la funcionalidad del c�digo para cuando se 
	    ;cumpli� la condici�n PORTA.0 = 0 y PORTC.3 = 1, el GOTO hace que el 
	    ;PIC vuelva a buscar en los pines de los puertos B y C para ver si 
	    ;esta condici�n se sigue cumpliendo.
	    

;YA SABIENDO QUE PORTA.0 = 1, PRIMERO CARGA EN EL ACUMULADOR W EL VALOR QUE 
;PUEDE ADOPTAR EL PUERTO D SI PORTC.3 = 0, OSEA W = 0X94, LUEGO EVAL�A EL VALOR 
;DE PORTC.3 Y SI ES 0, SE BRINCAR� EL GOTO PARA ASIGNAR W = 0X42 = PORTB, SI 
;PORTC.3 ES 1, CON UN GOTO SE BRINCAR� A LA PARTE PA1_PC1.
    ;PORTA.0 = 1 y PORTC.3 = 0
	;PORTD = 0X94.
	;PORTB = 0X42.
	    ;MOVLW  K: Coloca directamente en el acumulador W un n�mero binario 
	    ;cualquiera de 8 bits dado por el valor literal K indicado en 
	    ;hexadecimal, poniendo 0Xn�mero_hexadecimal.
PA1:	    MOVLW	0X94 ;W = 0X94
    ;BTFSC   F, B: Esta operaci�n es lo m�s parecido a un condicional if que 
    ;existe en el idioma ensamblador, su condici�n eval�a si el bit B del 
    ;registro F es uno o cero y si es 0 se brinca la siguiente instrucci�n, 
    ;sino sigue la ejecuci�n normal:
	;Si el bit B es cero (0):
	    ;SE BRINCA LA SIGUIENTE INSTRUCCI�N QUE HAYA EN EL C�DIGO (aumenta 
	    ;en 1 al contador de programa o PC).
	    ;Tarda 2 ciclos de m�quina en ejecutarse.
	    
	;Si el bit B es uno (1): 
	    ;Sigue la ejecuci�n normal del c�digo.
	    ;Tarda 1 ciclo de m�quina en ejecutarse.
    	    BTFSC	PORTC, 3 ;Checa el valor del PIN 3 del Puerto C

	    ;GOTO   k: Sirve para hacer que el programa brinque a otra parte del 
	    ;c�digo, indicado por una directiva EQU que tenga el nombre de la 
	    ;parte del c�digo a donde quiero que brinque el programa.
	    GOTO	PA1_PC1
	    ;Si PORTC.3 = 0 se lo brinca al GOTO.
	    ;Si PORTC.3 = 1 se ejecuta este GOTO.
	    	    
	    ;MOVWF   F: Lee el contenido del acumulador W y lo coloca en un 
	    ;registro de la RAM indicado por la direcci�n F.
	    MOVWF	PORTD ;PORTD = W = 0X94
	    ;MOVLW  K: Coloca directamente en el acumulador W un n�mero binario 
	    ;cualquiera de 8 bits dado por el valor literal K indicado en 
	    ;hexadecimal, poniendo 0Xn�mero_hexadecimal.
	    MOVLW	0X42 ;W = 0X42
	    ;MOVWF   F: Lee el contenido del acumulador W y lo coloca en un 
	    ;registro de la RAM indicado por la direcci�n F.
	    MOVWF	PORTB ;PORTB = W = 0X42
	    ;PORTA.0 = 1 y PORTC.3 = 0
		;PORTD = 0X94.
		;PORTB = 0X42.
	    ;GOTO   k: Sirve para hacer que el programa brinque a otra parte del 
	    ;c�digo, indicado por una directiva EQU que tenga el nombre de la 
	    ;parte del c�digo a donde quiero que brinque el programa.
	    GOTO	CHECA
	    ;Con esto se termina la funcionalidad del c�digo para cuando se 
	    ;cumpli� la condici�n PORTA.0 = 1 y PORTC.3 = 0, el GOTO hace que el 
	    ;PIC vuelva a buscar en los pines de los puertos B y C para ver si 
	    ;esta condici�n se sigue cumpliendo.

;CUANDO SE CUMPLI� EN LA PARTE ANTERIOR QUE PORTC.3 = 1, SE REESCRIBE EL VALOR 
;QUE TEN�A CARGADO EL ACUMULADOR W PARA CARGARSE AL PUERTO D, SE ASIGNA UN 
;NUEVO VALOR AL ACUMULADOR W Y ESTE NUEVO VALOR SE CARGA AL PUERTO B.
    ;PORTA.0 = 1 y PORTC.3 = 1
	;PORTD = 0XFF.
	;PORTB = 0XDE.
	    ;MOVLW  K: Coloca directamente en el acumulador W un n�mero binario 
	    ;cualquiera de 8 bits dado por el valor literal K indicado en 
	    ;hexadecimal, poniendo 0Xn�mero_hexadecimal.
PA1_PC1:    MOVLW	0XFF ;W = 0XFF
	    ;MOVWF   F: Lee el contenido del acumulador W y lo coloca en un 
	    ;registro de la RAM indicado por la direcci�n F.
	    MOVWF	PORTD ;PORTD = W = 0XFF
	    ;MOVLW  K: Coloca directamente en el acumulador W un n�mero binario 
	    ;cualquiera de 8 bits dado por el valor literal K indicado en 
	    ;hexadecimal, poniendo 0Xn�mero_hexadecimal.
	    MOVLW	0XDE ;W = 0XDE
	    ;MOVWF   F: Lee el contenido del acumulador W y lo coloca en un 
	    ;registro de la RAM indicado por la direcci�n F.
	    MOVWF	PORTB ;PORTB = W = 0XDE
	    ;PORTA.0 = 0 y PORTC.3 = 1
		;PORTD = 0XFF.
		;PORTB = 0XDE.
	    ;GOTO   k: Sirve para hacer que el programa brinque a otra parte del 
	    ;c�digo, indicado por una directiva EQU que tenga el nombre de la 
	    ;parte del c�digo a donde quiero que brinque el programa.
	    GOTO	CHECA
	    ;Con esto se termina la funcionalidad del c�digo para cuando se 
	    ;cumpli� la condici�n PORTA.1 = 0 y PORTC.3 = 1, el GOTO hace que el 
	    ;PIC vuelva a buscar en los pines de los puertos B y C para ver si 
	    ;esta condici�n se sigue cumpliendo.

	    ;Todos los c�digos en ensamblador deben tener al menos una 
	    ;instrucci�n GOTO cuya funci�n sea ocasionar que el PIC repita su 
	    ;funci�n indefinidamente, aunque en este caso pudimos ver que 
	    ;existieron 4 que realizan esta funci�n.
	    
	    ;Los programas en ensamblador deben acabar con la directiva END.
	    END