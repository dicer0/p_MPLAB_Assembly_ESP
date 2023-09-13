;3.- Lea el puerto C (PORTC), reste 0X3C y saque la magnitud del resultado por 
;el puerto B (PORTB).

;La directiva PROCESSOR debe ser la primera que venga en el programa y sirve 
;para indicar qu� dispositivo estoy programando.
	    PROCESSOR	16F887

;Se deben declarar 2 palabras de configuraci�n de 14 bits para setear el PIC 
;usando los registros 2007 y 2008 hexadecimales (que no pertenecen a la RAM).
	    __CONFIG	0X2007, 0X2BE4
;La primera palabra de configuraci�n que se guarda en el registro 0X2007 y sus 
;bits significan:
;1:    Apaga el modo DEBUG que revisa el c�digo l�nea por l�nea y habilita el 
;Puerto B como entradas y salidas digitales o anal�gicas (bit 13).
;0:    Apaga el Modo de Baja Tensi�n y habilita el Puerto B como entradas y 
;salidas digitales o anal�gicas (bit 12).
;1:    Activa el modo Reloj a Prueba de Fallas que monitorea si el oscilador 
;funciona bien (bit 11).
;0:    Desactiva el divisor de reloj, dejando la frecuencia default del 
;oscilador interno en el PIC que es de 4MHz (bit 10).
;11:   Activa el Brown-Out todo el tiempo, que reiniciar� al PIC si el valor de 
;voltaje en el oscilador baja de cierto rango (bits 9 y 8).
;1:    Apaga el modo de protecci�n de escritura en la memoria RAM (bit 7).
;1:    Apaga el modo de protecci�n de escritura en la memoria FLASH (bit 6).
;1:    Hace que el pin RE3 del puerto E funcione como reset, reiniciando el PIC 
;cuando le ingrese un 1 l�gico de una se�al digital (bit 5).
;0:    Enciende el Power-up Timer, hace que el PIC tarde 75 milisegundos en 
;encenderse para proteger al microcontrolador de las variaciones que vienen de 
;la fuente de alimentaci�n (bit 4).
;0:    Apaga el Watchdog (bit 3).
;100:  Elige el oscilador tipo INTOSCIO, que usa el oscilador interno incluido 
;en el PIC de 4 MHz y configura los pines RA6 y RA7 para que ambos sean 
;entradas/salidas anal�gicas o digitales (bits 2, 1 y 0).
;Por lo tanto la palabra de configuraci�n es 10 1011 1110 0100 = 2BE4
	    __CONFIG	0X2008, 0X3FFF
;La segunda palabra de configuraci�n que se guarda en el registro 0X2008 y sus 
;bits significan:
;111:        Siempre estar�n de esta manera, no se les debe cambiar (bits 13, 
;12 y 11).
;11:         Apaga el modo de protecci�n de escritura en la memoria FLASH (bits 
;10 y 9). 
;1:          Hace que el Brown-Out reinicie el PIC cuando la se�al de reloj baje 
;de 4V (bit 8), esta configuraci�n est� relacionada con la de la palabra de 
;configuraci�n anterior.
;1111 1111:  Siempre estar�n de esta manera, no se les debe cambiar (bits 7, 6, 
;5, 4, 3, 2, 1 y 0).
;Por lo tanto la palabra de configuraci�n es 11 1111 1111 1111 = 3FFF
	    
;La directiva INCLUDE sirve para abrir un archivo de texto plano, copiar todo 
;su contenido y pegarlo en el programa, en este caso se usa para a�adir el 
;archivo P16F887.INC que incluye las 35 instrucciones del PIC16F887 a mi 
;programa junto con sus directivas EQU para que las pueda usar.
	    INCLUDE	<P16F887.INC>
	    
;La directiva ORG (u origen) le indica al programa desde qu� direcci�n de la
;memoria FLASH debe empezar a guardar todas las instrucciones del c�digo y para 
;ello debe recibir una direcci�n de 13 bits.
	    ORG		0X0000
	    
;A PARTIR DE AHORA USAREMOS LAS 35 INSTRUCCIONES DEL PIC
;La directiva EQU asocia nombres a los registros de uso espec�fico y adem�s con 
;ella puedo darle a alg�n registro de prop�sito general un nombre en espec�fico,
;se usa mucho cuando se utilizan las 35 instrucciones del PIC.

;Siempre al inicializar el PIC nos encontramos en el banco 0 de la RAM porque 
;los bits RP0 y RP1 del registro STATUS se inicializan con valor 0, se cambia de 
;banco poniendo en este �rden RP1 y RP0 porque el bit RP1 es el bit 8 del 
;registro STATUS (osea el bit de su posici�n 7) y RP0 es el bit 7 del registro 
;STATUS (posici�n 6), eso hace que se vea en el �rden correcto como se ve abajo, 
;el banco en el que nos encontramos cuando en la ventana de SFRs que permite 
;ver el estado de los registros de prop�sito espec�fico, vea el estado del 
;registro STATUS.
	    ;Banco 0: RP1 = 0, RP0 = 0
	    ;Banco 1: RP1 = 0, RP0 = 1
	    ;Banco 2: RP1 = 1, RP0 = 0
	    ;Banco 3: RP1 = 1, RP0 = 1

;Ahora vamos a primero limpiar los pines de todos los puertos, ya que todos se 
;encuentran en el banco 0 y despu�s de un reset en el datasheet estos se 
;muestran como x, esto implica que no sabemos con qu� valor (1 o 0) se 
;iniciar�n, por lo que manualmente debemos poner sus bits como 0 (limpiarlos).
	    ;CLRF   F	(Z): Llena de ceros la direcci�n F del registro RAM 
	    ;indicado, como en este caso se usa un registro de prop�sito 
	    ;espec�fico (los puertos) en vez de poner un n�mero hexadecimal 
	    ;para indicar el registro F, pondr� su directiva EQU (osea su 
	    ;nombre). Esta instrucci�n siempre pone la bandera Z = 1.
	    CLRF	PORTA ;Hace 0 (limpia) todos los pines del puerto A
	    CLRF	PORTB ;Hace 0 (limpia) todos los pines del puerto B
	    CLRF	PORTC ;Hace 0 (limpia) todos los pines del puerto C
	    CLRF	PORTD ;Hace 0 (limpia) todos los pines del puerto D
	    CLRF	PORTE ;Hace 0 (limpia) todos los pines del puerto E
	    
;Ahora debo indicar si mis pines ser�n entradas o salidas y si ser�n digitales 
;o anal�gicos, para ello primero debo indicar si son digitales o anal�gicos y 
;despu�s indicar si son entradas o salidas, sino el PIC no hace caso.

;PUERTOS DIGITALES O ANAL�GICOS
;Los �nicos puertos del PIC16F887 que pueden ser entradas/salidas anal�gicas o 
;digitales son los puertos A, B y E (los dem�s siempre son digitales), para 
;indicar si los pines de los puertos A y E son digitales o anal�gicos debo 
;cambiar los bits del registro ANSEL individualmente y para indicar si los pines 
;del puerto B son digitales o anal�gicos debo cambiar los bits del registro 
;ANSELH (los registros ANSEL y ANSELH se inicializan con todos sus bits en 1, 
;osea como pines anal�gicos), donde:
	    ;Bit del registro ANSEL o ANSELH: 1 = Anal�gico
	    ;Bit del registro ANSEL o ANSELH: 0 = Digital
;Para poder hacer esto me debo trasladar al banco 3, que es donde se encuentran 
;los registros ANSEL y ANSELH, cambiando los bits RP0 y RP1 del registro STATUS.
	    ;BSF   F, B: Pone un 1 en el bit B de la direcci�n F del registro 
	    ;RAM.
	    ;BCF   F, B: Pone un 0 en el bit B de la direcci�n F del registro 
	    ;RAM.
	    ;La posici�n del bit B en el registro F se puede indicar contando 
	    ;desde cero en decimal, osea poniendo 0, 1, 2, 3, 4, 5, 6 o 7.
	    ;Pero como en este caso se usa un registro de prop�sito espec�fico 
	    ;(el registro STATUS) en vez de poner un n�mero hexadecimal para 
	    ;indicar el registro F, pondr� su directiva EQU (osea el nombre del 
	    ;registro) y tambi�n en vez de poner un n�mero decimal como B para 
	    ;indicar el bit que quiero afectar, pondr� su directiva EQU (osea el 
	    ;nombre del bit).
	    BSF		STATUS, RP1 ;RP1 = 1
	    BSF		STATUS, RP0 ;RP0 = 1
	    ;Con esto ya estoy en el banco 3
	    
	    ;CLRF   F	(Z): Llena de ceros la direcci�n F del registro RAM 
	    ;indicado. Siempre levanta la bandera ceros, Z = 1.
	    CLRF	ANSEL	;Hace todos los pines de los puertos A y E digitales.
	    CLRF	ANSELH	;Hace todos los pines del puerto B digitales.

;PUERTOS COMO ENTRADAS O SALIDAS
;Ahora debo indicar si los puertos son entradas o salidas, para hacer esto debo 
;modificar los registros TRISA, TRISB, TRISC, TRISD y TRISE; la mayor�a se 
;encuentran en el banco 1, por lo que debo cambiar el estado de los bits RP0 y 
;RP1 del registro STATUS
	    BCF		STATUS, RP1 ;RP1 = 0
	    BSF		STATUS, RP0 ;RP0 = 1
	    ;Con esto ya estoy en el banco 1
;------------Esta configuraci�n se repetir� en todos los ejercicios-------------
	    
;Ahora si ya puedo resolver el ejercicio:
;3.- Lea el puerto C (PORTC), reste 0X3C y saque la magnitud del resultado por 
;el puerto B (PORTB).

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

;En este caso el puerto C es de entrada y el B es de salida, por lo que solo 
;debo cambiar al registro TRIS asociado al puerto B:
	    ;CLRF   F	(Z): Llena de ceros la direcci�n F del registro RAM 
	    ;indicado. Siempre levanta la bandera ceros, Z = 1.
	    CLRF	TRISB ;Hace todos los pines del puerto B sean salidas.

;LUEGO ME DEBO REGRESAR AL BANCO 0 PARA QUE PUEDA MANIPULAR LOS PUERTOS
	    BCF		STATUS, RP1 ;RP1 = 0
	    BCF		STATUS, RP0 ;RP0 = 0
	    ;Con esto ya estoy en el banco 0

;Para efectuar una resta, primero debo haber cargado el n�mero que quiero restar
;al acumulador W y luego usar la instrucci�n SUBWF.
	    ;MOVLW  K: Coloca directamente en el acumulador W un n�mero binario 
	    ;cualquiera de 8 bits dado por el valor literal K, indicado en 
	    ;hexadecimal, poniendo 0Xn�mero_hexadecimal. 
RESTA:	    MOVLW	0X3C ; W = 0X3C
	    
	    ;SUBWF   F, D (C, DC, Z): Resta lo que haya en la direcci�n F del 
	    ;registro de RAM menos lo que haya en el acumulador W, la resta se 
	    ;lleva a cabo haciendo una suma entre el registro F y el 
	    ;complemento A2 de lo que haya en el acumulador W, el resultado de 
	    ;la resta se guardar� en el registro F o en el acumulador W 
	    ;dependiendo de cu�l se ponga en la posici�n de D.
	    SUBWF	PORTC, W ; W = PORTC - W = PORTC - 0X3C = PORTC + CA2(0X3C)
	    ;Podemos saber el signo del resultado dependiendo del estado de la 
	    ;bandera C (acarreo):
	;Si C = 0 el resultado de la resta fue negativo 
	    ;Sigue la ejecuci�n normal del c�digo 
	    ;Saca el complemento A2 del resultado para obtener su magnitud, 
	    ;esto se hace restando 0 hexadecimal menos el resultado negativo.
	    
	;Si C = 1 el resultado de la resta fue positivo 
	    ;SE SALTA LA SIGUIENTE L�NEA DEL C�DIGO.
	    ;Saca el resultado de la resta directamente.
	    
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
	    ;Se levanta la bandera poni�ndose en letra may�scula en la 
	    ;simulaci�n del c�digo.
	    
	    ;Z = Ceros: Se pone como 1 l�gico cuando al realizarse una 
	    ;operaci�n matem�tica el resultado es completamente cero. Se 
	    ;levanta la bandera poni�ndose en letra may�scula en la 
	    ;simulaci�n del c�digo.
		
;AHORA VAMOS A USAR UNA DE LAS 35 OPERACIONES QUE ME PERMITEN REALIZAR 
;CONDICIONALES PARECIDOS A UN IF.
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
    ;la bandera de acarreo C para saber si el resultado de la resta fue negativo 
    ;o positivo, siempre que querramos ver el estado de una bandera debemos 
    ;acceder al registro de prop�sito espec�fico STATUS, por lo que en vez de 
    ;poner un n�mero hexadecimal para indicar el registro F, pondr� su directiva 
    ;EQU (osea el nombre del registro) y en vez de poner un n�mero decimal 
    ;como B para indicar el bit que quiero alcanzar, pondr� su directiva EQU 
    ;(osea el nombre de la bandera).
	    BTFSS	STATUS, C ;Checar la bandera C del registro STATUS
	;Si C = 0 el resultado de la resta fue negativo 
	    ;Sigue la ejecuci�n normal del c�digo.
	    ;Saca el complemento A2 del resultado para obtener su magnitud, 
	    ;esto se hace restando 0 hexadecimal menos el resultado negativo.
	    
	;Si C = 1 el resultado de la resta fue positivo 
	    ;SE SALTA LA SIGUIENTE L�NEA DEL C�DIGO.
	    ;Saca el resultado de la resta directamente.
	    
	    ;SUBLW  K (C, DC, Z): Resta el valor literal K de 8 bits menos lo 
	    ;que haya en el acumulador W y el resultado de la resta lo guarda de 
	    ;nuevo en el acumulador W, los n�meros hexadecimales se declaran 
	    ;poniendo 0Xn�mero_hexadecimal.
	    ;PARA SACAR EL COMPLEMENTO A2 DE UN N�MERO NEGATIVO Y OBTENER SU 
	    ;MAGNITUD DEBEMOS RESTAR: MAGNITUD = 0 - N�MERO_NEGATIVO
	    SUBLW	0X00
	    ;W = 0X00 - W = 0X00 - (PORTC - 0X3C) = CA2(PORTC - 0X3C)
	    
	    ;MOVWF   F: Lee el contenido del acumulador W y lo coloca en un 
	    ;registro de la RAM indicado por la direcci�n F.
	    MOVWF	PORTB ;PORTB = W = CA2(PORTC - 0X30) o PORTC - 0X30
	    ;Toma lo que hay en el acumulador W que es la resta de lo que viene 
	    ;del puerto C - 0X30 y lo pasa al puerto B, si el resultado de la 
	    ;resta fue negativo, osea que la bandera C = 0, se le sac� el 
	    ;complemento A2 restando cero menos el resultado y sino simplemente
	    ;se mostr� el resultado de la resta binaria.
	    
	    ;GOTO   k: Sirve para hacer que el programa brinque a otra parte del 
	    ;c�digo, indicado por un signo de pesos seguido de un signo menos y 
	    ;el n�mero de instrucciones hacia atr�s que quiero que brinque el 
	    ;programa o por una directiva EQU que tenga el nombre de la parte 
	    ;del c�digo a donde quiero que brinque el programa que se debe poner
	    ;en el lugar del valor literal k.
	    GOTO	RESTA
	    ;Todos los c�digos en ensamblador deben tener una instrucci�n GOTO
	    ;para que el PIC repita su funci�n indefinidamente.
	    
	    ;Y adem�s deben acabar con la directiva END.
	    END