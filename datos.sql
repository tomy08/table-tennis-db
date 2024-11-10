USE table_tennis;

-- Insertar datos en la tabla ubicacion
INSERT INTO
    ubicacion (nombre)
VALUES ('Buenos Aires'),
    ('Av. Directorio 4147'),
    ('Roma 950'),
    ('Moreno 3201, Mar del Plata'),
    ('Ayacucho 3926, Rosario');

-- Insertar datos en la tabla club
INSERT INTO
    club (
        nombre,
        ID_ubicacion,
        fecha_creacion
    )
VALUES (
        'Jugador Libre',
        1,
        '1900-01-01'
    ),
    (
        'Alvear Club',
        2,
        '1935-08-19'
    ),
    (
        'Ateneo Popular de Versailles',
        3,
        '1938-07-02'
    ),
    (
        'Mar del Plata Club',
        4,
        '1950-10-10'
    ),
    (
        'Club Atlético Rosario',
        5,
        '1945-03-12'
    );

-- Insertar datos en la tabla jugador
INSERT INTO
    jugador (
        nombre,
        apellido,
        fecha_nac,
        rating,
        ID_club
    )
VALUES (
        'Tomas',
        'Santa Cruz',
        '2007-05-24',
        0,
        2
    ),
    (
        'Mateo',
        'Diaz',
        '2004-08-05',
        0,
        1
    ),
    (
        'Tiziano',
        'Romeo',
        '1999-02-27',
        0,
        3
    ),
    (
        'Ramiro',
        'González',
        '2000-04-17',
        0,
        1
    ),
    (
        'Facundo',
        'López',
        '1980-12-12',
        0,
        3
    ),
    (
        'Mauro',
        'Martín',
        '1990-07-21',
        0,
        2
    ),
    (
        'Axel',
        'Sánchez',
        '2006-05-17',
        0,
        1
    ),
    (
        'Manuel',
        'Gómez',
        '2010-02-19',
        0,
        2
    ),
    (
        'Lucas',
        'Pérez',
        '1998-09-11',
        0,
        4
    ),
    (
        'Nicolás',
        'Rodríguez',
        '1995-03-30',
        0,
        5
    ),
    (
        'Julian',
        'Molina',
        '2002-07-15',
        0,
        4
    ),
    (
        'Mariano',
        'Silva',
        '1993-12-05',
        0,
        5
    ),
    (
        'Santiago',
        'Martínez',
        '1999-11-05',
        0,
        3
    ),
    (
        'Esteban',
        'Ferrer',
        '2001-01-14',
        0,
        4
    ),
    (
        'Carlos',
        'Álvarez',
        '1985-04-23',
        0,
        5
    ),
    (
        'Raúl',
        'Medina',
        '1992-03-18',
        0,
        2
    );

-- Insertar datos en la tabla arbitro
INSERT INTO
    arbitro (nombre, apellido, fecha_nac)
VALUES (
        'Jose',
        'Rodolfo',
        '1999-12-01'
    ),
    (
        'Agustin',
        'Fernández',
        '2000-06-15'
    ),
    (
        'Jesús',
        'Ramon',
        '2000-06-15'
    ),
    (
        'Carlos',
        'Rivas',
        '1998-08-21'
    );

-- Insertar datos en la tabla instancia
INSERT INTO
    instancia (nombre)
VALUES ('final'),
    ('semifinal'),
    ('cuartos'),
    ('octavos');

-- Insertar datos en la tabla torneo
INSERT INTO
    torneo (
        nombre_torneo,
        fecha,
        categoria,
        ID_ubicacion
    )
VALUES (
        '1er torneo Alvear Club',
        '2024-05-20',
        5,
        2
    ),
    (
        'Copa Mar del Plata',
        '2024-06-15',
        4,
        4
    );

-- Insertar datos en la tabla partido para "1er torneo Alvear Club" empezando desde octavos
INSERT INTO
    partido (
        ID_torneo,
        ID_arbitro,
        ID_jugador1,
        ID_jugador2,
        ID_instancia
    )
VALUES
    -- Octavos de final
    (1, 1, 1, 2, 4),
    (1, 2, 3, 4, 4),
    (1, 3, 5, 6, 4),
    (1, 1, 7, 8, 4),
    (1, 2, 9, 10, 4),
    (1, 3, 11, 12, 4),
    (1, 4, 13, 14, 4),
    (1, 1, 15, 16, 4),
    -- Cuartos de final
    (1, 2, 1, 3, 3),
    (1, 3, 5, 7, 3),
    (1, 4, 9, 11, 3),
    (1, 1, 13, 15, 3),
    -- Semifinal
    (1, 2, 1, 5, 2),
    (1, 3, 9, 13, 2),
    -- Final
    (1, 1, 1, 9, 1);

-- Insertar partidos para el torneo "Copa Mar del Plata" (ID_torneo = 2)
-- Insertar partidos para los torneos "1er Torneo Alvear Club" y "Copa Mar del Plata"
INSERT INTO
    partido (
        ID_torneo,
        ID_arbitro,
        ID_jugador1,
        ID_jugador2,
        ID_instancia
    )
VALUES
    -- Partidos para el torneo "1er Torneo Alvear Club" (ID_torneo = 1)
    (1, 1, 1, 2, 3), -- Cuartos de final
    (1, 2, 3, 4, 3), -- Cuartos de final
    (1, 3, 5, 6, 3), -- Cuartos de final
    (1, 1, 7, 8, 3), -- Cuartos de final
    (1, 2, 1, 3, 2), -- Semifinal
    (1, 3, 6, 8, 2), -- Semifinal
    (1, 1, 1, 6, 1), -- Final
-- Partidos para el torneo "Copa Mar del Plata" (ID_torneo = 2)
-- Octavos de final
(2, 1, 1, 9, 4), -- Partido 1
(2, 2, 2, 10, 4), -- Partido 2
(2, 3, 3, 11, 4), -- Partido 3
(2, 4, 4, 12, 4), -- Partido 4
(2, 1, 5, 13, 4), -- Partido 5
(2, 2, 6, 14, 4), -- Partido 6
(2, 3, 7, 15, 4), -- Partido 7
(2, 4, 8, 16, 4), -- Partido 8
-- Cuartos de final
(2, 1, 1, 2, 3), -- Partido 9
(2, 2, 3, 4, 3), -- Partido 10
(2, 3, 5, 6, 3), -- Partido 11
(2, 4, 7, 8, 3), -- Partido 12
-- Semifinales
(2, 1, 1, 3, 2), -- Partido 13
(2, 2, 5, 7, 2), -- Partido 14
-- Final
(2, 3, 1, 5, 1);
-- Partido 15
-- Insertar sets para cada partido en ambos torneos
INSERT INTO
    sets (
        ID_partido,
        numero_set,
        player1_games_won,
        player2_games_won
    )
VALUES
    -- Sets del torneo "1er Torneo Alvear Club"
    (1, 1, 11, 8),
    (1, 2, 11, 5),
    (2, 1, 11, 7),
    (2, 2, 10, 12),
    (2, 3, 11, 9),
    (3, 1, 3, 11),
    (3, 2, 6, 11),
    (4, 1, 11, 5),
    (4, 2, 5, 11),
    (4, 3, 11, 13),
    (5, 1, 11, 9),
    (5, 2, 13, 11),
    (6, 1, 11, 6),
    (6, 2, 13, 8),
    (7, 1, 13, 11),
    (7, 2, 12, 14),
    (7, 3, 17, 15),
-- Sets del torneo "Copa Mar del Plata" - Octavos
(8, 1, 11, 8),
(8, 2, 9, 11),
(8, 3, 11, 7),
(9, 1, 11, 9),
(9, 2, 8, 11),
(9, 3, 11, 5),
(10, 1, 12, 10),
(10, 2, 11, 9),
(11, 1, 11, 7),
(11, 2, 11, 8),
(12, 1, 9, 11),
(12, 2, 11, 7),
(12, 3, 11, 6),
(13, 1, 11, 5),
(13, 2, 8, 11),
(13, 3, 11, 7),
(14, 1, 10, 12),
(14, 2, 11, 8),
(14, 3, 11, 9),
(15, 1, 11, 4),
(15, 2, 9, 11),
(15, 3, 11, 8),
-- Sets del torneo "Copa Mar del Plata" - Cuartos
(16, 1, 11, 9),
(16, 2, 11, 7),
(17, 1, 11, 5),
(17, 2, 8, 11),
(17, 3, 11, 7),
(18, 1, 10, 12),
(18, 2, 11, 8),
(18, 3, 11, 9),
(19, 1, 11, 7),
(19, 2, 10, 12),
(19, 3, 11, 9),
-- Sets del torneo "Copa Mar del Plata" - Semifinales
(20, 1, 11, 6),
(20, 2, 9, 11),
(20, 3, 11, 8),
(21, 1, 12, 10),
(21, 2, 11, 7),
-- Sets del torneo "Copa Mar del Plata" - Final
(22, 1, 11, 8), (22, 2, 9, 11), (22, 3, 11, 7);