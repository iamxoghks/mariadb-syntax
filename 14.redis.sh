# windosw에서는 redis 직접설치 불가능. docker -> redis 설치
docker run --name my-redis-container -d -p 6379:6379

# redis 접속 명령어
redis-cli

# dorcker에 설치된 redis 접속 명령어
docker exec -it 컨테이너id redis-cli

# redis는 0~15번까지 db로 구성되어 있다(default 0번)
# db 번호 선택
select db번호

# redis 내 모든 key 조회
keys *

# String 자료 구조
# set key:value 형식으로 값 세팅
set user:email:1 hong@naver.com
set user:email:2 hong2@naver.com
# 이미 존재하는 key를 set하면 덮어쓰기가 됨
set user:email:1 hong2@naver.com
# key 값이 이미 존재하면 pass 시키고 없을 때만 set 하기 위해서는 nx 옵션 사용
set user:email:1 hong3@naver.com nx
# 만료시간(=유효 시간, ttl -> time to live) 설정 가능 ex
set user:email:1 hong@naver.dom ex
# get key를 통해 value 확인 가능
get user:email:1
# 특정 키값 삭제하기
del 키값
# 현재 DB내 모든 key값 삭제
flushsb

# redis String 자료구조 실전 활용
# 동시성 이슈 해결
#   사례 1. 좋아요 기능 구현 ! redis는 기본적으로 모든 key:value가 문자열이다. 그래서 0으로 세팅해도 내부적으로 "0"으로 받아들임.
        set likes:posting:1 0
        incr likes:posting:1 # 특정 키값의 value 1씩 증가
        decr likes:posting:1 # 특정 키값의 value 1씩 감소
#   사례 2. 재고처리
        set stock:product:1 0
        incr stock:product:1 # 특정 키값의 value 1씩 증가
        decr stock:product:1 # 특정 키값의 value 1씩 감소
# 빠른 성능
#   사례 3 . log in 때 token 저장 목적으로 활용 가능
        set user:1:refresh_token abcdexxxxxx ex 1800
#   사례 4. 캐싱처리(json -> value) 임시로 저장. json에서 string은 \" 로 감싼다.
        set member:info:1 "{\"name\":\"hong\", \"email\":\"hong@daum.net\", \"age\":30}" ex 1000

# list 자료구조

# set 자료구조

# zset 자료구조

# hashes 자료구조