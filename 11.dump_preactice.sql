-- 덤프 파일 생성
mysqldump -u root -p 스키마명 > 덤프파일명
mysqldump -u root -p board > board_dump.sql

-- 덤프파일 적용(복원)
-- dump 적용을 위해서 스키마는 생성되어 있어야 하고, 파일은 실행문을 실행하는 위치에 있어야함.
create database board;
mysqldump -u root -p 스키마명 < 덤프파일명
mysqldump -u root -p board < board_dump.sql

-- **주의사항**
-- 1) VS Code 에서 인코딩시 utf8 설정 해야함.
-- 2) '<'를 인식 못할 때 git bash에서 작업.

