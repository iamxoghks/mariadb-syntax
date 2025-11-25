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

-- union : 두 개 이상의 select 문의 결과를 합치는 것. 중복된 행은 하나로 합쳐짐
-- union 시 column 개수와 데이터 타입이 동일해야 함.
select name, email from user union select title, contents from post;
-- 동일한 내용은 아니지만 각 column의 데이터 타입이 동일하기 때문에 union 가능.
-- union all : union과 동일하지만 중복된 행도 모두 포함
select name, email from user union all select title, contents from post;
-- union vs union all 예제
--- user 테이블과 post 테이블에서 각각 name/title 컬럼을 조회하여 union과 union all의 차이 확인
-- union 예제
select name from user
union
select title from post;
-- union all 예제
select name from user
union all
select title from post;
-- union 활용 예제

-- subquery를 사용하여 user 테이블에서 name 컬럼을 조회하고,
-- 해당 name이 post 테이블의 title 컬럼에 존재하는지 확인하여 일치하는 name/title을 출력
select name from user
where name in (select title from post); 
-- 한 번이라도 post 작성한 user의 목록 조회(중복 제거)
select distinct u.name from user as u join post as p on u.user_id = p.user_id;
-- null은 자동으로 in에서 제외됨.
select distinct name from user where user_id in (select user_id from post);
-- 한 번이라도 post 작성한 user의 목록 조회(중복 포함)
select name from user where user_id in (select user_id from post);
-- from 절의 서브쿼리 예제
select a.* from (select * from user) as a;
-- column 위치에 서브쿼리 예제
select user_id, email, (select count(*) from post as p where u.user_id = p.user_id) as post_count from user as u order by u.user_id asc;
select u.user_id, u.email, count(p.post_id) as post_count from user as u left join post as p on u.user_id = p.user_id group by u.user_id order by u.user_id asc;

-- group by ~column~ : 특정 column을 기준으로 그룹화하여 하나의 row로 묶음
select user_id from post group by user_id;
select user_id, count(*) as post_count from post group by user_id;

-- 사용자별로 post 작성 개수 출력(left join) email, post_count
select u.email, count(p.post_id) as post_count from user as u left join post as p on u.user_id = p.user_id GROUP by u.email;

-- 집계 함수: sum, avg, min, max, count
select count(*) from user;
select sum(age) from user;
select avg(age) from user;
-- 소수점 3번째 자리에서 반올림하여 2번째 자리까지 출력
select round(avg(age), 2) from user;

-- group by와 집계 함수 활용 예제
-- 사용자 이름별 숫자를 출력하고 이름별 나이의 평균값을 출력.
select name, count(*) as name_count, round(ifnull(avg(age),0),2) as avg_age from user group by name;
-- group by + where 
-- 날짜값이 null인 데이터는 제외하고 날짜별 post 글의 개수 출력
select
    DATE_FORMAT(created_time, '%Y-%m-%d') as date,
    count(*) as post_count 
from post 
where created_time is not null
group by DATE_FORMAT(created_time, '%Y-%m-%d')
order by date asc;

-- 자동차 종류 별 특정 옵션이 포함된 자동차 수 구하기
-- 코드를 입력하세요
SELECT car_type, count(car_id) as CARS from CAR_RENTAL_COMPANY_CAR where options like '%시트%'group by car_type order by car_type asc;
-- 입양 시각 구하기(1)
-- 코드를 입력하세요
SELECT DATE_FORMAT(DATETIME, "%H") as hour, count(*) as count from ANIMAL_OUTS where DATE_FORMAT(DATETIME, "%H") >= 9 and DATE_FORMAT(DATETIME, "%H") <= 19 group by hour order by hour ;
SELECT HOUR(DATETIME) AS hour, COUNT(*) AS count FROM ANIMAL_OUTS WHERE HOUR(DATETIME) BETWEEN 9 AND 19 GROUP BY hour ORDER BY hour;

-- having ~condition~ : group by로 묶인 그룹에(결과)에 대해 조건을 지정할 때 사용
-- where 는 전체 데이터에 대한 조건이고 having은 그룹화된 결과(집계 함수)에 대한 조건임.
-- 3번 이상 post에 작성한 사용자 id 찾기
select user_id, count(*) as post_count from post group by user_id having post_count >= 3;

-- 동명 동물 수 찾기 -> having
-- 코드를 입력하세요
SELECT name, count(*) as count from ANIMAL_INS where name is not null group by name having count >= 2 order by name asc;
-- 카테고리 별 도서 판매량 집계하기
-- 코드를 입력하세요
SELECT b.category, sum(bs.sales) as total_sales from BOOK_SALES as bs join BOOK as b where b.book_id = bs.book_id and bs.sales_date like '2022-01%' group by b.category order by b.category asc;
-- 조건에 맞는 사용자와 총 거래금액 조회하기
-- 코드를 입력하세요
SELECT u.user_id, u.nickname, sum(b.price) as total_sales from used_goods_user as u join used_goods_board as b where u.user_id = b.writer_id and status = 'DONE' group by u.user_id having total_sales >= 700000 order by total_sales

