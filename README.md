# Base de Datos de Tenis de Mesa

Esta es una base de datos diseñada para gestionar torneos de tenis de mesa, jugadores, partidos, árbitros, clubes y sets. A continuación se presenta un desglose de las tablas y sus estructuras:

## Tablas

1. **club**

   - `ID`: Identificador único del club (Clave primaria)
   - `nombre`: Nombre del club
   - `ubicacion`: Ubicación del club
   - `fecha_creacion`: Fecha de fundación del club

2. **jugador**

   - `ID`: Identificador único del jugador (Clave primaria)
   - `nombre`: Nombre del jugador
   - `apellido`: Apellido del jugador
   - `fecha_nac`: Fecha de nacimiento del jugador
   - `rating`: Clasificación del jugador
   - `ID_club`: Clave foránea que referencia al club al que pertenece el jugador

3. **torneo**

   - `ID`: Identificador único del torneo (Clave primaria)
   - `nombre_torneo`: Nombre del torneo
   - `fecha`: Fecha y hora del torneo
   - `categoria`: Categoría del torneo
   - `localidad`: Ubicación del torneo

4. **arbitro**

   - `ID`: Identificador único del árbitro (Clave primaria)
   - `nombre`: Nombre del árbitro
   - `apellido`: Apellido del árbitro
   - `fecha_nac`: Fecha de nacimiento del árbitro

5. **partido**

   - `ID`: Identificador único del partido (Clave primaria)
   - `ID_arbitro`: Clave foránea que referencia al árbitro que dirige el partido
   - `ID_jugador1`: Clave foránea que referencia al primer jugador en el partido
   - `ID_jugador2`: Clave foránea que referencia al segundo jugador en el partido
   - `ID_torneo`: Clave foránea que referencia al torneo en el que se juega el partido
   - `instancia`: Etapa del partido (por ejemplo, final, semifinal)

6. **sets**
   - `ID`: Identificador único del set (Clave primaria)
   - `ID_partido`: Clave foránea que referencia al partido al que pertenece el set
   - `numero_set`: Número de set
   - `player1_games_won`: Número de juegos ganados por el jugador 1 en el set
   - `player2_games_won`: Número de juegos ganados por el jugador 2 en el set

## Funciones

- **obtenerGanadorPartido(ID_partido INT)**

- **actualizarRanking(ID_partido INT)**
