--단일행 서브쿼리 -select 한 결과가 1행인 서브쿼리
--서브쿼리는 ()로 묶는다. 연산자보다는 오른쪽에 나온다

select salary from employees where first_name = 'Nancy';

select *
from employees where salary >= (select salary from employees where first_name = 'Nancy');

--직원번호가 103번인 사람과 동일한 직무를 가진 사람
select job_id from employees where employee_id = 103;
select * 
from employees where job_id = (select job_id from employees where employee_id = 103);
--주의할점 - 단일행 서브쿼리는 반드시 하나의 행을 리턴을 해야합니다
--서브쿼리가 반환하는 행이 여러행이라면, 다중행 연산자를 쓰면 됩니다.
select *
from employees 
where salary >= (select salary from employees where first_name = 'David');

-->ANY는 최소값 보다 큰 데이터 (4800,6800,9500)
select * from employees
where salary > ANY(select salary from employees where first_name = 'David');
--< ANY는 최대값 9500보다 작은 데이터
select * from employees
where salary < ANY(select salary from employees where first_name = 'David');
--> ALL는 최대값 9500보다 큰 데이터
select * from employees
where salary > ALL(select salary from employees where first_name = 'David');
--< ALL는 최대값 9500보다 작은 데이터
select * from employees
where salary < ALL(select salary from employees where first_name = 'David');
--IN은 정확히 일치하는 데이터가 나옴
select * from employees
where salary in (select salary from employees where first_name = 'David');

----------------------------------------------------------------------------------
--문제 1.
--EMPLOYEES 테이블에서 모든 사원들의 평균급여보다 높은 사원들을 데이터를 출력 하세요 ( AVG(컬럼) 사용)
select * from employees
where salary >(select avg(salary) from employees);
--EMPLOYEES 테이블에서 모든 사원들의 평균급여보다 높은 사원들을 수를 출력하세요
select count(*) from employees
where salary >(select avg(salary) from employees);
--EMPLOYEES 테이블에서 job_id가 IT_PFOG인 사원들의 평균급여보다 높은 사원들을 데이터를 출력하세요.
select * from employees
where salary > (select avg(salary) from employees where job_id = 'IT_PROG' );
--문제 2.
--DEPARTMENTS테이블에서 manager_id가 100인 사람의 department_id(부서아이디) 와
--EMPLOYEES테이블에서 department_id(부서아이디) 가 일치하는 모든 사원의 정보를 검색하세요.
select * from departments;
select * from employees 
where department_id =(select department_id from departments  where manager_id = 100);
--문제3
--EMPLOYEES테이블에서 “Pat”의 manager_id보다 높은 manager_id를 갖는 모든 사원의 데이터를 출력하세요
select * from employees  where manager_id >(select manager_id from employees where first_name = 'Pat');
--EMPLOYEES테이블에서 “James”(2명)들의 manager_id와 같은 모든 사원의 데이터를 출력하세요.
select * from employees where manager_id in (select manager_id from employees where first_name = 'James');
--Steven과 동일한 부서에 있는 사람들을 출력해주세요.
select * from employees where department_id in (select department_id from employees where first_name ='Steven');
--Steven의 급여보다 많은 급여를 받는 사람들은 출력하세요.
select * from employees where salary > ANY (select salary from employees where first_name ='Steven');
select * from employees;

-------------------------------------------------------------------------------------------------
--스칼라 서브쿼리-SELECT절에 들어오는 서브쿼리, 조인을 대체할 수 있음
select first_name,
    (select department_name from departments d where d.department_id = e.department_id)
from employees e;
--스칼라 쿼리는 한번에 하나의 컬럼을 가지고 옵니다. 많은 열을 가지고 올때는 가독성이 떨어질 수 있습니다.
select first_name,
(select department_name from departments d where d.department_id = e.department_id),
(select manager_id from departments d where d.department_id = e.department_id)
from employees e;

--스칼라 쿼리는 다른 테이블의 1개의 컬럼만 가지고 올때 조인보다 유리할 수 있음.
--회원별 jobs테이블의 title을 가지고 오고, 부서테일블의 부서명을 조회
select first_name,
(select department_name from departments d where d.department_id = e.department_id),
(select job_title from jobs j where j.job_id = e.job_id)
from employees e;
--join구문으로
select first_name,department_name
from employees e
left join departments d
on e.department_id = d.department_id;


------------------------------------------
--연습문제
--문제 4.
--EMPLOYEES테이블 DEPARTMENTS테이블을 left 조인하세요
--조건) 직원아이디, 이름(성, 이름), 부서아이디, 부서명 만 출력합니다.
--조건) 직원아이디 기준 오름차순 정렬
select e.employee_id, concat(e.first_name,e.last_name),d.department_id,d.department_name
from employees e 
left join departments d on e.department_id = d.department_id order by e.employee_id; 
--문제 5.
--문제 4의 결과를 (스칼라 쿼리)로 동일하게 조회하세요
select e.employee_id, concat(e.first_name,e.last_name), e.department_id,
       (select department_name from departments d where d.department_id = e.department_id)
from employees e order by e.employee_id;


--문제 6.
--DEPARTMENTS테이블 LOCATIONS테이블을 left 조인하세요
--조건) 부서아이디, 부서이름, 스트릿_어드레스, 시티 만 출력합니다
--조건) 부서아이디 기준 오름차순 정렬
select * from locations;
select d.department_id, d.department_name, l.street_address, l.city from departments d
left join locations l on d.location_id = l.location_id order by d.department_id;
--문제 7.
--문제 6의 결과를 (스칼라 쿼리)로 동일하게 조회하세요
select d.department_id, d.department_name,
       (select street_address from locations l where l.location_id = d.location_id) ,
       (select city from locations l where l.location_id = d.location_id)
from departments d
order by d.department_id;

--문제 8.
--LOCATIONS테이블 COUNTRIES테이블을 스칼라 쿼리로 조회하세요.
--조건) 로케이션아이디, 주소, 시티, country_id, country_name 만 출력합니다
--조건) country_name기준 오름차순 정렬
select * from countries;
select location_id, street_address, city, country_id,
(select country_name from countries c where c.country_id = l.country_id) as country_name
from locations l order by country_name;

-------------------------------------------------------------------------------------------
--인라인 뷰 -FROM절 하위에 서브쿼리가 들어값니다.
--SELECT절에서 만든 가상 컬럼에 대해서 조회를 해 나갈때 사용합니다.
SELECT *
FROM (SELECT *
      FROM (SELECT *
            FROM EMPLOYEES)
);

--ROWNUM은 조회된 순서에 대해서 번호가 붙기때문에 ORDER BY를 시키면 순서가 뒤바뀝니다.
SELECT ROWNUM EMPLOYEE_ID,
       FIRST_NAME,
       SALARY
FROM EMPLOYEES
ORDER BY SALARY DESC;
--인라인 뷰
SELECT EMPLOYEE_ID,
       FIRST_NAME,
       SALARY
FROM(SELECT *
     FROM EMPLOYEES
     ORDER BY SALARY DESC
     )
WHERE ROWNUM >10 AND ROWNUM <=20 ; --10~20번째 데이터가 나와야하는데, ROWNUM은 1부터만 조회가 가능합니다.

--인라인뷰로 FROM절에 필요한 컬럼을 가상의 컬럼으로 만들어 놓고, 조회
SELECT *
FROM(
     SELECT ROWNUM AS RN,
     --FIRST_NAME || LAST_NAME AS NAME,
     --SALARY
      A.*
FROM (
       SELECT *
       FROM EMPLOYEES
       ORDER BY SALARY DESC
       ) A
) 
WHERE RN> 10 AND RN<=20;

--인라인뷰 EX
--근속년수 컬럼, COMMISSION이 더해진 급여 컬럼을 가상으로 만들고 조회~
SELECT FIRST_NAME || ' ' || LAST_NAME AS 이름,
       TRUNC((SYSDATE - HIRE_DATE)/365) AS 근속년수,
       SALARY + SALARY* NVL(COMMISSION_PCT, 0) AS 급여
FROM EMPLOYEES
ORDER BY 근속년수;

-------------------------------------------------------------------------------
--문제 9.
--EMPLOYEES테이블 에서 first_name기준으로 내림차순 정렬하고, 41~50번째 데이터의 행 번호, 이름을 출력하세요
SELECT * 
FROM(SELECT ROWNUM AS RN ,
     CONCAT(FIRST_NAME,LAST_NAME)AS 이름
FROM (
      SELECT * FROM EMPLOYEES
      ORDER BY FIRST_NAME DESC)
)
WHERE RN>40 AND RN<50;
--문제 10.
--EMPLOYEES테이블에서 hire_date기준으로 오름차순 정렬하고, 31~40번째 데이터의 행 번호, 사원id, 이름, 번호, 
--입사일을 출력하세요.
SELECT * FROM EMPLOYEES;
SELECT * 
FROM (SELECT ROWNUM AS RN,
      EMPLOYEE_ID,
      CONCAT(FIRST_NAME,LAST_NAME) AS 이름,
      PHONE_NUMBER,
      HIRE_DATE
      FROM (SELECT * FROM EMPLOYEES
            ORDER BY HIRE_DATE DESC)
)
WHERE RN>30 AND RN<=40;
--문제 11.
--COMMITSSION을 적용한 급여를 새로운 컬럼으로 만들고, 이 데이터에서 10000보다 큰 사람들을 뽑아 보세요. (인라인뷰를 쓰면 됩니다)
SELECT * 
FROM (
    SELECT employee_id, first_name, last_name, salary, commission_pct,
           salary + (salary * commission_pct) AS total_salary
    FROM employees
) A
WHERE total_salary > 10000;
--문제 12.
--조인의 최적화
--SELECT CONCAT(FIRST_NAME, LAST_NAME) AS NAME,
--       D.DEPARTMENT_ID
--FROM EMPLOYEES E
--JOIN DEPARTMENTS D
--ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
--WHERE EMPLOYEE_ID = 200;
--
--이론적으로 위 구문의 실행방식은 EMPLOYEES - DEPARTMENTS 테이블을 먼저 조인하고, 후에 WHERE조건을 실행하게 됩니다.
--항상 이런것은 아닙니다. (이것은 데이터베이스 검색엔진(옵티마이저)에 의해 바뀔 수도 있습니다)
--그렇다면 SUBQUERY절로 WHERE구문을 작성하고, JOIN을 붙이는 것도 가능하지 않을까요?
--
--=> 부서아이디가 200인 데이터를 인라인뷰로 조회한 후에 JOIN을 붙여보세요.
SELECT CONCAT(E.FIRST_NAME,E.LAST_NAME) AS 이름,
              D.DEPARTMENT_ID
FROM(
      SELECT *
      FROM EMPLOYEES
      WHERE EMPLOYEE_ID = 200
)E
JOIN DEPARTMENTS D
ON E.DEPARTMENT_ID = E.DEPARTMENT_ID;

--------------------------------------------------------------------
--문제13
--EMPLOYEES테이블, DEPARTMENTS 테이블을 left조인하여, 입사일 오름차순 기준으로 10-20번째 데이터만 출력합니다.
--조건) rownum을 적용하여 번호, 직원아이디, 이름, 입사일, 부서이름 을 출력합니다.
--조건) hire_date를 기준으로 오름차순 정렬 되어야 합니다. rownum이 망가지면 안되요.
select *
from (
    select rownum rn,
       employee_id,
       first_name || last_name as name,
       hire_date,
       department_name
    from(
        select * 
        from employees e 
        left join departments d
        on e.department_id = d.department_id
        order by hire_date
 )
)
where rn >=10 and rn <=20;

--문제14
--SA_MAN 사원의 급여 내림차순 기준으로 ROWNUM을 붙여주세요.
--조건) SA_MAN 사원들의 ROWNUM, 이름, 급여, 부서아이디, 부서명을 출력하세요.
SELECT ROWNUM AS RN, 
        FIRST_NAME || ' ' || LAST_NAME AS 이름,
        SALARY,
        DEPARTMENT_ID,
        (SELECT DEPARTMENT_NAME FROM DEPARTMENTS D WHERE A.DEPARTMENT_ID = D.DEPARTMENT_ID)AS 부서명
    FROM (
        SELECT *
            FROM EMPLOYEES 
            WHERE JOB_ID = 'SA_MAN'
            ORDER BY SALARY DESC
           
        )A
;


--문제15
--DEPARTMENTS테이블에서 각 부서의 부서명, 매니저아이디, 부서에 속한 인원수 를 출력하세요.
--조건) 인원수 기준 내림차순 정렬하세요.
--조건) 사람이 없는 부서는 출력하지 뽑지 않습니다.
--힌트) 부서의 인원수 먼저 구한다. 이 테이블을 조인한다.
select * 
from departments d
left join (
    select department_id ,
           count(*) as 인원수
    from employees
    group by department_id
) A
on d.department_id = a.department_id;
--문제16
--부서에 모든 컬럼, 주소, 우편번호, 부서별 평균 연봉을 구해서 출력하세요.
--조건) 부서별 평균이 없으면 0으로 출력하세요
SELECT * FROM EMPLOYES;
select * from locations;
select * from departments;

--SELECT 
--    D.*, 
--    (SELECT AVG(SALARY) FROM EMPLOYEES E WHERE E.DEPARTMENT_ID = D.DEPARTMENT_ID GROUP BY DEPARTMENT_ID) AS 평균연봉
--FROM departments D;

SELECT D.*,
    평균연봉,
    L.STREET_ADDRESS,
    L.POSTAL_CODE
    FROM DEPARTMENTS D
LEFT JOIN(
    SELECT DEPARTMENT_ID,
            AVG(SALARY) AS 평균연봉
    FROM EMPLOYEES
    GROUP BY DEPARTMENT_ID
)A
ON D.DEPARTMENT_ID = A.DEPARTMENT_ID
LEFT JOIN LOCATIONS L
ON D.LOCATION_ID = L.LOCATION_ID;




