--문제 7.
--EMPLOYEES 테이블과 DEPARTMENTS 테이블의 부서번호를 조인하고 SA_MAN 사원만의 사원번호, 이름, 
--급여, 부서명, 근무지를 출력하세요. (Alias를 사용)
select * from departments;
select * from employees;
select e.employee_id as 사원번호
,concat(e.first_name,e.last_name)as 이름
,e.salary as 급여
,d.department_name, d.location_id 
from employees e join departments d 
on e.department_id = d.department_id
where e.job_id = 'SA_MAN';
--문제 8.
--employees, jobs 테이블을 조인 지정하고 job_title이 'Stock Manager', 'Stock Clerk'인 직원 정보만
--출력하세요.
select * from jobs;
select * from employees e join jobs j on e.job_id = j.job_id
where j.job_title in('Stock Manager','Stock Clerk');
--문제 9.
--departments 테이블에서 직원이 없는 부서를 찾아 출력하세요. LEFT OUTER JOIN 사용
select d.department_id as 부서번호, d.department_name as 부서명
from departments d left outer join employees e 
on d.department_id = e.department_id
where e.employee_id IS NULL;

--문제 10.
--join을 이용해서 사원의 이름과 그 사원의 매니저 이름을 출력하세요
--힌트) EMPLOYEES 테이블과 EMPLOYEES 테이블을 조인하세요.
select e1.first_name as 사원,
e2.first_name as 상급자
from employees e1
left join employees e2
on e1.manager_id = e2.manager_id;