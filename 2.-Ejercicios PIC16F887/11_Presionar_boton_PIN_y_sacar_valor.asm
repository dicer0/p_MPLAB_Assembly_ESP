;11.- Lea el pin 0 del puerto B (PORTB.0):
;Si el PORTB.0 = 0, el PORTD debe sacar 0XF5.
;Si el PORTB.0 = 1, el PORTD debe sacar 0X24.
	    
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
;pines de los puertos A, B y E (que son los únicos que pueden ser analógicos o 
;digitales) sean todos digitales.
	    
;Ahora si ya puedo resolver el ejercicio:
;11.- Lea el pin 0 del puerto B (PORTB.0):
;Si el PORTB.0 = 0, el PORTD debe sacar 0XF5. 
;Si el PORTB.0 = 1, el PORTD debe sacar 0X24.

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

;En este caso los puertos B y C son de entrada, el A y D son de salida, por lo 
;que solo debo cambiar al registro TRIS asociado al puerto A y D:
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

;ANTES DE USAR UN CONDICIONAL VAMOS A ASIGNAR UN VALOR AL ACUMULADOR W QUE 
;CORRESPONDE A 0X24 CUANDO PORTB.0 = 1, YA QUE SI PORTB.0 = 0, OSEA QUE EL PIN 0 
;DEL PUERTO B ES 0, LA INSTRUCCIÓN DE CÓDIGO QUE VA DESPUÉS DEL CONDICIONAL 
;BTFSS SI SE EJECUTARÁ Y REESCRIBIRÁ EL VALOR GUARDADO AHORITA EN EL ACUMULADOR 
;W POR EL QUE CORRESPONDE CUANDO PORTB.0 = 0 que es 0XF5.
	    ;MOVLW  K: Coloca directamente en el acumulador W un número binario 
	    ;cualquiera de 8 bits dado por el valor literal K indicado en 
	    ;hexadecimal, poniendo 0Xnúmero_hexadecimal.
BOTON:	    MOVLW	0X24 ;W = 0X24
	    
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
    ;uno de los pines del puerto B, por lo que debemos acceder al registro de 
    ;propósito específico por su nombre o directiva EQU, osea PORTB, en vez de 
    ;poner un número hexadecimal para indicar el registro F y pondré un número 
    ;decimal como B para indicar el PIN que quiero alcanzar del puerto.
	    BTFSS	PORTB, 0 ;Checa el valor del PIN 0 del Puerto B
	;Si PORTB.0 = 0:
	    ;Sigue la ejecución normal del código 
	    ;Reescribe el valor de W por W = 0XF5
	    
	;Si PORTB.0 = 1:
	    ;SE SALTA LA SIGUIENTE LÍNEA DEL CÓDIGO.
	    ;MANTIENE EL VALOR DEL ACUMULADOR W, W = 0X24
	    
;SOBREESCRIBIR EL VALOR DEL ACUMULADOR CUANDO PORTB.0 = 0
	    ;MOVLW  K: Coloca directamente en el acumulador W un número binario 
	    ;cualquiera de 8 bits dado por el valor literal K indicado en 
	    ;hexadecimal, poniendo 0Xnúmero_hexadecimal.
	    MOVLW	0XF5 ;W = 0XF5
	    
;ASIGNA EL VALOR DEL ACUMULADOR A TODOS LOS PINES DEL PUERTO D
	    ;MOVWF   F: Lee el contenido del acumulador W y lo coloca en un 
	    ;registro de la RAM indicado por la dirección F.
	    MOVWF	PORTD 
	    ;Si PORTB.0 = 0, PORTD = W = 0XF5.
	    ;Si PORTB.0 = 1, PORTD = W = 0X24.
	    
	    ;GOTO   k: Sirve para hacer que el programa brinque a otra parte del 
	    ;código, indicado por un signo de pesos seguido de un signo menos y 
	    ;el número de instrucciones hacia atrás que quiero que brinque el 
	    ;programa o por una directiva EQU que tenga el nombre de la parte 
	    ;del código a donde quiero que brinque el programa que se debe poner
	    ;en el lugar del valor literal k.
	    GOTO	BOTON
	    ;Todos los códigos en ensamblador deben tener una instrucción GOTO
	    ;hasta el final (antes de la instrucción END) para que el PIC repita 
	    ;su función indefinidamente.
	    
	    ;Los programas en ensamblador deben acabar con la directiva END.
	    END