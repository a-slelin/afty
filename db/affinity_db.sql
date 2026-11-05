-- Affinity — структура БД PostgreSQL

CREATE SCHEMA IF NOT EXISTS auth;
CREATE SCHEMA IF NOT EXISTS profile;
CREATE SCHEMA IF NOT EXISTS matching;
CREATE SCHEMA IF NOT EXISTS chat;


-- auth

CREATE TABLE auth.users (
    id             uuid         PRIMARY KEY,
    email          varchar(320) NOT NULL UNIQUE,
    password_hash  varchar(255) NOT NULL,
    role           varchar(16)  NOT NULL DEFAULT 'user',
    is_active      boolean      NOT NULL DEFAULT true,
    consent_at     timestamptz  NOT NULL,
    created_at     timestamptz  NOT NULL DEFAULT now()
);

CREATE TABLE auth.refresh_tokens (
    id          uuid        PRIMARY KEY,
    user_id     uuid        NOT NULL REFERENCES auth.users (id) ON DELETE CASCADE,
    token_hash  varchar(64) NOT NULL,
    expires_at  timestamptz NOT NULL,
    revoked     boolean     NOT NULL DEFAULT false
);


-- profile

CREATE TABLE profile.profiles (
    id            uuid          PRIMARY KEY,
    user_id       uuid          NOT NULL UNIQUE,
    display_name  varchar(50)   NOT NULL,
    birth_date    date          NOT NULL,
    gender        varchar(16)   NOT NULL,
    city          varchar(100)  NOT NULL,
    bio           text          NOT NULL DEFAULT '',
    looking_for   varchar(32)[] NOT NULL DEFAULT '{}',
    is_hidden     boolean       NOT NULL DEFAULT false,
    is_banned     boolean       NOT NULL DEFAULT false,
    created_at    timestamptz   NOT NULL DEFAULT now()
);

CREATE TABLE profile.interests (
    id    serial      PRIMARY KEY,
    name  varchar(30) NOT NULL UNIQUE
);

CREATE TABLE profile.profile_interests (
    profile_id   uuid    NOT NULL REFERENCES profile.profiles  (id) ON DELETE CASCADE,
    interest_id  integer NOT NULL REFERENCES profile.interests (id) ON DELETE CASCADE,
    PRIMARY KEY (profile_id, interest_id)
);

CREATE TABLE profile.photos (
    id          uuid         PRIMARY KEY,
    profile_id  uuid         NOT NULL REFERENCES profile.profiles (id) ON DELETE CASCADE,
    url         varchar(255) NOT NULL,
    position    smallint     NOT NULL
);

CREATE TABLE profile.preferences (
    profile_id  uuid         PRIMARY KEY REFERENCES profile.profiles (id) ON DELETE CASCADE,
    min_age     smallint     NOT NULL,
    max_age     smallint     NOT NULL,
    gender      varchar(16)  NOT NULL,
    city        varchar(100)
);

CREATE TABLE profile.compatibility_answers (
    profile_id   uuid     NOT NULL REFERENCES profile.profiles (id) ON DELETE CASCADE,
    question_id  smallint NOT NULL,
    answer       smallint NOT NULL,
    PRIMARY KEY (profile_id, question_id)
);


-- matching

CREATE TABLE matching.likes (
    id          uuid        PRIMARY KEY,
    from_user   uuid        NOT NULL,
    to_user     uuid        NOT NULL,
    is_super    boolean     NOT NULL DEFAULT false,
    message     text,
    created_at  timestamptz NOT NULL DEFAULT now(),
    UNIQUE (from_user, to_user)
);

CREATE TABLE matching.skips (
    from_user   uuid        NOT NULL,
    to_user     uuid        NOT NULL,
    created_at  timestamptz NOT NULL DEFAULT now(),
    PRIMARY KEY (from_user, to_user)
);

CREATE TABLE matching.blocks (
    blocker_id  uuid        NOT NULL,
    blocked_id  uuid        NOT NULL,
    created_at  timestamptz NOT NULL DEFAULT now(),
    PRIMARY KEY (blocker_id, blocked_id)
);

CREATE TABLE matching.matches (
    id             uuid        PRIMARY KEY,
    user_a         uuid        NOT NULL,
    user_b         uuid        NOT NULL,
    compatibility  smallint,
    created_at     timestamptz NOT NULL DEFAULT now(),
    UNIQUE (user_a, user_b)
);


-- chat

CREATE TABLE chat.chats (
    id               uuid        PRIMARY KEY,
    match_id         uuid        NOT NULL UNIQUE,
    status           varchar(16) NOT NULL DEFAULT 'active',
    last_message_at  timestamptz,
    created_at       timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE chat.messages (
    id         uuid        PRIMARY KEY,
    chat_id    uuid        NOT NULL REFERENCES chat.chats (id) ON DELETE CASCADE,
    sender_id  uuid        NOT NULL,
    text       text        NOT NULL,
    sent_at    timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE chat.reports (
    id           uuid        PRIMARY KEY,
    reporter_id  uuid        NOT NULL,
    target_id    uuid        NOT NULL,
    reason       text        NOT NULL,
    status       varchar(16) NOT NULL DEFAULT 'open',
    created_at   timestamptz NOT NULL DEFAULT now()
);
