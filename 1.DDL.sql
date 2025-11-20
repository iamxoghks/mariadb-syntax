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
-- table 삭제 (존재할 경우에만) 특정 쿼리 실행 시 에러가 나지 않도록 if exists 사용.
DROP TABLE IF EXISTS board;

-- table constraint 조회 (제약조건 조회)
SELECT * FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE WHERE TABLE_NAME = 'posts';
-- table index 조회
SHOW INDEX FROM posts;
-- table 구조 변경
ALTER TABLE board ADD COLUMN views INT DEFAULT 0;
-- table 컬럼명 변경
ALTER TABLE board CHANGE COLUMN views view_count INT;
-- table 컬럼 삭제
ALTER TABLE board DROP COLUMN view_count;
-- table 컬럼 데이터 타입 변경
ALTER TABLE board MODIFY COLUMN title VARCHAR(200) NOT NULL;
-- table 컬럼 위치 변경
ALTER TABLE board MODIFY COLUMN content TEXT NOT NULL AFTER title;
-- table 컬럼 기본값 변경
ALTER TABLE board ALTER COLUMN created_at SET DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;
-- table 컬럼 기본값 삭제
ALTER TABLE board ALTER COLUMN created_at DROP DEFAULT;
-- table 이름 변경
ALTER TABLE board RENAME TO bulletin_board;
-- table에 제약조건 추가 (예: writer 컬럼에 NOT NULL 제약조건 추가)
ALTER TABLE bulletin_board MODIFY COLUMN writer VARCHAR(50) NOT NULL;
-- table에 제약조건 삭제 (예: writer 컬럼의 NOT NULL 제약조건 삭제)
ALTER TABLE bulletin_board MODIFY COLUMN writer VARCHAR(50);
-- table에 제약조건 변경
ALTER TABLE bulletin_board MODIFY COLUMN title VARCHAR(150) NOT NULL;

-- table 변경 시 modify와 change 차이점
-- MODIFY: 컬럼의 데이터 타입, 크기, 제약조건 등을 변경할 때
-- CHANGE: 컬럼의 이름을 변경할 때 사용하며, 데이터 타입과 제약조건도 함께 변경 가능
-- 예시
ALTER TABLE bulletin_board MODIFY COLUMN writer VARCHAR(100) NOT NULL; -- MODIFY 사용
ALTER TABLE bulletin_board CHANGE COLUMN writer author VARCHAR(100) NOT NULL; -- CHANGE 사용

-- 실습 1. user table에 address 컬럼 추가, name은 not null로 변경
ALTER TABLE user ADD COLUMN address VARCHAR(255) NULL;
ALTER TABLE user MODIFY COLUMN name VARCHAR(100) NOT NULL;
-- 실습 2. post table에 title을 not null로 변경, content 컬럼은 contents로 변경
ALTER TABLE post MODIFY COLUMN title VARCHAR(255) NOT NULL;
ALTER TABLE post CHANGE COLUMN content contents TEXT;

