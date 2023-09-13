;7.- Lea el puerto B (PORTB) y el puerto C (PORTC):
;Si PORTB >= PORTC se debe sacar 0XAB por el puerto D (PORTD).
;Si PORTB < PORTC se debe sacar 0XC5 por el puerto D (PORTD).
	    
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
;7.- Lea el puerto B (PORTB) y el puerto C (PORTC):
;Si PORTB >= PORTC se debe sacar 0XAB por el puerto D (PORTD).
;Si PORTB < PORTC se debe sacar 0XC5 por el puerto D (PORTD).

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

;Puedo ver si dos valores son mayores o menores entre sí restándolos, en este 
;tipo de comparación sí importa el órden de la resta ya que será mayor o igual 
;el primer número binario ingresado si el resultado es positivo y menor si el 
;resultado es negativo, puedo checar si es positivo o negativo el resultado con 
;la bandera C = acarreo:
	;Si C = 0 el resultado de la resta fue negativo.
	    ;El primer dato ingresado ES MENOR al segundo dato ingresado.
	
	;Si C = 1 el resultado de la resta fue positivo.
	    ;El primer dato ingresado ES MAYOR O IGUAL al segundo dato ingresado.
	    
;Para efectuar una resta, primero debo haber cargado el número que quiero restar
;al acumulador W y luego usar la instrucción SUBWF.
	    ;MOVF  F,D	(Z): Lee el contenido de un registro de la RAM indicado 
	    ;por la dirección F y lo coloca en el mismo registro F o en el 
	    ;acumulador W, dependiendo de lo que pongamos como D. Afecta la 
	    ;bandera Z, indicando si lo que ingresó al registro es cero o no.
COMPARA:    MOVF	PORTC, W ;W = PORTC
	    
	    ;SUBWF   F, D (C, DC, Z): Resta lo que haya en la dirección F del 
	    ;registro de RAM menos lo que haya en el acumulador W, la resta se 
	    ;lleva a cabo haciendo una suma entre el registro F y el 
	    ;complemento A2 de lo que haya en el acumulador W, el resultado de 
	    ;la resta se guardará en el registro F o en el acumulador W 
	    ;dependiendo de cuál se ponga en la posición de D.
	    SUBWF	PORTB, W ;W = PORTB - W = PORTB - PORTC = PORTB + CA2(PORTC)
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
	    
;ANTES DE USAR UN CONDICIONAL VAMOS A ASIGNAR UN VALOR AL ACUMULADOR W QUE 
;CORRESPONDE A CUANDO PORTB >= PORTC, YA QUE SI EL ACARREO ES 1, EL CONDICIONAL 
;BTFSS HARÁ QUE EL PROGRAMA SE SALTE LA SIGUIENTE INSTRUCCIÓN QUE CORRESPONDERÁ
;A CUANDO PORTB < PORTC Y EL VALOR ACTUAL SE MANTENDRÁ, SI EL ACARREO ES 0, LA 
;SIGUIENTE INSTRUCCIÓN DE CÓDIGO QUE VA DESPUÉS DE BTFSS SI SE EJECUTARÁ Y 
;REESCRIBIRÁ EL VALOR GUARDADO AHORITA EN EL ACUMULADOR W POR EL QUE CORRESPONDE 
;CUANDO PORTB < PORTC.
	    ;MOVLW  K: Coloca directamente en el acumulador W un número binario 
	    ;cualquiera de 8 bits dado por el valor literal K indicado en 
	    ;hexadecimal, poniendo 0Xnúmero_hexadecimal.
MAYOR:	    MOVLW	0XAB ;W = 0XAB
	    ;La directiva EQU de la línea de código no está conectada a nignuna 
	    ;instrucción GOTO, solamente es informativa.
	    ;Si C = 1, osea que el resultado de PORTB - PORTC fue positivo, 
	    ;PORTB >= PORTC, por lo tanto W = 0XAB
	    
;AHORA VAMOS A USAR UNA DE LAS 35 OPERACIONES QUE ME PERMITEN REALIZAR 
;CONDICIONALES PARECIDOS A UN IF.
    ;BTFSS   F, B: Esta operación es lo más parecido a un condicional if que 
    ;existe en el idioma ensamblador, su condición evalúa si el bit B del 
    ;registro F es uno o cero y si es 1 se brinca la siguiente instrucción, 
    ;sino sigue la ejecución normal:
	;Si el bit B es cero (0):
	    ;Sigue la ejecución normal del código.
	    ;Tarda 1 ciclo de máquina en ejecutarse.
	    
	;Si el bit B es uno (1): 
	    ;SE BRINCA LA SIGUIENTE INSTRUCCIÓN QUE HAYA EN EL CÓDIGO (aumenta 
	    ;en 1 al contador de programa o PC).
	    ;Tarda 2 ciclos de máquina en ejecutarse.
	    
    ;La posición del bit B en el registro F se puede indicar poniendo el nombre 
    ;del bit (osea su directiva EQU) o contando desde cero en decimal, osea 
    ;poniendo 0, 1, 2, 3, 4, 5, 6 o 7. En este caso queremos checar el estado de 
    ;la bandera de acarreo C para saber si el resultado de la resta fue negativo 
    ;o positivo, siempre que querramos ver el estado de una bandera debemos 
    ;acceder al registro de propósito específico STATUS, por lo que en vez de 
    ;poner un número hexadecimal para indicar el registro F, pondré su directiva 
    ;EQU (osea el nombre del registro) y en vez de poner un número decimal 
    ;como B para indicar el bit que quiero alcanzar, pondré su directiva EQU 
    ;(osea el nombre de la bandera).
	    BTFSS	STATUS, C ;Checar la bandera C del registro STATUS
	;Si C = 0 el resultado de la resta fue negativo 
	    ;Sigue la ejecución normal del código 
	    ;El primer dato ingresado a la comparación es menor, PORTB < PORTC.
	    
	;Si C = 1 el resultado de la resta fue positivo 
	    ;SE SALTA LA SIGUIENTE LÍNEA DEL CÓDIGO.
	    ;EL PRIMER DATO INGRESADO A LA COMPARACIÓN ES MAYOR O IGUAL, PORTB >= PORTC.
	    
;Si C = 1, osea que PORTB ? PORTC esta instrucción de código se la salta el 
;programa por el condicional BTFSS y en el acumulador se queda el valor W = 0XAB
;Sino la siguiente insrrucción del código sobreescribe ese valor.	    
	    ;MOVLW  K: Coloca directamente en el acumulador W un número binario 
	    ;cualquiera de 8 bits dado por el valor literal K indicado en 
	    ;hexadecimal, poniendo 0Xnúmero_hexadecimal.
MENOR:	    MOVLW	0XC5 ;W = 0XC5
	    ;La directiva EQU de la línea de código no está conectada a nignuna 
	    ;instrucción GOTO, solamente es informativa.
	    ;Si C = 0, osea que el resultado de PORTB - PORTC fue negativo, 
	    ;PORTB < PORTC, por lo tanto W = 0XC5
	    
	    ;MOVWF   F: Lee el contenido del acumulador W y lo coloca en un 
	    ;registro de la RAM indicado por la dirección F.
	    MOVWF	PORTD 
	    ;Si C = 0, PORTB < PORTC, PORTD = W = 0XC5
	    ;Si C = 1, PORTB >= PORTC, PORTD = W = 0XAB
	    
	    ;GOTO   k: Sirve para hacer que el programa brinque a otra parte del 
	    ;código, indicado por un signo de pesos seguido de un signo menos y 
	    ;el número de instrucciones hacia atrás que quiero que brinque el 
	    ;programa o por una directiva EQU que tenga el nombre de la parte 
	    ;del código a donde quiero que brinque el programa que se debe poner
	    ;en el lugar del valor literal k.
	    GOTO	COMPARA
	    ;Todos los códigos en ensamblador deben tener una instrucción GOTO
	    ;hasta el final (antes de la instrucción END) para que el PIC repita 
	    ;su función indefinidamente.
	    
	    ;Los programas en ensamblador deben acabar con la directiva END.
	    END