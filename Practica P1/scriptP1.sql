-- ELEIMINARMMOS LA TABLAS ANTERIOREMETE CREADAS

    -- aqui eleiminamos todas las restricciones que tenga una tabla
ALTER TABLE ANYADIR_A DROP COLUMN album CASCADE CONSTRAINTS;
ALTER TABLE ANYADIR_A DROP COLUMN usuario CASCADE CONSTRAINTS;
ALTER TABLE USUARIO DROP COLUMN invitador CASCADE CONSTRAINTS;
ALTER TABLE LISTA DROP COLUMN id_usuario CASCADE CONSTRAINTS;
ALTER TABLE MUSICO DROP COLUMN banda CASCADE CONSTRAINTS;
ALTER TABLE BANDA DROP COLUMN lider CASCADE CONSTRAINTS;
ALTER TABLE ALBUM DROP COLUMN artista CASCADE CONSTRAINTS;
ALTER TABLE CANCION DROP COLUMN id CASCADE CONSTRAINTS;

    -- eleimanos todas las tablas
DROP TABLE ANYADIR_A;
DROP TABLE USUARIO;
DROP TABLE LISTA;
DROP TABLE MUSICO;
DROP TABLE BANDA;
DROP TABLE ALBUM;
DROP TABLE CANCION;


-- CREAMOS LA TABLA

--  la creacion de la tabla en orden sin dependencia y ya vamos juntando 
CREATE TABLE CANCION (
    posicion    NUMBER(100)     NOT NULL,
    titulo      VARCHAR(10)     NOT NULL,
    duracion    TIME            NOT NULL,
    listas      NUMBER(100)     NOT NULL,
    id_album    CHAR(10)        NOT NULL,
    CONSTRAINT cancion_pk PRIMARY  KEY (id_album,posicion),

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
    lider            BIT             NOT NULL,
    -- Tiene que detecctar, de clave principal, clave ajena, y las restricciones que tenga una variable. Como por ejemplo que un tipo no sea menor que cero, etc etc
    CONSTRAINT banda_pk PRIMARY  KEY (id_artista)
    CONSTRAINT banda_ak1 UNIQUE (lider)
    CONSTRAINT banda_ak2 UNIQUE (nombre)
);

CREATE TABLE MUSICO (
    id_musico    CHAR(10)           NOT NULL,
    nombre       VARCHAR(10)        NOT NULL,
    banda        CHAR(10)           NOT NULL,
    CONSTRAINT musico_pk PRIMARY  KEY (id_musico)
    CONSTRAINT musico_fk_banda FOREIGN KEY (banda)
            REFERENCES BANDA(id_artista);
            --ON DELETE CASCADE ON UPDATE CASCADE
    CONSTRAINT musico_ok CHECK (musico IN (('VOZ','GUITARRA','BAJO', 'PIANO','BATERIA','OTRO')))
);

CREATE TABLE LISTA (
    num_lista       NUMBER(100)     NOT NULL,
    nombre          VARCHAR(10)     NOT NULL,
    descripcion     CHAR(350)       NULL,
    id_usuario      CHAR(10)        NOT NULL,
    CONSTRAINT lista_pk PRIMARY  KEY (id_usuario,num_lista)

);

CREATE TABLE USUARIO (
    ultimo_acceso    DATE           NOT NULL,
    id_usuario       CHAR(10)       NOT NULL,
    nombre           VARCHAR(10)    NOT NULL,
    email            VARCHAR(10)    NULL,
    telefono         NUMBER(9)      NULL,
    tipo             CHAR(25)       NOT NULL,
    cuota            NUMBER(10)     NOT NULL,
    invitador        VARCHAR(10)    NULL,
    CONSTRAINT usuario_pk PRIMARY  KEY (id_usuario)
    CONSTRAINT usuario_ak1 UNIQUE (email)
    CONSTRAINT usuario_ak2 UNIQUE (telefono)
    CONSTRAINT usuario_fk_invitador FOREIGN KEY (invitador)
        REFERENCES USUARIO(id_usuario);
        --ON DELETE SET-NULL ON UPDATE CASCADE
    CONSTRAINT usuario_tipo_ok CHECK (tipo IN (('GRATUITO','PREMIUM INDIVIDUAL','PREMIUM DOS','PREMIUM FAMILIAR')))
    CONSTRAINT usuario_email_tel_ok CHECK ((email IS NOT NULL AND telefono IS NULL) OR (email IS NULL AND telefono IS NOT NULL))

);

CREATE TABLE ANYADIR_A (
    album       VARCHAR(10)     NOT NULL,
    cancion     VARCHAR(10)     NOT NULL,
    lista       VARCHAR(10)     NOT NULL,
    fecha       DATE            NOT NULL,
    CONSTRAINT anyadir_a_pk PRIMARY  KEY (album, cancion, lista, fecha)
    CONSTRAINT anyadir_a_fk_album FOREIGN KEY (album, cancion)
        REFERENCES CANCION(id_album, posicion);
        --ON DELETE NO ACTCION ON UPDATE CASCADE
    CONSTRAINT anyadir_a_fk_usuario FOREIGN KEY (usuario,lista)
        REFERENCES LISTA(id_usuario, num_lista);
        --ON DELETE NO ACTCION ON UPDATE CASCADE

);

-- AÑADIMOS LAS CLAVES AGENAS

--  solo se pone cuando hay ciclo referencial y hay que gestionarlo. A nivel base de datos no seria lo mismo 
-- Ya que ocurre cuando una tabla hace referencia a otra que aun no se ha creado, entonces obtenemos un error de complilacion. Para evitarlo hacemos lo siguientes ALTER TABLE 
-- que se ejecutan al final despues de la creacion de cada tabla, la que este referenciada y sea necesaria
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