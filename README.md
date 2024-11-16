# Trabajo Práctico Final de Base de Datos

## Contexto y Justificación

La base de datos creada ayuda a organizar torneos de tenis de mesa. Elegí este tema porque me interesa el deporte y vi la necesidad de tener un sistema para manejar bien la información de los jugadores, partidos, árbitros y resultados.

Con esta base de datos, es fácil almacenar y consultar todos estos datos, además de ver estadísticas y rankings de los jugadores. Si la conectara a una página web, se podría convertir en una aplicación muy parecida a las que existen hoy en día para la gestión de torneos y seguimiento de jugadores.

## Listado de Entidades, Atributos, Claves y Tipo de Datos Utilizados

1. **club**

   - `ID` **(PK)**: INT
   - `nombre`: VARCHAR(50)
   - `ID_ubicacion` **(FK-Ubicacion)**: INT
   - `fecha_creacion`: DATE

2. **jugador**

   - `ID` **(PK)**: INT
   - `nombre`: VARCHAR(50)
   - `apellido`: VARCHAR(50)
   - `fecha_nac`: DATE
   - `rating`: INT
   - `ID_club` **(FK-Club)**: INT

3. **torneo**

   - `ID` **(PK)**: INT
   - `nombre_torneo`: VARCHAR(50)
   - `fecha`: DATETIME
   - `categoria`: INT
   - `ID_ubicacion` **(FK-Ubicacion)**: INT

4. **arbitro**

   - `ID` **(PK)**: INT
   - `nombre`: VARCHAR(50)
   - `apellido`: VARCHAR(50)
   - `fecha_nac`: DATE

5. **instancia**

   - `ID` **(PK)**: INT
   - `nombre`: VARCHAR(50)

6. **partido**

   - `ID` **(PK)**: INT
   - `ID_arbitro` **(FK-Arbitro)**: INT
   - `ID_jugador1` **(FK-Jugador)**: INT
   - `ID_jugador2` **(FK-Jugador)**: INT
   - `ID_torneo` **(FK-Torneo)**: INT
   - `ID_instancia` **(FK-Instancia)**: INT

7. **sets**

   - `ID` **(PK)**: INT
   - `ID_partido` **(FK-Partido)**: INT
   - `numero_set`: INT
   - `player1_games_won`: INT
   - `player2_games_won`: INT

8. **ubicacion**
   - `ID` **(PK)**: INT
   - `nombre`: VARCHAR(50)

## Modelo Entidad-Relación y Modelo Relacional

![Modelo relacional](./modelo-relacional.PNG)

## Comandos SQL

### DDL (Data Definition Language)

```sql
-- Creación de la base de datos
CREATE DATABASE table_tennis;
USE table_tennis;

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
```

### Updates

```sql
-- Actualizar el nombre de un club
UPDATE club SET nombre = 'Club Deportivo Alvear' WHERE ID = 2;

-- Actualizar el rating de un jugador
UPDATE jugador SET rating = 1500 WHERE ID = 1;

-- Actualizar la fecha de un torneo
UPDATE torneo SET fecha = '2024-07-01' WHERE ID = 1;
```

### Deletes

```sql
-- Eliminar un jugador
DELETE FROM jugador WHERE ID = 8;

-- Eliminar un partido
DELETE FROM partido WHERE ID = 7;

-- Eliminar un set
DELETE FROM sets WHERE ID = 15;
```

## Subconsultas

### 1. Estadísticas de Jugadores

```sql
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
```

![Tabla de Estadísticas de Jugadores](./public/estadisticas_jugadores.png)

### 2. Puntaje Máximo por Club

```sql
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
```

![Tabla de Puntaje Máximo por Club](./public/puntaje_maximo_club.png)

### 3. Ranking de Jugadores por Club

```sql
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
```

![Tabla de Ranking de Jugadores por Club](./public/ranking_jugadores_club.png)

### 4. Partidos por Torneo

```sql
SELECT
    t.ID AS torneo_ID,
    t.nombre_torneo AS nombre_torneo,
    p.ID AS partido_ID,
    i.nombre AS instancia_partido,
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
    INNER JOIN instancia i ON p.ID_instancia = i.ID
GROUP BY
    t.ID,
    t.nombre_torneo,
    p.ID,
    i.nombre,
    j1.nombre,
    j1.apellido,
    j2.nombre,
    j2.apellido
ORDER BY t.ID, i.nombre, j1.rating DESC, j2.rating DESC;
```

![Tabla de Partidos por Torneo](./public/obtener_partidos_por_torneo.png)

### 5. Partidos por Jugador

```sql
SELECT
    j.ID AS jugador_ID,
    j.nombre AS nombre_jugador,
    j.apellido AS apellido_jugador,
    p.ID AS partido_ID,
    i.nombre AS instancia_partido,
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
    INNER JOIN instancia i ON p.ID_instancia = i.ID
GROUP BY
    j.ID,
    j.nombre,
    j.apellido,
    p.ID,
    i.nombre,
    j1.nombre,
    j1.apellido,
    j2.nombre,
    j2.apellido
ORDER BY j.ID, i.nombre, j1.rating DESC, j2.rating DESC;
```

![Tabla de Partidos por Jugador](./public/obtener_partidos_por_jugador.png)

### 6. Finales por Jugador

```sql
SELECT
    j.ID AS jugador_ID,
    j.nombre AS nombre_jugador,
    j.apellido AS apellido_jugador,
    p.ID AS partido_ID,
    i.nombre AS instancia_partido,
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
    INNER JOIN instancia i ON p.ID_instancia = i.ID
WHERE
    i.nombre = 'final'
GROUP BY
    j.ID,
    j.nombre,
    j.apellido,
    p.ID,
    i.nombre,
    j1.nombre,
    j1.apellido,
    j2.nombre,
    j2.apellido
ORDER BY j.ID, i.nombre, j1.rating DESC, j2.rating DESC;
```

![Tabla de Finales por Jugador](./public/obtener_finales_por_jugador.png)

### 7. Finales Ganadas por Jugador

```sql
SELECT
    j.ID AS jugador_ID,
    j.nombre AS nombre_jugador,
    j.apellido AS apellido_jugador,
    p.ID AS partido_ID,
    i.nombre AS instancia_partido,
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
    INNER JOIN instancia i ON p.ID_instancia = i.ID
WHERE
    i.nombre = 'final'
    AND obtenerGanadorPartido (p.ID) = j.ID
GROUP BY
    j.ID,
    j.nombre,
    j.apellido,
    p.ID,
    i.nombre,
    j1.nombre,
    j1.apellido,
    j2.nombre,
    j2.apellido
ORDER BY j.ID, i.nombre, j1.rating DESC, j2.rating DESC;
```

![Tabla de Finales Ganadas por Jugador](./public/obtener_finales_ganadas_por_jugador.png)

### 8. Finales Perdidas por Jugador

```sql
SELECT
    j.ID AS jugador_ID,
    j.nombre AS nombre_jugador,
    j.apellido AS apellido_jugador,
    p.ID AS partido_ID,
    i.nombre AS instancia_partido,
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
    INNER JOIN instancia i ON p.ID_instancia = i.ID
WHERE
    i.nombre = 'final'
    AND obtenerGanadorPartido (p.ID) != j.ID
GROUP BY
    j.ID,
    j.nombre,
    j.apellido,
    p.ID,
    i.nombre,
    j1.nombre,
    j1.apellido,
    j2.nombre,
    j2.apellido
ORDER BY j.ID, i.nombre, j1.rating DESC, j2.rating DESC;
```

![Tabla de Finales Perdidas por Jugador](./public/obtener_finales_perdidas_por_jugador.png)

### 9. Partidos Ganados por Jugador

```sql
SELECT
    j.ID AS jugador_ID,
    j.nombre AS nombre_jugador,
    j.apellido AS apellido_jugador,
    p.ID AS partido_ID,
    i.nombre AS instancia_partido,
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
    INNER JOIN instancia i ON p.ID_instancia = i.ID
WHERE
    j.ID = obtenerGanadorPartido (p.ID)
GROUP BY
    j.ID,
    j.nombre,
    j.apellido,
    p.ID,
    i.nombre,
    j1.nombre,
    j1.apellido,
    j2.nombre,
    j2.apellido
ORDER BY j.ID, i.nombre, j1.rating DESC, j2.rating DESC;
```

![Tabla de Partidos Ganados por Jugador](./public/obtener_partidos_ganados_por_jugador.png)

### 10. Partidos Perdidos por Jugador

```sql
SELECT
    j.ID AS jugador_ID,
    j.nombre AS nombre_jugador,
    j.apellido AS apellido_jugador,
    p.ID AS partido_ID,
    i.nombre AS instancia_partido,
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
    INNER JOIN instancia i ON p.ID_instancia = i.ID
WHERE
    j.ID != obtenerGanadorPartido (p.ID)
GROUP BY
    j.ID,
    j.nombre,
    j.apellido,
    p.ID,
    i.nombre,
    j1.nombre,
    j1.apellido,
    j2.nombre,
    j2.apellido
ORDER BY j.ID, i.nombre, j1.rating DESC, j2.rating DESC;
```

![Tabla de Partidos Perdidos por Jugador](./public/obtener_partidos_perdidos_por_jugador.png)

### 11. Promedio de Rating por Club

```sql
SELECT
    c.ID AS club_ID,
    c.nombre AS nombre_club,
    AVG(j.rating) AS promedio_rating,
    COUNT(j.ID) AS cantidad_jugadores
FROM club c
    INNER JOIN jugador j ON c.ID = j.ID_club
GROUP BY
    c.ID,
    c.nombre
HAVING
    COUNT(j.ID) > 1
ORDER BY promedio_rating DESC;
```

![Tabla de Promedio de Rating por Club](./public/promedio_rating_club.png)

### 12. Promedio de Sets Ganados por Jugador

```sql
SELECT
    j.ID AS jugador_ID,
    j.nombre AS nombre_jugador,
    j.apellido AS apellido_jugador,
    AVG(
        CASE
            WHEN s.player1_games_won > s.player2_games_won
            AND p.ID_jugador1 = j.ID THEN 1
            WHEN s.player2_games_won > s.player1_games_won
            AND p.ID_jugador2 = j.ID THEN 1
            ELSE 0
        END
    ) AS promedio_sets_ganados
FROM
    jugador j
    INNER JOIN partido p ON j.ID = p.ID_jugador1
    OR j.ID = p.ID_jugador2
    INNER JOIN sets s ON p.ID = s.ID_partido
GROUP BY
    j.ID,
    j.nombre,
    j.apellido
ORDER BY promedio_sets_ganados DESC;
```

![Tabla de Promedio de Sets Ganados por Jugador](./public/promedio_sets_ganados_por_jugador.png)

### 13. Promedio de Edad de Jugadores por Club

```sql
SELECT
    c.ID AS club_ID,
    c.nombre AS nombre_club,
    AVG(
        YEAR(CURDATE()) - YEAR(j.fecha_nac)
    ) AS promedio_edad
FROM club c
    INNER JOIN jugador j ON c.ID = j.ID_club
GROUP BY
    c.ID,
    c.nombre
ORDER BY promedio_edad DESC;
```

![Tabla de Promedio de Edad de Jugadores por Club](./public/promedio_edad_jugadores_por_club.png)

### 14. Winrate de Jugadores

```sql
SELECT
    j.ID AS jugador_ID,
    j.nombre AS nombre_jugador,
    j.apellido AS apellido_jugador,
    SUM(
        CASE
            WHEN j.ID = obtenerGanadorPartido (p.ID) THEN 1
            ELSE 0
        END
    ) AS partidos_ganados,
    COUNT(*) AS partidos_jugados,
    SUM(
        CASE
            WHEN j.ID = obtenerGanadorPartido (p.ID) THEN 1
            ELSE 0
        END
    ) / COUNT(*) AS winrate
FROM jugador j
    INNER JOIN partido p ON j.ID = p.ID_jugador1
    OR j.ID = p.ID_jugador2
GROUP BY
    j.ID,
    j.nombre,
    j.apellido
ORDER BY winrate DESC;
```

![Tabla de Winrate de Jugadores](./public/winrate_jugadores.png)

## Modificación de Restricciones de FK

1. En la tabla `partido`, cambiar la restricción de `ID_jugador1` a `ON DELETE CASCADE` para eliminar todos los partidos asociados cuando se elimina un jugador.
2. En la tabla `partido`, cambiar la restricción de `ID_jugador2` a `ON DELETE CASCADE` para eliminar todos los partidos asociados cuando se elimina un jugador.
3. En la tabla `partido`, cambiar la restricción de `ID_arbitro` a `ON DELETE SET NULL` para mantener el registro del partido pero sin árbitro cuando se elimina un árbitro.
4. En la tabla `club`, cambiar la restricción de `ID_ubicacion` a `ON DELETE SET NULL` para mantener el registro del club pero sin ubicación cuando se elimina una ubicación.
