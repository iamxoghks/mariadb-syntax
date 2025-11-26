-- pk, fk, unique 제약조건 설정 시 자동으로 index가 생성됨
-- -> why? 조회가 빈번해서 => 원하면 얼마든지 추가 가능
-- index 조회
show index from user;
show index from post;
-- user 테이블에서 name 컬럼에 인덱스가 설정되어 있는지 확인
show index from user where column_name = 'name';
-- post 테이블에서 title 컬럼에 인덱스가 설정되어 있는지 확인
show index from post where column_name = 'title';
-- index 생성
craete index 인덱스명 on 테이블명(컬럼명);
create index idx_user_name on user(name);
-- index 생성 확인
show index from user;
-- 결과에서 나오는 cardinality 값의 종류를 이야기함

-- index 삭제
drop index 인덱스명 on 테이블명;
drop index idx_user_name on user

-- pk : 제약조건 + 인덱스 생성 -> 인덱스만 별도 삭제 가능
-- fk : 제약조건 + 인덱스 생성 -> 인덱스만 별도 삭제 불가
-- unique : 제약조건 + 인덱스 생성 -> 인덱스와 제약조건 같이 삭제
-- name : 인덱스 인위적 추가 -> 인덱스만 따로 삭제
create index idx_user_name on user(name);

-- index는 한 개의 cloumn 뿐 아니라, 여러 column을 묶어서 생성 가능
create index idx_user_name_email on user(name, email);
show index from user;
-- 복합(다중 컬럼) 인덱스 생성 : CREATE INDEX index_name ON 테이블명(컬럼1, 컬럼2);
-- 컬럼1을 기준으로 정렬하여 index로 저장하고, 컬럼1이 중복된다면 컬럼2를 기준으로 정렬하여 index로 저장
-- 이 경우 두 개의 cloumn을 and 조건으로 조회해야만 index를 사용.

-- index 성능 test
-- 기존 table 삭제(drop table post; / drop table user;) 후 간단한 table로 index 성능 테스트
create table author(id bigint auto_increment, email varchar(255), name varchar(255), primary key(id));
create table author(id bigint auto_increment, email varchar(255) unique, name varchar(255), primary key(id));
-- 아래 프로시저를 통해 수십만건의 데이터 insert후에 index생성 전후에 따라 조회성능확인
DELIMITER //
CREATE PROCEDURE insert_authors()
BEGIN
    DECLARE i INT DEFAULT 1;
    DECLARE email VARCHAR(100);
    DECLARE batch_size INT DEFAULT 10000; -- 한 번에 삽입할 행 수
    DECLARE max_iterations INT DEFAULT 100; -- 총 반복 횟수 (1000000 / batch_size)
    DECLARE iteration INT DEFAULT 1;
    WHILE iteration <= max_iterations DO
        START TRANSACTION;
        WHILE i <= iteration * batch_size DO
            SET email = CONCAT('bradkim', i, '@naver.com');
            INSERT INTO author (email) VALUES (email);
            SET i = i + 1;
        END WHILE;
        COMMIT;
        SET iteration = iteration + 1;
        DO SLEEP(0.1); -- 각 트랜잭션 후 0.1초 지연
    END WHILE;
END //
DELIMITER ;

-- 프로시저 실행
CALL board.insert_authors();
-- index 생성 전 조회 성능 확인 -> 0.6s
select * from author where email = 'bradkim1000000@naver.com';
-- index 생성 후 조회 성능 확인 -> 0.0s
select * from author where email = 'bradkim1000000@naver.com';

-- db table에서 고려할 것
-- 1:1(회원 id: 전화번호) => unique O, 1:n(회원 id : 게시글 리스트) => unique X 삼지창
-- mandatory 세로 막대기, optional 동그라미
-- 1. 회원 입장에서 게시글이 1:1 인가 1:n 인가
-- 2. 회원 입장에서 게시글이 필수, 선택인가
-- 3. 게시글 입장에서 회원이 1:1 인가 n:1 인가
-- 4. 게시글 입장에서 회원이 필수, 선택인가

-- 룰
-- 자식 table에 FK 설정
-- 누가 부모 table이고, 누가 자식 table인지 파악
-- ex) post 삭제된다고 user가 삭제되지는 않음. user가 삭제될 때 post가 삭제되거나 post의 user_id가 null이 되어야 함.
-- user(부모) 1 : n post(자식)
-- user table의 user_id(pk) <-> post table의 user_id(fk)
-- user table의 user_id(pk) <-> post table의 user_id(fk) unique
-- user(부모) 1 : 1 post(자식)
-- user table의 user_id(pk) <-> post table의 user_id(fk) unique