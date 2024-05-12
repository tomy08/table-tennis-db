-- Base de datos: table_tennis

CREATE DATABASE table_tennis;


USE table_tennis;


-- Borrar tablas si existen
DROP TABLE IF EXISTS games;
DROP TABLE IF EXISTS sets;
DROP TABLE IF EXISTS partido;
DROP TABLE IF EXISTS jugador;
DROP TABLE IF EXISTS club;
DROP TABLE IF EXISTS torneo;

-- Creación de tablas

CREATE TABLE club (
    ID INT PRIMARY KEY NOT NULL,
    nombre VARCHAR(50) NOT NULL,
    ubicacion VARCHAR(50) NOT NULL,
    fecha_creacion DATE NOT NULL
);

CREATE TABLE jugador (
    ID INT PRIMARY KEY NOT NULL,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    fecha_nac DATE NOT NULL,
    rating INT NOT NULL,
    ID_club INT NOT NULL,
    FOREIGN KEY (ID_club) REFERENCES club(ID)
);

CREATE TABLE torneo (
    ID INT PRIMARY KEY NOT NULL,
    nombre_torneo VARCHAR(50) NOT NULL,
    fecha DATETIME NOT NULL,
    categoria INT NOT NULL,
    localidad VARCHAR(50) NOT NULL
);


CREATE TABLE partido (
    ID INT PRIMARY KEY NOT NULL,
    ID_jugador1 INT NOT NULL,
    ID_jugador2 INT NOT NULL,
    ID_torneo INT NOT NULL,
    FOREIGN KEY (ID_jugador1) REFERENCES jugador(ID),
    FOREIGN KEY (ID_jugador2) REFERENCES jugador(ID),
    FOREIGN KEY (ID_torneo) REFERENCES torneo(ID),
);

CREATE TABLE sets (
    ID INT PRIMARY KEY,
    ID_partido INT,
    numero_set INT,
    player1_games_won INT,
    player2_games_won INT,
    ID_ganador INT,
    FOREIGN KEY (ID_partido) REFERENCES partido(ID),
    FOREIGN KEY (ID_ganador) REFERENCES jugador(ID)
);

CREATE TABLE games (
    ID INT PRIMARY KEY NOT NULL,
    ID_set INT,
    player1_score INT,
    player2_score INT,
    ID_ganador INT,
    FOREIGN KEY (ID_set) REFERENCES sets(ID),
    FOREIGN KEY (ID_ganador) REFERENCES jugador(ID)
);


-- Creacion de funciones

DROP FUNCTION IF EXISTS obtenerGanadorPartido;
DELIMITER //
CREATE FUNCTION obtenerGanadorPartido(ID_partido INT) RETURNS INT
READS SQL DATA
BEGIN
    DECLARE ganador INT;
    DECLARE contador_jugador1 INT DEFAULT 0;
    DECLARE contador_jugador2 INT DEFAULT 0;
    
    -- Contar los sets ganados por cada jugador en el partido dado
    SELECT COUNT(*) INTO contador_jugador1
    FROM sets
    WHERE ID_partido = obtenerGanadorPartido.ID_partido AND ID_ganador = sets.ID_jugador1;
    
    SELECT COUNT(*) INTO contador_jugador2
    FROM sets
    WHERE ID_partido = obtenerGanadorPartido.ID_partido AND ID_ganador = sets.ID_jugador2;
    
    
    IF contador_jugador1 > contador_jugador2 THEN
        SET ganador = sets.ID_jugador1;
    ELSEIF contador_jugador2 > contador_jugador1 THEN
        SET ganador = sets.ID_jugador2;
    ELSE
        SET ganador = NULL;
    END IF;
    
    RETURN ganador;
END //
DELIMITER ;

