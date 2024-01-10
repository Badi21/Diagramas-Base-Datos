/*
Asignatura: Bases de Datos

Practica: P3. Definicion y Modificacion de Datos en SQL

Equipo de practicas: bd2107
 Integrante 1: Badar Tagmouti Abdoune
*/

-- EJERCICIO 1. 
-- a. Sentencias INSERT

INSERT INTO ALBUM (id_album, titulo, año, genero, artista) VALUES ('ALB001', 'Álbum1', TO_DATE('01-01-2020', 'DD-MM-YYYY'), 'POP', 'A001');
INSERT INTO ALBUM (id_album, titulo, año, genero, artista) VALUES ('ALB002', 'Álbum2', TO_DATE('01-01-2015', 'DD-MM-YYYY'), 'ROCK', 'A002');
INSERT INTO ALBUM (id_album, titulo, año, genero, artista) VALUES ('ALB003', 'Álbum3', TO_DATE('01-01-2018', 'DD-MM-YYYY'), 'INDIE', 'A003');
INSERT INTO ALBUM (id_album, titulo, año, genero, artista) VALUES ('ALB004', 'Álbum4', TO_DATE('01-01-2021', 'DD-MM-YYYY'), 'HIP HOP', 'A004');

INSERT INTO ANYADIR_A (fecha, album, cancion, lista)
VALUES (TO_DATE('2023-05-01', 'YYYY-MM-DD'), 'A001', 'Cancion1', 'U001');

INSERT INTO ANYADIR_A (fecha, album, cancion, lista)
VALUES (TO_DATE('2023-05-02', 'YYYY-MM-DD'), 'A001', 'Cancion1', 'U002');

INSERT INTO ANYADIR_A (fecha, album, cancion, lista)
VALUES (TO_DATE('2023-05-03', 'YYYY-MM-DD'), 'A001', 'Cancion2', 'U001');

INSERT INTO ARTISTA (id_artista, nombre, pais_origen, solista, banda) VALUES ('A001', 'Artista1', 'País1', 'S', 'B001');
INSERT INTO ARTISTA (id_artista, nombre, pais_origen, solista, banda) VALUES ('A002', 'Artista2', 'País2', 'N', 'B002');
INSERT INTO ARTISTA (id_artista, nombre, pais_origen, solista, banda) VALUES ('A003', 'Artista3', 'País3', 'S', 'B003');
INSERT INTO ARTISTA (id_artista, nombre, pais_origen, solista, banda) VALUES ('A004', 'Artista4', 'País4', 'N', 'B004');

INSERT INTO BANDA (año_fundacion, id_artista, nombre, pais_origen, lider) VALUES (TO_DATE('01-01-2000', 'DD-MM-YYYY'), 'B001', 'Banda1', 'País1', 'A001');
INSERT INTO BANDA (año_fundacion, id_artista, nombre, pais_origen, lider) VALUES (TO_DATE('01-01-2005', 'DD-MM-YYYY'), 'B002', 'Banda2', 'País2', 'A002');
INSERT INTO BANDA (año_fundacion, id_artista, nombre, pais_origen, lider) VALUES (TO_DATE('01-01-2010', 'DD-MM-YYYY'), 'B003', 'Banda3', 'País3', 'A003');
INSERT INTO BANDA (año_fundacion, id_artista, nombre, pais_origen, lider) VALUES (TO_DATE('01-01-2015', 'DD-MM-YYYY'), 'B004', 'Banda4', 'País4', 'A004');

INSERT INTO CANCION (posicion, titulo, duracion, listas, id_album) VALUES (1, 'Canción1', TO_DATE('01-01-2023', 'DD-MM-YYYY'), 5, 'ALB001');
INSERT INTO CANCION (posicion, titulo, duracion, listas, id_album) VALUES (2, 'Canción2', TO_DATE('01-01-2023', 'DD-MM-YYYY'), 3, 'ALB002');
INSERT INTO CANCION (posicion, titulo, duracion, listas, id_album) VALUES (3, 'Canción3', TO_DATE('01-01-2023', 'DD-MM-YYYY'), 7, 'ALB003');
INSERT INTO CANCION (posicion, titulo, duracion, listas, id_album) VALUES (4, 'Canción4', TO_DATE('01-01-2023', 'DD-MM-YYYY'), 2, 'ALB004');

INSERT INTO LISTA (num_lista, nombre, descripcion, id_usuario) VALUES (1, 'Lista1', 'Descripción1', 'U001');
INSERT INTO LISTA (num_lista, nombre, descripcion, id_usuario) VALUES (2, 'Lista2', 'Descripción2', 'U002');
INSERT INTO LISTA (num_lista, nombre, descripcion, id_usuario) VALUES (3, 'Lista3', 'Descripción3', 'U003');
INSERT INTO LISTA (num_lista, nombre, descripcion, id_usuario) VALUES (4, 'Lista4', 'Descripción4', 'U004');

INSERT INTO MUSICO (id_musico, nombre, banda) VALUES ('M001', 'Músico1', 'B001');
INSERT INTO MUSICO (id_musico, nombre, banda) VALUES ('M002', 'Músico2', 'B002');
INSERT INTO MUSICO (id_musico, nombre, banda) VALUES ('M003', 'Músico3', 'B003');
INSERT INTO MUSICO (id_musico, nombre, banda) VALUES ('M004', 'Músico4', 'B004');

INSERT INTO MUSICO_INSTRUMENTO (id_musico, instrumento) VALUES ('M001', 'GUITARRA');
INSERT INTO MUSICO_INSTRUMENTO (id_musico, instrumento) VALUES ('M002', 'BAJO');
INSERT INTO MUSICO_INSTRUMENTO (id_musico, instrumento) VALUES ('M003', 'PIANO');
INSERT INTO MUSICO_INSTRUMENTO (id_musico, instrumento) VALUES ('M004', 'BATERIA');

INSERT INTO SOLISTA (bio_breve, id_artista, nombre, pais_origen) VALUES ('Biografía1', 'A001', 'Solista1', 'País1');
INSERT INTO SOLISTA (bio_breve, id_artista, nombre, pais_origen) VALUES ('Biografía2', 'A003', 'Solista2', 'País3');

INSERT INTO USUARIO (ultimo_acceso, id_usuario, nombre, email, telefono, tipo, cuota, id_invitador) VALUES (TO_DATE('12-05-2023', 'DD-MM-YYYY'), 'U001', 'Usuario1', 'usuario1@example.com', NULL, 'PREMIUM INDIVIDUAL', 10, NULL);
INSERT INTO USUARIO (ultimo_acceso, id_usuario, nombre, email, telefono, tipo, cuota, id_invitador) VALUES (TO_DATE('12-05-2023', 'DD-MM-YYYY'), 'U002', 'Usuario2', NULL, 123456789, 'GRATUITO', 0, NULL);
INSERT INTO USUARIO (ultimo_acceso, id_usuario, nombre, email, telefono, tipo, cuota, id_invitador) VALUES (TO_DATE('12-05-2023', 'DD-MM-YYYY'), 'U003', 'Usuario3', 'usuario3@example.com', NULL, 'PREMIUM INDIVIDUAL', 10, 'U001');
INSERT INTO USUARIO (ultimo_acceso, id_usuario, nombre, email, telefono, tipo, cuota, id_invitador) VALUES (TO_DATE('12-05-2023', 'DD-MM-YYYY'), 'U004', 'Usuario4', 'usuario4@example.com', NULL, 'PREMIUM DOS', 20, 'U002');

--------------------------------------------------------------------------------------
-- b. Calculo de valores de la columna CANCION.cuantas_listas

UPDATE CANCION SET cuantas_listas = (
    SELECT COUNT(DISTINCT num_lista)
    FROM LISTA
    WHERE aa.CANCION = CANCION.id_album
);

COMMIT;