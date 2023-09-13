;13.- Realiza una subrutina que guarde un valor del contador de programa (PC) 
;en un nivel superior al nivel 0 de la Pila.
	    
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
;13.- Realiza una subrutina que guarde un valor del contador de programa (PC) 
;en un nivel superior al nivel 0 de la Pila.
	    
;TODAS LAS SUBRUTINAS LAS DEBO DECLARAR HASTA LA PARTE DE ABAJO EN MI PROGRAMA.
;UNA SUBRUTINA ES COMO UNA FUNCI�N EN CUALQUIER OTRO LENGUAJE DE PROGRAMACI�N, 
;YA QUE SIRVE PARA ESCRIBIR C�DIGO QUE SE REUTILIZAR� VARIAS VECES DENTRO DE UN 
;MISMO PROGRAMA, SE LE DEBE ASIGNAR UN NOMBRE A LA SUBRUTINA (O DIRECTIVA EQU) 
;Y CUANDO LO QUIERA USAR SIMPLEMENTE DEBO USAR LA INSTRUCCI�N CALL Y EL NOMBRE 
;DE LA SUBRUTINA.
;AL UTILIZAR LA INSTRUCCI�N CALL SE MODIFICA EL ESTADO DE LA PILA, QUE ES UN 
;FRAGMENTO DE LA MEMORIA RAM DISE�ADO PARA GUARDAR VALORES DEL CONTADOR DE 
;PROGRAMA (PC) PARA APUNTAR A DIRECCIONES DE LA MEMORIA FLASH, OSEA A L�NEAS 
;ESPEC�FICAS DE MI C�DIGO, LA PILA EN EL PIC16F887 CONSTA DE 8 NIVELES, POR LO 
;QUE SOLO PODREMOS DECLARAR SUBRUTINAS QUE ANIDEN 8 SURUTINAS DENTRO DE ELLAS, 
;AUNQUE PODREMOS CREAR LAS SUBRUTINAS QUE QUERRAMOS SIEMPRE Y CUANDO SE RESPETE 
;ESTA CONDICI�N. LAS ACCIONES QUE HACE EL PROGRAMA CUANDO SE USA CALL SON:
    ;Almacena en un nivel de la Pila el valor que le sigue al PC que hay 
    ;donde se us� la instrucci�n CALL, en este caso como CALL se usa en la 
    ;l�nea 58 del c�digo, se guardar�a el valor 59 en el nivel 0 de la pila, 
    ;pero como en ese nivel hay un comentario, se guarda en la pila el valor 
    ;del PC donde se encuentra la siguiente l�nea de c�digo, osea el 67 en la 
    ;columna Location de la Pila.
    
    ;Sube el nivel de la Pila, que cuenta del 0 al 7, en este caso subir� al 
    ;nivel 1.
    
    ;Carga en el PC el valor de donde se encuentra la subrutina que se quiere 
    ;usar, en este caso como la subrutina se declar� hasta el final del c�digo
    ;en la l�nea 167, ese valor se carga al PC.
;PARA SIMULAR EL COMPORTAMIENTO DE LA PILA DEBO USAR LA HERRAMIENTA STOPWATCH 
;DE MPLABX Y SUS BREAKPOINTS, EN ESPEC�FICO SI QUIERO VER LOS NIVELES DE LA 
;PILA QUE ALCANZA CADA SUBRUTINA DEBO PONER UN BREAKPOINT JUSTO EN SU 
;INSTRUCCI�N RETURN
	    ;CALL   k: Sirve para llamar una subrutina por su nombre y ejecutar 
	    ;una acci�n que se pueda repetir varias dentro del mismo c�digo, de 
	    ;esta manera esa acci�n no la debo escribir varias veces.
INICIO:	    CALL	SUBRUTINA ;Llama la subrutina que no tiene otra anidada.
	    ;NOP: Esta instrucci�n no hace nada, solamente sirve para dejar 
	    ;pasar 1 ciclo de m�quina (cm). En los microcontroladores 1 ciclo de 
	    ;m�quina equivale a 4 ciclos del oscilador (o se�al de reloj). Si 
	    ;estamos utilizando el oscilador interno del PIC16F887 sin activar 
	    ;el divisor de reloj, la frecuencia del reloj es de 4MHz, por lo que 
	    ;1 cm = 4*(1/4X10^6) = 1 microsegundo = 1 us
	    NOP
	    
	    ;CALL   k: Sirve para ejecutar una subrutina, indicada por su nombre.
	    CALL	SUBRUTINA1 ;Llama la subrutina que tiene otra anidada.
	    ;NOP: Esta instrucci�n no hace nada, solamente sirve para dejar 
	    ;pasar 1 ciclo de m�quina (cm).
	    NOP
	    
	    ;CALL   k: Sirve para ejecutar una subrutina, indicada por su nombre.
	    CALL	SUB_F ;Llama la subrutina que llega al nivel 7 de la pila.
	    ;NOP: Esta instrucci�n no hace nada, solamente sirve para dejar 
	    ;pasar 1 ciclo de m�quina (cm).
	    NOP
	    
	    
	    ;GOTO   k: Sirve para hacer que el programa brinque a otra parte del 
	    ;c�digo, indicado por una directiva EQU que tenga el nombre de la 
	    ;parte del c�digo a donde quiero que brinque el programa.
	    GOTO	INICIO
	    ;Todos los c�digos en ensamblador deben tener al menos una 
	    ;instrucci�n GOTO cuya funci�n sea ocasionar que el PIC repita su 
	    ;funci�n indefinidamente.


;-----------HASTA ABAJO DEL PROGRAMA SE DECLARAN TODAS LAS SUBRUTINAS-----------
;ESTA ES UNA SUBRUTINA NO ANIDADA, QUE SOLO ALCANZAR� A GUARDAR UN VALOR DE PC 
;EN EL NIVEL 0 DE LA PILA Y HAR� QUE BRINQUE AL NIVEL 1 CON LA INSTRUCCI�N CALL, 
;PARA QUE LUEGO AL LLEGAR A LA INSTRUCCI�N RETURN REGRESE LA PILA AL NIVEL 0.
	    ;NOP: Esta instrucci�n no hace nada, solamente sirve para dejar 
	    ;pasar 1 ciclo de m�quina (cm).
SUBRUTINA:  NOP
	    ;RETURN: Todas las subrutinas siempre deben terminar con la 
	    ;instrucci�n return, lo que hace RETURN es bajar un nivel a la pila 
	    ;y cargar en el PC el valor que est� guardado ah�, haciendo que el 
	    ;programa brinque a la parte del c�digo despu�s de la instrucci�n 
	    ;CALL que llam� esta subrutina, siguiendo as� la ejecuci�n normal 
	    ;que llevaba el programa.
	    RETURN


;ESTA ES UNA SUBRUTINA CON OTRA ANIDADA, QUE ALCANZAR� A GUARDAR UN VALOR DE PC 
;EN EL NIVEL 0 DE LA PILA Y HAR� QUE BRINQUE AL NIVEL 1 CON LA INSTRUCCI�N 
;CALL, LUEGO LLAMAR� LA SUBRUTINA ANIDADA Y �STA OTRA ESCRIBIR� EN EL NIVEL 1 
;DE LA PILA OTRO VALOR DE PC Y SUBIR� AL NIVEL 2 CON LA SEGUNDA INSTRUCCI�N CALL, 
;DESPU�S AL LLEGAR A LA INSTRUCCI�N RETURN DE LA SUBRUTINA ANIDADA, HAR� QUE LA 
;PILA REGRESE AL NIVEL 1 DE LA PILA Y AL LLEGAR A LA INSTRUCCI�N RETURN DE LA 
;PRIMERA SUBRUTINA REGRESAR� AL NIVEL 0.
	    ;NOP: Esta instrucci�n no hace nada, solamente sirve para dejar 
	    ;pasar 1 ciclo de m�quina (cm).
SUBRUTINA1: NOP
;CUANDO DENTRO DE UNA SUBRUTINA SE LLAME A OTRA, A LA SEGUNDA SUBRUTINA SE LE 
;DICE QUE EST� ANIDADA DENTRO DE LA PRIMERA Y AL ANIDAR UNA SUBRUTINA LO QUE 
;ESTAMOS HACIENDO ES ESCRIBIR EN NIVELES SUPERIORES DE LA PILA, DEBEMOS TENER 
;CUIDADO AL HACER ESTO PORQUE SI ANIDAMOS M�S DE 8 SUBRUTINAS DENTRO DE UNA 
;MISMA, ESTAREMOS DESBORDANDO LA PILA, APUNTANDO A UN NIVEL QUE NO EXISTE, YA 
;QUE LA PILA DEL PIC16F887 CUENTA CON 8 NIVELES, PODEMOS VER EL NIVEL DE LA PILA 
;QUE SE EST� UTILIZANDO DENTRO DE MPLAB CON EL SIMULADOR ABRIENDO LA VENTANA: 
	    ;Window->Target Memory Views->Hardware Stack
;LA FLECHITA VERDE QUE APUNTA AL NIVEL DE PILA DONDE SE VA A ESCRIBIR EL 
;SIGUIENTE VALOR DEL PC, SE LLAMA STACK POINTER Y SI ESTE LLEGA A APUNTAR UN 
;N�MERO MAYOR A 7, ES PORQUE EXISTEN M�S DE 8 SUBRUTINAS ANIDADAS DENTRO DE UNA 
;Y EL PROGRAMA FALLAR� FATALMENTE YA QUE ESTAR� APUNTANDO A UN NIVEL DE LA PILA 
;QUE NO EXISTE.
	    ;CALL   k: Sirve para ejecutar una subrutina, indicada por su nombre.
	    CALL	SUBRUTINA2
	    ;RETURN: Todas las subrutinas siempre deben terminar con la 
	    ;instrucci�n return, lo que hace RETURN es bajar un nivel a la pila 
	    ;y cargar en el PC el valor que est� guardado ah�, haciendo que el 
	    ;programa brinque a la parte del c�digo despu�s de la instrucci�n 
	    ;CALL que llam� esta subrutina, siguiendo as� la ejecuci�n normal 
	    ;que llevaba el programa.
	    RETURN
	    
;ESTA ES LA SUBRUTINA QUE EST� ANIDADA DENTRO DE LA SUBRUTINA 1 Y HACE QUE LA 
;PILA SUBA AL NIVEL 2, AUNQUE NO ESCRIBE NADA DENTRO DE �L.
SUBRUTINA2: ;NOP: Esta instrucci�n no hace nada, solamente sirve para dejar 
	    ;pasar 1 ciclo de m�quina (cm).
	    NOP
	    ;RETURN: Todas las subrutinas siempre deben terminar con la 
	    ;instrucci�n return, lo que hace RETURN es bajar un nivel a la pila 
	    ;y cargar en el PC el valor que est� guardado ah�, haciendo que el 
	    ;programa brinque a la parte del c�digo despu�s de la instrucci�n 
	    ;CALL que llam� esta subrutina, siguiendo as� la ejecuci�n normal 
	    ;que llevaba el programa.
	    RETURN
	    
;SUBRUTINA QUE LLEGA AL �LTIMO NIVEL DE LA PILA, QUE VA DEL 0 AL 7.
	    ;CALL   k: Sirve para ejecutar una subrutina, indicada por su nombre.
SUB_F:	    CALL	SUB_F1
	    ;RETURN: Todas las subrutinas siempre deben terminar con la 
	    ;instrucci�n return.
	    RETURN
	    ;CALL   k: Sirve para ejecutar una subrutina, indicada por su nombre.
SUB_F1:	    CALL	SUB_F2
	    ;RETURN: Todas las subrutinas siempre deben terminar con la 
	    ;instrucci�n return.
	    RETURN
	    ;CALL   k: Sirve para ejecutar una subrutina, indicada por su nombre.
SUB_F2:	    CALL	SUB_F3
	    ;RETURN: Todas las subrutinas siempre deben terminar con la 
	    ;instrucci�n return.
	    RETURN
	    ;CALL   k: Sirve para ejecutar una subrutina, indicada por su nombre.
SUB_F3:	    CALL	SUB_F4
	    ;RETURN: Todas las subrutinas siempre deben terminar con la 
	    ;instrucci�n return.
	    RETURN
	    ;CALL   k: Sirve para ejecutar una subrutina, indicada por su nombre.
SUB_F4:	    CALL	SUB_F5
	    ;RETURN: Todas las subrutinas siempre deben terminar con la 
	    ;instrucci�n return.
	    RETURN
	    ;CALL   k: Sirve para ejecutar una subrutina, indicada por su nombre.
SUB_F5:	    CALL	SUB_F6
	    ;RETURN: Todas las subrutinas siempre deben terminar con la 
	    ;instrucci�n return.
	    RETURN
	    ;NOP: Esta instrucci�n no hace nada, solamente sirve para dejar 
	    ;pasar 1 ciclo de m�quina (cm).
SUB_F6:	    NOP
	    ;RETURN: Todas las subrutinas siempre deben terminar con la 
	    ;instrucci�n return.
	    RETURN
;SI PONGO UNA SUBRUTINA M�S ANIDADA, LO QUE PASAR� ES QUE SE DESBORDAR� LA PILA
;Y ESTO LO PODR� NOTAR PORQUE AL SIMULAR MI C�DIGO EL STACK POINTER ESTAR� 
;APUNTANDO A UN NIVEL QUE NO EXISTE Y NING�N NIVEL DE LA PILA ESTAR� MARCADO EN 
;COLOR VERDE.
	    
	    ;Los programas en ensamblador deben acabar con la directiva END.
	    END