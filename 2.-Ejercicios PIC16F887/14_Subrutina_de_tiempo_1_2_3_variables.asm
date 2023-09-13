;14.- Realiza una subrutina de tiempo de 1 variable que cree un retardo de 
;10 milisegundos.
	    
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
;14.- Realiza una subrutina de tiempo de 1 variable que cree un retardo de 
;10 milisegundos.

;ME DEBO IR AL BANCO 0 PARA PODER ACCEDER A SUS REGISTROS DE PROPÓSITO GENERAL 
;Y AHÍ PODER GUARDAR EL VALOR DE LAS VARIABLES DE MIS SUBRUTINAS DE TIEMPO
INICIO:	    BCF		STATUS, RP1 ;RP1 = 0
	    BCF		STATUS, RP0 ;RP0 = 0
	    ;Con esto ya estoy en el banco 0
	    ;Banco 0: RP1 = 0, RP0 = 0
	    ;Banco 1: RP1 = 0, RP0 = 1
	    ;Banco 2: RP1 = 1, RP0 = 0
	    ;Banco 3: RP1 = 1, RP0 = 1
	    
;TODAS LAS SUBRUTINAS LAS DEBO DECLARAR HASTA LA PARTE DE ABAJO EN MI PROGRAMA.
;Una subrutina es como una función en cualquier otro lenguaje de programación, 
;ya que sirve para escribir código que se reutilizará varias veces dentro de un
;mismo programa, se le debe asignar un nombre (directiva EQU) a la subrutina 
;y cuando la quiera usar simplemente debo usar la instrucción CALL y el nombre 
;de la subrutina. Las subrutinas afectan el estado de la Pila y solo se pueden 
;anidar 6 subrutinas dentro de una misma (osea una subrutina de 7 niveles), sino 
;la Pila se desbordará de sus 8 niveles y el programa fallará catastróficamente.
	    
;PARA SIMULAR EL COMPORTAMIENTO DE LAS SUBRUTINAS DEBO USAR LA HERRAMIENTA 
;STOPWATCH DE MPLABX Y SUS BREAKPOINTS, YA SEA PARA VER EL ESTADO DE LOS NIVELES 
;EN LA PILA QUE ALCANZA CADA SUBRUTINA PONIENDO UN BREAKPOINT JUSTO EN LA 
;INSTRUCCIÓN RETURN DE CADA UNA O PARA MEDIR EL TIEMPO DE CADA SUBRUTINA DE 
;TIEMPO VIENDO LA VENTANA DEL STOPWATCH.
	    
;LAS SUBRUTINAS DE TIEMPO SE USAN PARA DEJAR PASAR CIERTO TIEMPO DESPUÉS DE QUE 
;SE EJECUTE UNA LÍNEA DE CÓDIGO, A ESTO SE LE LLAMA MANEJO DE TIEMPOS Y ES MUY
;IMPORTANTE EN LAS TAREAS DEL PIC. DEPENDIENDO DEL TIEMPO DE RETARDO QUE QUIERA
;ALCANZAR USARÉ SUBRUTINAS DE TIEMPO DE 1, 2 O 3 VARIABLES.
	    
;SUBRUTINA DE TIEMPO DE 1 VARIABLE: Abarca un tiempo de retardo de 11 us 
;(microsegundos) a 1,541 us = 1.541 ms (milisegundos).
    ;Las variables de mi subrutina se pueden colocar en los registros de 
    ;propósito general que quiera, pero para tener un órden, las variables 1, 2 
    ;o 3 de las subrutinas de tiempo las guardaré en los registros de propósito 
    ;general que vayan de la dirección 0X60 a la 0X68 del banco 0 de la memoria 
    ;RAM en el PIC y las declararé en forma decimal de la siguiente manera:
	;.numero_decimal
    ;Se usa el siguiente registro de propósito general para guardar la variable:
	;Registro 0X60 para guardar la variable 1.
	    ;MOVLW  K: Coloca directamente en el acumulador W un número binario 
	    ;cualquiera de 8 bits dado por el valor literal K. Como en este caso 
	    ;lo usaré para colocar una variable de mi subrutina de tiempo, se 
	    ;declara en forma decimal, poniendo .número_decimal.
	    MOVLW	.25 ;W = var1 = .25 = 25 decimal
	    ;MOVWF   F: Lee el contenido del acumulador W y lo coloca en un 
	    ;registro de la RAM indicado por la dirección F. En este el 
	    ;contenido del acumulador W se coloca en un registro de propósito 
	    ;general F que sirve para guardar un valor en la memoria RAM (que se 
	    ;borrará cuando se reinicie el PIC), indicado en forma hexadecimal, 
	    ;poniendo 0Xnúmero_hexadecimal.
	    MOVWF	0X60 ;0X60 = W = var1 = 25 decimal
	    ;CALL   k: Sirve para llamar una subrutina por su nombre y ejecutar 
	    ;una acción que se pueda repetir varias dentro del mismo código, de 
	    ;esta manera esa acción no la debo escribir varias veces.
	    CALL	ST1V ;Llama la Subrutina de Tiempo de 1 Variable (ST1V).
	    
	    
	    ;GOTO   k: Sirve para hacer que el programa brinque a otra parte del 
	    ;código, indicado por una directiva EQU que tenga el nombre de la 
	    ;parte del código a donde quiero que brinque el programa.
	    GOTO	INICIO
	    ;Todos los códigos en ensamblador deben tener al menos una 
	    ;instrucción GOTO cuya función sea ocasionar que el PIC repita su 
	    ;función indefinidamente.


;-----------HASTA ABAJO DEL PROGRAMA SE DECLARAN TODAS LAS SUBRUTINAS-----------
;PARA CREAR UNA SUBRUTINA DE TIEMPO LO QUE SE HACE ES CREAR UN CONTADOR QUE 
;CUENTE EL TIEMPO DE RETARDO DESEADO, DADO POR EL VALOR #cm EN LAS 3 ECUACIONES 
;DE LAS SUBRUTINAS DE TIEMPO DE 1, 2 O 3 VARIABLES, DEPENDIENDO DEL TIEMPO QUE 
;SE QUIERA ALCANZAR SE USARÁ UNA SUBRUTINA EN ESPECÍFCO, YA QUE MIENTRAS MAYOR 
;SEA EL TIEMPO DE RETARDO, MAYOR DEBERÁ SER EL NÚMERO DE VARIABLES EN LA 
;SUBRUTINA.
;EN LAS ECUACIONES DE LAS SUBRUTINAS DE TIEMPO DE 1, 2 Y 3 VARIABLES SE 
;CONSIDERA QUE EN LOS MICROCONTROLADORES UN CICLO DE MÁQUINA (cm) EQUIVALE A 
;4 CICLOS DEL OSCILADOR Y SI ESTAMOS UTILIZANDO EL OSCILADOR INTERNO DEL 
;PIC16F887 SIN UTILIZAR EL DIVISOR DE RELOJ, LA FRECUENCIA DEL RELOJ ES DE 4MHZ, 
;POR LO QUE:
    ;1 cm = 4*(1/4X10^6) = 1 microsegundo = 1 us
;*******************************************************************************
;SUBRUTINA DE TIEMPO DE 1 VARIABLE: Puede abarcar tiempos de retardo de 
;11 us (microsegundos) a 1.541 ms (milisegundos) ya que var1 en su ecuación 
;solo puede adoptar valores de 1 a 256.
;SE USA EL REGISTRO DE PROPÓSITO GENERAL 0X60.
    ;Ecuación: En la ecuación, #cm es el tiempo de retardo que quiero obtener y 
    ;lo debo introducir en microsegundos (us).
	;#cm = 5 + (var1)(#NOPS + 3)
    ;----------------Bucle con var1 guardada en el registro 0X60----------------
	    ;NOP: Esta instrucción no hace nada, solamente sirve para dejar 
	    ;pasar 1 ciclo de máquina (cm). Se puede declarar un número 
	    ;cualquiera de NOPS pero en el curso dentro de las subrutinas de 
	    ;tiempo siempre usaremos #NOPS = 3 para que sea un dato conocido.
ST1V:	    NOP
	    NOP
            NOP ;#NOPS = 3
    ;AHORA VAMOS A USAR UNA DE LAS 35 OPERACIONES QUE ME PERMITEN REALIZAR 
    ;UN BUCLE PARECIDO AL CICLO FOR Y SE USA PARA CREAR UN CONTADOR.
    ;DECFSZ	F, D: Esta operación decrementa (le resta 1) a lo que haya en 
    ;la dirección F del registro de RAM indicado y el resultado lo guarda en 
    ;el acumulador W o en el mismo registro F, además dependiendo de si el 
    ;resultado del decremento es cero o no, se brincará la siguiente instrucción 
    ;o la ejecutará normalmente:
	;Si el resultado del decremento NO es cero:
	    ;Sigue la ejecución normal del código.
	    ;Dura 1 ciclo de máquina su ejecución.
	    
	;Si el resultado del decremento es cero (0X00):
	    ;SE BRINCA LA SIGUIENTE INSTRUCCIÓN QUE HAYA EN EL CÓDIGO (aumenta 
	    ;en 1 al contador de programa o PC).
	    ;Dura 2 ciclos de máquina su ejecución.
	    ;HACE QUE EL PROGRAMA SALGA DE LA SUBRUTINA DE TIEMPO DE 1 VARIABLE.
            DECFSZ		0X60,F
	    ;GOTO   k: Sirve para hacer que el programa brinque a otra parte del 
	    ;código, indicado por una directiva EQU que tenga el nombre de la 
	    ;parte del código a donde quiero que brinque el programa.
            GOTO		ST1V
            ;RETURN: Todas las subrutinas siempre deben terminar con la 
	    ;instrucción return, lo que hace RETURN es bajar un nivel a la pila	
	    ;y cargar en el PC el valor que esté guardado ahí, haciendo que el 
	    ;programa brinque a la parte del código después de la instrucción 
	    ;CALL que llamó esta subrutina, siguiendo así la ejecución normal 
	    ;que llevaba el programa.
    ;----------------Bucle con var1 guardada en el registro 0X60----------------
	    RETURN
;*******************************************************************************
;SUBRUTINA DE TIEMPO DE 2 VARIABLES: Puede abarcar tiempos de retardo de 
;17 us (microsegundos) a 394.247 ms (milisegundos) ya que var1 y var2 en su 
;ecuación solo puede adoptar valores de 1 a 256.
;LA SUBRUTINA DE TIEMPO DE 2 VARIABLES SE CREA ANIDANDO LA DE 1 VARIABLE DENTRO
;DE OTRA Y SE USAN LOS REGISTROS DE PROPÓSITO GENERAL 0X61, 0X62 y 0X63.
    ;Ecuación: En la ecuación, #cm es el tiempo de retardo que quiero obtener y 
    ;lo debo introducir en microsegundos (us).
	;#cm = 7 + var2 * (4 + (nops+3) * var1)
    ;----------------Bucle con var2 guardada en el registro 0X61----------------
	    ;MOVF   F, D: Lee el contenido de un registro de la RAM indicado 
	    ;por la dirección F y lo coloca en el mismo registro F o en el 
	    ;acumulador W, dependiendo de la directiva EQU que ponga en donde 
	    ;dice D.
ST2V:	    MOVF		0X62,W ;W = 0X62 = var1
	    ;MOVWF   F: Lee el contenido del acumulador W y lo coloca en un 
	    ;registro de la RAM indicado por la dirección F. En este caso el 
	    ;contenido del acumulador W se coloca en un registro de propósito 
	    ;general F que sirve para guardar un valor en la memoria RAM (que se 
	    ;borrará cuando se reinicie el PIC), indicado en forma hexadecimal, 
	    ;poniendo 0Xnúmero_hexadecimal para la subrutina de tiempo.
	    MOVWF		0X63 ;Guarda una copia de la variable 1
	    ;NOP: Esta instrucción no hace nada, solamente sirve para dejar 
	    ;pasar 1 ciclo de máquina (cm). Se puede declarar un número 
	    ;cualquiera de NOPS pero en el curso dentro de las subrutinas de 
	    ;tiempo siempre usaremos #NOPS = 3 para que sea un dato conocido.
	;--------Bucle con la copia de var1 guardada en el registro 0X63--------
ST2V_V1:    NOP
	    NOP             
            NOP ;#NOPS = 3
    ;AHORA VAMOS A USAR UNA DE LAS 35 OPERACIONES QUE ME PERMITEN REALIZAR 
    ;UN BUCLE PARECIDO AL CICLO FOR Y SE USA PARA CREAR UN CONTADOR.
    ;DECFSZ	F, D: Esta operación decrementa (le resta 1) a lo que haya en 
    ;la dirección F del registro de RAM indicado y el resultado lo guarda en 
    ;el acumulador W o en el mismo registro F, además dependiendo de si el 
    ;resultado del decremento es cero o no, se brincará la siguiente instrucción 
    ;o la ejecutará normalmente:
	;Si el resultado del decremento NO es cero:
	    ;Sigue la ejecución normal del código.
	    
	;Si el resultado del decremento es cero (0X00):
	    ;SE BRINCA LA SIGUIENTE INSTRUCCIÓN QUE HAYA EN EL CÓDIGO (aumenta 
	    ;en 1 al contador de programa o PC).
	    ;HACE QUE EL PROGRAMA SALGA DE LA SUBRUTINA DE TIEMPO DE 1 VARIABLE.
            DECFSZ		0X63,F ;Haz un bucle con la copia de var1
	    ;GOTO   k: Sirve para hacer que el programa brinque a otra parte del 
	    ;código, indicado por una directiva EQU que tenga el nombre de la 
	    ;parte del código a donde quiero que brinque el programa.
            GOTO		ST2V_V1
	;--------Bucle con la copia de var1 guardada en el registro 0X63--------
    ;DECFSZ	F, D: Esta operación decrementa (le resta 1) a lo que haya en 
    ;la dirección F del registro de RAM indicado y el resultado lo guarda en 
    ;el acumulador W o en el mismo registro F, además dependiendo de si el 
    ;resultado del decremento es cero o no, se brincará la siguiente instrucción 
    ;o la ejecutará normalmente:
	;Si el resultado del decremento NO es cero:
	    ;Sigue la ejecución normal del código.
	    
	;Si el resultado del decremento es cero (0X00):
	    ;SE BRINCA LA SIGUIENTE INSTRUCCIÓN QUE HAYA EN EL CÓDIGO (aumenta 
	    ;en 1 al contador de programa o PC).
	    ;HACE QUE EL PROGRAMA SALGA DE LA SUBRUTINA DE TIEMPO DE 2 VARIABLES.
	    DECFSZ		0X61,F ;Haz un bucle con var2
	    ;GOTO   k: Sirve para hacer que el programa brinque a otra parte del 
	    ;código, indicado por una directiva EQU que tenga el nombre de la 
	    ;parte del código a donde quiero que brinque el programa.
	    GOTO		ST2V
	    ;RETURN: Todas las subrutinas siempre deben terminar con la 
	    ;instrucción return, lo que hace RETURN es bajar un nivel a la pila	
	    ;y cargar en el PC el valor que esté guardado ahí, haciendo que el 
	    ;programa brinque a la parte del código después de la instrucción 
	    ;CALL que llamó esta subrutina, siguiendo así la ejecución normal 
	    ;que llevaba el programa.
    ;----------------Bucle con var2 guardada en el registro 0X61----------------
	    RETURN
;*******************************************************************************
;SUBRUTINA DE TIEMPO DE 3 VARIABLES: Puede abarcar tiempos de retardo de 
;23 us (microsegundos) a 100.926 s (segundos) = 1.6821 min (minutos) ya que 
;var1,var2 y var3 pueden adoptar valores de 1 a 256 en su ecuación.
;LA SUBRUTINA DE TIEMPO DE 3 VARIABLES SE CREA ANIDANDO LA DE 2 VARIABLES y DE 1 
;VARIABLE DENTRO DE OTRA Y SE USAN LOS REGISTROS DE PROPÓSITO GENERAL 0X64, 0X65
;0X66, 0X67 y 0X68.
    ;Ecuación: En la ecuación, #cm es el tiempo de retardo que quiero obtener y 
    ;lo debo introducir en microsegundos (us).
	;#cm = 9 + var1 * (var3 * (var2 * (nops+3) + 4) + 4)
    ;----------------Bucle con var3 guardada en el registro 0X64----------------
	    ;MOVF   F, D: Lee el contenido de un registro de la RAM indicado 
	    ;por la dirección F y lo coloca en el mismo registro F o en el 
	    ;acumulador W, dependiendo de la directiva EQU que ponga en donde 
	    ;dice D.
ST3V:	    MOVF		0X66,W ;W = 0X66 = var1
	    ;MOVWF   F: Lee el contenido del acumulador W y lo coloca en un 
	    ;registro de la RAM indicado por la dirección F. En este caso el 
	    ;contenido del acumulador W se coloca en un registro de propósito 
	    ;general F que sirve para guardar un valor en la memoria RAM (que se 
	    ;borrará cuando se reinicie el PIC), indicado en forma hexadecimal, 
	    ;poniendo 0Xnúmero_hexadecimal para la subrutina de tiempo.
	    MOVWF		0X67 ;0X67 = W = var1, copia de la variable 1
	    ;NOP: Esta instrucción no hace nada, solamente sirve para dejar 
	    ;pasar 1 ciclo de máquina (cm). Se puede declarar un número 
	    ;cualquiera de NOPS pero en el curso dentro de las subrutinas de 
	    ;tiempo siempre usaremos #NOPS = 3 para que sea un dato conocido.
	;--------Bucle con la copia de var1 guardada en el registro 0X67--------
	    ;MOVF   F, D: Lee el contenido de un registro de la RAM indicado 
	    ;por la dirección F y lo coloca en el mismo registro F o en el 
	    ;acumulador W, dependiendo de la directiva EQU que ponga en donde 
	    ;dice D.
ST3V_V1:    MOVF		0X65,W ;W = 0X65 = var2
	    ;MOVWF   F: Lee el contenido del acumulador W y lo coloca en un 
	    ;registro de la RAM indicado por la dirección F. En este caso el 
	    ;contenido del acumulador W se coloca en un registro de propósito 
	    ;general F que sirve para guardar un valor en la memoria RAM (que se 
	    ;borrará cuando se reinicie el PIC), indicado en forma hexadecimal, 
	    ;poniendo 0Xnúmero_hexadecimal para la subrutina de tiempo.
	    MOVWF		0X68 ;0X68 = W = var2, copia de la variable 2
	    ;NOP: Esta instrucción no hace nada, solamente sirve para dejar 
	    ;pasar 1 ciclo de máquina (cm). Se puede declarar un número 
	    ;cualquiera de NOPS pero en el curso dentro de las subrutinas de 
	    ;tiempo siempre usaremos #NOPS = 3 para que sea un dato conocido.
ST3V_V2:    NOP
	    NOP             
            NOP ;#NOPS = 3
    ;AHORA VAMOS A USAR UNA DE LAS 35 OPERACIONES QUE ME PERMITEN REALIZAR 
    ;UN BUCLE PARECIDO AL CICLO FOR Y SE USA PARA CREAR UN CONTADOR.
    ;DECFSZ	F, D: Esta operación decrementa (le resta 1) a lo que haya en 
    ;la dirección F del registro de RAM indicado y el resultado lo guarda en 
    ;el acumulador W o en el mismo registro F, además dependiendo de si el 
    ;resultado del decremento es cero o no, se brincará la siguiente instrucción 
    ;o la ejecutará normalmente:
	;Si el resultado del decremento NO es cero:
	    ;Sigue la ejecución normal del código.
	    
	;Si el resultado del decremento es cero (0X00):
	    ;SE BRINCA LA SIGUIENTE INSTRUCCIÓN QUE HAYA EN EL CÓDIGO (aumenta 
	    ;en 1 al contador de programa o PC).
	    ;HACE QUE EL PROGRAMA SALGA DE LA SUBRUTINA DE TIEMPO DE 1 VARIABLE.
            DECFSZ		0X68,F ;Haz un bucle con la copia de var2
	    ;GOTO   k: Sirve para hacer que el programa brinque a otra parte del 
	    ;código, indicado por una directiva EQU que tenga el nombre de la 
	    ;parte del código a donde quiero que brinque el programa.
            GOTO		ST3V_V2

    ;DECFSZ	F, D: Esta operación decrementa (le resta 1) a lo que haya en 
    ;la dirección F del registro de RAM indicado y el resultado lo guarda en 
    ;el acumulador W o en el mismo registro F, además dependiendo de si el 
    ;resultado del decremento es cero o no, se brincará la siguiente instrucción 
    ;o la ejecutará normalmente:
	;Si el resultado del decremento NO es cero:
	    ;Sigue la ejecución normal del código.
	    
	;Si el resultado del decremento es cero (0X00):
	    ;SE BRINCA LA SIGUIENTE INSTRUCCIÓN QUE HAYA EN EL CÓDIGO (aumenta 
	    ;en 1 al contador de programa o PC).
	    ;HACE QUE EL PROGRAMA SALGA DE LA SUBRUTINA DE TIEMPO DE 2 VARIABLES.
	    DECFSZ		0X67,F ;Haz un bucle con la copia de var1
	    ;GOTO   k: Sirve para hacer que el programa brinque a otra parte del 
	    ;código, indicado por una directiva EQU que tenga el nombre de la 
	    ;parte del código a donde quiero que brinque el programa.
	    GOTO		ST3V_V1
	    ;RETURN: Todas las subrutinas siempre deben terminar con la 
	    ;instrucción return, lo que hace RETURN es bajar un nivel a la pila	
	    ;y cargar en el PC el valor que esté guardado ahí, haciendo que el 
	    ;programa brinque a la parte del código después de la instrucción 
	    ;CALL que llamó esta subrutina, siguiendo así la ejecución normal 
	    ;que llevaba el programa.

    ;DECFSZ	F, D: Esta operación decrementa (le resta 1) a lo que haya en 
    ;la dirección F del registro de RAM indicado y el resultado lo guarda en 
    ;el acumulador W o en el mismo registro F, además dependiendo de si el 
    ;resultado del decremento es cero o no, se brincará la siguiente instrucción 
    ;o la ejecutará normalmente:
	;Si el resultado del decremento NO es cero:
	    ;Sigue la ejecución normal del código.
	;--------Bucle con la copia de var1 guardada en el registro 0X67--------
	;Si el resultado del decremento es cero (0X00):
	    ;SE BRINCA LA SIGUIENTE INSTRUCCIÓN QUE HAYA EN EL CÓDIGO (aumenta 
	    ;en 1 al contador de programa o PC).
	    ;HACE QUE EL PROGRAMA SALGA DE LA SUBRUTINA DE TIEMPO DE 2 VARIABLES.
	    DECFSZ		0X64,F ;Haz un bucle con var3
	    ;GOTO   k: Sirve para hacer que el programa brinque a otra parte del 
	    ;código, indicado por una directiva EQU que tenga el nombre de la 
	    ;parte del código a donde quiero que brinque el programa.
	    GOTO		ST3V
	    ;RETURN: Todas las subrutinas siempre deben terminar con la 
	    ;instrucción return, lo que hace RETURN es bajar un nivel a la pila	
	    ;y cargar en el PC el valor que esté guardado ahí, haciendo que el 
	    ;programa brinque a la parte del código después de la instrucción 
	    ;CALL que llamó esta subrutina, siguiendo así la ejecución normal 
	    ;que llevaba el programa.
    ;----------------Bucle con var3 guardada en el registro 0X64----------------
	    RETURN
;*******************************************************************************
	    
	    ;Los programas en ensamblador deben acabar con la directiva END.
	    END