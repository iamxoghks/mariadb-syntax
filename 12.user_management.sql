-- 사용자 조회
select * from mysql.user;

-- 사용자 생성
create user '계정명'@'%' identified by 'test4321';

-- 권한 부여
grant select on board.user to '계정명'@'%';
grant select on board.* to '계정명'@'%';
grant select, insert on board.* to '계정명'@'%';
grant all privileges on board.* to '계정명'@'%';

-- 권한 회수
revoke select on board.user from '계정명'@'%';
revoke select, insert on board.* from '계정명'@'%';
revoke all privileges on board.* from '계정명'@'%';

-- 권한 조회
show grants for '계정명'@'%';

-- 사용자 삭제
drop user '계정명'@'%';