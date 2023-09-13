/*CÓDIGO EN C++ PARA CALCULAR LOS VALORES DE LAS SUBRUTINAS DE TIEMPO DE 1, 2 Y 3 VARIABLES, este tipo de código tiene 
extensión .cpp (C Plus Plus). Las subrutinas de tiempo sirven para obtener retardos de tiempo donde el programa 
ensamblador deja pasar cierto tiempo para ejecutar la siguiente línea de código, a esto se le llama manejo de tiempos*/
/*Para poder correr el código en Visual Studio Code debo haber instalado en la computadora MinGW, después añadir las 
extensiones C/C++ y Code Runner en Visual Studio y luego para correr el código debo dar clic en:
			Ctrl+Alt+N para correr el código
			Ctrl+Alt+M para dejar de correr el código
O simplemente debo dar clic en el botón de PLAY que se encuentra en la esquina superior derecha.
Si quiero limpiar la consola después de ejecutar mi programa debo escribir: 
			cls
Y dar clic en la tecla Enter.
El proceso de descarga se encuentra en el link:
https://platzi.com/blog/compilando-cc-desde-visual-studio-code-windows-10/*/

//LIBRERÍAS
#include <iostream>
/*Esto significa input/output stream y sirve para poder ingresar datos al sistema por medio de cin>> y sacarlos por 
medio de cout<<*/
#include <fstream>
/*Esta librería sirve para que no se cierre nuestro programa, incluye la función system que sirve para controlar 
algunos aspectos de la consola que permite sacar y meter datos al programa*/
#include <conio.h>
/*Esta librería sirve para dar estilo estético a la letra de la consola y a la misma consola, aunque no se usará para
eso en el código, la usaremos solamente por la instrucción getch() que para el programa y nos deja ver lo que se 
imprimió en consola*/

using namespace std; //Esto lo incluye la librería <iostream>
//Se declara esta línea de código para que cuando use cin>> y cout<< no las deba declarar como std::cin>> y std::cout<<

/*DECLARACIÓN DE CONSTANTES USANDO #define:
	-	nops: Guarda el valor del número de NOPS, que es una instrucción del lenguaje ensamblador usada en la subrutina 
		de tiempo que no hace nada, solo deja pasar 1 ciclo de máquina, en el curso de microcontroladores se declaran 
		3 NOPS dentro de la subrutina de tiempo para que sea un valor conocido y fijo en la ecuación.
Hay que tener en cuenta que al declarar constantes con #define debemos hacerlo después de los #include (que importan 
librerías), pero antes de declarar nuestras funciones y demás.*/
#define nops 3 //Aquí declaro el número de nops que se usaré en las ecuaciones de mis subrutinas de 1, 2 y 3 variables 

int main(){
	/*INICIO DE LA FUNCIÓN PRINCIPAL QUE NO PUEDE SER DE TIPO VOID, POR LO QUE RETORNA UN CERO CON UN RETURN CUANDO 
	TERMINA DE EJECUTARSE*/
	float t, f, ecuacion, cm, tcm, tiempo_requerido;
	/*DECLARACIÓN DE LAS VARIABLES:
	- 	t: Guarda el tiempo que quiero que se tarde mi subrutina en microsegundos (us).
	-	f (frecuencia del oscilador en el PIC16F887): Guarda la frecuencia en MegaHertz (MHz) del oscilador usado en 
		el PIC. Si usamos el oscilador interno del PIC sin cambiar el divisor de reloj, la frecuencia es de 4MHz.
	-	ecuacion: Sirve para declarar las 3 ecuaciones de las subrutinas de tiempo de 1, 2 y 3 variables.
	-	cm: Guarda el valor que vale un solo ciclo de máquina respecto a la frecuencia del oscilador en el PIC f que 
		introdujo el usuario en consola, donde  1 cm = 4*T = 4*(1/f) ya que 1 ciclo de máquina equivale a 4 ciclos del 
		oscilador. Si usamos el oscilador interno del PIC sin cambiar el divisor de reloj, f = 4MHz, por lo tanto 
		cm = 1us (microsegundo), pero si usamos otra frecuencia de oscilador en el PIC, este valor cambia.
	-	tcm: Es el tiempo real que debo obtener como resultado de las ecuaciones de mis subrutinas de tiempo de 1, 2 y 3 
		variables, ya tomando en cuenta el tiempo t introducido por el usuario en consola y el valor de 1 cm, que puede 
		variar dependiendo de la frecuencia del oscilador en el PIC. Como esto lo obtenemos de una división entre t y cm
		que deben tener unidades iguales, tcm es adimensional.
	-	tiempo_requerido: Esta variable también guarda el valor correcto que debemos obtener de las ecuaciones de las 
		subrutinas de tiempo de 1, 2 y 3 variables de la misma manera como lo hace tcm, pero esta variable se usa 
		específicamente para evaluarse en la condición if, que actualizará el valor de tiempo_requerido si el resultado 
		obtenido por la ecuación de la subrutina de tiempo es menor a tcm y mayor o igual a cero, para que finalmente se 
		guarde el resultado correcto de la ecuación en una variable y el programa ya no vuelva a entrar al condicional if
		para guardar un valor diferente. Esta variable se actualiza a su valor original después de evaluar cada ecuación 
		de las subrutinas de tiempo.*/
	float tiempo_faltante, cm1, cm2, cm3, NOPS_faltantes_ST1V, NOPS_faltantes_ST2V, NOPS_faltantes_ST3V;
	/*DECLARACIÓN DE LAS VARIABLES:
	-	tiempo_faltante: Guarda el resultado de la resta hecha entre tcm y ecuación para ver el tiempo que le faltó al 
		resultado de la ecuación para alcanzar el tiempo deseado dado por tcm, esto después se guadará como un número de 
		NOPS que deberán ser incluidos en el código de lenguaje ensamblador en las variables NOPS_faltantes_ST1V, 
		NOPS_faltantes_ST2V y NOPS_faltantes_ST3V.
	-	cm1: Guarda el tiempo alcanzado por la ecuación de subrutina de tiempo de 1 variable que debe ser un número 
		entero y puede ser igual o no al  tiempo t introducido por el usuario, si no lo alcanzó, el tiempo faltante se 
		guardará en la variable NOPS_faltantes_ST1V.
	-	cm2: Guarda el tiempo alcanzado por la ecuación de subrutina de tiempo de 2 variables que debe ser un número 
		entero y puede ser igual o no al  tiempo t introducido por el usuario, si no lo alcanzó, el tiempo faltante se 
		guardará en la variable NOPS_faltantes_ST2V.
	-	cm3: Guarda el tiempo alcanzado por la ecuación de subrutina de tiempo de 3 variables que debe ser un número 
		entero y puede ser igual o no al  tiempo t introducido por el usuario, si no lo alcanzó, el tiempo faltante se 
		guardará en la variable NOPS_faltantes_ST3V.
	-	NOPS_faltantes_ST1V: Guarda el número de NOPS que faltaron en el resultado de la ecuación de subrutina de tiempo 
		de 1 variable para alcanzar el tiempo t introducido por el usuario. Cada NOP vale 1 microsegundo.
	-	NOPS_faltantes_ST2V: Guarda el número de NOPS que faltaron en el resultado de la ecuación de subrutina de tiempo 
		de 2 variables para alcanzar el tiempo t introducido por el usuario. Cada NOP vale 1 microsegundo.
	-	NOPS_faltantes_ST3V: Guarda el número de NOPS que faltaron en el resultado de la ecuación de subrutina de tiempo 
		de 3 variables para alcanzar el tiempo t introducido por el usuario. Cada NOP vale 1 microsegundo.*/
	float ST1V_var1,		ST2V_var1, ST2V_var2,		ST3V_var1, ST3V_var2, ST3V_var3;
	/*DECLARACIÓN DE LAS VARIABLES:
	-	ST1V_var1: Guarda el valor de la variable 1 resultado de la Subrutina de Tiempo 1 Variable (ST1V).
	-	ST2V_var1: Guarda el valor de la variable 1 resultado de la Subrutina de Tiempo 2 Variables (ST2V).
	-	ST2V_var2: Guarda el valor de la variable 2 resultado de la Subrutina de Tiempo 2 Variables (ST2V).
	-	ST3V_var1: Guarda el valor de la variable 1 resultado de la Subrutina de Tiempo 3 Variables (ST3V).
	-	ST3V_var2: Guarda el valor de la variable 2 resultado de la Subrutina de Tiempo 3 Variables (ST3V).
	-	ST3V_var3: Guarda el valor de la variable 3 resultado de la Subrutina de Tiempo 3 Variables (ST3V).*/
	
	cout<<"Programa para conocer el valor de las \nvariables para subrutinas de tiempo\n";
	/*Con cout<< imprimo en consola un mensaje, osea que tengo salida de datos.*/
	cout<<"\nIngrese la frecuencia del oscilador en MHz:\n";
	cin>>f;				//Ingresa la frecuencia del oscilador en el PIC16F887
	/*Con cin>> permito que el usuario pueda ingresar datos al programa por medio de la consola y guardarlos en una 
	variable.*/
	cout<<"\nIngrese el tiempo requerido en microsegundos (us):\n";
	cin>>t;				//Ingresa el tiempo que quiero que se tarde mi subrutina
	cout<<"\nEl numero de instrucciones NOP usado en las ecuaciones es de 3\n"; //# de NOPS usado en las ecuaciones.
	//cout<< y cin>> es lo que incluye la librería <iostream>
	
	//1 ciclo de máquina equivale a 4 veces el periodo de reloj, osea cm = 4*T = 4*(1/f)
	cm = 4 * (1/f);
	
	//t   = tiempo que quiero que tarde mi subrutina (introducido por el usuario cuya unidad debe ser igual a cm).
	//cm  = 4*T = 4*(1/f), equivalencia de 1 ciclo de máquina tomando en cuenta la frecuencia del oscilador.
	/*tcm = Es el tiempo real que debo obtener como resultado de las ecuaciones de mis subrutinas de tiempo de 1, 2 y 3 
	variables, ya tomando en cuenta el tiempo t introducido por el usuario en consola y el valor de cm, que puede variar 
	dependiendo de la frecuencia del oscilador en el PIC. Como esto lo obtenemos de una división entre t y cm que deben 
	tener unidades iguales, tcm es adimensional*/
	tcm = t/cm;

	/*tiempo_requerido = Esta variable también guarda el valor correcto que debemos obtener de las ecuaciones de las 
	subrutinas de tiempo de 1, 2 y 3 variables de la misma manera como lo hace tcm, pero esta variable se usa 
	específicamente para evaluarse en la condición if, que actualizará el valor de tiempo_requerido si el resultado 
	obtenido por la ecuación de la subrutina de tiempo es menor a tcm y mayor o igual a cero, para que finalmente se 
	guarde el resultado correcto de la ecuación en una variable y el programa ya no vuelva a entrar al condicional if
	para guardar un valor diferente. Esta variable se actualiza a su valor original, osea tcm después de evaluar cada 
	ecuación de las subrutinas de tiempo.*/
	tiempo_requerido = tcm;
	
	/*ECUACIÓN DE SUBRUTINA DE TIEMPO DE 1 VARIABLE: Se usa directamente la variable del bucle for para que funcione 
	como var1 y de esa forma se pueda encontrar el valor de la variable que se encuentre entre 1 y 256, que a su vez 
	sea menor o igual al tiempo de retardo solicitado por el usuario en consola.*/
	for(float var1=1; var1<=256; var1=var1+1){
		//#cm = 5 + (var1)(#NOPS + 3)
		ecuacion = 5 + (var1 * (nops+3));
		tiempo_faltante = tcm - ecuacion;
		if(tiempo_faltante<tiempo_requerido && tiempo_faltante>=0){
			ST1V_var1 = var1; //Este es el resultado correcto de la variable 1 en la subrutina de 1 variable.
			cm1 = ecuacion;
			//Este es el tiempo alcanzado (número de ciclos de máquina) en la ecuación por la subrutina de 1 variable.
			NOPS_faltantes_ST1V = tiempo_faltante; 
			//Este es el tiempo que le faltó a la ecuación de la subrutina de 1 variable para alcanzar tcm.
			tiempo_requerido = tiempo_faltante;
			/*Esta variable se actualiza para que cuando se encuentre el valor correcto de la ecuación en la subrutina,
			osea que sea mayor a cero y menor al tiempo_requerido, ya no entre al if y solo guarde ese valor como el 
			correcto en la variable ST1V_var1.*/
		}
	}
	/*Se realiza la ecuación varias veces iterando con los diferentes valores de var1 dados por el ciclo for (de 1 a 256) 
	para ver cuál de ellos cumple la condición if de obtener un resultado menor al tiempo (tcm) y mayor o igual a cero, 
	para que ese valor de var1 sea guardado en la variable ST1V_var1, el resultado de la ecuación sea guardado en la 
	variable cm1 (ciclos de máquina	de la subrutina de 1 variable) y la resta de tcm menos el resultado de la ecuación 
	sea guardada como el tiempo faltante en la variable NOPS_faltantes_ST1V. Estos tres valores se toman como el resultado 
	correcto de la ecuación de subrutina de tiempo de 1 variable y se imprimirán en consola.*/
	
	/*ACTUALIZACIÓN DE LA VARIABLE tiempo_requerido PARA QUE SEA IGUAL AL TIEMPO REQUERIDO POR EL USUARIO YA TOMANDO EN 
	CUENTA EL VALOR DE 1cm CONSIDERANDO LA FRECUENCIA DEL OSCILADOR USADO POR EL PIC.*/
	tiempo_requerido = tcm;

	/*ECUACIÓN DE SUBRUTINA DE TIEMPO DE 2 VARIABLES: Se usan directamente las variables del bucle for para que funcionen
	como var1 y var2, para de esa forma encontrar el valor de ambas variables que se encuentre entre 1 y 256, que a su vez
	satisfaga el tiempo solicitado por el usuario en la consola*/
	for(float var1=1; var1<=256; var1=1+var1){
		for(float var2=1; var2<=256; var2=1+var2){
			//#cm = 7 + var2 * (4 + (nops+3) * var1)
			ecuacion = 7 + var2 * (4 + (nops+3) * var1);
			tiempo_faltante = tcm - ecuacion;
			/*Para que un resultado de la ecuación pueda ser tomado como correcto debe ser mayor que 1 y */
			if(tiempo_faltante<tiempo_requerido && tiempo_faltante>=0){
				ST2V_var1 = var1; //Este es el resultado correcto de la variable 1 en la subrutina de 2 variables.
				ST2V_var2 = var2; //Este es el resultado correcto de la variable 2 en la subrutina de 2 variables.
				cm2 = ecuacion;
				//Este es el tiempo alcanzado (número de ciclos de máquina) en la ecuación por la subrutina de 2 variables.
				NOPS_faltantes_ST2V = tiempo_faltante;
				//Este es el tiempo que le faltó a la ecuación de la subrutina de 1 variable para alcanzar tcm.
				tiempo_requerido = tiempo_faltante;
				/*Esta variable se actualiza para que cuando se encuentre el valor correcto de la ecuación en la subrutina,
				osea que sea mayor a cero y menor al tiempo_requerido, ya no entre al if y solo guarde ese valor como el 
				correcto en las variables ST2V_var1 y ST2V_var2.*/
			}
		}
	}
	/*Se realiza la ecuación varias veces iterando con los diferentes valores de var1 y var2 dados por el ciclo for, 
	donde ambos tendrán valores de 1 a 256 para ver cuál de ellos cumple la condición if de obtener un resultado menor al 
	tiempo (tcm) y mayor o igual a cero, para que ese valor de var1 sea guardado en la variable ST2V_var1, el valor de 
	var2 sea guardado en ST2V_var2, el resultado de la ecuación sea guardado en la variable cm2 (ciclos de máquina de la 
	subrutina de 2 variables) y la resta de tcm menos el resultado de la ecuación sea guardada como el tiempo faltante en 
	la variable NOPS_faltantes_ST2V. Estos cuatro valores se toman como el resultado correcto de la ecuación de subrutina 
	de tiempo de 2 variables y se imprimirán en consola.*/

	/*ACTUALIZACIÓN DE LA VARIABLE tiempo_requerido PARA QUE SEA IGUAL AL TIEMPO REQUERIDO POR EL USUARIO YA TOMANDO EN 
	CUENTA EL VALOR DE 1cm CONSIDERANDO LA FRECUENCIA DEL OSCILADOR USADO POR EL PIC.*/
	tiempo_requerido = tcm;
	
	/*ECUACIÓN DE SUBRUTINA DE TIEMPO DE 3 VARIABLES: Se usan directamente las variables del bucle for para que funcionen
	como var1, var2 y var3, para de esa forma encontrar el valor de ambas variables que se encuentre entre 1 y 256, que 
	a su vez satisfaga el tiempo solicitado por el usuario en la consola*/
	for(float var1=1; var1<=256; var1=1+var1){
		for(float var2=1; var2<=256; var2=1+var2){
			for(float var3=1; var3<=256; var3=1+var3){
				//#cm = 9 + var1 * (var3 * (var2 * (nops+3) + 4) + 4)
				ecuacion = 9 + var1 * (var3 * (var2 * (nops+3) + 4) + 4);
				tiempo_faltante = tcm - ecuacion;
				if(tiempo_faltante<tiempo_requerido && tiempo_faltante>=0){
				ST3V_var1 = var1; //Este es el resultado correcto de la variable 1 en la subrutina de 3 variables.
				ST3V_var2 = var2; //Este es el resultado correcto de la variable 2 en la subrutina de 3 variables.
				ST3V_var3 = var3; //Este es el resultado correcto de la variable 3 en la subrutina de 3 variables.
				cm3 = ecuacion;
				//Este es el tiempo alcanzado (número de ciclos de máquina) en la ecuación por la subrutina de 3 variables.
				NOPS_faltantes_ST3V = tiempo_faltante;
				//Este es el tiempo que le faltó a la ecuación de la subrutina de 1 variable para alcanzar tcm.
				tiempo_requerido = tiempo_faltante;
				/*Esta variable se actualiza para que cuando se encuentre el valor correcto de la ecuación en la subrutina,
				osea que sea mayor a cero y menor al tiempo_requerido, ya no entre al if y solo guarde ese valor como el 
				correcto en las variables ST3V_var1, ST3V_var2 y ST3V_var3.*/
				}
			}
		}
	}
	/*Se realiza la ecuación varias veces iterando con los diferentes valores de var1, var2 y var3 dados por el ciclo for,
	donde los tres tendrán valores de 1 a 256 para ver cuál de ellos cumple la condición if de obtener un resultado menor 
	al tiempo (tcm) y mayor o igual a cero, para que ese valor de var1 sea guardado en la variable ST3V_var1, el valor de 
	var2 sea guardado en ST3V_var2, el valor de var3 sea guardado en ST3V_var3, el resultado de la ecuación sea guardado 
	en la variable cm3 (ciclos de máquina de la subrutina de 3 variables) y la resta de tcm menos el resultado de la 
	ecuación sea guardada como el tiempo faltante en la variable NOPS_faltantes_ST3V. Estos cinco valores se toman como 
	el resultado correcto de la ecuación de subrutina de tiempo de 3 variables y se imprimirán en consola.*/
	
	//RESULTADO DE LA ECUACIÓN DE SUBRUTINA DE TIEMPO DE 1 VARIABLE
	cout<<"\n\n*Valores para subrutina de 1 variable*";
	cout<<"\nVariable 1 = "<<ST1V_var1;
	cout<<"\nCiclos de maquina obtenidos: "<<cm1;
	cout<<"\nNumero de NOPS faltantes: "<<NOPS_faltantes_ST1V;
	/*Estos NOPS faltantes se pondrían después de la instrucción CALL que llamó a la subrutina de tiempo dentro del 
	archivo de lenguaje ensamblador*/
	
	//RESULTADO DE LA ECUACIÓN DE SUBRUTINA DE TIEMPO DE 2 VARIABLES
	cout<<"\n\n*Valores para subrutina de 2 variables*";
	cout<<"\nVariable 2 = "<<ST2V_var2;
	cout<<"\nVariable 1 = "<<ST2V_var1;
	cout<<"\nCiclos de maquina obtenidos: "<<cm2;
	cout<<"\nNumero de NOPS faltantes: "<<NOPS_faltantes_ST2V;
	/*Estos NOPS faltantes se pondrían después de la instrucción CALL que llamó a la subrutina de tiempo dentro del 
	archivo de lenguaje ensamblador*/
	
	//RESULTADO DE LA ECUACIÓN DE SUBRUTINA DE TIEMPO DE 3 VARIABLES
	cout<<"\n\n*Valores para subrutina de 3 variables*";
	cout<<"\nVariable 3 = "<<ST3V_var3;
	cout<<"\nVariable 2 = "<<ST3V_var2;
	cout<<"\nVariable 1 = "<<ST3V_var1;
	cout<<"\nCiclos de maquina obtenidos: "<<cm3;
	cout<<"\nNumero de NOPS faltantes: "<<NOPS_faltantes_ST3V;
	/*Estos NOPS faltantes se pondrían después de la instrucción CALL que llamó a la subrutina de tiempo dentro del 
	archivo de lenguaje ensamblador*/
	cout<<"\n";
	
	//Creaci�n del archivo.asm con el c�digo
	ofstream fs("Subrutinas.asm");
	fs<<"\n\n*Valores para subrutina de 1 variable*";
	fs<<"\nVariable 1: "<<ST1V_var1;
	fs<<"\nCiclos de maquina ejecutados: "<<cm1;
	fs<<"\nCiclos de maquina faltantes: "<<NOPS_faltantes_ST1V;
	fs<<"\nCodigo de la subrutina:";
	fs<<"\n		MOVLW	."<<ST1V_var1;
	fs<<"	;VAR1.";
	fs<<"\n		MOVWF	0x60";
	fs<<"\n		CALL	ST1V";
	fs<<"\n		;CODIGO...";
	fs<<"\nST1V		NOP";
	fs<<"\n		NOP";
	fs<<"\n		NOP";
	fs<<"\n		DECFSZ	0x60,F";
	fs<<"\n		GOTO	ST1V";
	fs<<"\n		;NOP FALTANTES: "<<NOPS_faltantes_ST1V;
	if(NOPS_faltantes_ST1V<11){
		for(int i=0;i<NOPS_faltantes_ST1V;i=i+1)
			fs<<"\n		NOP";
	}
	else{
		fs<<"\n;DEMASIADOS NOP, SE SUGIERE HACER OTRA SUBRUTINA DE TIEMPO";
	}
	fs<<"\n		RETURN";
	
	fs<<"\n\n*Valores para subrutina de 2 variables*";
	fs<<"\nVariable 1: "<<ST2V_var1;
	fs<<"\nVariable 2: "<<ST2V_var2;
	fs<<"\nCiclos de maquina ejecutados: "<<cm2;
	fs<<"\nCiclos de maquina faltantes: "<<NOPS_faltantes_ST2V;
	fs<<"\nCodigo de la subrutina:";
	fs<<"\n		MOVLW	."<<ST2V_var2;
	fs<<"	;VAR2.";
	fs<<"\n		MOVWF	0x61";
	fs<<"\n		MOVLW	."<<ST2V_var1;
	fs<<"	;VAR1.";
	fs<<"\n		MOVWF	0x62";
	fs<<"\n		CALL	ST2V";
	fs<<"\n		;CODIGO...";
	fs<<"\nST2V		MOVF	0x62,W";
	fs<<"\n		MOVWF	0x63";
	fs<<"\nDECRE2V	NOP";
	fs<<"\n		NOP";
	fs<<"\n		NOP";
	fs<<"\n		DECFSZ	0x63,F";
	fs<<"\n		GOTO	DECRE2V";
	fs<<"\n		DECFSZ	0x61,F";
	fs<<"\n		GOTO	ST2V";
	fs<<"\n		;NOP FALTANTES: "<<NOPS_faltantes_ST2V;
	if(NOPS_faltantes_ST2V<11){
		for(int i=0;i<NOPS_faltantes_ST2V;i=i+1)
			fs<<"\n		NOP";
	}
	else{
		fs<<"\n;DEMASIADOS NOP, SE SUGIERE HACER OTRA SUBRUTINA DE TIEMPO";
	}
	fs<<"\n		RETURN";
	
	fs<<"\n\n*Valores para subrutina de 3 variables*";
	fs<<"\nVariable 1: "<<ST3V_var1;
	fs<<"\nVariable 2: "<<ST3V_var2;
	fs<<"\nVariable 3: "<<ST3V_var3;
	fs<<"\nCiclos de maquina ejecutados: "<<cm3;
	fs<<"\nCiclos de maquina faltantes: "<<NOPS_faltantes_ST3V;
	fs<<"\nCodigo de la subrutina:";
	fs<<"\n		MOVLW	."<<ST3V_var1;
	fs<<"	;VAR1.";
	fs<<"\n		MOVWF	0x64";
	fs<<"\n		MOVLW	."<<ST3V_var2;
	fs<<"	;VAR2.";
	fs<<"\n		MOVWF	0x65";
	fs<<"\n		MOVLW	."<<ST3V_var3;
	fs<<"	;VAR3.";
	fs<<"\n		MOVWF	0x66";
	fs<<"\n		CALL	ST3V";
	fs<<"\n		;CODIGO...";
	fs<<"\nST3V		MOVF	0x66,W";
	fs<<"\n		MOVWF	0x67";
	fs<<"\nRECARGA3V	MOVF	0x65,W";
	fs<<"\n		MOVWF	0x68";
	fs<<"\nDECRE3V	NOP";
	fs<<"\n		NOP";
	fs<<"\n		NOP";
	fs<<"\n		DECFSZ	0x68,F";
	fs<<"\n		GOTO	DECRE3V";
	fs<<"\n		DECFSZ	0x67,F";
	fs<<"\n		GOTO	RECARGA3V";
	fs<<"\n		DECFSZ	0x64,F";
	fs<<"\n		GOTO	ST3V";
	fs<<"\n		;NOP FALTANTES: "<<NOPS_faltantes_ST3V;
	if(NOPS_faltantes_ST3V<11){
		for(int i=0;i<NOPS_faltantes_ST3V;i=i+1)
			fs<<"\n		NOP";
	}
	else{
		fs<<"\n;DEMASIADOS NOP, SE SUGIERE HACER OTRA SUBRUTINA DE TIEMPO";
	}
	fs<<"\n		RETURN";
	
	fs.close();
	//Esto sirve para cerrar el archivo creado ya que hayamos pegado en él todo el texto que queramos
	getch();
	/*getch sirve para detener la consola para que el usuario pueda ver lo que se imprime en consola y lo trae la 
	librería <conio.h>*/
	
	return 0; //LA FUNCIÓN DEVUELVE UN NÚMERO CERO CUANDO TERMINA DE EJECUTARSE 
	/*EN LAS FUNCIONES SIEMPRE DEBE EXISTIR UNA INSTRUCCIÓN RETURN (AUNQUE ESTA NO DEVUELVA NADA), SIEMPRE Y CUANDO LA 
	FUNCIÓN NO HAYA SIDO DECLARADA COMO VOID, LA FUNCIÓN PRINCIPAL O MAIN NO PUEDE SER DECLARADA COMO VOID*/
}