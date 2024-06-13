USE table_tennis;

-- Creación de funciones
DROP FUNCTION IF EXISTS obtenerGanadorPartido;

DELIMITER $$

CREATE FUNCTION obtenerGanadorPartido (ID_partido INT) RETURNS INT 
READS SQL DATA 
BEGIN 
    DECLARE ganador INT;
    DECLARE contador_jugador1 INT DEFAULT 0;
    DECLARE contador_jugador2 INT DEFAULT 0;

    -- Contar los sets ganados por cada jugador en el partido dado
    SELECT COUNT(*) INTO contador_jugador1
    FROM sets
    WHERE
        sets.ID_partido = ID_partido
        AND sets.player1_games_won > sets.player2_games_won;

    SELECT COUNT(*) INTO contador_jugador2
    FROM sets
    WHERE
        sets.ID_partido = ID_partido
        AND sets.player1_games_won < sets.player2_games_won;

    IF contador_jugador1 > contador_jugador2 THEN
        SET ganador = (SELECT ID_jugador1 FROM partido WHERE ID = ID_partido);
    ELSEIF contador_jugador2 > contador_jugador1 THEN
        SET ganador = (SELECT ID_jugador2 FROM partido WHERE ID = ID_partido);
    ELSE 
        SET ganador = NULL;
    END IF;

    RETURN ganador;
END$$

DELIMITER;

DROP FUNCTION IF EXISTS actualizarRanking;

DELIMITER $$

CREATE FUNCTION actualizarRanking (ID_partido INT) RETURNS INT 
READS SQL DATA
BEGIN 
    DECLARE instancia_actual VARCHAR(50);
    DECLARE ranking_actual_jugador1 INT;
    DECLARE ranking_actual_jugador2 INT;
    DECLARE ganador_partido INT;
    DECLARE jugador1_id INT;
    DECLARE jugador2_id INT;

    -- Obtener la instancia actual del partido
    SELECT i.nombre INTO instancia_actual
    FROM partido p
    JOIN instancia i ON p.ID_instancia = i.ID
    WHERE p.ID = ID_partido;

    -- Obtener IDs de los jugadores
    SELECT ID_jugador1, ID_jugador2 INTO jugador1_id, jugador2_id
    FROM partido
    WHERE ID = ID_partido;

    -- Obtener el ranking actual de cada jugador
    SELECT rating INTO ranking_actual_jugador1
    FROM jugador
    WHERE ID = jugador1_id;

    SELECT rating INTO ranking_actual_jugador2
    FROM jugador
    WHERE ID = jugador2_id;

    -- Obtener el ganador del partido
    SELECT obtenerGanadorPartido(ID_partido) INTO ganador_partido;

    -- Actualizar ranking según la instancia del partido
    IF instancia_actual = 'final' THEN
        IF ganador_partido IS NOT NULL THEN
            SET ranking_actual_jugador1 = ranking_actual_jugador1 + 45;
            SET ranking_actual_jugador2 = ranking_actual_jugador2 + 45;
        END IF;
    ELSEIF instancia_actual = 'semifinal' THEN
        SET ranking_actual_jugador1 = ranking_actual_jugador1 + 30;
        SET ranking_actual_jugador2 = ranking_actual_jugador2 + 30;
    ELSEIF instancia_actual = 'cuartos' THEN
        SET ranking_actual_jugador1 = ranking_actual_jugador1 + 15;
        SET ranking_actual_jugador2 = ranking_actual_jugador2 + 15;
    ELSEIF instancia_actual = 'octavos' THEN
        SET ranking_actual_jugador1 = ranking_actual_jugador1 + 2;
        SET ranking_actual_jugador2 = ranking_actual_jugador2 + 2;
    ELSEIF instancia_actual = 'dieciseisavos' THEN
        SET ranking_actual_jugador1 = ranking_actual_jugador1 - 5;
        SET ranking_actual_jugador2 = ranking_actual_jugador2 - 5;
    ELSEIF instancia_actual = 'treintaidosavos' THEN
        SET ranking_actual_jugador1 = ranking_actual_jugador1 - 10;
        SET ranking_actual_jugador2 = ranking_actual_jugador2 - 10;
    ELSE
        RETURN 1;
    END IF;

    -- Puntos adicionales para el ganador si es la final
    IF instancia_actual = 'final' AND ganador_partido IS NOT NULL THEN
        IF ganador_partido = jugador1_id THEN
            SET ranking_actual_jugador1 = ranking_actual_jugador1 + 25;
        ELSE
            SET ranking_actual_jugador2 = ranking_actual_jugador2 + 25;
        END IF;
    END IF;

    -- Actualizar el ranking de los jugadores en la tabla jugador
    UPDATE jugador
    SET rating = ranking_actual_jugador1
    WHERE ID = jugador1_id;

    UPDATE jugador
    SET rating = ranking_actual_jugador2
    WHERE ID = jugador2_id;

    RETURN 1;
END$$

DELIMITER;

DROP TRIGGER IF EXISTS after_insert_partido;

DELIMITER $$

CREATE TRIGGER after_insert_partido
AFTER INSERT ON partido
FOR EACH ROW
BEGIN
    CALL actualizarRanking(NEW.ID);
END$$

DELIMITER;