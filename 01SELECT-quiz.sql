--모든 사원의 사원번호, 이름, 입사일, 급여를 출력하세요
select employee_id, first_name , hire_date, salary from employees;
--모든 사원의 이름과 성을 붙여 출력하세요. 열 별칭은 name으로 하세요.
select concat(first_name, last_name)as name from employees;
--50번 부서 사원의 모든 정보를 출력하세요.
select * from employees where department_id='50';
--50번 부서 사원의 이름, 부서번호, 직무아이디를 출력하세요.
select first_name, last_name ,department_id , job_id from employees where department_id ='50';
--모든 사원의 이름, 급여 그리고 300달러 인상된 급여를 출력하세요.
select first_name, salary, salary+300 as "인상된 급여" from employees; 
--급여가 10000보다 큰 사원의 이름과 급여를 출력하세요.
select first_name , salary from employees where salary > 10000;
--보너스를 받는 사원의 이름과 직무, 보너스율을 출력하세요
select * from employees;
select first_name, job_id , commission_pct from employees where commission_pct >0;
--2003년도 입사한 사원의 이름과 입사일 그리고 급여를 출력하세요.(BETWEEN 연산자 사용)
select first_name, hire_date ,salary from employees where hire_date between '2003/01/01' and '2003/12/31';
2003년도 입사한 사원의 이름과 입사일 그리고 급여를 출력하세요.(LIKE 연산자 사용)