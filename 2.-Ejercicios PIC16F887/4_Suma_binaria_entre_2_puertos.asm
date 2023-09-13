;4.- Lea el puerto B (PORTB) y el puerto C (PORTC), sume los contenidos y saque 
;el resultado por el puerto D (PORTD).
	    
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
;4.- Lea el puerto B (PORTB) y el puerto C (PORTC), sume los contenidos y saque 
;el resultado por el puerto D (PORTD).

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

;En este caso los puertos B y C son de entrada y el D es de salida, por lo que 
;solo debo cambiar al registro TRIS asociado al puerto D:
	    ;CLRF   F	(Z): Llena de ceros la direcci�n F del registro RAM 
	    ;indicado. Siempre levanta la bandera ceros, Z = 1.
	    CLRF	TRISD ;Hace todos los pines del puerto D sean salidas.

;LUEGO ME DEBO REGRESAR AL BANCO 0 PARA QUE PUEDA MANIPULAR LOS PUERTOS
	    BCF		STATUS, RP1 ;RP1 = 0
	    BCF		STATUS, RP0 ;RP0 = 0
	    ;Con esto ya estoy en el banco 0
	    ;Banco 0: RP1 = 0, RP0 = 0
	    ;Banco 1: RP1 = 0, RP0 = 1
	    ;Banco 2: RP1 = 1, RP0 = 0
	    ;Banco 3: RP1 = 1, RP0 = 1

;Para efectuar una resta, primero debo haber cargado el n�mero que quiero restar
;al acumulador W y luego usar la instrucci�n ADDWF.
	    ;MOVF  F,D	(Z): Lee el contenido de un registro de la RAM indicado 
	    ;por la direcci�n F y lo coloca en el mismo registro F o en el 
	    ;acumulador W, dependiendo de lo que pongamos como D. Afecta la 
	    ;bandera Z, indicando si lo que ingres� al registro es cero o no.
SUM_PUERTOS:MOVF	PORTB, W ;W = PORTB
	    
	    ;ADDWF  F,D	(C, DC, Z): Suma el contenido del acumulador W con el 
	    ;contenido de un registro de RAM indicado por la direcci�n F y el 
	    ;resultado lo guarda en el acumulador W o en el mismo registro F.
	    ADDWF	PORTC, W ;W = W + PORTC = PORTB + PORTC
	    ;La instrucci�n afecta las banderas C de acarreo, DC de acarreo 
	    ;decimal y Z de ceros que son los bit 0, 1 y 2 del registro STATUS:
	    ;C = Acerreo: Se pone como 1 l�gico cuando al final de una 
	    ;operaci�n matem�tica sobr� un 1, tambi�n indica el signo del 
	    ;resultado despu�s de efectuar una operaci�n (se levanta la bandera 
	    ;cuando tiene un 1 l�gico y en el programa lo podemos notar porque 
	    ;se pone en letra may�scula, las banderas las podemos ver en la 
	    ;parte superior del programa, a la derecha del contador de programa 
	    ;o PC).
	    
	    ;DC = Acerreo Decimal: Se pone como 1 l�gico cuando al 
	    ;realizarse una operaci�n matem�tica pas� un 1 l�gico de los 4 
	    ;primeros bits (los de la derecha) del n�mero binario de 8 bits 
	    ;a los segundos 4 bits del n�mero binario (los de la izquierda). 
	    ;Se levanta la bandera poni�ndose en letra may�scula al simular el 
	    ;c�digo.
	    
	    ;Z = Ceros: Se pone como 1 l�gico cuando al realizarse una 
	    ;operaci�n matem�tica el resultado es completamente cero. Se 
	    ;levanta la bandera poni�ndose en letra may�scula al simular el 
	    ;c�digo.
	    	    
	    ;MOVWF   F: Lee el contenido del acumulador W y lo coloca en un 
	    ;registro de la RAM indicado por la direcci�n F.
	    MOVWF	PORTD ;PORTD = W = PORTB + PORTC
	    
	    ;GOTO   k: Sirve para hacer que el programa brinque a otra parte del 
	    ;c�digo, indicado por un signo de pesos seguido de un signo menos y 
	    ;el n�mero de instrucciones hacia atr�s que quiero que brinque el 
	    ;programa o por una directiva EQU que tenga el nombre de la parte 
	    ;del c�digo a donde quiero que brinque el programa que se debe poner
	    ;en el lugar del valor literal k.
	    GOTO	SUM_PUERTOS
	    ;Todos los c�digos en ensamblador deben tener una instrucci�n GOTO
	    ;para que el PIC repita su funci�n indefinidamente.
	    
	    ;Los programas en ensamblador deben acabar con la directiva END.
	    END