# Base de Datos de Tenis de Mesa

Esta es una base de datos diseñada para gestionar torneos de tenis de mesa, jugadores, partidos, árbitros, clubes y sets.

## Modelo relacional

![Modelo relacional](./modelo-relacional.PNG)

## Tablas

1. **club**

   - `ID` **(PK)**
   - `nombre`
   - `ID_ubicacion` **(FK-Ubicacion)**
   - `fecha_creacion`

2. **jugador**

   - `ID` **(PK)**
   - `nombre`
   - `apellido`
   - `fecha_nac`
   - `rating`
   - `ID_club` **(FK-Club)**

3. **torneo**

   - `ID` **(PK)**
   - `nombre_torneo`
   - `fecha`
   - `categoria`
   - `ID_ubicacion` **(FK-Ubicacion)**

4. **arbitro**

   - `ID` **(PK)**
   - `nombre`
   - `apellido`
   - `fecha_nac`

5. **instancia**

   - `ID` **(PK)**
   - `nombre` (nombre de la instancia como 'final', 'semifinal', etc.)

6. **partido**

   - `ID` **(PK)**
   - `ID_arbitro` **(FK-Arbitro)**
   - `ID_jugador1` **(FK-Jugador)**
   - `ID_jugador2` **(FK-Jugador)**
   - `ID_torneo` **(FK-Torneo)**
   - `ID_instancia` **(FK-Instancia)**

7. **sets**

   - `ID` **(PK)**
   - `ID_partido` **(FK-Partido)**
   - `numero_set`
   - `player1_games_won`
   - `player2_games_won`

8. **ubicacion**
   - `ID` **(PK)**
   - `direccion`
   - `ciudad`
   - `pais`

## Funciones

- **obtenerGanadorPartido(ID_partido INT)**

  Esta función determina el ganador de un partido dado el `ID_partido`.

- **actualizarRanking(ID_partido INT)**

  Esta función actualiza el ranking de los jugadores después de un partido basado en la instancia del torneo y el resultado del partido.

## Vistas

- **estadisticas_jugadores**

  Vista que proporciona estadísticas detalladas de los jugadores, como el número de partidos jugados, finales jugadas, finales ganadas y partidos ganados.

- **puntaje_maximo_club**

  Vista que muestra el puntaje máximo de los clubes, calculado como la suma de los ratings de los jugadores pertenecientes a cada club.

- **ranking_jugadores**

  Vista que muestra el ranking de los jugadores ordenados por su rating en orden descendente.

- **match_view**

  Vista que proporciona una visión detallada de los partidos, incluyendo información sobre los jugadores, árbitros, sets y resultados.

## Triggers

- **after_insert_partido**

  Este trigger se activa después de insertar un nuevo partido y llama a la función `actualizarRanking` para actualizar el ranking de los jugadores involucrados.
