-- terminal에서 mardiaDB, MySQL 접속 명령어
mariadb -u root -p

-- schema 생성
CREATE DATABASE board;
-- incode set utf8mb4
ALTER DATABASE board CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
-- incode set 확인
SHOW VARIABLES LIKE 'character_set_database';
SHOW VARIABLES LIKE 'character_set_server';
-- schema 삭제
DROP DATABASE board;
-- schema 목록 조회
SHOW DATABASES;
-- schema 사용
USE board;
-- table 생성
CREATE TABLE board (
    board_no INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(100) NOT NULL,
    content TEXT NOT NULL,
    writer VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
-- table 목록 조회
SHOW TABLES;
-- table 구조 조회
DESCRIBE board;
desc board;
-- table 삭제
DROP TABLE board;