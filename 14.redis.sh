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
# deque 또는 double-ended queue 와 유사한 구조
# 왼쪽 끝과 오른쪽 끝에 데이터를 넣을 수 있음
lpush students kim1
lpush students lee1
rpush students park1
# list 조회
lrange students 0 2 # 0부터 2번째까지 조회
lrange studnets 0 -1 # 0부터 끝까지
lrange students 0 0 # 0번째 값만 조회
# list값 꺼내기 (꺼내면서 삭제 = pop)
rpop students
# A list에서 rpop 해서, B list에 lpush 할 수 있다
rpoplpush A list B list
rpoplpush students students
# list에서 개수조회
llen students
# expire, ttl 문법 모두 사용 가능


# redis list 자료구조 실전 활용
#   사례 1. 최근 방문한 상품 목록 조회
        rpush user:1:recent:product_view apple
        rpush user:1:recent:product_view banana
        rpush user:1:recent:product_view orange
        rpush user:1:recent:product_view melon
        rpush user:1:recent:product_view mango
        # 최근 본 상품목록 3개 조회
        lrange user:1:recent:product_view -3 -1
# 1. 웹사이트 방문
# 2. 최근 살펴본 상품 리스트 등.

# set 자료구조. 중복 없음, 순서 없음
sadd memberlist m1
sadd memberlist m2
sadd memberlist m3
sadd memberlist m3
# set 조회
smembers memberlist
# set의 멤버 수 조회
scard memberlist
# redis set 자료구조 실전 활용
    # 사례 1. SNS상 like 구현
        sadd like:posting:1 abc@naver.com
        sadd like:posting:1 bcd@naver.com
        sadd like:posting:1 abc@naver.com
        scard like:posting:1
    # 사례 1. 1) 게시글 상세보기 조회 시 like 수 출력
        scard like:posting:1 # like 개수 조회
        sismember like:posting:1 abc@naver.com # 내가 like 눌렀는지 조회
        sadd liek:posting:1 abc@naver.com # like 실행
        srem like:posting:1 abc@naver.com # like 취소

# zset 자료구조 sorted set
# zset 조회: zrange(score 기준 오름차순 정렬), zrevrange(내림차순 정렬)
# zset 자료구조 실전 활용
    # 사례 1. 최근 본 상품 목록 -> value가 같은 값이 있으면, 중복이 제거되고 score 시간 값만 update 된다.
    zadd user:1:recent:product_view 151400 apple
    zadd user:1:recent:product_view 151401 banana
    zadd user:1:recent:product_view 151402 orange
    zadd user:1:recent:product_view 151403 melon
    zadd user:1:recent:product_view 151404 mango
    zadd user:1:recent:product_view 151405 melon

    zrange user:1:recent:product_view -3 -1
    zrevrange user:1:recent:product_view 0 2 withscores



# hashes 자료구조