CREATE TABLE matches (
    match_id BIGINT,
    map_name TEXT,
    map_id INTEGER,
    map_index INTEGER,
    hltv_demo_id BIGINT,
    match_url TEXT,
    event TEXT,
    team1 TEXT,
    team2 TEXT,
    score1 INTEGER,
    score2 INTEGER,
    winner TEXT,
    winner_side TEXT,
    format TEXT,
    stars INTEGER,
    match_date TIMESTAMPTZ,
    rounds_played INTEGER,
    created_at TIMESTAMPTZ,

    PRIMARY KEY (match_id, map_id)
);


CREATE TABLE rounds (
    match_id BIGINT,
    map_name TEXT,
    map_id INTEGER,
    round INTEGER,

    round_start_tick BIGINT,
    freeze_end_tick BIGINT,
    round_end_tick BIGINT,
    official_end_tick BIGINT,
    round_duration_ticks BIGINT,
    round_duration_s DOUBLE PRECISION,

    winner_side TEXT,
    winner_side_id INTEGER,
    reason TEXT,
    reason_id INTEGER,

    bomb_plant_tick BIGINT,
    bomb_plant_seconds DOUBLE PRECISION,
    bomb_site TEXT,
    bomb_site_id INTEGER,
    has_bomb_plant BOOLEAN,

    n_kills INTEGER,
    n_headshots INTEGER,
    n_awp_kills INTEGER,
    n_smoke_kills INTEGER,
    n_blind_kills INTEGER,
    n_noscope_kills INTEGER,
    n_wallbang_kills INTEGER,
    n_trade_kills_5s INTEGER,
    n_1v1_kills INTEGER,

    ct_kills INTEGER,
    t_kills INTEGER,
    ct_headshots INTEGER,
    t_headshots INTEGER,
    ct_survivors INTEGER,
    t_survivors INTEGER,

    opening_kill_tick BIGINT,
    opening_kill_seconds DOUBLE PRECISION,
    opening_kill_side TEXT,
    opening_kill_side_id INTEGER,
    opening_death_side TEXT,
    opening_death_side_id INTEGER,
    opening_weapon TEXT,
    opening_weapon_id INTEGER,

    had_clutch_context BOOLEAN,
    had_1v1 BOOLEAN,

    PRIMARY KEY (match_id, map_id, round),

    FOREIGN KEY (match_id, map_id)
        REFERENCES matches(match_id, map_id)
);


CREATE TABLE kills (
    kill_id TEXT PRIMARY KEY,
    match_id BIGINT,
    map_name TEXT,
    map_id INTEGER,
    round INTEGER,
    kill_ordinal INTEGER,
    tick BIGINT,
    event_seconds DOUBLE PRECISION,

    attacker_side TEXT,
    attacker_side_id INTEGER,
    attacker_player_slot INTEGER,

    victim_side TEXT,
    victim_side_id INTEGER,
    victim_player_slot INTEGER,

    assister_player_slot INTEGER,

    weapon TEXT,
    weapon_id INTEGER,
    weapon_class TEXT,
    weapon_class_id INTEGER,

    headshot BOOLEAN,
    distance DOUBLE PRECISION,
    dmg_health INTEGER,
    hitgroup TEXT,
    hitgroup_id INTEGER,

    noscope BOOLEAN,
    through_smoke BOOLEAN,
    penetrated INTEGER,
    wallbang BOOLEAN,
    attacker_blind BOOLEAN,

    attacker_kills_before INTEGER,
    attacker_kills_after INTEGER,

    ct_alive_before INTEGER,
    t_alive_before INTEGER,
    ct_alive_after INTEGER,
    t_alive_after INTEGER,

    attacker_alive_before INTEGER,
    opponent_alive_before INTEGER,
    attacker_alive_after INTEGER,
    opponent_alive_after INTEGER,

    time_since_previous_kill_s DOUBLE PRECISION,
    time_to_next_kill_s DOUBLE PRECISION,

    is_opening_kill BOOLEAN,
    is_trade_within_5s BOOLEAN,
    is_1v1_before BOOLEAN,
    is_clutch_context BOOLEAN,

    FOREIGN KEY (match_id, map_id, round)
        REFERENCES rounds(match_id, map_id, round)
);



CREATE TABLE round_player (
    match_id BIGINT,
    map_name TEXT,
    map_id INTEGER,
    round INTEGER,
    player_slot INTEGER,

    start_side TEXT,
    start_side_id INTEGER,

    kills INTEGER,
    deaths INTEGER,
    assists INTEGER,
    headshots INTEGER,
    kast BOOLEAN,

    PRIMARY KEY (match_id, map_id, round, player_slot),

    FOREIGN KEY (match_id, map_id, round)
        REFERENCES rounds(match_id, map_id, round)
);
