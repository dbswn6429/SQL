--그룹함수 --행에대한 기초통계값
--sum ,avg,max,min,count - 전부 null이 아닌 데이터에 대해서 통계를 구합니다
select sum(salary),avg(salary),max(salary),min(salary),count(salary) from employees;
--min,max 날짜, 문자열에도 적용이 됩니다
select min(hire_date), max(hire_date),min(first_name),max(first_name) from employees;
--count함수는 2가지 사용방법이 있음
select count(commission_pct) from employees; -- 35, null이 아닌 데이터에 대해서 집계
select count(*) from employees; -- 107,전체행수(null포함)
--주의할점:그룹함수는 일반컬럼과 동시에 사용이 불가능
select first_name, avg(salary) from employees; --x
--그룹함수 뒤에 OVER()를 붙이면 전체행이 출력이되고, 그룹함수 사용이 가능함
SELECT FIRST_NAME, AVG(SALARY) OVER(), COUNT(*) OVER() FROM EMPLOYEES;

------------------------------------------------------------------------
--GROUP BY절 - 컬럼기준으로 그룹핑
SELECT DEPARTMENT_ID FROM EMPLOYEES GROUP BY DEPARTMENT_ID;

SELECT DEPARTMENT_ID ,SUM(SALARY),AVG(SALARY),MIN(SALARY),MAX(SALARY),COUNT(*)
FROM EMPLOYEES GROUP BY DEPARTMENT_ID;
--주의할점 - GROUP BY에 지정되지 않은 컬럼은 SELECT절에 사용할 수 없음.
SELECT DEPARTMENT_ID,
       FIRST_NAME -- X
FROM EMPLOYEES
GROUP BY DEPARTMENT_ID;
--2개 이상의 그룹화
select department_id, job_id, avg(salary)  --그룹함수 같이 사용 가능
from employees
group by department_id, job_id
order by department_id;
--
select department_id , job_id, count(*), count(*) over() as 전체행수
from employees
group by department_id, job_id
order by department_id;
--where절에 그룹의 조건을 넣는것이 아닙니다
select department_id, sum(salary)
from employees
where sum(salary) >= 50000 -- group by 조건을 쓰는 곳은 having이라고 있음!
group by department_id;
--------------------------------------------
--having - 그룹 by의 조건
--where -일반행 조건
select department_id, avg(salary), count(*)
from employees
group by department_id
having avg(salary) >= 5000 and count(*) >=1;
--각 직무별 연봉들의 급여 평균이 10000이 넘는 직무?
select job_id, avg(salary)
from employees
where job_id like 'SA%'
group by job_id
having avg(salary) >= 10000
order by avg(salary) desc;
-----------------------------------------------------------------
--시험대비
--ROLLUP - GROUP BY와 함께 사용되고, 상위그룹의 소계를 구합니다
select department_id , avg(salary)
from employees 
group by rollup(department_id);
--
select department_id, job_id, avg(salary)
from employees
group by rollup(department_id, job_id)
order by department_id, job_id;
-- CUBE - 롤업에 의해서 구해진 값 + 서브그룹의 통계가 추가됨
select department_id, job_id, avg(salary)
from employees
group by cube(department_id, job_id)
order by department_id, job_id;

--GROUPING() - 그룹절로 만들어진 경우에는 0을 반환, 롤업 or 큐브로 만들어진 행인 경우에는 1을 반환
select department_id,
job_id,
avg(salary),
grouping(department_id),
grouping(job_id)
from employees
group by rollup(department_id, job_id)
order by department_id;
--
