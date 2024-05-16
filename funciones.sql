USE table_tennis;

-- Creacion de funciones
DROP FUNCTION IF EXISTS obtenerGanadorPartido;

DELIMITER / /

CREATE FUNCTION obtenerGanadorPartido (ID_partido INT) RETURNS INT READS SQL DATA BEGIN DECLARE ganador INT;

DECLARE contador_jugador1 INT DEFAULT 0;

DECLARE contador_jugador2 INT DEFAULT 0;

-- Contar los sets ganados por cada jugador en el partido dado
SELECT COUNT(*) INTO contador_jugador1
FROM sets
WHERE
    ID_partido = obtenerGanadorPartido.ID_partido
    AND ID_ganador = sets.ID_jugador1;

SELECT COUNT(*) INTO contador_jugador2
FROM sets
WHERE
    ID_partido = obtenerGanadorPartido.ID_partido
    AND ID_ganador = sets.ID_jugador2;

IF contador_jugador1 > contador_jugador2 THEN
SET
    ganador = sets.ID_jugador1;

ELSEIF contador_jugador2 > contador_jugador1 THEN
SET
    ganador = sets.ID_jugador2;

ELSE SET ganador = NULL;

END IF;

RETURN ganador;

END //

DELIMITER;

DROP FUNCTION IF EXISTS actualizarRanking;

DELIMITER / /

CREATE FUNCTION actualizarRanking (ID_partido INT) RETURNS INT 
BEGIN 
DECLARE instancia_actual VARCHAR(50);

DECLARE ranking_actual_jugador1 INT;

DECLARE ranking_actual_jugador2 INT;

DECLARE ganador_partido INT;

SELECT instancia INTO instancia_actual
FROM partido
WHERE
    ID = ID_partido;

SELECT rating INTO ranking_actual_jugador1
FROM jugador
WHERE
    ID = (
        SELECT ID_jugador1
        FROM partido
        WHERE
            ID = ID_partido
    );

SELECT rating INTO ranking_actual_jugador2
FROM jugador
WHERE
    ID = (
        SELECT ID_jugador2
        FROM partido
        WHERE
            ID = ID_partido
    );

SELECT obtenerGanadorPartido (ID_partido) INTO ganador_partido;

IF instancia_actual = 'final' THEN IF ganador_partido IS NOT NULL THEN
SET
    ranking_actual_jugador1 = ranking_actual_jugador1 + 45;

SET ranking_actual_jugador2 = ranking_actual_jugador2 + 45;

END IF;

ELSEIF instancia_actual = 'semifinal' THEN
SET
    ranking_actual_jugador1 = ranking_actual_jugador1 + 30;

SET ranking_actual_jugador2 = ranking_actual_jugador2 + 30;

ELSEIF instancia_actual = 'cuartos' THEN
SET
    ranking_actual_jugador1 = ranking_actual_jugador1 + 15;

SET ranking_actual_jugador2 = ranking_actual_jugador2 + 15;

ELSEIF instancia_actual = 'octavos' THEN
SET
    ranking_actual_jugador1 = ranking_actual_jugador1 + 2;

SET ranking_actual_jugador2 = ranking_actual_jugador2 + 2;

ELSEIF instancia_actual = 'dieciseisavos' THEN
SET
    ranking_actual_jugador1 = ranking_actual_jugador1 - 5;

SET ranking_actual_jugador2 = ranking_actual_jugador2 - 5;

ELSEIF instancia_actual = 'treintaidosavos' THEN
SET
    ranking_actual_jugador1 = ranking_actual_jugador1 - 10;

SET ranking_actual_jugador2 = ranking_actual_jugador2 - 10;

ELSE RETURN 1;

END IF;

IF instancia_actual = 'final'
AND ganador_partido IS NOT NULL THEN IF ganador_partido = (
    SELECT ID_jugador1
    FROM partido
    WHERE
        ID = ID_partido
) THEN
SET
    ranking_actual_jugador1 = ranking_actual_jugador1 + 25;

ELSE SET ranking_actual_jugador2 = ranking_actual_jugador2 + 25;

END IF;

END IF;

UPDATE jugador
SET
    rating = ranking_actual_jugador1
WHERE
    ID = (
        SELECT ID_jugador1
        FROM partido
        WHERE
            ID = ID_partido
    );

UPDATE jugador
SET
    rating = ranking_actual_jugador2
WHERE
    ID = (
        SELECT ID_jugador2
        FROM partido
        WHERE
            ID = ID_partido
    );

RETURN 1;

END //

DELIMITER;