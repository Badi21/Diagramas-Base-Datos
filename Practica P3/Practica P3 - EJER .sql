/*
Asignatura: Bases de Datos

Practica: P3. Definicion y Modificacion de Datos en SQL

Equipo de practicas: bd2107
 Integrante 1: Badar Tagmouti Abdoune
*/

--------------------------------------------------------------------------------------
----EJERCICIO 2. Insertar comentarios de tabla y de columna en el Diccionario de Datos


--a

COMMENT ON TABLE SOLISTA IS 'La tabla solista contiene información acerca de
su nombre, su identificador, el país de origeny una biografía breve de el';

COMMENT ON COLUMN MUSICO.id_musico IS 'id del músico';
COMMENT ON COLUMN MUSICO.banda IS 'banda a la que pertenece el musico';
COMMENT ON COLUMN MUSICO.nombre IS 'Nombre completo del músico';

--b


SELECT *
FROM USER_TAB_COMMENTS
WHERE table_name = 'SOLISTA';

SELECT *
FROM USER_COL_COMMENTS
WHERE table_name = 'MUSICO';


--c

--------------------------------------------------------------------------------------
/**
 Sí es una sentencia de definición de datos. Esta sentencia es tratada como una transacción de 
 manera que no hace falta ejecutar una orden commit de manera explícita, pues oracle realiza
 un COMMIT antes de ejecutar la orden y, en caso de que tenga éxito, otro después.
**/

-- EJERCICIO 3. Modificar valores de una columna

--a-

SELECT id_usuario, nombre, cuota
FROM USUARIO
WHERE id_usuario IN (
    SELECT id_invitador
    FROM USUARIO
    GROUP BY id_invitador
    HAVING COUNT(*) >= 2
)
ORDER BY nombre;


--b

UPDATE USUARIO
SET cuota = CASE
    WHEN tipo = 'GRATUITO' THEN 0
    ELSE cuota * 0.95
    END
WHERE id_usuario IN (
    SELECT id_invitador
    FROM USUARIO
    GROUP BY id_invitador
    HAVING COUNT(*) >= 2
);

---

SELECT id_usuario, nombre, cuota
FROM USUARIO
WHERE id_usuario IN (
    SELECT id_invitador
    FROM USUARIO
    GROUP BY id_invitador
    HAVING COUNT(*) >= 2
)
ORDER BY nombre;


--c

ROLLBACK;

--
SELECT id_usuario, nombre, cuota
FROM USUARIO
WHERE id_usuario IN (
    SELECT id_invitador
    FROM USUARIO
    GROUP BY id_invitador
    HAVING COUNT(*) >= 2
)
ORDER BY nombre;

--------------------------------------------------------------------------------------
-- EJERCICIO 4. Modificar una clave primaria

-- Paso 1: Desactivar restricciones de integridad referencial
ALTER TABLE LISTA ENABLE CONSTRAINT lista_fk_id_usuario;
ALTER TABLE USUARIO DISABLE CONSTRAINT usuario_fk_invitador;
ALTER TABLE ANYADIR_A DISABLE CONSTRAINT anyadir_a_fk_album;

-- Paso 2: Cambiar el identificador de usuario en la tabla USUARIO
UPDATE USUARIO SET id_usuario = ('U901') WHERE id_usuario = 'U001';

-- Paso 3: Actualizar las referencias en las tablas relacionadas
UPDATE LISTA SET id_usuario = ('U901') WHERE id_usuario = 'U001';
UPDATE ANYADIR_A SET album = ('U901') WHERE album = 'U001';

-- Paso 4: Actualizar el campo id_invitador en la tabla USUARIO
UPDATE USUARIO SET id_invitador = ('U901') WHERE id_invitador = 'U001';

-- Paso 5: Reactivar restricciones de integridad referencial
ALTER TABLE USUARIO ENABLE CONSTRAINT usuario_fk_invitador;
ALTER TABLE ANYADIR_A ENABLE CONSTRAINT anyadir_a_fk_album;
ALTER TABLE LISTA ENABLE CONSTRAINT lista_fk_id_usuario;

--
SELECT * FROM USUARIO;

SELECT * FROM LISTA


--------------------------------------------------------------------------------------
-- EJERCICIO 5. Intercambiar los álbumes

--a

SELECT id_album, titulo, genero
FROM ALBUM
WHERE genero_musical = 'INDIE'
    OR genero_musical = 'POP'
ORDER BY genero_musical;

--b
ALTER TABLE ALBUM DISABLE CONSTRAINT album_fk_artista;
 


UPDATE ALBUM SET artista = ('ROCK') --hace de varible auxiliar
WHERE artista = 'POP';
UPDATE ALBUM SET artista = ('POP')
WHERE revista = 'INDIE';
UPDATE ALBUM SET artista = ('INDIE')
WHERE revista = 'ROCK';

ALTER TABLE ALBUM ENABLE CONSTRAINT album_fk_artista;
---
SELECT id_album, titulo, genero
FROM ALBUM
WHERE genero_musical = 'INDIE'
    OR genero_musical = 'POP'
ORDER BY genero_musical;

--c

ROLLBACK;
SELECT id_album, titulo, genero
FROM ALBUM
WHERE genero_musical = 'INDIE'
    OR genero_musical = 'POP'
ORDER BY genero_musical;


/**
    No vuelven al estado original porque la sentencia ALTER, al ser LDD, realiza
    un COMMIT de manera explícita por lo que los datos se guardan y no se puede
    deshacer la transacción.
**/


ALTER TABLE ALBUM DISABLE CONSTRAINT album_fk_artista;
 


UPDATE ALBUM SET artista = ('ROCK') --hace de varible auxiliar
WHERE artista = 'POP';
UPDATE ALBUM SET artista = ('POP')
WHERE revista = 'INDIE';
UPDATE ALBUM SET artista = ('INDIE')
WHERE revista = 'ROCK';


ALTER TABLE ALBUM ENABLE CONSTRAINT album_fk_artista;


--------------------------------------------------------------------------------------
-- EJERCICIO 6. Borrar algunos artículos

--a

DELETE FROM USUARIO
WHERE tipo = 'GRATUITO'
  AND id_usuario NOT IN (
    SELECT DISTINCT id_invitador
    FROM USUARIO
    WHERE id_invitador IS NOT NULL
  )
  AND ultimo_acceso < DATE '2019-11-19'
  AND id_usuario NOT IN (
    SELECT DISTINCT id_usuario
    FROM LISTA
  );

-- Confirmar los cambios realizados
COMMIT; 

--------------------------------------------------------------------------------------
-- EJERCICIO 7. Borrar 

ALTER TABLE ANYADIR_A DISABLE CONSTRAINT anyadir_a_fk_album;
ALTER TABLE ANYADIR_A DISABLE CONSTRAINT anyadir_a_fk_usuario;
ALTER TABLE CANCION DISABLE CONSTRAINT cancion_fk_id;
ALTER TABLE BANDA DISABLE CONSTRAINT banda_fk_lider;
ALTER TABLE ALBUM DISABLE CONSTRAINT album_fk_artista;

-- Eliminar las filas relacionadas con la banda 'B001' en el orden adecuado
DELETE FROM MUSICO_INSTRUMENTO WHERE id_musico IN (SELECT id_musico FROM MUSICO WHERE banda = 'B001');
DELETE FROM MUSICO WHERE banda = 'B001';
DELETE FROM BANDA WHERE id_artista = 'B001';
DELETE FROM ALBUM WHERE artista = 'B001';
DELETE FROM CANCION WHERE id_album IN (SELECT id_album FROM ALBUM WHERE artista = 'B001');
DELETE FROM ANYADIR_A WHERE album IN (SELECT id_album FROM ALBUM WHERE artista = 'B001');


ALTER TABLE ANYADIR_A ENABLE CONSTRAINT anyadir_a_fk_album;
ALTER TABLE ANYADIR_A ENABLE CONSTRAINT anyadir_a_fk_usuario;
ALTER TABLE CANCION ENABLE CONSTRAINT cancion_fk_id;
ALTER TABLE BANDA ENABLE CONSTRAINT banda_fk_lider;
ALTER TABLE ALBUM ENABLE CONSTRAINT album_fk_artista;


--------------------------------------------------------------------------------------
-- EJERCICIO 8. Eliminar algunas columnas
--a
ALTER TABLE SOLISTA DROP COLUMN pais_origen;
ALTER TABLE SOLISTA DROP COLUMN bio_breve;

--b
ALTER TABLE SOLISTA DROP (pais_origen , bio_breve);




--------------------------------------------------------------------------------------
-- EJERCICIO 9. Crear y manipular una vista
-- a

CREATE VIEW DATOS_USUARIO AS
SELECT
    U.nombre AS usuario,
    U.tipo,
    U.cuota,
    (
        SELECT COUNT(num_lista)
        FROM LISTA
        WHERE id_usuario = U.id_usuario
    ) AS listas,
    (
        SELECT COUNT(C.posicion)
        FROM LISTA L
        JOIN CANCION C ON L.num_lista = C.listas
        WHERE L.id_usuario = U.id_usuario
    ) AS canciones,
    FLOOR(SYSDATE - U.ultimo_acceso) AS desconexion
FROM USUARIO U
WHERE U.tipo != 'GRATUITO';

-- la función FLOOR para redondear hacia abajo ese número y obtener un valor entero. 


--b
SELECT *
FROM  DATOS_USUARIO
ORDER BY usuario.;
    
--c

CREATE OR REPLACE VIEW DATOS_USUARIO AS
SELECT (round((usuario - usuario) , 0),tipo,(cuota + cuota * 0.21) cuota, listas,canciones,desconexion  
FROM LISTA JOIN USUARIO U ON U.id = L.usuario
                             RIGHT JOIN  CONT C ON U.DNI = U.lista;
--

SELECT *
FROM  DATOS_USUARIO
ORDER usuario;

--d
INSERT INTO 
 USUARIO(id_usuario, nombre, email, telefono, tipo, cuota, invitador, ultimo_acceso)
VALUES ('U236', 'JEREMIAS', 'jere@mail.com', NULL, 'PREMIUM DOS', 14, 'U840', TO_DATE('29/01/2023', 'dd/mm/yyyy'));

         
INSERT INTO 
 CONT (usuario, cuantos)
 VALUES('U236', 'PREMIUM DOS', 14);

--e
SELECT *
FROM DATOS_USUARIO
ORDER BY usuario;

/**
Si se aplica el cambio del 21% ya que al modificar los datos almacenados en las tablas 
base, se modifican los de las vistas.
**/

COMMIT;


--------------------------------------------------------------------------------------
--EJERCICIO 10. Crear y cargar una tabla, y modificar su estructura (alterar) su estructura.

--a

CREATE TABLE HITS AS
SELECT C.titulo AS cancion, A.titulo AS album, A.artista, COUNT(*) AS cuantas_listas
FROM CANCION C
    JOIN ANYADIR_A AA ON C.id_album = AA.album AND C.posicion = AA.cancion
    JOIN ALBUM A ON C.id_album = A.id_album
GROUP BY C.titulo, A.titulo, A.artista
HAVING COUNT(*) >= 2;


--b

SELECT *
FROM HITS
ORDER BY cuantas_listas;

--c

ALTER TABLE HITS
    ADD (cuando NUMBER(4) DEFAULT 1972 NOT NULL);

--d
                                     
UPDATE HITS H SET cuando  = (SELECT COUNT(*) FROM ALBUM A WHERE A.cancion = H.id);
--

SELECT *
FROM HITS
ORDER BY id_album;

COMMIT;

--------------------------------------------------------------------------------------
--EJERCICIO 11. Restricciones de integridad.

--RI1
CREATE ASSERTION RI1 CHECK (
    NOT EXISTS (
        SELECT 1
        FROM SOLISTA S
        LEFT JOIN ALBUM A ON S.id_artista = A.artista
        WHERE A.id_album IS NULL
    )
);



--RI2

CREATE ASSERTION RI2 CHECK (
    NOT EXISTS (
        SELECT 1
        FROM ALBUM A
        LEFT JOIN CANCION C ON A.id_album = C.id_album
        GROUP BY A.id_album
        HAVING COUNT(C.id_album) < 7
    )
);


--RI3

CREATE ASSERTION RI3 CHECK (
    NOT EXISTS (
        SELECT 1
        FROM BANDA B
        LEFT JOIN MUSICO M ON B.lider = M.id_musico
        WHERE M.id_musico IS NULL
    )
);
    

