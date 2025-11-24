-- transaction test script
alter table add column post_count int default 0;
update user set post_count = (select count(*) from post where post.user_id = user.user_id);

-- transaction example
-- post에 글쓰기(insert) + user의 post_count 증가(update)를 하나의 transaction으로 묶기
-- start transaction은 실질적 의미는 없고 transaction의 시작을 알리는 역할
start transaction; 
update user set post_count = post_count + 1 where user_id = 'user123';
insert into post (title, contents, user_id) values ('New Post', 'This is a new post.', 'user123');
commit;
-- 위에 있는 transaction은 중간에 실패할 경우 rollback이 어렵다
-- stored procedure를 사용하여 transaction 처리하는 방법
DELIMITER $$

CREATE PROCEDURE add_post ()
BEGIN
  -- 예외 발생 시 트랜잭션 롤백
  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    ROLLBACK;
  END;

  START TRANSACTION;

  UPDATE `user`
    SET post_count = post_count + 1
  WHERE user_id = 2;

  INSERT INTO post (title, contents, user_id)
  VALUES ('New Post', 'this is really new post', 2);

  COMMIT;
END $$

DELIMITER ;