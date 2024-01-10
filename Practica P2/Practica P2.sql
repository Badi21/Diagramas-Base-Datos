/*
Asignatura: BASE DE DATOS

Practica: P2. Consultas en SQL

Equipo de practicas: bd2107 
 Integrante 1: Badar Tagmouti Abdoune
*/

-- EJERCICIOS:

-------------------------------------------------------
-- Consulta 1
-- 1.Socios que actualmente tienen prestadas (aún no devueltas) películas dirigidas por un director no estadounidense. Columnas:(nombre, direccion).

SELECT S.nombre, S.direccion
FROM SOCIO S
JOIN PRESTAMO T ON S.idsocio = T.socio
JOIN COPIA C ON T.pelicula = C.pelicula AND T.copia = C.num_copia
JOIN PELICULA P ON C.pelicula = P.idpel
JOIN DIRECTOR D ON P.director = D.iddir
WHERE D.nacionalidad <> 'Estadounidense' AND T.finalizado = 'NO'

/* Breve explicacion
hemos resuelto la consulta para obtener la lista de socios que tienen películas prestadas actualmente, las cuales han sido dirigidas por un director no estadounidense
Mediante una combinación de claves primarias y ajenas, hemos unido estas tablas y aplicado los filtros necesarios. El resultado obtenido muestra el nombre y la dirección de los socios que cumplen con estas condiciones
*/
	

-------------------------------------------------------
-- CONSULTA 2
-- 2.Lista de todos los socios, con indicación de las copias de las películas de nacionalidad argentinaque   hantomado   prestadas.   Para   aquellos   socios   que   no   han tomado prestadasnunca películas argentinas, rellenar lacolumna titulocon tres guiones: '---'y copia con  un 0.Ordenado  por idsocio, tituloy copia.Columnas: (idsocio, nombre, titulo, copia)

SELECT S.idsocio, S.nombre, COALESCE(P.titulo, '---') AS titulo, COALESCE(C.num_copia, 0) AS copia
FROM SOCIO S
LEFT JOIN PRESTAMO T ON S.idsocio = T.socio
LEFT JOIN COPIA C ON T.pelicula = C.pelicula AND T.copia = C.num_copia
LEFT JOIN PELICULA P ON C.pelicula = P.idpel AND P.nacionalidad = 'Argentina'
ORDER BY S.idsocio, titulo, copia

/* Breve explicacion
hemos resuelto la consulta para obtener una lista de todos los socios, indicando las copias de las películas de nacionalidad argentina que han tomado prestadas. Para aquellos socios que no han tomado prestadas películas argentinas, hemos rellenado las columnas "titulo" con tres guiones ('---') y "copia" con el valor 0. El resultado muestra los idsocio, nombre, título y copia correspondientes a los socios y las películas argentinas prestadas
*/

-------------------------------------------------------
-- CONSULTA 3
-- 3.Intérpretes  que  hanparticipado  en más  de 2películasdel  director 'WOODY  ALLEN', ordenados alfabéticamente.Columna: (idinter, nombre).

SELECT I.idinter, I.nombre
FROM INTERPRETE I
JOIN REPARTO R ON I.idinter = R.interprete
JOIN PELICULA P ON R.pelicula = P.idpel
JOIN DIRECTOR D ON P.director = D.iddir
WHERE D.nombre = 'WOODY ALLEN'
GROUP BY I.idinter, I.nombre
HAVING COUNT(DISTINCT P.idpel) > 2
ORDER BY I.nombre;

/* Breve explicacion
resolvemos la consulta para obtener los intérpretes que han participado en más de 2 películas del director 'WOODY ALLEN', ordenados alfabéticamente. Mediante una combinación de las tablas y la aplicación de filtros, hemos contado la cantidad de películas en las que cada intérprete ha participado bajo la dirección de 'WOODY ALLEN'. Luego, hemos seleccionado aquellos intérpretes que tienen un recuento mayor a 2 y los hemos ordenado alfabéticamente por su nombre
*/

-------------------------------------------------------
-- CONSULTA 4
-- 4.Número  total  de  copias  de aquellas  películas  en  las  que ha actuadoalgún intérpreteaustraliano. Columnas:(idpel,titulo,total_copias).

SELECT P.idpel, P.titulo, COUNT(C.num_copia) AS total_copias
FROM INTERPRETE I
JOIN REPARTO R ON I.idinter = R.interprete
JOIN PELICULA P ON R.pelicula = P.idpel
JOIN COPIA C ON P.idpel = C.pelicula
WHERE I.nacionalidad = 'australiano'
GROUP BY P.idpel, P.titulo;

/* Breve explicacion
obtenemos el número total de copias de aquellas películas en las que ha actuado algún intérprete australiano. hemos seleccionado las películas en las que ha participado al menos un intérprete australiano. Luego, hemos sumado el número de copias de cada una de esas películas. El resultado muestra el idpel, título de la película y el total de copias correspondiente
*/


-------------------------------------------------------
-- CONSULTA 5
-- 5.Lista  de  nombres  y  nacionalidades  respectivas  de  personas noestadounidenses,  que han dirigido, participado, o ambas cosas, en películas de nacionalidad estadounidense. Ordenado por nombre. Columnas:(nombre, nacionalidad).

SELECT DISTINCT
    CASE
        WHEN D.nombre IS NOT NULL THEN D.nombre
        ELSE I.nombre
    END AS nombre,
    CASE
        WHEN D.nacionalidad IS NOT NULL THEN D.nacionalidad
        ELSE I.nacionalidad
    END AS nacionalidad
FROM DIRECTOR D
FULL OUTER JOIN PELICULA P ON D.iddir = P.director
LEFT JOIN REPARTO R ON P.idpel = R.pelicula
LEFT JOIN INTERPRETE I ON R.interprete = I.idinter
WHERE P.nacionalidad = 'estadounidense'
    AND (D.nacionalidad IS NOT NULL OR I.nacionalidad IS NOT NULL)
    AND (D.nacionalidad <> 'estadounidense' OR I.nacionalidad <> 'estadounidense')
ORDER BY nombre;

/* Breve descripcion
hemos resuelto la consulta para obtener la lista de nombres y nacionalidades de personas no estadounidenses que han dirigido, participado o ambas cosas, en películas de nacionalidad estadounidense.
Hemos seleccionado aquellas personas cuya nacionalidad no es estadounidense y han estado involucradas en películas de nacionalidad estadounidense. El resultado muestra el nombre y la nacionalidad de estas personas, ordenados por nombre.
*/


-------------------------------------------------------
-- CONSULTA 6
-- 6.Película que más veces ha sido prestada aunmismo socio, indicando a quién ha sido. Columnas:(titulo,nombre).

SELECT P.titulo, S.nombre
FROM PELICULA P
JOIN COPIA C ON P.idpel = C.pelicula
JOIN PRESTAMO T ON C.pelicula = T.pelicula AND C.num_copia = T.copia
JOIN SOCIO S ON T.socio = S.idsocio
WHERE T.finalizado = 'NO'
GROUP BY P.titulo, S.nombre
HAVING COUNT(*) = (
  SELECT MAX(prestamos)
  FROM (
    SELECT T.socio, COUNT(*) AS prestamos
    FROM PRESTAMO T
    WHERE T.finalizado = 'NO'
    GROUP BY T.socio, T.pelicula, T.copia
  ) AS subquery
  GROUP BY socio
);

/* Breve descripcion
primero unimos las tablas relevantes (PELICULA, COPIA, PRESTAMO y SOCIO) utilizando las claves primarias y ajenas correspondientes. Luego, filtramos los préstamos que aún no han sido devueltos (T.finalizado = 'NO'). Agrupamos las filas por título de película y nombre de socio y aplicamos la cláusula HAVING para seleccionar solo aquellas combinaciones de película y socio que tengan el número máximo de préstamos.

La subconsulta interna (subquery) cuenta el número de préstamos para cada combinación de socio, película y copia. Luego, la subconsulta externa obtiene el máximo número de préstamos para cada socio. Finalmente, comparamos el número de préstamos de cada combinación película-socio con el máximo número de préstamos para seleccionar solo aquellos que coincidan
*/


-------------------------------------------------------
-- CONSULTA 7
-- 7.Para  cada  intérprete  mostrar  el  número  de  ocasiones  en  las  que  ha  participado  en películas  como  protagonista  y  como secundario  (nombre, veces_prota, veces_secun), ordenado  por  nombre  del  intérprete.Si un  intérprete  noha participadonuncacomo protagonista y/o como secundario, debe aparecer un 0en la columna correspondiente.

SELECT I.nombre, 
       COALESCE(SUM(CASE WHEN R.tipo_papel = 'PROTAGONISTA' THEN 1 ELSE 0 END), 0) AS veces_prota,
       COALESCE(SUM(CASE WHEN R.tipo_papel = 'SECUNDARIO' THEN 1 ELSE 0 END), 0) AS veces_secun
FROM INTERPRETE I
LEFT JOIN REPARTO R ON I.idinter = R.interprete
GROUP BY I.nombre
ORDER BY I.nombre;

/* Breve explicacion
unimos las tablas INTERPRETE e REPARTO utilizando la clave ajena idinter. Utilizamos LEFT JOIN para incluir todos los intérpretes, incluso aquellos que no hayan participado en ninguna película.

Luego, utilizamos la cláusula CASE en combinación con SUM para contar el número de veces que cada intérprete ha participado como protagonista y como secundario. Si un intérprete no ha participado en alguna de las categorías, utilizamos COALESCE para mostrar un valor de 0 en la columna correspondiente.

Finalmente, agrupamos por el nombre del intérprete y ordenamos por nombre. Esto nos dará el resultado deseado con el número de veces que cada intérprete ha participado como protagonista y como secundario.
*/

-------------------------------------------------------
-- CONSULTA 8
-- 8.Socios que  hantomado  prestadastodas  las  películas  de  la  actriz 'CECILIAROTH'.Columnas: (idsocio, nombre)

SELECT DISTINCT S.idsocio, S.nombre
FROM SOCIO S
INNER JOIN PRESTAMO T ON S.idsocio = T.socio
INNER JOIN COPIA C ON T.pelicula = C.pelicula AND T.copia = C.num_copia
INNER JOIN PELICULA P ON C.pelicula = P.idpel
WHERE P.idpel IN (
    SELECT DISTINCT R.pelicula
    FROM REPARTO R
    INNER JOIN INTERPRETE I ON R.interprete = I.idinter
    WHERE I.nombre = 'CECILIA ROTH'
)
GROUP BY S.idsocio, S.nombre
HAVING COUNT(DISTINCT P.idpel) = (
    SELECT COUNT(DISTINCT R.pelicula)
    FROM REPARTO R
    INNER JOIN INTERPRETE I ON R.interprete = I.idinter
    WHERE I.nombre = 'CECILIA ROTH'
);

/* Breve expliacion
comenzamos uniendo las tablas SOCIO, PRESTAMO, COPIA y PELICULA para obtener los datos de los socios y las películas prestadas.

Luego, utilizamos una subconsulta para obtener las películas en las que ha participado la actriz 'CECILIA ROTH'. Esto se logra uniendo las tablas REPARTO e INTERPRETE y filtrando por el nombre de la actriz.

A continuación, agrupamos por idsocio y nombre del socio y aplicamos una cláusula HAVING para asegurarnos de que el número de películas prestadas por el socio sea igual al número total de películas en las que ha participado la actriz.

Finalmente, obtenemos los socios distintos que cumplen con las condiciones y mostramos los campos idsocio y nombre en el resultado
*/

-------------------------------------------------------
-- CONSULTA 9
-- 9.Socios responsables de aquellos socios que no han devuelto alguna de laspelículas que tienen en préstamo. Para aquellos socios que no tengan responsable, mostrar la cadena '*sin  responsable*'en   la   columna nombre_respo.Ordenado   por nombre_socio.Columnas: (nombre_respo, telef_respo, nombre_socio).

SELECT COALESCE(R.nombre, '*sin responsable*') AS nombre_respo, R.telefono AS telef_respo, S.nombre AS nombre_socio
FROM SOCIO S
LEFT JOIN SOCIO R ON S.responsable = R.idsocio
WHERE S.idsocio IN (
    SELECT T.socio
    FROM PRESTAMO T
    INNER JOIN COPIA C ON T.pelicula = C.pelicula AND T.copia = C.num_copia
    WHERE T.finalizado = 'NO'
)
ORDER BY S.nombre;

/* Breve explicacion
utilizamos la tabla SOCIO para obtener los datos de los socios y la tabla SOCIO nuevamente (unida como R) para obtener los datos de los responsables. Utilizamos un LEFT JOIN para asegurarnos de incluir a los socios que no tienen un responsable asignado.

Luego, aplicamos una subconsulta para obtener los idsocio de los socios que tienen películas en préstamo y que aún no han sido devueltas. Esto se logra uniendo las tablas PRESTAMO y COPIA y filtrando por el valor 'NO' en la columna finalizado.

Finalmente, mostramos el nombre del responsable utilizando la función COALESCE para reemplazar los valores nulos por 'sin responsable'. Mostramos también el teléfono del responsable y el nombre del socio en el resultado, ordenado por nombre del socio
*/

-------------------------------------------------------
-- CONSULTA 10
-- 10.Nombre del socio que ha tomado prestadasel mayor número de películas diferentesy cuántas han sido. Columnas:(nombre, cuantas_peliculas)

SELECT S.nombre, COUNT(DISTINCT T.pelicula) AS cuantas_peliculas
FROM SOCIO S
INNER JOIN PRESTAMO T ON S.idsocio = T.socio
GROUP BY S.idsocio, S.nombre
HAVING COUNT(DISTINCT T.pelicula) = (
    SELECT COUNT(DISTINCT T2.pelicula)
    FROM PRESTAMO T2
    GROUP BY T2.socio
    ORDER BY COUNT(DISTINCT T2.pelicula) DESC
    FETCH FIRST 1 ROW ONLY
)

/* 
utilizamos las tablas SOCIO y PRESTAMO para obtener los datos de los socios y los préstamos. Unimos las tablas mediante la condición de que el idsocio coincida en ambas tablas.

Luego, agrupamos los resultados por idsocio y nombre del socio y contamos la cantidad de películas distintas que ha tomado prestadas cada socio utilizando la función COUNT(DISTINCT T.pelicula).

Utilizamos la cláusula HAVING para filtrar los resultados y seleccionar solo aquellos socios cuya cantidad de películas distintas prestadas sea igual al máximo número de películas distintas prestadas por algún socio. Esto lo logramos mediante una subconsulta que cuenta la cantidad de películas distintas prestadas por cada socio y luego ordena los resultados de forma descendente. Usamos la cláusula FETCH FIRST 1 ROW ONLY para seleccionar solo la primera fila, que contiene el máximo número de películas distintas prestadas.

Finalmente, mostramos el nombre del socio y la cantidad de películas distintas prestadas en el resultado.
*/



