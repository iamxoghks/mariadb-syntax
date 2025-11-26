-- 회원 테이블 생성 id(pk), email(unique, not null), name(not null), password(not null)
create table board.USER_LIST(user_id BIGINT primary key auto_increment, email VARCHAR(255) not null UNIQUE, name VARCHAR(255) not null, password VARCHAR(255) not null);
-- 주소 테이블 생성 id(pk), country(not null), city(not null), street(not null), user_id(fk, not null))
CREATE TABLE board.ADDR_LIST(addr_id BIGINT PRIMARY key auto_increment, country VARCHAR(255) not null, city VARCHAR(255) not null, street VARCHAR(255) not null, user_id BIGINT not null UNIQUE , foreign key(user_id) REFERENCES USER_LIST(user_id));
-- 게시글 테이블 생성 id(pk), title(not null), content
CREATE TABLE board.POST_LIST(post_id BIGINT PRIMARY KEY auto_increment, title VARCHAR(255) not null, content VARCHAR(3000));
-- 게시글과 회원 매핑 테이블 생성 id(pk), user_id(fk, not null), post_id(fk, not null)
CREATE TABLE board.USER_POST_LIST(up_list_id BIGINT PRIMARY KEY auto_increment, user_id BIGINT not null, post_id BIGINT not null, foreign key(user_id) REFERENCES board.USER_LIST(user_id), foreign key(post_id) REFERENCES board.POST_LIST(post_id));


-- 회원 생성
insert into board.USER_LIST (email, name, password) VALUES ('rlaxoghks04@gmail.com', 'xoghks', '1234');
-- 회원과 매치되는 주소 생성
insert into board.ADDR_LIST (country, city, street, user_id ) VALUES ('Korea', 'Seoul', 'yeo', 1);

DELIMITER $$

CREATE PROCEDURE add_post ()
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
-- 게시글 작성
insert into board.POST_LIST(title, content) VALUES('first post', 'hello world!');
-- 회원과 게시글 매핑
insert into board.USER_POST_LIST(user_id, post_id) VALUES (1, 1);


-- 글 전체 목록 조회하기: 제목, 내용, 글쓴이 이름이 조회가 되도록 select쿼리 생성
select upl.post_id, p.title, p.content, upl.user_id, u.name
    from board.USER_POST_LIST upl
    join board.USER_LIST u on upl.user_id = u.user_id
    join board.POST_LIST p on p.post_id = upl.post_id
order by upl.post_id;