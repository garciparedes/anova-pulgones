/*
 * University: Universidad de Valladolid
 * Degree: Grado en Estadística
 * Subject: Regresión y ANOVA
 * Year: 2017/18
 * Teacher: Lourdes Barba Escribá
 * Author: Sergio García Prado (garciparedes.me)
 * Name: Práctica Pulgones
 *
 */
data pulgones;
	do semana=1 to 6;

		do repet=1 to 40;
			input recuento @@;
			output;
		end;
	end;
	datalines;
	12 1 6 1 5 7 1 1 2 1 20 0 9 7 0 12 2 0 0 2 8 0 11 2 21 0 3 18 2 2 6 6
	5 1 12 0 3 1 1 18 40 16 32 15 44 41 43 53 67 21 6 31 15 11 21 40 15 50
	17 32 24 7 25 11 64 22 50 27 3 46 45 10 8 27 34 19 86 83 17 36 86 63
	20 68 55 42 24 29 20 27 26 63 40 46 7 15 10 30 46 26 15 42 6 28 7 9 5
	35 6 9 108 38 35 64 21 20 62 25 0 0 29 2 3 0 4 2 6 7 5 4 6 0 0 5 1 3 2
	2 2 5 0 1 1 0 3 1 2 0 3 3 18 7 21 0 0 0 2 3 0 40 5 7 0 0 0 1 1 2 1 0
	25 1 0 0 0 0 0 0 0 5 0 2 0 0 0 2 0 0 0 4 0 0 0 0 2 0 0 0 0 2 1 0 0 1 7
	0 0 0 4 1 5 2 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
;
run;

proc print data=pulgones (obs=5);
run;


/**
 *
 * 1) ¿Es adecuado utilizar un modelo de un factor para ello? Haz un análisis
 * 		descriptivo de los datos por semanas y valora las hipótesis que se
 *		asumen en el modelo.
 *
 */
proc univariate data=pulgones;
   class semana;
   var recuento;
   histogram recuento / normal;
   qqplot recuento / normal
                     (mu=est sigma=est color=blue w=1);
run;

proc sgplot data=pulgones;
	vbox recuento /  group=semana;
run;



/**
 *
 * 2)	Realiza el contraste de igualdad de medias y analiza los residuos. ¿Qué 
 * 		conclusiones sacas?
 *
 */

proc glm data=pulgones PLOTS(UNPACK)=DIAGNOSTICS;
	class semana;
	model recuento=semana;
run;


/**
 *
 * 3)	Realiza el test de Levene. ¿Te sorprende el resultado?
 *
 */
proc glm data=pulgones;
	class semana;
	model recuento=semana;
	means semana / hovtest=levene;
run;

/**
 *
 * 4)	Transforma la respuesta mediante log(recuento+1) y repite el apartado 2.
 * 		¿Qué cambios observas?
 *
 */
data pulgones_log;
	set pulgones;
	recuento=log(recuento + 1);
run;

proc sgplot data=pulgones_log;
	vbox recuento /  group=semana;
run;


proc glm data=pulgones_log PLOTS(UNPACK)=DIAGNOSTICS;
	class semana;
	model recuento=semana;
	means semana / hovtest=levene bon;
run;

/**
 *
 * 5)	Realiza el test de kruskal-Wallis sobre los datos originales para 
 * 		contrastar la igualdad de medias.
 *
 */
proc npar1way data=pulgones wilcoxon;
	class semana;
	var recuento;
run;