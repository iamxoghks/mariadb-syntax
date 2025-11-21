tinyint : 1 byte integer (-128 to 127)
smallint : 2 byte integer (-32,768 to 32,767)
mediumint : 3 byte integer (-8,388,608 to 8,388,607)
int/integer : 4 byte integer (-2,147,483,648 to 2,147,483,647) 대략 40억 범위
bigint : 8 byte integer (-9,223,372,036,854,775,808 to 9,223,372,036,854,775,807)   
float : 4 byte floating point number
double : 8 byte floating point number
decimal : fixed-point number, 정확한 소수점 계산이 필요할 때 사용 (예: 금융 계산)
char(n) : 고정 길이 문자열, n은 최대 255까지 지정 가능
varchar(n) : 가변 길이 문자열, n은 최대 65,535까지 지정 가능 (실제 저장 길이에 따라 공간 사용), 메모리 위주 저장 -> 조회성능 빠름
text : 가변 길이 문자열, 최대 65,535 바이트, storage 위주 저장. 조회성능 varchar에 비해 느림 = 자주 조회하지 않는 장문의 데이터는 text로!
=> 길이가 정해진 짧은 단어는 char 또는 varchar, 장문의 데이터는 text 또는 varchar,그 외 모두 varchar 사용 권장.

mediumtext : 가변 길이 문자열, 최대 16,777,215 바이트
longtext : 가변 길이 문자열, 최대 4,294,967,295 바이트
date : 날짜 값 (YYYY-MM-DD)
datetime : 날짜와 시간 값 (YYYY-MM-DD HH:MM:SS)
timestamp : 타임스탬프 값 (1970-01-01 00:00:01 UTC부터의 초 단위)
time : 시간 값 (HH:MM:SS)
year : 연도 값 (4자리 연도)
enum : 열거형, 미리 정의된 값들 중 하나를 선택
set : 집합형, 미리 정의된 값들 중 여러 개를 선택 가능
-- boolean 타입은 MySQL/MariaDB에서 TINYINT(1)로 구현됨. 0은 false, 1은 true로 간주됨.