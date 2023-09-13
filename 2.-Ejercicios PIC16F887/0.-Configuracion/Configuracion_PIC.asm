;La directiva PROCESSOR debe ser la primera que venga en el programa y sirve 
;para indicar qué dispositivo estoy programando.
	    PROCESSOR	16F887

;Se deben declarar 2 palabras de configuración de 14 bits para setear el PIC 
;usando los registros 2007 y 2008 hexadecimales (que no pertenecen a la RAM).
	    __CONFIG	0X2007, 0X2BE4
;La primera palabra de configuración que se guarda en el registro 0X2007 y sus 
;bits significan:
;1:    Apaga el modo DEBUG que revisa el código línea por línea y habilita el 
;Puerto B como entradas y salidas digitales o analógicas (bit 13).
;0:    Apaga el Modo de Baja Tensión y habilita el Puerto B como entradas y 
;salidas digitales o analógicas (bit 12).
;1:    Activa el modo Reloj a Prueba de Fallas que monitorea si el oscilador 
;funciona bien (bit 11).
;0:    Desactiva el divisor de reloj, dejando la frecuencia default del 
;oscilador interno en el PIC que es de 4MHz (bit 10).
;11:   Activa el Brown-Out todo el tiempo, que reiniciará al PIC si el valor de 
;voltaje en el oscilador baja de cierto rango (bits 9 y 8).
;1:    Apaga el modo de protección de escritura en la memoria RAM (bit 7).
;1:    Apaga el modo de protección de escritura en la memoria FLASH (bit 6).
;1:    Hace que el pin RE3 del puerto E funcione como reset, reiniciando el PIC 
;cuando le ingrese un 1 lógico de una señal digital (bit 5).
;0:    Enciende el Power-up Timer, hace que el PIC tarde 75 milisegundos en 
;encenderse para proteger al microcontrolador de las variaciones que vienen de 
;la fuente de alimentación (bit 4).
;0:    Apaga el Watchdog (bit 3).
;100:  Elige el oscilador tipo INTOSCIO, que usa el oscilador interno incluido 
;en el PIC de 4 MHz y configura los pines RA6 y RA7 para que ambos sean 
;entradas/salidas analógicas o digitales (bits 2, 1 y 0).
;Por lo tanto la palabra de configuración es 10 1011 1110 0100 = 2BE4
	    __CONFIG	0X2008, 0X3FFF
;La segunda palabra de configuración que se guarda en el registro 0X2008 y sus 
;bits significan:
;111:        Siempre estarán de esta manera, no se les debe cambiar (bits 13, 
;12 y 11).
;11:         Apaga el modo de protección de escritura en la memoria FLASH (bits 
;10 y 9). 
;1:          Hace que el Brown-Out reinicie el PIC cuando la señal de reloj baje 
;de 4V (bit 8), esta configuración está relacionada con la de la palabra de 
;configuración anterior.
;1111 1111:  Siempre estarán de esta manera, no se les debe cambiar (bits 7, 6, 
;5, 4, 3, 2, 1 y 0).
;Por lo tanto la palabra de configuración es 11 1111 1111 1111 = 3FFF
	    
;La directiva INCLUDE sirve para abrir un archivo de texto plano, copiar todo 
;su contenido y pegarlo en el programa, en este caso se usa para añadir el 
;archivo P16F887.INC que incluye las 35 instrucciones del PIC16F887 a mi 
;programa junto con sus directivas EQU para que las pueda usar.
	    INCLUDE	<P16F887.INC>
	    
;La directiva ORG (u origen) le indica al programa desde qué dirección de la
;memoria FLASH debe empezar a guardar todas las instrucciones del código y para 
;ello debe recibir una dirección de 13 bits.
	    ORG		0X0000
	    
;A PARTIR DE AHORA USAREMOS LAS 35 INSTRUCCIONES DEL PIC
;La directiva EQU asocia nombres a los registros de uso específico y además con 
;ella puedo darle a algún registro de propósito general un nombre en específico,
;se usa mucho cuando se utilizan las 35 instrucciones del PIC.

;Siempre al inicializar el PIC nos encontramos en el banco 0 de la RAM porque 
;los bits RP0 y RP1 del registro STATUS se inicializan con valor 0, se cambia de 
;banco poniendo en este órden RP1 y RP0 porque el bit RP1 es el bit 8 del 
;registro STATUS (osea el bit de su posición 7) y RP0 es el bit 7 del registro 
;STATUS (posición 6), eso hace que se vea en el órden correcto como se ve abajo, 
;el banco en el que nos encontramos cuando en la ventana de SFRs que permite 
;ver el estado de los registros de propósito específico, vea el estado del 
;registro STATUS.
	    ;Banco 0: RP1 = 0, RP0 = 0
	    ;Banco 1: RP1 = 0, RP0 = 1
	    ;Banco 2: RP1 = 1, RP0 = 0
	    ;Banco 3: RP1 = 1, RP0 = 1

;Ahora vamos a primero limpiar los pines de todos los puertos, ya que todos se 
;encuentran en el banco 0 y después de un reset en el datasheet estos se 
;muestran como x, esto implica que no sabemos con qué valor (1 o 0) se 
;iniciarán, por lo que manualmente debemos poner sus bits como 0 (limpiarlos).
	    ;CLRF   F	(Z): Llena de ceros la dirección F del registro RAM 
	    ;indicado, como en este caso se usa un registro de propósito 
	    ;específico (los puertos) en vez de poner un número hexadecimal 
	    ;para indicar el registro F, pondré su directiva EQU (osea su 
	    ;nombre). Esta instrucción siempre pone la bandera Z = 1.
	    CLRF	PORTA ;Hace 0 (limpia) todos los pines del puerto A
	    CLRF	PORTB ;Hace 0 (limpia) todos los pines del puerto B
	    CLRF	PORTC ;Hace 0 (limpia) todos los pines del puerto C
	    CLRF	PORTD ;Hace 0 (limpia) todos los pines del puerto D
	    CLRF	PORTE ;Hace 0 (limpia) todos los pines del puerto E
	    
;Ahora debo indicar si mis pines serán entradas o salidas y si serán digitales 
;o analógicos, para ello primero debo indicar si son digitales o analógicos y 
;después indicar si son entradas o salidas, sino el PIC no hace caso.

;PUERTOS DIGITALES O ANALÓGICOS
;Los únicos puertos del PIC16F887 que pueden ser entradas/salidas analógicas o 
;digitales son los puertos A, B y E (los demás siempre son digitales), para 
;indicar si los pines de los puertos A y E son digitales o analógicos debo 
;cambiar los bits del registro ANSEL individualmente y para indicar si los pines 
;del puerto B son digitales o analógicos debo cambiar los bits del registro 
;ANSELH (los registros ANSEL y ANSELH se inicializan con todos sus bits en 1, 
;osea como pines analógicos), donde:
	    ;Bit del registro ANSEL o ANSELH: 1 = Analógico
	    ;Bit del registro ANSEL o ANSELH: 0 = Digital
;Para poder hacer esto me debo trasladar al banco 3, que es donde se encuentran 
;los registros ANSEL y ANSELH, cambiando los bits RP0 y RP1 del registro STATUS.
	    ;BSF   F, B: Pone un 1 en el bit B de la dirección F del registro 
	    ;RAM.
	    ;BCF   F, B: Pone un 0 en el bit B de la dirección F del registro 
	    ;RAM.
	    ;La posición del bit B en el registro F se puede indicar contando 
	    ;desde cero en decimal, osea poniendo 0, 1, 2, 3, 4, 5, 6 o 7.
	    ;Pero como en este caso se usa un registro de propósito específico 
	    ;(el registro STATUS) en vez de poner un número hexadecimal para 
	    ;indicar el registro F, pondré su directiva EQU (osea el nombre del 
	    ;registro) y también en vez de poner un número decimal como B para 
	    ;indicar el bit que quiero afectar, pondré su directiva EQU (osea el 
	    ;nombre del bit).
	    BSF		STATUS, RP1 ;RP1 = 1
	    BSF		STATUS, RP0 ;RP0 = 1
	    ;Con esto ya estoy en el banco 3
	    
	    ;CLRF   F	(Z): Llena de ceros la dirección F del registro RAM 
	    ;indicado. Siempre levanta la bandera ceros, Z = 1.
	    CLRF	ANSEL	;Hace todos los pines de los puertos A y E digitales.
	    CLRF	ANSELH	;Hace todos los pines del puerto B digitales.

;PUERTOS COMO ENTRADAS O SALIDAS
;Ahora debo indicar si los puertos son entradas o salidas, para hacer esto debo 
;modificar los registros TRISA, TRISB, TRISC, TRISD y TRISE; la mayoría se 
;encuentran en el banco 1, por lo que debo cambiar el estado de los bits RP0 y 
;RP1 del registro STATUS
	    BCF		STATUS, RP1 ;RP1 = 0
	    BSF		STATUS, RP0 ;RP0 = 1
	    ;Con esto ya estoy en el banco 1
;------------Esta configuración se repetirá en todos los ejercicios-------------

;La configuración del PIC será jalada por una instrucción INCLUDE, para poder 
;hacerlo debo poner la dirección de la carpeta que llega hasta donde se 
;encuentra el archivo dentro de este proyecto de MPLABX en mi computadora, con 
;todo y el nombre del archivo que es Configuracion_PIC.asm de la siguiente 
;manera:
	    ;INCLUDE	<C:\Users\diego\Documents\Aprendiendo MPLAB (Ensamblador)\EjerciciosPIC16F887.X\Configuracion_PIC.asm>
;Lo que hace la configuración es indicar el PIC que estoy usando, declarar las 
;2 palabras de configuración, usar otra directiva INCLUDE para jalar el archivo 
;P16F887.INC que incluye las 35 instrucciones del PIC junto con las directivas 
;EQU (los nombres) de sus registros, la directiva ORG que indica la dirección de 
;la memoria FLASH desde donde se empezará a guardar el código, el limpiado 
;(poner en 0) de todos los bits de los puertos (A, B, C, D y E) y hacer que los 
;puertos A, B y E (que son los únicos que pueden ser analógicos o digitales) 
;sean todos entradas o salidas digitales.