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
        INSERT INTO board.USER_POST_LIST(user_id, post_id) VALUES(userId, postId);x
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