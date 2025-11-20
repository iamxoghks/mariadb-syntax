-- insert : table에 새로운 행(레코드)를 추가하는 명령어
INSERT INTO 테이블명(컬럼1, 컬럼2, ...) VALUES (값1, 값2, ...);
INSERT INTO user(user_id, name, email) VALUES ('user123', 'John Doe', 'john.doe@example.com');
-- update : table의 기존 행(레코드)을 수정하는 명령어
UPDATE 테이블명 SET 컬럼1 = 값1, 컬럼2 = 값2, ... WHERE 조건;
UPDATE user SET email = 'new.email@example.com' WHERE user_id = 'user123';
-- delete : table에서 행(레코드)을 삭제하는 명령어
DELETE FROM 테이블명 WHERE 조건;
DELETE FROM user WHERE user_id = 'user123';

-- select : table에서 데이터를 조회하는 명령어
SELECT 컬럼1, 컬럼2, ... FROM 테이블명 WHERE 조건;
SELECT * FROM user WHERE name = 'John Doe';
-- select all columns
SELECT * FROM user;
-- select with conditions
SELECT * FROM post WHERE created_at >= '2024-01-01';
-- select with ordering
SELECT * FROM post ORDER BY created_at DESC;
-- select with limit
SELECT * FROM post LIMIT 10;

-- select with join
SELECT u.name, p.title FROM user u JOIN post p ON u.user_id = p.user_id;
-- select useing in
select * from post where user_id in (select user_id from user where name='user1');

-- DELETE와 TRUNCATE의 차이점
-- DELETE: 특정 조건에 맞는 행(레코드)을 삭제하며, WHERE 절을 사용할 수 있음. 삭제된 행 수에 따라 성능이 다를 수 있음.
-- DELETE는 개별 행을 하나씩 삭제하는 반면, TRUNCATE는 테이블을 초기화하는 방식으로 작동함.
-- DELETE는 storage engine의 트랜잭션 로그를 기록하므로, 대량의 데이터를 삭제할 때는 성능이 저하될 수 있음.
-- 결과적으로 DELETE는 삭제 후 복구가 가능하다.
-- DELETE -> 느리다, 복구가 가능하다. truncate -> 빠르다, 복구 불가능.
DELETE FROM post WHERE user_id = 'user123';
-- TRUNCATE: 테이블의 모든 행(레코드)을 삭제하며, WHERE 절을 사용할 수 없음. 일반적으로 DELETE보다 빠름.
TRUNCATE TABLE post;

-- distinct 사용법
SELECT DISTINCT 컬럼명 FROM 테이블명;
SELECT DISTINCT writer FROM board;
-- count 사용법
SELECT COUNT(*) FROM board;
SELECT COUNT(DISTINCT writer) FROM board;
-- group by 사용법
SELECT writer, COUNT(*) AS post_count FROM board GROUP BY writer;
-- having 사용법
SELECT writer, COUNT(*) AS post_count FROM board GROUP BY writer HAVING post_count > 5;
-- between 사용법
SELECT * FROM board WHERE created_at BETWEEN '2024-01-01' AND '2024-12-31';
-- like 사용법
SELECT * FROM board WHERE title LIKE '%announcement%';
-- null 값 조회
SELECT * FROM board WHERE content IS NULL;
SELECT * FROM board WHERE content IS NOT NULL;
-- and, or 사용법
SELECT * FROM board WHERE writer = 'John Doe' AND created_at >= '2024-01-01';
SELECT * FROM board WHERE writer = 'John Doe' OR writer = 'Jane Smith';
-- order by 사용법
-- desc: 내림차순, asc: 오름차순. 아무것도 붙이지 않는다면 기본값은 오름차순(asc)
SELECT * FROM board ORDER BY created_at DESC;
SELECT * FROM board ORDER BY title ASC;
-- limit 사용법
SELECT * FROM board LIMIT 10;
-- offset 사용법
SELECT * FROM board LIMIT 10 OFFSET 20;
-- join 사용법
-- inner join
SELECT u.name, p.title FROM user u INNER JOIN post p ON u.user_id = p.user_id;
-- left join
SELECT u.name, p.title FROM user u LEFT JOIN post p ON u.user_id = p.user_id;
-- right join
SELECT u.name, p.title FROM user u RIGHT JOIN post p ON u.user_id = p.user_id;
-- full outer join (MariaDB에서는 지원하지 않음, 대신 union 사용)
SELECT u.name, p.title FROM user u LEFT JOIN post p ON u.user_id = p.user_id
UNION
SELECT u.name, p.title FROM user u RIGHT JOIN post p ON u.user_id = p.user_id;
-- self join
SELECT a.name AS author, b.title AS post_title
FROM user a
JOIN post b ON a.user_id = b.user_id
WHERE a.user_id = 'user123';