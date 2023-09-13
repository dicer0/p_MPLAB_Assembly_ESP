;4.- Lea el puerto B (PORTB) y el puerto C (PORTC), sume los contenidos y saque 
;el resultado por el puerto D (PORTD).
	    
;La configuración del PIC será jalada por una instrucción INCLUDE, para poder 
;hacerlo debo poner la dirección de la carpeta que llega hasta donde se 
;encuentra el archivo dentro de este proyecto de MPLABX en mi computadora, con 
;todo y el nombre del archivo que es Configuracion_PIC.asm de la siguiente 
;manera:
	    INCLUDE	<C:\Users\diego\OneDrive\Documents\The_MechaBible\p_MPLAB (Ensamblador)_ESP\2.-Ejercicios PIC16F887\0.-Configuracion\Configuracion_PIC.asm>
;Lo que hace la configuración es indicar el PIC que estoy usando, declarar las 
;2 palabras de configuración, usar otra directiva INCLUDE para jalar el archivo 
;P16F887.INC que incluye las 35 instrucciones del PIC junto con las directivas 
;EQU (los nombres) de sus registros, la directiva ORG que indica la dirección de 
;la memoria FLASH desde donde se empezará a guardar el código, el limpiado 
;(poner en 0) de todos los bits de los puertos (A, B, C, D y E) y hacer que los 
;puertos A, B y E (que son los únicos que pueden ser analógicos o digitales) 
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
;De esta manera se indica para cada registro TRIS, que está asociado a cada 
;puerto A, B, C, D o E si su pin es de entrada o salida. 
;Por default todos los bits de los registros TRIS después de un reset se ponen 
;en 1 lógico, osea que son entradas, por lo que solo debo cambiar y poner en 0 
;los bits asociados a los pines de los puertos que quiero que se vuelvan salidas.

;En este caso los puertos B y C son de entrada y el D es de salida, por lo que 
;solo debo cambiar al registro TRIS asociado al puerto D:
	    ;CLRF   F	(Z): Llena de ceros la dirección F del registro RAM 
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

;Para efectuar una resta, primero debo haber cargado el número que quiero restar
;al acumulador W y luego usar la instrucción ADDWF.
	    ;MOVF  F,D	(Z): Lee el contenido de un registro de la RAM indicado 
	    ;por la dirección F y lo coloca en el mismo registro F o en el 
	    ;acumulador W, dependiendo de lo que pongamos como D. Afecta la 
	    ;bandera Z, indicando si lo que ingresó al registro es cero o no.
SUM_PUERTOS:MOVF	PORTB, W ;W = PORTB
	    
	    ;ADDWF  F,D	(C, DC, Z): Suma el contenido del acumulador W con el 
	    ;contenido de un registro de RAM indicado por la dirección F y el 
	    ;resultado lo guarda en el acumulador W o en el mismo registro F.
	    ADDWF	PORTC, W ;W = W + PORTC = PORTB + PORTC
	    ;La instrucción afecta las banderas C de acarreo, DC de acarreo 
	    ;decimal y Z de ceros que son los bit 0, 1 y 2 del registro STATUS:
	    ;C = Acerreo: Se pone como 1 lógico cuando al final de una 
	    ;operación matemática sobró un 1, también indica el signo del 
	    ;resultado después de efectuar una operación (se levanta la bandera 
	    ;cuando tiene un 1 lógico y en el programa lo podemos notar porque 
	    ;se pone en letra mayúscula, las banderas las podemos ver en la 
	    ;parte superior del programa, a la derecha del contador de programa 
	    ;o PC).
	    
	    ;DC = Acerreo Decimal: Se pone como 1 lógico cuando al 
	    ;realizarse una operación matemática pasó un 1 lógico de los 4 
	    ;primeros bits (los de la derecha) del número binario de 8 bits 
	    ;a los segundos 4 bits del número binario (los de la izquierda). 
	    ;Se levanta la bandera poniéndose en letra mayúscula al simular el 
	    ;código.
	    
	    ;Z = Ceros: Se pone como 1 lógico cuando al realizarse una 
	    ;operación matemática el resultado es completamente cero. Se 
	    ;levanta la bandera poniéndose en letra mayúscula al simular el 
	    ;código.
	    	    
	    ;MOVWF   F: Lee el contenido del acumulador W y lo coloca en un 
	    ;registro de la RAM indicado por la dirección F.
	    MOVWF	PORTD ;PORTD = W = PORTB + PORTC
	    
	    ;GOTO   k: Sirve para hacer que el programa brinque a otra parte del 
	    ;código, indicado por un signo de pesos seguido de un signo menos y 
	    ;el número de instrucciones hacia atrás que quiero que brinque el 
	    ;programa o por una directiva EQU que tenga el nombre de la parte 
	    ;del código a donde quiero que brinque el programa que se debe poner
	    ;en el lugar del valor literal k.
	    GOTO	SUM_PUERTOS
	    ;Todos los códigos en ensamblador deben tener una instrucción GOTO
	    ;para que el PIC repita su función indefinidamente.
	    
	    ;Los programas en ensamblador deben acabar con la directiva END.
	    END