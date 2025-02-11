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


