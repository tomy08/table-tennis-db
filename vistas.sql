USE table_tennis;

-- Eliminar vistas si existen
DROP VIEW IF EXISTS estadisticas_jugadores;

DROP VIEW IF EXISTS puntaje_maximo_club;

DROP VIEW IF EXISTS ranking_jugadores;

DROP VIEW IF EXISTS match_view;

-- Crear vista estadisticas_jugadores
CREATE VIEW estadisticas_jugadores AS
SELECT
    j.ID AS jugador_ID,
    j.nombre AS nombre_jugador,
    j.apellido AS apellido_jugador,
    j.rating AS rating_jugador,
    SUM(
        CASE
            WHEN p.ID_jugador1 = j.ID
            OR p.ID_jugador2 = j.ID THEN 1
            ELSE 0
        END
    ) AS partidos_jugados,
    SUM(
        CASE
            WHEN i.nombre = 'final'
            AND (
                p.ID_jugador1 = j.ID
                OR p.ID_jugador2 = j.ID
            ) THEN 1
            ELSE 0
        END
    ) AS finales_jugadas,
    SUM(
        CASE
            WHEN i.nombre = 'final'
            AND (
                p.ID_jugador1 = j.ID
                OR p.ID_jugador2 = j.ID
            )
            AND obtenerGanadorPartido (p.ID) = j.ID THEN 1
            ELSE 0
        END
    ) AS finales_ganadas,
    SUM(
        CASE
            WHEN obtenerGanadorPartido (p.ID) = j.ID THEN 1
            ELSE 0
        END
    ) AS partidos_ganados
FROM
    jugador j
    LEFT JOIN partido p ON j.ID = p.ID_jugador1
    OR j.ID = p.ID_jugador2
    LEFT JOIN instancia i ON p.ID_instancia = i.ID
GROUP BY
    j.ID;

-- Crear vista puntaje_maximo_club
CREATE VIEW puntaje_maximo_club AS
SELECT
    c.ID AS club_ID,
    c.nombre AS nombre_club,
    SUM(j.rating) AS puntaje_maximo,
    COUNT(*) AS cantidad_jugadores
FROM club c
    INNER JOIN jugador j ON c.ID = j.ID_club
GROUP BY
    c.ID
ORDER BY puntaje_maximo;

-- Crear vista ranking_jugadores
CREATE VIEW ranking_jugadores AS
SELECT *
FROM jugador
ORDER BY rating DESC;

-- Crear vista match_view
CREATE VIEW match_view AS
SELECT
    p.ID AS match_id,
    p.ID_arbitro AS referee_id,
    p.ID_jugador1 AS player1_id,
    CONCAT(j1.nombre, ' ', j1.apellido) AS player1_name,
    j1.rating AS player1_rating,
    p.ID_jugador2 AS player2_id,
    CONCAT(j2.nombre, ' ', j2.apellido) AS player2_name,
    j2.rating AS player2_rating,
    p.ID_torneo AS tournament_id,
    i.nombre AS stage,
    s.numero_set AS set_number,
    s.player1_games_won,
    s.player2_games_won
FROM
    partido p
    LEFT JOIN sets s ON p.ID = s.ID_partido
    INNER JOIN jugador j1 ON p.ID_jugador1 = j1.ID
    INNER JOIN jugador j2 ON p.ID_jugador2 = j2.ID
    INNER JOIN instancia i ON p.ID_instancia = i.ID;