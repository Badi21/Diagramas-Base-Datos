/*
Asignatura: Bases de Datos

Practica: P3. Definicion y Modificacion de Datos en SQL

Equipo de practicas: bd2107
 Integrante 1: Badar Tagmouti Abdoune
*/

-- EJERCICIO 0. Sentencias CREATE definitivas

CREATE TABLE CANCION(
    posicion    NUMBER(2)     NOT NULL,
    titulo      VARCHAR(10)     NOT NULL,
    duracion    DATE            NOT NULL,
    listas      NUMBER(2)     NOT NULL,
    id_album    CHAR(10)        NOT NULL,
    CONSTRAINT cancion_pk PRIMARY  KEY (id_album,posicion)
);

CREATE TABLE ALBUM (
    id_album    CHAR(10)        NOT NULL,
    titulo      VARCHAR(10)     NOT NULL,
    año         DATE            NOT NULL,
    genero      CHAR(10)        NOT NULL,
    artista     VARCHAR(10)     NOT NULL,
    CONSTRAINT album_pk PRIMARY  KEY (id_album),
    
    CONSTRAINT album_genero_ok CHECK (genero IN ('POP', 'ROCK', 'INDIE', 'HIP HOP', 'K-POP', 'CLASICA', 'LATINO', 'FLAMENCO', 'OTRO'))
);

CREATE TABLE ARTISTA (
    id_artista      CHAR(10)         NOT NULL,
    nombre          VARCHAR(10)      NOT NULL,
    pais_origen     VARCHAR(10)      NULL,
    solista         CHAR(10)         NOT NULL,
    banda           CHAR(10)         NOT NULL,
    CONSTRAINT artista_pk PRIMARY  KEY (id_artista)
);

CREATE TABLE SOLISTA (
    bio_breve       CHAR(250)       NULL,
    id_artista      CHAR(10)        NOT NULL,
    nombre          VARCHAR(10)     NOT NULL,
    pais_origen     VARCHAR(10)     NULL,
    CONSTRAINT solista_pk PRIMARY  KEY (id_artista)
);

CREATE TABLE BANDA (
    año_fundacion    DATE            NOT NULL,
    id_artista       CHAR(10)        NOT NULL,
    nombre           VARCHAR(10)     NOT NULL,
    pais_origen      VARCHAR(10)     NULL,
    lider            CHAR(10)             NOT NULL,
    -- Tiene que detecctar, de clave principal, clave ajena, y las restricciones que tenga una variable. Como por ejemplo que un tipo no sea menor que cero, etc etc
    CONSTRAINT banda_pk PRIMARY  KEY (id_artista),
    CONSTRAINT banda_ak1 UNIQUE (lider),
    CONSTRAINT banda_ak2 UNIQUE (nombre)
);


CREATE TABLE MUSICO (
    id_musico    CHAR(10)           NOT NULL,
    nombre       VARCHAR(10)        NOT NULL,
    banda        CHAR(10)           NOT NULL,
    CONSTRAINT musico_pk PRIMARY  KEY (id_musico),
    CONSTRAINT musico_fk_banda FOREIGN KEY (banda)
            REFERENCES BANDA(id_artista)
            --ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE MUSICO_INSTRUMENTO (
    id_musico   CHAR(10)            NOT NULL,
    instrumento VARCHAR(10)         NOT NULL,
    CONSTRAINT musico_instrumento_pk PRIMARY KEY (id_musico, instrumento),
    CONSTRAINT musico_instrumento_fk_musico FOREIGN KEY (id_musico) REFERENCES MUSICO(id_musico),
    CONSTRAINT musico_instrumento_ok CHECK (instrumento IN ('GUITARRA', 'BAJO', 'PIANO', 'BATERIA', 'OTRO'))
);

CREATE TABLE LISTA (
    num_lista       NUMBER(4)     NOT NULL,
    nombre          VARCHAR(10)     NOT NULL,
    descripcion     CHAR(350)       NULL,
    id_usuario      CHAR(10)        NOT NULL,
    CONSTRAINT lista_pk PRIMARY  KEY (id_usuario,num_lista)

);

CREATE TABLE USUARIO(
    ultimo_acceso    DATE           NOT NULL,
    id_usuario       VARCHAR(10)       NOT NULL,
    nombre           VARCHAR(10)    NOT NULL,
    email            VARCHAR(10)    NULL,
    telefono         NUMBER(9)      NULL,
    tipo             VARCHAR(10)       NOT NULL,
    cuota            NUMBER(10)     NOT NULL,
    id_invitador     VARCHAR(10)    NULL,
    CONSTRAINT usuario_pk PRIMARY  KEY (id_usuario),
    CONSTRAINT usuario_ak1 UNIQUE (email),
    CONSTRAINT usuario_ak2 UNIQUE (telefono),
    CONSTRAINT usuario_fk_invitador FOREIGN KEY (id_invitador)
        REFERENCES USUARIO(id_usuario),
        --ON DELETE SET-NULL ON UPDATE CASCADE
    CONSTRAINT usuario_tipo_ok CHECK (tipo IN ('GRATUITO','PREMIUM INDIVIDUAL','PREMIUM DOS','PREMIUM FAMILIAR')),
    CONSTRAINT usuario_email_tel_ok CHECK ((email IS NOT NULL AND telefono IS NULL) OR (email IS NULL AND telefono IS NOT NULL))

);

CREATE TABLE ANYADIR_A (
    fecha       DATE            NOT NULL,
    album       VARCHAR(10)     NOT NULL,
    cancion     VARCHAR(10)     NOT NULL,
    lista       VARCHAR(10)     NOT NULL,
    CONSTRAINT anyadir_a_pk PRIMARY  KEY (album, cancion, lista, fecha)
    CONSTRAINT anyadir_a_fk_album FOREIGN KEY (album, cancion)
        REFERENCES CANCION(id_album, posicion);
        --ON DELETE NO ACTCION ON UPDATE CASCADE
    CONSTRAINT anyadir_a_fk_usuario FOREIGN KEY (usuario,lista)
        REFERENCES LISTA(id_usuario, num_lista);
        --ON DELETE NO ACTCION ON UPDATE CASCADE

);


ALTER TABLE CANCION CONSTRAINT cancion_fk_id FOREIGN KEY (id_album)
       REFERENCES ALBUM(id_album);
        --ON DELETE CASCADE ON UPDATE CASCADE

ALTER TABLE BANDA ADD CONSTRAINT banda_fk_lider FOREIGN KEY (lider)
            REFERENCES MUSICO(id_musico);
            --ON DELETE CASCADE ON UPDATE CASCADE

ALTER TABLE ALBUM CONSTRAINT album_fk_artista FOREIGN KEY (artista)
            REFERENCES ARTISTA(id_artista);
            --ON DELETE CASCADE ON UPDATE CASCADE

ALTER TABLE LISTA CONSTRAINT lista_fk_id_usuario FOREIGN KEY (id_usuario)
        REFERENCES USUARIO(id_usuario);
         --ON DELETE CASCADE ON UPDATE CASCADE