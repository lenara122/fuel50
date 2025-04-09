-- V1__schema.sql

CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    fname VARCHAR(100) NOT NULL
);