;13.- Realiza una subrutina que guarde un valor del contador de programa (PC) 
;en un nivel superior al nivel 0 de la Pila.
	    
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
;13.- Realiza una subrutina que guarde un valor del contador de programa (PC) 
;en un nivel superior al nivel 0 de la Pila.
	    
;TODAS LAS SUBRUTINAS LAS DEBO DECLARAR HASTA LA PARTE DE ABAJO EN MI PROGRAMA.
;UNA SUBRUTINA ES COMO UNA FUNCIÓN EN CUALQUIER OTRO LENGUAJE DE PROGRAMACIÓN, 
;YA QUE SIRVE PARA ESCRIBIR CÓDIGO QUE SE REUTILIZARÁ VARIAS VECES DENTRO DE UN 
;MISMO PROGRAMA, SE LE DEBE ASIGNAR UN NOMBRE A LA SUBRUTINA (O DIRECTIVA EQU) 
;Y CUANDO LO QUIERA USAR SIMPLEMENTE DEBO USAR LA INSTRUCCIÓN CALL Y EL NOMBRE 
;DE LA SUBRUTINA.
;AL UTILIZAR LA INSTRUCCIÓN CALL SE MODIFICA EL ESTADO DE LA PILA, QUE ES UN 
;FRAGMENTO DE LA MEMORIA RAM DISEÑADO PARA GUARDAR VALORES DEL CONTADOR DE 
;PROGRAMA (PC) PARA APUNTAR A DIRECCIONES DE LA MEMORIA FLASH, OSEA A LÍNEAS 
;ESPECÍFICAS DE MI CÓDIGO, LA PILA EN EL PIC16F887 CONSTA DE 8 NIVELES, POR LO 
;QUE SOLO PODREMOS DECLARAR SUBRUTINAS QUE ANIDEN 8 SURUTINAS DENTRO DE ELLAS, 
;AUNQUE PODREMOS CREAR LAS SUBRUTINAS QUE QUERRAMOS SIEMPRE Y CUANDO SE RESPETE 
;ESTA CONDICIÓN. LAS ACCIONES QUE HACE EL PROGRAMA CUANDO SE USA CALL SON:
    ;Almacena en un nivel de la Pila el valor que le sigue al PC que hay 
    ;donde se usó la instrucción CALL, en este caso como CALL se usa en la 
    ;línea 58 del código, se guardaría el valor 59 en el nivel 0 de la pila, 
    ;pero como en ese nivel hay un comentario, se guarda en la pila el valor 
    ;del PC donde se encuentra la siguiente línea de código, osea el 67 en la 
    ;columna Location de la Pila.
    
    ;Sube el nivel de la Pila, que cuenta del 0 al 7, en este caso subirá al 
    ;nivel 1.
    
    ;Carga en el PC el valor de donde se encuentra la subrutina que se quiere 
    ;usar, en este caso como la subrutina se declaró hasta el final del código
    ;en la línea 167, ese valor se carga al PC.
;PARA SIMULAR EL COMPORTAMIENTO DE LA PILA DEBO USAR LA HERRAMIENTA STOPWATCH 
;DE MPLABX Y SUS BREAKPOINTS, EN ESPECÍFICO SI QUIERO VER LOS NIVELES DE LA 
;PILA QUE ALCANZA CADA SUBRUTINA DEBO PONER UN BREAKPOINT JUSTO EN SU 
;INSTRUCCIÓN RETURN
	    ;CALL   k: Sirve para llamar una subrutina por su nombre y ejecutar 
	    ;una acción que se pueda repetir varias dentro del mismo código, de 
	    ;esta manera esa acción no la debo escribir varias veces.
INICIO:	    CALL	SUBRUTINA ;Llama la subrutina que no tiene otra anidada.
	    ;NOP: Esta instrucción no hace nada, solamente sirve para dejar 
	    ;pasar 1 ciclo de máquina (cm). En los microcontroladores 1 ciclo de 
	    ;máquina equivale a 4 ciclos del oscilador (o señal de reloj). Si 
	    ;estamos utilizando el oscilador interno del PIC16F887 sin activar 
	    ;el divisor de reloj, la frecuencia del reloj es de 4MHz, por lo que 
	    ;1 cm = 4*(1/4X10^6) = 1 microsegundo = 1 us
	    NOP
	    
	    ;CALL   k: Sirve para ejecutar una subrutina, indicada por su nombre.
	    CALL	SUBRUTINA1 ;Llama la subrutina que tiene otra anidada.
	    ;NOP: Esta instrucción no hace nada, solamente sirve para dejar 
	    ;pasar 1 ciclo de máquina (cm).
	    NOP
	    
	    ;CALL   k: Sirve para ejecutar una subrutina, indicada por su nombre.
	    CALL	SUB_F ;Llama la subrutina que llega al nivel 7 de la pila.
	    ;NOP: Esta instrucción no hace nada, solamente sirve para dejar 
	    ;pasar 1 ciclo de máquina (cm).
	    NOP
	    
	    
	    ;GOTO   k: Sirve para hacer que el programa brinque a otra parte del 
	    ;código, indicado por una directiva EQU que tenga el nombre de la 
	    ;parte del código a donde quiero que brinque el programa.
	    GOTO	INICIO
	    ;Todos los códigos en ensamblador deben tener al menos una 
	    ;instrucción GOTO cuya función sea ocasionar que el PIC repita su 
	    ;función indefinidamente.


;-----------HASTA ABAJO DEL PROGRAMA SE DECLARAN TODAS LAS SUBRUTINAS-----------
;ESTA ES UNA SUBRUTINA NO ANIDADA, QUE SOLO ALCANZARÁ A GUARDAR UN VALOR DE PC 
;EN EL NIVEL 0 DE LA PILA Y HARÁ QUE BRINQUE AL NIVEL 1 CON LA INSTRUCCIÓN CALL, 
;PARA QUE LUEGO AL LLEGAR A LA INSTRUCCIÓN RETURN REGRESE LA PILA AL NIVEL 0.
	    ;NOP: Esta instrucción no hace nada, solamente sirve para dejar 
	    ;pasar 1 ciclo de máquina (cm).
SUBRUTINA:  NOP
	    ;RETURN: Todas las subrutinas siempre deben terminar con la 
	    ;instrucción return, lo que hace RETURN es bajar un nivel a la pila 
	    ;y cargar en el PC el valor que esté guardado ahí, haciendo que el 
	    ;programa brinque a la parte del código después de la instrucción 
	    ;CALL que llamó esta subrutina, siguiendo así la ejecución normal 
	    ;que llevaba el programa.
	    RETURN


;ESTA ES UNA SUBRUTINA CON OTRA ANIDADA, QUE ALCANZARÁ A GUARDAR UN VALOR DE PC 
;EN EL NIVEL 0 DE LA PILA Y HARÁ QUE BRINQUE AL NIVEL 1 CON LA INSTRUCCIÓN 
;CALL, LUEGO LLAMARÁ LA SUBRUTINA ANIDADA Y ÉSTA OTRA ESCRIBIRÁ EN EL NIVEL 1 
;DE LA PILA OTRO VALOR DE PC Y SUBIRÁ AL NIVEL 2 CON LA SEGUNDA INSTRUCCIÓN CALL, 
;DESPUÉS AL LLEGAR A LA INSTRUCCIÓN RETURN DE LA SUBRUTINA ANIDADA, HARÁ QUE LA 
;PILA REGRESE AL NIVEL 1 DE LA PILA Y AL LLEGAR A LA INSTRUCCIÓN RETURN DE LA 
;PRIMERA SUBRUTINA REGRESARÁ AL NIVEL 0.
	    ;NOP: Esta instrucción no hace nada, solamente sirve para dejar 
	    ;pasar 1 ciclo de máquina (cm).
SUBRUTINA1: NOP
;CUANDO DENTRO DE UNA SUBRUTINA SE LLAME A OTRA, A LA SEGUNDA SUBRUTINA SE LE 
;DICE QUE ESTÁ ANIDADA DENTRO DE LA PRIMERA Y AL ANIDAR UNA SUBRUTINA LO QUE 
;ESTAMOS HACIENDO ES ESCRIBIR EN NIVELES SUPERIORES DE LA PILA, DEBEMOS TENER 
;CUIDADO AL HACER ESTO PORQUE SI ANIDAMOS MÁS DE 8 SUBRUTINAS DENTRO DE UNA 
;MISMA, ESTAREMOS DESBORDANDO LA PILA, APUNTANDO A UN NIVEL QUE NO EXISTE, YA 
;QUE LA PILA DEL PIC16F887 CUENTA CON 8 NIVELES, PODEMOS VER EL NIVEL DE LA PILA 
;QUE SE ESTÁ UTILIZANDO DENTRO DE MPLAB CON EL SIMULADOR ABRIENDO LA VENTANA: 
	    ;Window->Target Memory Views->Hardware Stack
;LA FLECHITA VERDE QUE APUNTA AL NIVEL DE PILA DONDE SE VA A ESCRIBIR EL 
;SIGUIENTE VALOR DEL PC, SE LLAMA STACK POINTER Y SI ESTE LLEGA A APUNTAR UN 
;NÚMERO MAYOR A 7, ES PORQUE EXISTEN MÁS DE 8 SUBRUTINAS ANIDADAS DENTRO DE UNA 
;Y EL PROGRAMA FALLARÁ FATALMENTE YA QUE ESTARÁ APUNTANDO A UN NIVEL DE LA PILA 
;QUE NO EXISTE.
	    ;CALL   k: Sirve para ejecutar una subrutina, indicada por su nombre.
	    CALL	SUBRUTINA2
	    ;RETURN: Todas las subrutinas siempre deben terminar con la 
	    ;instrucción return, lo que hace RETURN es bajar un nivel a la pila 
	    ;y cargar en el PC el valor que esté guardado ahí, haciendo que el 
	    ;programa brinque a la parte del código después de la instrucción 
	    ;CALL que llamó esta subrutina, siguiendo así la ejecución normal 
	    ;que llevaba el programa.
	    RETURN
	    
;ESTA ES LA SUBRUTINA QUE ESTÁ ANIDADA DENTRO DE LA SUBRUTINA 1 Y HACE QUE LA 
;PILA SUBA AL NIVEL 2, AUNQUE NO ESCRIBE NADA DENTRO DE ÉL.
SUBRUTINA2: ;NOP: Esta instrucción no hace nada, solamente sirve para dejar 
	    ;pasar 1 ciclo de máquina (cm).
	    NOP
	    ;RETURN: Todas las subrutinas siempre deben terminar con la 
	    ;instrucción return, lo que hace RETURN es bajar un nivel a la pila 
	    ;y cargar en el PC el valor que esté guardado ahí, haciendo que el 
	    ;programa brinque a la parte del código después de la instrucción 
	    ;CALL que llamó esta subrutina, siguiendo así la ejecución normal 
	    ;que llevaba el programa.
	    RETURN
	    
;SUBRUTINA QUE LLEGA AL ÚLTIMO NIVEL DE LA PILA, QUE VA DEL 0 AL 7.
	    ;CALL   k: Sirve para ejecutar una subrutina, indicada por su nombre.
SUB_F:	    CALL	SUB_F1
	    ;RETURN: Todas las subrutinas siempre deben terminar con la 
	    ;instrucción return.
	    RETURN
	    ;CALL   k: Sirve para ejecutar una subrutina, indicada por su nombre.
SUB_F1:	    CALL	SUB_F2
	    ;RETURN: Todas las subrutinas siempre deben terminar con la 
	    ;instrucción return.
	    RETURN
	    ;CALL   k: Sirve para ejecutar una subrutina, indicada por su nombre.
SUB_F2:	    CALL	SUB_F3
	    ;RETURN: Todas las subrutinas siempre deben terminar con la 
	    ;instrucción return.
	    RETURN
	    ;CALL   k: Sirve para ejecutar una subrutina, indicada por su nombre.
SUB_F3:	    CALL	SUB_F4
	    ;RETURN: Todas las subrutinas siempre deben terminar con la 
	    ;instrucción return.
	    RETURN
	    ;CALL   k: Sirve para ejecutar una subrutina, indicada por su nombre.
SUB_F4:	    CALL	SUB_F5
	    ;RETURN: Todas las subrutinas siempre deben terminar con la 
	    ;instrucción return.
	    RETURN
	    ;CALL   k: Sirve para ejecutar una subrutina, indicada por su nombre.
SUB_F5:	    CALL	SUB_F6
	    ;RETURN: Todas las subrutinas siempre deben terminar con la 
	    ;instrucción return.
	    RETURN
	    ;NOP: Esta instrucción no hace nada, solamente sirve para dejar 
	    ;pasar 1 ciclo de máquina (cm).
SUB_F6:	    NOP
	    ;RETURN: Todas las subrutinas siempre deben terminar con la 
	    ;instrucción return.
	    RETURN
;SI PONGO UNA SUBRUTINA MÁS ANIDADA, LO QUE PASARÁ ES QUE SE DESBORDARÁ LA PILA
;Y ESTO LO PODRÉ NOTAR PORQUE AL SIMULAR MI CÓDIGO EL STACK POINTER ESTARÁ 
;APUNTANDO A UN NIVEL QUE NO EXISTE Y NINGÚN NIVEL DE LA PILA ESTARÁ MARCADO EN 
;COLOR VERDE.
	    
	    ;Los programas en ensamblador deben acabar con la directiva END.
	    END