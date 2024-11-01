USE table_tennis;

DROP VIEW IF EXISTS ranking_jugadores;
-- obtener el ranking de los jugadores
CREATE VIEW ranking_jugadores AS
SELECT *
from jugador
order by rating desc;

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

DROP VIEW IF EXISTS ranking_jugadores_club;
-- obtener el ranking de los jugadores y agruparlos por club
CREATE VIEW ranking_jugadores_club AS
SELECT
    c.ID AS club_ID,
    c.nombre AS nombre_club,
    j.ID AS jugador_ID,
    j.nombre AS nombre_jugador,
    j.apellido AS apellido_jugador,
    j.rating AS rating_jugador
FROM club c
    INNER JOIN jugador j ON c.ID = j.ID_club
ORDER BY c.ID, j.rating DESC;

DROP VIEW IF EXISTS obtener_partidos_por_torneo;
-- obtener partidos por torneo

CREATE VIEW obtener_partidos_por_torneo AS
SELECT
    t.ID AS torneo_ID,
    t.nombre_torneo AS nombre_torneo,
    p.ID AS partido_ID,
    p.instancia AS instancia_partido,
    j1.nombre AS nombre_jugador1,
    j1.apellido AS apellido_jugador1,
    j2.nombre AS nombre_jugador2,
    j2.apellido AS apellido_jugador2,
    GROUP_CONCAT(
        s.player1_games_won
        ORDER BY s.numero_set
    ) AS games_jugador1,
    GROUP_CONCAT(
        s.player2_games_won
        ORDER BY s.numero_set
    ) AS games_jugador2,
    obtenerGanadorPartido (p.ID) AS ganador_id
FROM
    torneo t
    INNER JOIN partido p ON t.ID = p.ID_torneo
    INNER JOIN jugador j1 ON p.ID_jugador1 = j1.ID
    INNER JOIN jugador j2 ON p.ID_jugador2 = j2.ID
    INNER JOIN sets s ON p.ID = s.ID_partido
GROUP BY
    t.ID,
    t.nombre_torneo,
    p.ID,
    p.instancia,
    j1.nombre,
    j1.apellido,
    j2.nombre,
    j2.apellido
ORDER BY t.ID, p.instancia, j1.rating DESC, j2.rating DESC;

DROP VIEW IF EXISTS obtener_partidos_por_jugador;
-- obtener partidos por jugador

CREATE VIEW obtener_partidos_por_jugador AS
SELECT
    j.ID AS jugador_ID,
    j.nombre AS nombre_jugador,
    j.apellido AS apellido_jugador,
    p.ID AS partido_ID,
    p.instancia AS instancia_partido,
    CASE
        WHEN j.nombre = j1.nombre THEN j2.nombre
        WHEN j.nombre = j2.nombre THEN j1.nombre
    END AS nombre_rival,
    CASE
        WHEN j.nombre = j1.nombre THEN j2.apellido
        WHEN j.nombre = j2.nombre THEN j1.apellido
    END AS apellido_rival,
    j1.id AS jugador1_id,
    j2.id AS jugador2_id,
    GROUP_CONCAT(
        s.player1_games_won
        ORDER BY s.numero_set
    ) AS games_jugador1,
    GROUP_CONCAT(
        s.player2_games_won
        ORDER BY s.numero_set
    ) AS games_jugador2,
    obtenerGanadorPartido (p.ID) AS ganador_id
FROM
    jugador j
    INNER JOIN partido p ON j.ID = p.ID_jugador1
    OR j.ID = p.ID_jugador2
    INNER JOIN sets s ON p.ID = s.ID_partido
    INNER JOIN jugador j1 ON p.ID_jugador1 = j1.ID
    INNER JOIN jugador j2 ON p.ID_jugador2 = j2.ID
GROUP BY
    j.ID,
    j.nombre,
    j.apellido,
    p.ID,
    p.instancia,
    j1.nombre,
    j1.apellido,
    j2.nombre,
    j2.apellido
ORDER BY j.ID, p.instancia, j1.rating DESC, j2.rating DESC;

DROP VIEW IF EXISTS obtener_partidos_ganados_por_jugador;
-- obtener partidos ganados por jugador

CREATE VIEW obtener_finales_por_jugador AS
SELECT
    j.ID AS jugador_ID,
    j.nombre AS nombre_jugador,
    j.apellido AS apellido_jugador,
    p.ID AS partido_ID,
    p.instancia AS instancia_partido,
    CASE
        WHEN j.nombre = j1.nombre THEN j2.nombre
        WHEN j.nombre = j2.nombre THEN j1.nombre
    END AS nombre_rival,
    CASE
        WHEN j.nombre = j1.nombre THEN j2.apellido
        WHEN j.nombre = j2.nombre THEN j1.apellido
    END AS apellido_rival,
    j1.id AS jugador1_id,
    j2.id AS jugador2_id,
    GROUP_CONCAT(
        s.player1_games_won
        ORDER BY s.numero_set
    ) AS games_jugador1,
    GROUP_CONCAT(
        s.player2_games_won
        ORDER BY s.numero_set
    ) AS games_jugador2,
    obtenerGanadorPartido (p.ID) AS ganador_id
FROM
    jugador j
    INNER JOIN partido p ON j.ID = p.ID_jugador1
    OR j.ID = p.ID_jugador2
    INNER JOIN sets s ON p.ID = s.ID_partido
    INNER JOIN jugador j1 ON p.ID_jugador1 = j1.ID
    INNER JOIN jugador j2 ON p.ID_jugador2 = j2.ID
WHERE
    p.instancia = 'final'
GROUP BY
    j.ID,
    j.nombre,
    j.apellido,
    p.ID,
    p.instancia,
    j1.nombre,
    j1.apellido,
    j2.nombre,
    j2.apellido
ORDER BY j.ID, p.instancia, j1.rating DESC, j2.rating DESC;

DROP VIEW IF EXISTS obtener_finales_ganadas_por_jugador;
-- obtener finales ganadas por jugador
CREATE View obtener_finales_ganadas_por_jugador AS
SELECT
    j.ID AS jugador_ID,
    j.nombre AS nombre_jugador,
    j.apellido AS apellido_jugador,
    p.ID AS partido_ID,
    p.instancia AS instancia_partido,
    CASE
        WHEN j.nombre = j1.nombre THEN j2.nombre
        WHEN j.nombre = j2.nombre THEN j1.nombre
    END AS nombre_rival,
    CASE
        WHEN j.nombre = j1.nombre THEN j2.apellido
        WHEN j.nombre = j2.nombre THEN j1.apellido
    END AS apellido_rival,
    j1.id AS jugador1_id,
    j2.id AS jugador2_id,
    GROUP_CONCAT(
        s.player1_games_won
        ORDER BY s.numero_set
    ) AS games_jugador1,
    GROUP_CONCAT(
        s.player2_games_won
        ORDER BY s.numero_set
    ) AS games_jugador2,
    obtenerGanadorPartido (p.ID) AS ganador_id
FROM
    jugador j
    INNER JOIN partido p ON j.ID = p.ID_jugador1
    OR j.ID = p.ID_jugador2
    INNER JOIN sets s ON p.ID = s.ID_partido
    INNER JOIN jugador j1 ON p.ID_jugador1 = j1.ID
    INNER JOIN jugador j2 ON p.ID_jugador2 = j2.ID
WHERE
    p.instancia = 'final'
    AND obtenerGanadorPartido (p.ID) = j.ID
GROUP BY
    j.ID,
    j.nombre,
    j.apellido,
    p.ID,
    p.instancia,
    j1.nombre,
    j1.apellido,
    j2.nombre,
    j2.apellido
ORDER BY j.ID, p.instancia, j1.rating DESC, j2.rating DESC;

DROP VIEW IF EXISTS obtener_finales_perdidas_por_jugador;
-- obtener finales perdidas por jugador
CREATE View obtener_finales_perdidas_por_jugador AS
SELECT
    j.ID AS jugador_ID,
    j.nombre AS nombre_jugador,
    j.apellido AS apellido_jugador,
    p.ID AS partido_ID,
    p.instancia AS instancia_partido,
    CASE
        WHEN j.nombre = j1.nombre THEN j2.nombre
        WHEN j.nombre = j2.nombre THEN j1.nombre
    END AS nombre_rival,
    CASE
        WHEN j.nombre = j1.nombre THEN j2.apellido
        WHEN j.nombre = j2.nombre THEN j1.apellido
    END AS apellido_rival,
    j1.id AS jugador1_id,
    j2.id AS jugador2_id,
    GROUP_CONCAT(
        s.player1_games_won
        ORDER BY s.numero_set
    ) AS games_jugador1,
    GROUP_CONCAT(
        s.player2_games_won
        ORDER BY s.numero_set
    ) AS games_jugador2,
    obtenerGanadorPartido (p.ID) AS ganador_id
FROM
    jugador j
    INNER JOIN partido p ON j.ID = p.ID_jugador1
    OR j.ID = p.ID_jugador2
    INNER JOIN sets s ON p.ID = s.ID_partido
    INNER JOIN jugador j1 ON p.ID_jugador1 = j1.ID
    INNER JOIN jugador j2 ON p.ID_jugador2 = j2.ID
WHERE
    p.instancia = 'final'
    AND obtenerGanadorPartido (p.ID) != j.ID
GROUP BY
    j.ID,
    j.nombre,
    j.apellido,
    p.ID,
    p.instancia,
    j1.nombre,
    j1.apellido,
    j2.nombre,
    j2.apellido
ORDER BY j.ID, p.instancia, j1.rating DESC, j2.rating DESC;

DROP VIEW IF EXISTS obtener_partidos_ganados_por_jugador;
-- obtener partidos ganados por jugador

CREATE VIEW obtener_partidos_ganados_por_jugador AS
SELECT
    j.ID AS jugador_ID,
    j.nombre AS nombre_jugador,
    j.apellido AS apellido_jugador,
    p.ID AS partido_ID,
    p.instancia AS instancia_partido,
    CASE
        WHEN j.nombre = j1.nombre THEN j2.nombre
        WHEN j.nombre = j2.nombre THEN j1.nombre
    END AS nombre_rival,
    CASE
        WHEN j.nombre = j1.nombre THEN j2.apellido
        WHEN j.nombre = j2.nombre THEN j1.apellido
    END AS apellido_rival,
    j1.id AS jugador1_id,
    j2.id AS jugador2_id,
    GROUP_CONCAT(
        s.player1_games_won
        ORDER BY s.numero_set
    ) AS games_jugador1,
    GROUP_CONCAT(
        s.player2_games_won
        ORDER BY s.numero_set
    ) AS games_jugador2,
    obtenerGanadorPartido (p.ID) AS ganador_id
FROM
    jugador j
    INNER JOIN partido p ON j.ID = p.ID_jugador1
    OR j.ID = p.ID_jugador2
    INNER JOIN sets s ON p.ID = s.ID_partido
    INNER JOIN jugador j1 ON p.ID_jugador1 = j1.ID
    INNER JOIN jugador j2 ON p.ID_jugador2 = j2.ID
WHERE
    j.ID = obtenerGanadorPartido (p.ID)
GROUP BY
    j.ID,
    j.nombre,
    j.apellido,
    p.ID,
    p.instancia,
    j1.nombre,
    j1.apellido,
    j2.nombre,
    j2.apellido
ORDER BY j.ID, p.instancia, j1.rating DESC, j2.rating DESC;

DROP VIEW IF EXISTS obtener_partidos_perdidos_por_jugador;
-- obtener partidos perdidos por jugador

CREATE VIEW obtener_partidos_perdidos_por_jugador AS
SELECT
    j.ID AS jugador_ID,
    j.nombre AS nombre_jugador,
    j.apellido AS apellido_jugador,
    p.ID AS partido_ID,
    p.instancia AS instancia_partido,
    CASE
        WHEN j.nombre = j1.nombre THEN j2.nombre
        WHEN j.nombre = j2.nombre THEN j1.nombre
    END AS nombre_rival,
    CASE
        WHEN j.nombre = j1.nombre THEN j2.apellido
        WHEN j.nombre = j2.nombre THEN j1.apellido
    END AS apellido_rival,
    j1.id AS jugador1_id,
    j2.id AS jugador2_id,
    GROUP_CONCAT(
        s.player1_games_won
        ORDER BY s.numero_set
    ) AS games_jugador1,
    GROUP_CONCAT(
        s.player2_games_won
        ORDER BY s.numero_set
    ) AS games_jugador2,
    obtenerGanadorPartido (p.ID) AS ganador_id
FROM
    jugador j
    INNER JOIN partido p ON j.ID = p.ID_jugador1
    OR j.ID = p.ID_jugador2
    INNER JOIN sets s ON p.ID = s.ID_partido
    INNER JOIN jugador j1 ON p.ID_jugador1 = j1.ID
    INNER JOIN jugador j2 ON p.ID_jugador2 = j2.ID
WHERE
    j.ID != obtenerGanadorPartido (p.ID)
GROUP BY
    j.ID,
    j.nombre,
    j.apellido,
    p.ID,
    p.instancia,
    j1.nombre,
    j1.apellido,
    j2.nombre,
    j2.apellido
ORDER BY j.ID, p.instancia, j1.rating DESC, j2.rating DESC;