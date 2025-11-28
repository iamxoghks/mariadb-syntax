-- view : 실제 데이터를 참조만 하는 가상의 테이블.
-- INSERT, UPDATE가 안 되고 SELECT만 가능하다.
-- 사용 목적 : 1) 권한 분리, 2) 

-- view 생성
create view user_view as select name, email from user;
create view user_view2 as select p.title, u.name, u.email from post p inner join user u on u.user_id = p.user_id;
-- user는 실제 데이터지만, 가상의 user_view 테이블에 name, email만 넣고 정의.

-- view 조회
select * from user_view;

-- view에 대한 권한 부여
grant select on board.user_view to '계정명'@'%';

-- view 삭제
drop view user_view;


-- procedure 생성 및 조회
DELIMITER $$

CREATE PROCEDURE 전체주문조회 ()
BEGIN
  -- 예외 발생 시 트랜잭션 롤백
  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    ROLLBACK;
  END;

  START TRANSACTION;

  INSERT INTO board.POST_LIST (title, content)
    VALUES ('New Post', 'this is really new post');
    
  INSERT INTO board.USER_POST_LIST (user_id, post_id)
  VALUES (2, LAST_INSERT_ID());

  COMMIT;
END $$


-- 글쓰기
delimiter //
-- 사용자가 title, content, 본인의 email 값을 입력
CREATE PROCEDURE 글쓰기2(IN userEmail VARCHAR(255), IN postTitle VARCHAR(255), IN postContent VARCHAR(255))
BEGIN
    DECLARE userId BIGINT;
    DECLARE postId BIGINT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;
        -- email로 회원 id 찾기
        SELECT user_id INTO userId FROM board.USER_LIST WHERE email = userEmail;
        -- post 테이블에 insert
        INSERT INTO board.POST_LIST(title, content) VALUES(postTitle, postContent);
        -- post 테이블에 insert 된 id값 구하기
        SET postId = LAST_INSERT_ID();
        -- user_post_list 테이블에 insert(user_id, post_id 필요)
        INSERT INTO board.USER_POST_LIST(user_id, post_id) VALUES(userId, postId);
    COMMIT;
END
delimiter //

call 글쓰기2('rlaxoghks04@gmail.com', 'typed title', 'typed content');

-- 글 삭제 if else
delimiter //
-- 사용자가 title, content, 본인의 email 값을 입력
CREATE PROCEDURE 글삭제(IN userId BIGINT, IN postId BIGINT)
BEGIN
    DECLARE postCounter BIGINT;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;
        -- 참여자 수 조회
        SELECT count(*) INTO postCounter FROM board.USER_POST_LIST WHERE board.post_id = postId;
        -- IF 시작
        IF postCounter = 1 THEN
            DELETE FROM board.USER_POST_LIST WHERE post_id = postId AND user_id = userId;
            DELETE FROM board.POST_LIST WHERE post_id = postId;
        ELSE
            DELETE FROM board.USER_POST_LIST WHERE post_id = postId AND user_id = userId;
        END IF;
        -- IF 끝
    COMMIT;
END
delimiter //



DELIMITER //

CREATE PROCEDURE 글삭제2(
    IN userId BIGINT,
    IN postId BIGINT
)
BEGIN
    DECLARE postParticipants BIGINT;

    -- 어떤 SQL 에러가 나도 롤백하고 호출자에게 에러를 그대로 전달
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    -- 0) 입력값 검증: NULL이면 즉시 에러
    IF userId IS NULL OR postId IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = '값이 비어있습니다.';
    END IF;

    START TRANSACTION;

        -- 1) 게시글 존재 여부 확인 (없으면 에러)
        IF NOT EXISTS (
            SELECT 1
              FROM board.POST_LIST
             WHERE post_id = postId
        ) THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = '해당되는 글이 없습니다.';
        END IF;

        -- 2) 사용자-게시글 매핑 삭제 시도
        --    매핑이 없으면 삭제 건수가 0 → "해당되는 글이 없습니다."로 에러
        DELETE FROM board.USER_POST_LIST
         WHERE post_id = postId
           AND user_id = userId;

        IF ROW_COUNT() = 0 THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = '해당되는 글이 없습니다.';
        END IF;

        -- 3) 남은 참여자 수를 잠금과 함께 확인
        --    (같은 post_id의 매핑 레코드들을 FOR UPDATE로 잠가 동시성 이슈 완화)
        SELECT COUNT(*)
          INTO postParticipants
          FROM board.USER_POST_LIST
         WHERE post_id = postId
         FOR UPDATE;

        -- 4) 마지막 1명이었다면 본문까지 삭제
        IF postParticipants = 0 THEN
            DELETE FROM board.POST_LIST
             WHERE post_id = postId;
        END IF;

    COMMIT;
END//

DELIMITER ;


-- 대량 글쓰기
delimiter //
-- 사용자가 title, content, 본인의 email 값을 입력
CREATE PROCEDURE 대량글쓰기1(IN loopCount BIGINT, IN userEmail VARCHAR(255))
BEGIN
    DECLARE userId BIGINT;
    DECLARE postId BIGINT;
    DECLARE countValue BIGINT DEFAULT 0;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    WHILE countValue < loopCount DO 
        START TRANSACTION;
            SELECT user_id INTO userId FROM board.USER_LIST WHERE email = userEmail;
            INSERT INTO board.POST_LIST(title, content) VALUES("안녕하세요", "푸하하");
            SET postId = LAST_INSERT_ID();
            INSERT INTO board.USER_POST_LIST(user_id, post_id) VALUES(userId, postId);
        COMMIT;
        SET countValue = countValue + 1;
    END WHILE;
END
delimiter //



-- MariaDB Engine
SHOW engines;
-- InnoDB, MyISAM 등.. 차이점. 대부분의 경우 InnoDB 씀
1. InnoDB
Supports transactions(commit, rollback)
row-level locking
foreign keys and encryption for tables
조회 성능 느림.

2. MyISAM
Non-transactional engine with good performance
small data footprint
조회 성능 빠름.