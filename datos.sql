INSERT INTO
    arbitro (nombre, apellido, fecha_nac)
VALUES (
        "Jose",
        "Rodolfo",
        "1999-12-01"
    ),
    (
        "Agustin",
        "Fernández",
        "2000-06-15"
    ),
    (
        "Jesús",
        "Ramon",
        "2000-06-15"
    );

INSERT INTO
    club (
        nombre,
        ubicacion,
        fecha_creacion
    )
VALUES (
        "Jugador Libre",
        "Buenos Aires",
        "1900-01-01"
    ),
    (
        "Alvear Club",
        "Av. directorio 4147",
        "1935-08-19"
    ),
    (
        "Ateneo Popular de Versailles",
        "Roma 950",
        "1938-07-02"
    );

INSERT INTO
    jugador (
        nombre,
        apellido,
        fecha_nac,
        rating,
        ID_club
    )
VALUES (
        "Tomas",
        "Santa Cruz",
        "2007-05-24",
        0,
        2
    ),
    (
        "Mateo",
        "Diaz",
        "2004-08-05",
        0,
        1
    ),
    (
        "Tiziano",
        "Romeo",
        "1999-02-27",
        0,
        3
    ),
    (
        "Ramiro",
        "González",
        "2000-04-17",
        0,
        1
    ),
    (
        "Facundo",
        "López",
        "1980-12-12",
        0,
        3
    ),
    (
        "Mauro",
        "Martín",
        "1990-07-21",
        0,
        2
    ),
    (
        "Axel",
        "Sánchez",
        "2006-05-17",
        0,
        1
    ),
    (
        "Manuel",
        "Gómez ",
        "2010-02-19",
        0,
        2
    );

INSERT INTO
    torneo (
        nombre_torneo,
        fecha,
        categoria,
        localidad
    )
VALUES (
        "1er torneo Alvear Club",
        "2024-05-20",
        5,
        "Av. Directorio 4147"
    );

INSERT INTO
    partido (
        ID_torneo,
        ID_arbitro,
        ID_jugador1,
        ID_jugador2,
        instancia
    )
VALUES (1, 1, 1, 2, "cuartos"),
    (1, 2, 3, 4, "cuartos"),
    (1, 3, 5, 6, "cuartos"),
    (1, 1, 7, 8, "cuartos"),
    (1, 2, 1, 3, "semifinal"),
    (1, 3, 6, 8, "semifinal"),
    (1, 1, 1, 6, "final");

INSERT INTO
    sets (
        ID_partido,
        numero_set,
        player1_games_won,
        player2_games_won
    )
VALUES (1, 1, 11, 8),
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
    (7, 3, 17, 15);