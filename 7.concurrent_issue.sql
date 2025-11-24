-- read uncommitted : commit 되지 않은 데이터도 읽을 수 있음 (dirty read 발생 가능) 
-- 실습
-- 1. auto commit 비활성화
-- 2. update 문 실행 (commit 하지 않음)
-- 3. 다른 세션에서 해당 데이터 조회 (commit 되지 않은 데이터 조회 가능
-- 결론 : maridb는 기본 isolation level이 repeatable read이므로 read uncommitted 설정해도 dirty read가 발생하지 않음.

-- read committed : committed 된 데이터만 read 가능 (phantom read, non-repeatable read 발생 가능)
-- 실습
-- 1. db에서 코드 실행
start transaction;
    select count(*) from user;
    do sleep(15);
    select count(*) from user;
commit;
-- 2. terminal에서 코드 실행
insert into user(email) values('a23@gmail.com');

-- repeatable read : read의 일관성 보장 -> loat update 문제 발생- > beta lock으로 해결
-- lost update : 두 개의 트랜잭션이 동시에 같은 데이터를 읽고 수정할 때, 먼저 커밋된 트랜잭션의 변경 사항이 나중에 커밋된 트랜잭션에 의해 덮어써지는 현상
-- 실습. lost update 문제 발생 예시
-- > select 문에서 for update 옵션 사용
-- 1. db에서 코드 실행
DELIMITER //
create procedure concurrent_test1()
begin
    declare count int;
    start transaction;
    insert into post(title, user_id) values('hello world', 1);
    select post_count into count from user where user_id=1 for update;
    do sleep(15);
    update user set post_count=count+1 where user_id=1;
    commit;
end //
DELIMITER ;
call concurrent_test1();
-- terminal에서 실행
select post_count from user where user_id=1 for update;

-- serializable : 모든 트랜잭션이 순차적으로 실행되는 것처럼 동작, 동시성 성능 저하
-- 가장 엄격한 isolation level