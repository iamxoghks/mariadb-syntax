-- pk, fk, unique 제약조건 설정 시 자동으로 index가 생성됨
-- -> why? 조회가 빈번해서 => 원하면 얼마든지 추가 가능
-- index 조회
show index from user;
show index from post;
-- user 테이블에서 name 컬럼에 인덱스가 설정되어 있는지 확인
show index from user where column_name = 'name';
-- post 테이블에서 title 컬럼에 인덱스가 설정되어 있는지 확인
show index from post where column_name = 'title';
-- index 생성
craete index 인덱스명 on 테이블명(컬럼명);
create index idx_user_name on user(name);
-- index 생성 확인
show index from user;
-- 결과에서 나오는 cardinality 값의 종류를 이야기함

-- index 삭제
drop index 인덱스명 on 테이블명;
drop index idx_user_name on user

-- pk : 제약조건 + 인덱스 생성 -> 인덱스만 별도 삭제 가능
-- fk : 제약조건 + 인덱스 생성 -> 인덱스만 별도 삭제 불가
-- unique : 제약조건 + 인덱스 생성 -> 인덱스와 제약조건 같이 삭제
-- name : 인덱스 인위적 추가 -> 인덱스만 따로 삭제
create index idx_user_name on user(name);

-- index는 한 개의 cloumn 뿐 아니라, 여러 column을 묶어서 생성 가능
create index idx_user_name_email on user(name, email);
show index from user;
-- 복합(다중 컬럼) 인덱스 생성 : CREATE INDEX index_name ON 테이블명(컬럼1, 컬럼2);
-- 컬럼1을 기준으로 정렬하여 index로 저장하고, 컬럼1이 중복된다면 컬럼2를 기준으로 정렬하여 index로 저장
-- 이 경우 두 개의 cloumn을 and 조건으로 조회해야만 index를 사용.