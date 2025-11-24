-- 흐름 제어 if, ifnull, case when

-- if(a, b, c) : a가 참이면 b 반환, 거짓이면 c 반환
select if, if(name is null, 'anonymous', name) from user;
select if, if(name is not null, name, 'anonymous') from user;
-- 예제
SELECT 
    employee_id,
    first_name,
    last_name,
    salary,
    -- if 문 사용 예제
    IF(salary > 5000, 'High Salary', 'Low Salary') AS salary_level,
    
    -- ifnull 문 사용 예제
    IFNULL(commission_pct, 0) AS commission_pct_non_null,
    
    -- case when 문 사용 예제
    CASE 
        WHEN salary > 7000 THEN 'Very High Salary'
        WHEN salary BETWEEN 4000 AND 7000 THEN 'Moderate Salary'
        ELSE 'Low Salary'
    END AS detailed_salary_level
FROM employees;

-- ifnull(a,b) : a가 null이면 b 반환, 아니면 a 반환
select ifnull(name, 'anonymous') from user;

-- case when end
select id,
case
    when name is null then 'anonymous'
    when name = 'hong1' then '홍길동1'
    when name = 'hong2' then '홍길동2'
    else name
end as display_name
from user;