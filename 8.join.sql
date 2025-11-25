-- case 1 : user inner join post
-- post 작성한 기록이 있는 user와 해당 사용자가 작성한 post 조회
select * from user inner join post on user.user_id = post.user_id;
select * from user u inner join post p on u.user_id = p.user_id;
select * from user as u inner join post as p on u.user_id = p.user_id;
select u.*, p.* from user as u inner join post as p on u.user_id = p.user_id;

-- case 2 : post inner join user
-- 작성자가 있는 post와 해당 post의 작성자 조회
select * from post inner join user on post.user_id = user.user_id;
select * from post p inner join user u on p.user_id = u.user_id;
select * from post as p inner join user as u on p.user_id = u.user_id
select p.*, u.* from post as p inner join user as u on p.user_id = u.user_id;
-- 작성자가 있는 post 전체 정보와 작성자의 이메일 출력
select p.*, u.email from post as p inner join user as u on p.user_id = u.user_id;

-- case 3 : user left join post
-- 모든 사용자를 조회하고, 만약 작성한 post가 있다면 함께 조회
select * from user left join post on user.user_id = post.user_id;
select * from user u left join post p on u.user_id = p.user_id;
select * from user as u left join post as p on u.user_id = p.user_id;
select u.*, p.* from user as u left join post as p on u.user_id = p.user_id;

-- case 4 : post left join user
-- 모든 post를 조회하고, 만약 작성자가 있다면 함께 조회
select * from post left join user on post.user_id = user.user_id;
select * from post p left join user u on p.user_id = u.user_id;
select * from post as p left join user as u on p.user_id = u.user_id
select p.*, u.* from post as p left join user as u on p.user_id = u.user_id;

-- 작성자가 있는 post 중 제목과 작성자를 출력하되, 작성자의 나의가 30세 이상인 post만 출력
select p.title, u.email, u.age from post as p join user as u on p.user_id = u.user_id where age >= 30;

-- post 작성자의 이름이 null이 아닌 post만 조회
select p.* from post as p join user as u on p.user_id = u.user_id where p.user_id is not null;

-- 조건에 맞는 도서와 저자 리스트 출력
-- 없어진 기록 찾기
SELECT o.animal_id, o.name from ANIMAL_OUTS as o left join ANIMAL_INS as i on o.animal_id = i.animal_id where i.datetime is null order by o.animal_id asc;
select animal_id, name from ANIMAL_OUTS where animal_id not in(select animal_id from ANIMAL_INS);