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