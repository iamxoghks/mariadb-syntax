

alter table post add constraint post_pk primary key (id);
-- fk 제약조건 추가
alter table post add constraint post_fk foreign key (user_id) references "user"(id);

-- on delete/on update 제약조건 변경 테스트
alter table post add constraint post_fk foreign key (user_id) references "user"(id) on delete cascade on update cascade;

-- default 옵션
-- 어떤 컬럼이든 default 지정이 가능하지만, 일반적으로 enum type 또는 timestamp type에 주로 사용됨.
alter table user modify column name varchar(20) default 'anonymous';

-- auto_increment 옵션
-- primary key로 지정된 컬럼에 주로 사용됨.
alter table user modify column user_id int auto_increment;

-- uuid 
-- uuid는 128비트 숫자를 나타내며, 일반적으로 16진수 문자열로 표현됨.
-- uuid는 전역적으로 고유한 식별자를 생성하는 데 사용되며, 분산 시스템에서 충돌 없이 식별자를 생성하는 데 유용함.
-- MySQL/MariaDB에서 uuid를 사용하려면 char(36) 또는 binary(16) 타입을 사용함.
-- uuid 생성 함수: UUID() - 하이픈 포함, UUID_SHORT() - 하이픈 미포함
alter table user add column uuid char(36) default (UUID());