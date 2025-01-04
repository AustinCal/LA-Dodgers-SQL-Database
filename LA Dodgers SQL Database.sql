-- Coaches
CREATE TABLE all_coaches (
    coach_id         NUMBER(5) PRIMARY KEY,
    f_name           VARCHAR2(25),
    l_name           VARCHAR2(25),
    tenure_length    INTERVAL YEAR TO MONTH,
    c_title          VARCHAR2(50)
);
-- Season
CREATE TABLE season (
    season_id      NUMBER(3) PRIMARY KEY,
    season_year    NUMBER(4) UNIQUE NOT NULL,
    season_mvp     VARCHAR2(50)
);

-- Team Stats
CREATE TABLE team_stats (
    team_stats_id      NUMBER(4) PRIMARY KEY,
    t_total_runs       NUMBER(4),
    t_average          NUMBER(5, 3),
    t_stolen_bases     NUMBER(4),
    t_home_runs        NUMBER(4),
    t_hits             NUMBER(4),
    t_doubles          NUMBER(4),
    t_triples          NUMBER(4),
    t_win              NUMBER(4),
    t_loss             NUMBER(4),
    t_K                NUMBER(4)
);

-- Player
CREATE TABLE player (
    player_ID                  NUMBER(10) PRIMARY KEY,
    name                        VARCHAR2(50),
    primary_position            CHAR(2),
    height                      NUMBER(3), CHECK (height > 0),
    weight                      NUMBER(3) CHECK (weight > 0),
    player_contract_remaining   INTERVAL YEAR TO MONTH,      
    player_salary               NUMBER(10, 2) DEFAULT 725000 
);

-- game
CREATE TABLE game (
    game_id            NUMBER(5) PRIMARY KEY,
    g_date            DATE,
    team              VARCHAR2(30),
    game_type         CHAR(3),  --SUPERTYPE(R or PS)
    our_score         NUMBER(4),
    coach_id          NUMBER(4) REFERENCES all_coaches (coach_id),
    team_stats_id     NUMBER(4) REFERENCES team_stats (team_stats_id),
    season_id         NUMBER(4) REFERENCES season (season_id),
    CONSTRAINT unique_game_date_team UNIQUE (g_date, team)  
);

--stats(OVERLAPPING)
CREATE TABLE stats (
    stats_id NUMBER(5) PRIMARY KEY,
    game_played DATE,
	batting CHAR (1) CHECK (batting = 'Y'),
    pitching CHAR (1) CHECK (pitching = 'Y'),
    player_ID NUMBER(10),
    game_ID NUMBER(5)
);

-- Batting stats
CREATE TABLE batter_stats (
    stats_id          NUMBER(5) PRIMARY KEY,
    b_at_bats         NUMBER(5),         
    b_runs            NUMBER(5),         
    b_hits            NUMBER(5),         
    b_doubles         NUMBER(5),
    b_triples         NUMBER(5),
    b_homeruns        NUMBER(5),
    b_rbi             NUMBER(5),
    b_total_bases     NUMBER(5),
    b_walks           NUMBER(5),
    b_strikeouts      NUMBER(5),
    b_stolen_bases    NUMBER(5),
    b_average         NUMBER(5,3),      
    CONSTRAINT chk_batting_average CHECK (b_average BETWEEN 0 AND 1)
);

-- Pitching stats
CREATE TABLE pitching_stats (
    stats_id          NUMBER(5) PRIMARY KEY,
    p_games_started   NUMBER(5),           
    p_quality_starts  NUMBER(5),           
    p_wins            NUMBER(5),           
    p_loss            NUMBER(5),           
    p_saves           NUMBER(5),           
    p_hits            NUMBER(5),           
    p_earned_runs     NUMBER(5),           
    p_homeruns_given  NUMBER(5),           
    p_walks           NUMBER(5),           
    p_strikeouts      NUMBER(5),          
    CONSTRAINT chk_era_non_negative CHECK (p_earned_runs >= 0),
    CONSTRAINT chk_qs_non_negative CHECK (p_quality_starts >= 0),
    CONSTRAINT chk_so_non_negative CHECK (p_strikeouts >= 0)
);

-- Ticket Sale
CREATE TABLE ticket_sale (
    ticket_id         NUMBER(5) PRIMARY KEY,
    date_id           NUMBER(3),             
    customer_last     VARCHAR2(50),
    section_number    NUMBER(5),            
    t_row_number      CHAR(3),            
    game_ID           NUMBER(5) REFERENCES game(game_ID)
);

CREATE TABLE regular_season (
    game_ID          NUMBER(4) REFERENCES game(game_ID), 
    regular_mvp      VARCHAR2(25),                        
    CONSTRAINT regular_season_pk PRIMARY KEY (game_ID)   
);

-- Post season table
CREATE TABLE post_season (
    game_ID           NUMBER(3) REFERENCES game(game_ID), 
    post_season_rounds VARCHAR2(50),                      
    p_mvp             VARCHAR2(100),                       
    p_g_start         DATE UNIQUE,                         
    CONSTRAINT post_season_pk PRIMARY KEY (game_ID)       
);

--coaches

CREATE SEQUENCE all_coaches_seq
    START WITH 1000
    INCREMENT BY 1
    MINVALUE 1000
    NOCACHE;

INSERT INTO all_coaches (coach_id, f_name, l_name, tenure_length, c_title)
VALUES (all_coaches_seq.NEXTVAL, 'Dave', 'Roberts', INTERVAL '4' YEAR, 'Manager');

INSERT INTO all_coaches (coach_id, f_name, l_name, tenure_length, c_title) VALUES (all_coaches_seq.NEXTVAL, 'Dave', 'Roberts', INTERVAL '4' YEAR, 'Manager');					
INSERT INTO all_coaches (coach_id, f_name, l_name, tenure_length, c_title) VALUES (all_coaches_seq.NEXTVAL, 'Danny', 'Lehmann', NULL, 'Bench Coach');					
INSERT INTO all_coaches (coach_id, f_name, l_name, tenure_length, c_title) VALUES (all_coaches_seq.NEXTVAL, 'Aaron', 'Bates', NULL, 'Hitting Coach');					
INSERT INTO all_coaches (coach_id, f_name, l_name, tenure_length, c_title) VALUES (all_coaches_seq.NEXTVAL, 'Robert', 'Van Scoyoc', NULL, 'Hitting Coach');					
INSERT INTO all_coaches (coach_id, f_name, l_name, tenure_length, c_title) VALUES (all_coaches_seq.NEXTVAL, 'Mark', 'Prior', NULL, 'Pithing Coach');					
INSERT INTO all_coaches (coach_id, f_name, l_name, tenure_length, c_title) VALUES (all_coaches_seq.NEXTVAL, 'Clayton', 'McCullough', NULL, 'First Base Coach');					
INSERT INTO all_coaches (coach_id, f_name, l_name, tenure_length, c_title) VALUES (all_coaches_seq.NEXTVAL, 'Dino', 'Ebel', NULL, 'Third Base Coach');					
INSERT INTO all_coaches (coach_id, f_name, l_name, tenure_length, c_title) VALUES (all_coaches_seq.NEXTVAL, 'Josh', 'Bard', NULL, 'Bullpen Coach');					
INSERT INTO all_coaches (coach_id, f_name, l_name, tenure_length, c_title) VALUES (all_coaches_seq.NEXTVAL, 'Connor', 'McGuiness', NULL, 'Assistant Pitching Coach');					
INSERT INTO all_coaches (coach_id, f_name, l_name, tenure_length, c_title) VALUES (all_coaches_seq.NEXTVAL, 'Bob', 'Geren', NULL, 'Major League Field Coordinator');					

--Season Inserts
INSERT INTO season (season_id, season_year, season_mvp)
VALUES (101, 2024, 'Mookie Betts');

--team stats
CREATE SYNONYM ts_stats FOR team_stats;

INSERT INTO ts_stats (team_stats_id, t_total_runs, t_average, t_stolen_bases, t_home_runs, t_hits, t_doubles, t_triples, t_win, t_loss, t_K) 
VALUES (2024, 842, 0.251, 126, 233, 1390, 293, 15, 98, 64, 1390);								


-- PLAYER

-- Mookie Betts (Player 1001) - Outfielder (Hitter)
INSERT INTO player (player_ID, name, primary_position, height, weight, player_contract_remaining, player_salary)
VALUES(1001, 'Mookie Betts', 'OF', 180, 180, INTERVAL '4' YEAR + INTERVAL '8' MONTH, 30000000);

-- Freddie Freeman (Player 1002) - First Baseman (Hitter)
INSERT INTO player (player_ID, name, primary_position, height, weight, player_contract_remaining, player_salary)
VALUES (1002, 'Freddie Freeman', '1B', 188, 220, INTERVAL '5' YEAR + INTERVAL '2' MONTH, 27000000);

-- Clayton Kershaw (Player 1003) - Starting Pitcher (SP)
INSERT INTO player (player_ID, name, primary_position, height, weight, player_contract_remaining, player_salary)
VALUES (1003, 'Clayton Kershaw', 'SP', 191, 210, INTERVAL '1' YEAR + INTERVAL '4' MONTH, 25000000);

-- Julio Urías (Player 1004) - Starting Pitcher (SP)
INSERT INTO player (player_ID, name, primary_position, height, weight, player_contract_remaining, player_salary)
VALUES (1004, 'Julio Urías', 'SP', 183, 225, INTERVAL '2' YEAR + INTERVAL '8' MONTH, 10000000);

-- Max Muncy (Player 1005) - Second Baseman (2B)
INSERT INTO player (player_ID, name, primary_position, height, weight, player_contract_remaining, player_salary)
VALUES (1005, 'Max Muncy', '2B', 191, 215, INTERVAL '2' YEAR + INTERVAL '1' MONTH, 14000000);

-- Will Smith (Player 1006) - Catcher (C)
INSERT INTO player (player_ID, name, primary_position, height, weight, player_contract_remaining, player_salary)
VALUES (1006, 'Will Smith', 'C', 185, 210, INTERVAL '4' YEAR + INTERVAL '10' MONTH, 4000000);

-- Chris Taylor (Player 1007) - Outfielder (OF)
INSERT INTO player (player_ID, name, primary_position, height, weight, player_contract_remaining, player_salary)
VALUES (1007, 'Chris Taylor', 'OF', 185, 210, INTERVAL '3' YEAR + INTERVAL '3' MONTH, 12000000);

-- Austin Barnes (Player 1010) - Catcher (C)
INSERT INTO player (player_ID, name, primary_position, height, weight, player_contract_remaining, player_salary)
VALUES (1010, 'Austin Barnes', 'C', 180, 210, INTERVAL '1' YEAR + INTERVAL '9' MONTH, 1000000);

-- Trayce Thompson (Player 1011) - Outfielder (OF)
INSERT INTO player (player_ID, name, primary_position, height, weight, player_contract_remaining, player_salary)
VALUES (1011, 'Trayce Thompson', 'OF', 193, 210, INTERVAL '1' YEAR + INTERVAL '5' MONTH, 1800000);

-- J.D. Martinez (Player 1009) - Designated Hitter (DH)
INSERT INTO player (player_ID, name, primary_position, height, weight, player_contract_remaining, player_salary)
VALUES (1009, 'J.D. Martinez', 'DH', 188, 220, INTERVAL '2' YEAR + INTERVAL '7' MONTH, 20000000);

-- James Outman (Player 1012) - Outfielder (OF)
INSERT INTO player (player_ID, name, primary_position, height, weight, player_contract_remaining, player_salary)
VALUES (1012, 'James Outman', 'OF', 188, 200, INTERVAL '5' YEAR + INTERVAL '6' MONTH, 700000);

-- Evan Phillips (Player 1015) - Relief Pitcher (RP)
INSERT INTO player (player_ID, name, primary_position, height, weight, player_contract_remaining, player_salary)
VALUES (1015, 'Evan Phillips', 'RP', 180, 205, INTERVAL '4' YEAR + INTERVAL '4' MONTH, 1000000);

-- Alex Vesia (Player 1013) - Relief Pitcher (RP)
INSERT INTO player (player_ID, name, primary_position, height, weight, player_contract_remaining, player_salary)
VALUES (1013, 'Alex Vesia', 'RP', 180, 195, INTERVAL '2' YEAR + INTERVAL '11' MONTH, 700000);

-- Blake Treinen (Player 1014) - Relief Pitcher (RP)
INSERT INTO player (player_ID, name, primary_position, height, weight, player_contract_remaining, player_salary)
VALUES (1014, 'Blake Treinen', 'RP', 191, 230, INTERVAL '1' YEAR + INTERVAL '8' MONTH, 8000000);

-- Dustin May (Player 1021) - Starting Pitcher (SP)
INSERT INTO player (player_ID, name, primary_position, height, weight, player_contract_remaining, player_salary)
VALUES (1021, 'Dustin May', 'SP', 196, 220, INTERVAL '4' YEAR + INTERVAL '2' MONTH, 900000);

-- Shohei Ohtani (Player 1025) - Designated Hitter (DH)
INSERT INTO player (player_ID, name, primary_position, height, weight, player_contract_remaining, player_salary)
VALUES (1025, 'Shohei Ohtani', 'DH', 193, 210, INTERVAL '10' YEAR, 2000000);



--Game
-- Insert for Game 1 (2024-07-01)
INSERT INTO game (game_id, g_date, team, game_type, our_score, coach_id, team_stats_id, season_id)
VALUES (2001, TO_DATE('2024-07-01', 'YYYY-MM-DD'), 'Los Angeles Dodgers', 'R', 7, 1001, 2024, 101);

-- Insert for Game 2 (2024-07-02)
INSERT INTO game (game_id, g_date, team, game_type, our_score, coach_id, team_stats_id, season_id)
VALUES (2002, TO_DATE('2024-07-02', 'YYYY-MM-DD'), 'Los Angeles Dodgers', 'R', 6, 1001, 2024, 101);

-- Insert for Game 3 (2024-07-03)
INSERT INTO game (game_id, g_date, team, game_type, our_score, coach_id, team_stats_id, season_id)
VALUES (2003, TO_DATE('2024-07-03', 'YYYY-MM-DD'), 'Los Angeles Dodgers', 'R', 8, 1001, 2024, 101);

-- Insert for Game 4 (2024-07-04)
INSERT INTO game (game_id, g_date, team, game_type, our_score, coach_id, team_stats_id, season_id)
VALUES (2004, TO_DATE('2024-07-04', 'YYYY-MM-DD'), 'Los Angeles Dodgers', 'R', 5, 1001, 2024, 101);

-- Insert for Game 5 (2024-07-05)
INSERT INTO game (game_id, g_date, team, game_type, our_score, coach_id, team_stats_id, season_id)
VALUES (2005, TO_DATE('2024-07-05', 'YYYY-MM-DD'), 'Los Angeles Dodgers', 'R', 9, 1001, 2024, 101);

--World Series
-- Insert for World Series Game 1 (2024-10-25)
INSERT INTO game (game_id, g_date, team, game_type, our_score, coach_id, team_stats_id, season_id)
VALUES (1, TO_DATE('2024-10-25', 'YYYY-MM-DD'), 'Los Angeles Dodgers', 'PS', 7, 1001, 2024, 101);

-- Insert for World Series Game 2 (2024-10-26)
INSERT INTO game (game_id, g_date, team, game_type, our_score, coach_id, team_stats_id, season_id)
VALUES (2, TO_DATE('2024-10-26', 'YYYY-MM-DD'), 'Los Angeles Dodgers', 'PS', 6, 1001, 2024, 101);

-- Insert for World Series Game 3 (2024-10-28)
INSERT INTO game (game_id, g_date, team, game_type, our_score, coach_id, team_stats_id, season_id)
VALUES (3, TO_DATE('2024-10-28', 'YYYY-MM-DD'), 'Los Angeles Dodgers', 'PS', 8, 1001, 2024, 101);

-- Insert for World Series Game 4 (2024-10-29)
INSERT INTO game (game_id, g_date, team, game_type, our_score, coach_id, team_stats_id, season_id)
VALUES (4, TO_DATE('2024-10-29', 'YYYY-MM-DD'), 'Los Angeles Dodgers', 'PS', 5, 1001, 2024, 101);

-- Insert for World Series Game 5 (2024-10-31)
INSERT INTO game (game_id, g_date, team, game_type, our_score, coach_id, team_stats_id, season_id)
VALUES (5, TO_DATE('2024-10-31', 'YYYY-MM-DD'), 'Los Angeles Dodgers', 'PS', 4, 1001, 2024, 101);


-- Stats
-- Game 1 (2024-10-25)
INSERT INTO stats (stats_id, game_played, batting, pitching, player_ID, game_ID)
VALUES (1, TO_DATE('2024-10-25', 'YYYY-MM-DD'), 'Y', NULL, 1001, 2001);
INSERT INTO stats (stats_id, game_played, batting, pitching, player_ID, game_ID)
VALUES (2, TO_DATE('2024-10-25', 'YYYY-MM-DD'), 'Y', NULL, 1002, 2001);
INSERT INTO stats (stats_id, game_played, batting, pitching, player_ID, game_ID)
VALUES (3, TO_DATE('2024-10-25', 'YYYY-MM-DD'), NULL, 'Y', 1003, 2001);
INSERT INTO stats (stats_id, game_played, batting, pitching, player_ID, game_ID)
VALUES (4, TO_DATE('2024-10-25', 'YYYY-MM-DD'), NULL, 'Y', 1004, 2001);
INSERT INTO stats (stats_id, game_played, batting, pitching, player_ID, game_ID)
VALUES (5, TO_DATE('2024-10-25', 'YYYY-MM-DD'), 'Y', NULL, 1005, 2001);
INSERT INTO stats (stats_id, game_played, batting, pitching, player_ID, game_ID)
VALUES (6, TO_DATE('2024-10-25', 'YYYY-MM-DD'), 'Y', NULL, 1006, 2001);
INSERT INTO stats (stats_id, game_played, batting, pitching, player_ID, game_ID)
VALUES (7, TO_DATE('2024-10-25', 'YYYY-MM-DD'), 'Y', NULL, 1007, 2001);
INSERT INTO stats (stats_id, game_played, batting, pitching, player_ID, game_ID)
VALUES (8, TO_DATE('2024-10-25', 'YYYY-MM-DD'), 'Y', NULL, 1010, 2001);
INSERT INTO stats (stats_id, game_played, batting, pitching, player_ID, game_ID)
VALUES (9, TO_DATE('2024-10-25', 'YYYY-MM-DD'), 'Y', NULL, 1011, 2001);
INSERT INTO stats (stats_id, game_played, batting, pitching, player_ID, game_ID)
VALUES (10, TO_DATE('2024-10-25', 'YYYY-MM-DD'), 'Y', NULL, 1009, 2001);

-- Game 2 (2024-10-26)
INSERT INTO stats (stats_id, game_played, batting, pitching, player_ID, game_ID)
VALUES (11, TO_DATE('2024-10-26', 'YYYY-MM-DD'), 'Y', NULL, 1001, 20002);
INSERT INTO stats (stats_id, game_played, batting, pitching, player_ID, game_ID)
VALUES (12, TO_DATE('2024-10-26', 'YYYY-MM-DD'), 'Y', NULL, 1002, 20002);
INSERT INTO stats (stats_id, game_played, batting, pitching, player_ID, game_ID)
VALUES (13, TO_DATE('2024-10-26', 'YYYY-MM-DD'), NULL, 'Y', 1003, 20002);
INSERT INTO stats (stats_id, game_played, batting, pitching, player_ID, game_ID)
VALUES (14, TO_DATE('2024-10-26', 'YYYY-MM-DD'), NULL, 'Y', 1004, 20002);
INSERT INTO stats (stats_id, game_played, batting, pitching, player_ID, game_ID)
VALUES (15, TO_DATE('2024-10-26', 'YYYY-MM-DD'), 'Y', NULL, 1005, 20002);
INSERT INTO stats (stats_id, game_played, batting, pitching, player_ID, game_ID)
VALUES (16, TO_DATE('2024-10-26', 'YYYY-MM-DD'), 'Y', NULL, 1006, 20002);
INSERT INTO stats (stats_id, game_played, batting, pitching, player_ID, game_ID)
VALUES (17, TO_DATE('2024-10-26', 'YYYY-MM-DD'), 'Y', NULL, 1007, 20002);
INSERT INTO stats (stats_id, game_played, batting, pitching, player_ID, game_ID)
VALUES (18, TO_DATE('2024-10-26', 'YYYY-MM-DD'), 'Y', NULL, 1010, 20002);
INSERT INTO stats (stats_id, game_played, batting, pitching, player_ID, game_ID)
VALUES (19, TO_DATE('2024-10-26', 'YYYY-MM-DD'), 'Y', NULL, 1011, 20002);
INSERT INTO stats (stats_id, game_played, batting, pitching, player_ID, game_ID)
VALUES (20, TO_DATE('2024-10-26', 'YYYY-MM-DD'), 'Y', NULL, 1009, 20002);


--batter Stat
-- Mookie Betts (Player 1001) - Outfielder (Hitter)
INSERT INTO batter_stats (stats_id, b_at_bats, b_runs, b_hits, b_doubles, b_triples, b_homeruns, b_rbi, b_total_bases, b_walks, b_strikeouts, b_stolen_bases, b_average)
VALUES (1001, 450, 100, 160, 30, 5, 40, 100, 300, 80, 120, 25, 0.355);

-- Freddie Freeman (Player 1002) - First Baseman (Hitter)
INSERT INTO batter_stats (stats_id, b_at_bats, b_runs, b_hits, b_doubles, b_triples, b_homeruns, b_rbi, b_total_bases, b_walks, b_strikeouts, b_stolen_bases, b_average)
VALUES (1002, 520, 110, 180, 40, 3, 30, 115, 320, 90, 100, 10, 0.346);

-- Max Muncy (Player 1005) - Second Baseman (Hitter)
INSERT INTO batter_stats (stats_id, b_at_bats, b_runs, b_hits, b_doubles, b_triples, b_homeruns, b_rbi, b_total_bases, b_walks, b_strikeouts, b_stolen_bases, b_average)
VALUES (1005, 450, 85, 130, 30, 2, 25, 90, 230, 75, 110, 15, 0.289);

-- Will Smith (Player 1006) - Catcher (Hitter)
INSERT INTO batter_stats (stats_id, b_at_bats, b_runs, b_hits, b_doubles, b_triples, b_homeruns, b_rbi, b_total_bases, b_walks, b_strikeouts, b_stolen_bases, b_average)
VALUES (1006, 380, 60, 110, 20, 3, 15, 60, 170, 50, 90, 5, 0.289);

-- Chris Taylor (Player 1007) - Outfielder (Hitter)
INSERT INTO batter_stats (stats_id, b_at_bats, b_runs, b_hits, b_doubles, b_triples, b_homeruns, b_rbi, b_total_bases, b_walks, b_strikeouts, b_stolen_bases, b_average)
VALUES (1007, 420, 70, 100, 25, 4, 15, 50, 180, 60, 120, 20, 0.238);

-- J.D. Martinez (Player 1009) - Designated Hitter (DH)
INSERT INTO batter_stats (stats_id, b_at_bats, b_runs, b_hits, b_doubles, b_triples, b_homeruns, b_rbi, b_total_bases, b_walks, b_strikeouts, b_stolen_bases, b_average)
VALUES (1009, 480, 95, 140, 25, 2, 35, 105, 280, 75, 110, 5, 0.292);

-- Trayce Thompson (Player 1011) - Outfielder (Hitter)
INSERT INTO batter_stats (stats_id, b_at_bats, b_runs, b_hits, b_doubles, b_triples, b_homeruns, b_rbi, b_total_bases, b_walks, b_strikeouts, b_stolen_bases, b_average)
VALUES (1011, 250, 30, 60, 10, 1, 5, 25, 90, 20, 80, 10, 0.240);

-- James Outman (Player 1012) - Outfielder (Hitter)
INSERT INTO batter_stats (stats_id, b_at_bats, b_runs, b_hits, b_doubles, b_triples, b_homeruns, b_rbi, b_total_bases, b_walks, b_strikeouts, b_stolen_bases, b_average)
VALUES (1012, 200, 25, 50, 10, 2, 8, 30, 90, 15, 50, 10, 0.250);

INSERT INTO batter_stats (stats_id, b_at_bats, b_runs, b_hits, b_doubles, b_triples, b_homeruns, b_rbi, b_total_bases, b_walks, b_strikeouts, b_stolen_bases, b_average)
VALUES (1025, 636, 134, 197, 38, 7, 54, 130, 390, 81, 162, 4, 0.310);


--pitcher stat
-- Clayton Kershaw (Player 1003) - Starting Pitcher (SP)
INSERT INTO pitching_stats (stats_id, p_games_started, p_quality_starts, p_wins, p_loss, p_saves, p_hits, p_earned_runs, p_homeruns_given, p_walks, p_strikeouts)
VALUES (1003, 28, 20, 14, 6, 0, 170, 55, 20, 40, 220);

-- Julio Urías (Player 1004) - Starting Pitcher (SP)
INSERT INTO pitching_stats (stats_id, p_games_started, p_quality_starts, p_wins, p_loss, p_saves, p_hits, p_earned_runs, p_homeruns_given, p_walks, p_strikeouts)
VALUES (1004, 30, 22, 16, 7, 0, 180, 60, 18, 45, 215);

-- Evan Phillips (Player 1015) - Relief Pitcher (RP)
INSERT INTO pitching_stats (stats_id, p_games_started, p_quality_starts, p_wins, p_loss, p_saves, p_hits, p_earned_runs, p_homeruns_given, p_walks, p_strikeouts)
VALUES (1015, 0, 0, 3, 2, 15, 50, 20, 5, 20, 90);

-- Alex Vesia (Player 1013) - Relief Pitcher (RP)
INSERT INTO pitching_stats (stats_id, p_games_started, p_quality_starts, p_wins, p_loss, p_saves, p_hits, p_earned_runs, p_homeruns_given, p_walks, p_strikeouts)
VALUES (1013, 0, 0, 2, 1, 10, 40, 15, 4, 15, 80);

-- Blake Treinen (Player 1014) - Relief Pitcher (RP)
INSERT INTO pitching_stats (stats_id, p_games_started, p_quality_starts, p_wins, p_loss, p_saves, p_hits, p_earned_runs, p_homeruns_given, p_walks, p_strikeouts)
VALUES (1014, 0, 0, 1, 3, 8, 45, 25, 7, 18, 65);

-- Dustin May (Player 1021) - Starting Pitcher (SP)
INSERT INTO pitching_stats (stats_id, p_games_started, p_quality_starts, p_wins, p_loss, p_saves, p_hits, p_earned_runs, p_homeruns_given, p_walks, p_strikeouts)
VALUES (1021, 25, 18, 10, 8, 0, 155, 60, 15, 50, 180);

-- Shohei Ohtani (Player 1025) - Starting Pitcher (SP)
INSERT INTO pitching_stats (stats_id, p_games_started, p_quality_starts, p_wins, p_loss, p_saves, p_hits, p_earned_runs, p_homeruns_given, p_walks, p_strikeouts)
VALUES (1025, 28, 16, 15, 9, 0, 159, 70, 20, 44, 219);




--ticket Sale
CREATE SEQUENCE ticket_id_seq
    START WITH 5000
    INCREMENT BY 1
    MINVALUE 5000
    NOCACHE;

INSERT INTO ticket_sale (ticket_id, date_id, customer_last, section_number, t_row_number, game_ID) 
VALUES (ticket_id_seq.NEXTVAL, 500, 'John', '202', 'A10', 2001);										
INSERT INTO ticket_sale (ticket_id, date_id, customer_last, section_number, t_row_number, game_ID) 
VALUES (ticket_id_seq.NEXTVAL, 508, 'Jung', '208', 'P12', 2001);										
INSERT INTO ticket_sale (ticket_id, date_id, customer_last, section_number, t_row_number, game_ID) 
VALUES (ticket_id_seq.NEXTVAL, 504, 'Smith', '245', 'A10', 2002);										
INSERT INTO ticket_sale (ticket_id, date_id, customer_last, section_number, t_row_number, game_ID) 
VALUES (ticket_id_seq.NEXTVAL, 509, 'Ivanov', '206', 'K10', 2002);										
INSERT INTO ticket_sale (ticket_id, date_id, customer_last, section_number, t_row_number, game_ID) 
VALUES (ticket_id_seq.NEXTVAL, 506, 'Dubois', '268', 'K09', 2004);										
INSERT INTO ticket_sale (ticket_id, date_id, customer_last, section_number, t_row_number, game_ID) 
VALUES (ticket_id_seq.NEXTVAL, 585, 'Paterson', '217', 'P10', 2003);										
INSERT INTO ticket_sale (ticket_id, date_id, customer_last, section_number, t_row_number, game_ID) 
VALUES (ticket_id_seq.NEXTVAL, 569, 'Jensen', '298', 'Z12', 2002);										
INSERT INTO ticket_sale (ticket_id, date_id, customer_last, section_number, t_row_number, game_ID) 
VALUES (ticket_id_seq.NEXTVAL, 504, 'Wang', '265', 'M12', 2004);										
INSERT INTO ticket_sale (ticket_id, date_id, customer_last, section_number, t_row_number, game_ID) 
VALUES (ticket_id_seq.NEXTVAL, 543, 'Nguyen', '222', 'J85', 2003);										
INSERT INTO ticket_sale (ticket_id, date_id, customer_last, section_number, t_row_number, game_ID) 
VALUES (ticket_id_seq.NEXTVAL, 579, 'Diouf', '274', 'K12', 2002);										
INSERT INTO ticket_sale (ticket_id, date_id, customer_last, section_number, t_row_number, game_ID) 
VALUES (ticket_id_seq.NEXTVAL, 564, 'Nkosi', '296', 'K23', 2005);										
INSERT INTO ticket_sale (ticket_id, date_id, customer_last, section_number, t_row_number, game_ID) 
VALUES (ticket_id_seq.NEXTVAL, 525, 'Sato', '214', 'Y15', 2001);										
INSERT INTO ticket_sale (ticket_id, date_id, customer_last, section_number, t_row_number, game_ID) 
VALUES (ticket_id_seq.NEXTVAL, 526, 'Takahashi', '246', 'X12', 2003);										
INSERT INTO ticket_sale (ticket_id, date_id, customer_last, section_number, t_row_number, game_ID) 
VALUES (ticket_id_seq.NEXTVAL, 576, 'Lee', '203', 'C46', 2003);										

--reg season inserts
INSERT INTO regular_season (game_ID, regular_mvp) 
VALUES (2001, 'Mookie Betts');

INSERT INTO regular_season (game_ID, regular_mvp) 
VALUES (2002, NULL);

INSERT INTO regular_season (game_ID, regular_mvp) 
VALUES (2003, 'Freddie Freeman');

INSERT INTO regular_season (game_ID, regular_mvp) 
VALUES (2004, NULL);

INSERT INTO regular_season (game_ID, regular_mvp) 
VALUES (2005, 'Mookie Betts');

--post season inserts
INSERT INTO post_season (game_ID, post_season_rounds, p_mvp, p_g_start)
VALUES (1, 'World Series', 'Mookie Betts', TO_DATE('2024-10-28', 'YYYY-MM-DD'));

INSERT INTO post_season (game_ID, post_season_rounds, p_mvp, p_g_start)
VALUES (2, 'World Series', NULL, TO_DATE('2024-10-29', 'YYYY-MM-DD'));

INSERT INTO post_season (game_ID, post_season_rounds, p_mvp, p_g_start)
VALUES (3, 'World Series', 'Freddie Freeman', TO_DATE('2024-10-30', 'YYYY-MM-DD'));

INSERT INTO post_season (game_ID, post_season_rounds, p_mvp, p_g_start)
VALUES (4, 'World Series', NULL, TO_DATE('2024-10-31', 'YYYY-MM-DD'));

INSERT INTO post_season (game_ID, post_season_rounds, p_mvp, p_g_start)
VALUES (5, 'World Series', 'Mookie Betts', TO_DATE('2024-11-01', 'YYYY-MM-DD'));



--View Batter with AVG is more than .300
CREATE VIEW accurate_batter AS
SELECT * FROM batter_stats
WHERE b_average > 0.300;

SELECT * FROM accurate_batter;
SELECT * FROM player;
SELECT * FROM game;
SELECT * FROM stats;
SELECT * FROM batter_stats;
SELECT * FROM pitching_stats;
SELECT * FROM ticket_sale;
SELECT * FROM regular_season;
SELECT * FROM post_season;

