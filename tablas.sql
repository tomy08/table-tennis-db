-- Base de datos: table_tennis
CREATE DATABASE table_tennis;

USE table_tennis;

-- Borrar tablas si existen
DROP TABLE IF EXISTS sets;

DROP TABLE IF EXISTS partido;

DROP TABLE IF EXISTS arbitro;

DROP TABLE IF EXISTS jugador;

DROP TABLE IF EXISTS club;

DROP TABLE IF EXISTS torneo;

DROP TABLE IF EXISTS instancia;

DROP TABLE IF EXISTS ubicacion;

-- Creación de tablas
CREATE TABLE ubicacion (
    ID INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    nombre VARCHAR(50) NOT NULL
);

CREATE TABLE club (
    ID INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    nombre VARCHAR(50) NOT NULL,
    ID_ubicacion INT NULL,
    fecha_creacion DATE NOT NULL,
    FOREIGN KEY (ID_ubicacion) REFERENCES ubicacion (ID) ON DELETE SET NULL
);

CREATE TABLE jugador (
    ID INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    fecha_nac DATE NOT NULL,
    rating INT NOT NULL,
    ID_club INT DEFAULT 1,
    FOREIGN KEY (ID_club) REFERENCES club (ID) ON DELETE SET NULL
);

CREATE TABLE torneo (
    ID INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    nombre_torneo VARCHAR(50) NOT NULL,
    fecha DATETIME NOT NULL,
    categoria INT NOT NULL,
    ID_ubicacion INT NOT NULL,
    FOREIGN KEY (ID_ubicacion) REFERENCES ubicacion (ID)
);

CREATE TABLE arbitro (
    ID INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    fecha_nac DATE NOT NULL
);

CREATE TABLE instancia (
    ID INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    nombre VARCHAR(50) NOT NULL,
    CONSTRAINT instancia_valores_permitidos CHECK (
        nombre IN (
            'final',
            'semifinal',
            'cuartos',
            'octavos',
            'dieciseisavos',
            'treintaidosavos'
        )
    )
);

CREATE TABLE partido (
    ID INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    ID_arbitro INT NOT NULL,
    ID_jugador1 INT NOT NULL,
    ID_jugador2 INT NOT NULL,
    ID_torneo INT NOT NULL,
    ID_instancia INT NOT NULL,
    FOREIGN KEY (ID_jugador1) REFERENCES jugador (ID) ON DELETE SET NULL,
    FOREIGN KEY (ID_jugador2) REFERENCES jugador (ID) ON DELETE SET NULL,
    FOREIGN KEY (ID_torneo) REFERENCES torneo (ID),
    FOREIGN KEY (ID_arbitro) REFERENCES arbitro (ID) ON DELETE SET NULL,
    FOREIGN KEY (ID_instancia) REFERENCES instancia (ID)
);

CREATE TABLE sets (
    ID INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    ID_partido INT,
    numero_set INT,
    player1_games_won INT,
    player2_games_won INT,
    FOREIGN KEY (ID_partido) REFERENCES partido (ID)
);