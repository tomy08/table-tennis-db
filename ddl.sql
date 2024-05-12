-- Entidades:
-- •	Jugador: (ID, nombre, apellido, fecha_nac, rating, ID_club) ✅
-- •	Club: (ID, nombre, ubicación, fecha_creacion) ✅
-- •	Torneo: (ID, nombre_torneo, fecha, categoría, localidad)
-- •	Partido: (ID, ID_jugador1, ID_jugador2, resultado, ID_torneo)


-- Relaciones:
-- •	Club 0:n Jugador – ID_CLUB ✅
-- •	Torneo 1:n Partido – ID_TORNEO
-- •	Jugador m:n Partido – ID_JUGADOR


CREATE DATABASE IF NOT EXISTS table_tennis;

CREATE TABLE IF NOT EXISTS club (
    ID INT PRIMARY KEY NOT NULL,
    nombre VARCHAR(50) NOT NULL,
    ubicacion VARCHAR(50) NOT NULL,
    fecha_creacion DATE NOT NULL
);

CREATE TABLE IF NOT EXISTS jugador (
    ID INT PRIMARY KEY NOT NULL,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    fecha_nac DATE NOT NULL,
    rating INT NOT NULL,
    ID_club INT NOT NULL,
    FOREIGN KEY (ID_club) REFERENCES club(ID)
);

CREATE TABLE IF NOT EXISTS torneo (
    ID INT PRIMARY KEY NOT NULL,
    nombre_torneo VARCHAR(50) NOT NULL,
    fecha DATETIME NOT NULL,
    categoria INT NOT NULL,
    localidad VARCHAR(50) NOT NULL
);

CREATE TABLE IF NOT EXISTS partido (
    ID INT PRIMARY KEY NOT NULL,
    ID_jugador1 INT NOT NULL,
    ID_jugador2 INT NOT NULL,
    ID_torneo INT NOT NULL,
    ID_ganador INT,
    FOREIGN KEY (ID_jugador1) REFERENCES jugador(ID),
    FOREIGN KEY (ID_jugador2) REFERENCES jugador(ID),
    FOREIGN KEY (ID_torneo) REFERENCES torneo(ID),
    FOREIGN KEY (ID_ganador) REFERENCES jugador(ID)
);


CREATE TABLE IF NOT EXISTS games (
    ID INT PRIMARY KEY NOT NULL,
    ID_partido INT,
    player1_score INT,
    player2_score INT,
    ID_ganador INT,
    FOREIGN KEY (ID_partido) REFERENCES partido(ID),
    FOREIGN KEY (ID_ganador) REFERENCES jugador(ID)
);


CREATE TABLE IF NOT EXISTS sets (
    set_id INT PRIMARY KEY,
    ID_partido INT,
    set_number INT,
    player1_games_won INT,
    player2_games_won INT,
    ID_ganador INT,
    FOREIGN KEY (ID_partido) REFERENCES partido(ID),
    FOREIGN KEY (ID_ganador) REFERENCES jugador(ID)
);

