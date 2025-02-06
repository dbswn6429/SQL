-- WHERE절
select * from employees;
select first_name, job_id from employees where job_id = 'IT_PROG';
select * from employees where salary >= 15000;
select * from employees where salary < 10000;
select * from employees where department_id <> 50; --같지 않음
select * from employees where first_name = 'Steven';  --데이터는 대소문자 구분
select * from employees where hire_date ='04/01/30'; --날짜도 문자열로 찾으면 됨
select * from employees where hire_date <= '04/01/30';

--between A and B
select * from employees where salary between 10000 and 15000;
select * from employees where hire_date between '03/01/01' and '03/12/31';

--IN 연산자
select * from employees where department_id in(50,60,70);
select * from employees where job_id in('IT_PROG', 'AD_VP');

--LIKE 연산자
select * from employees where job_id like 'IT%';
select * from employees where hire_date like '03%'; --03으로 시작하는
select * from employees where hire_date like '%01'; --01로 끝나는
select * from employees where hire_date like '%05%';
select * from employees where first_name like '_ar%';
select * from employees where hire_date like '___05%';
--IS NULL, IS NOT NULL
select * from employees;
select * from employees where commission_pct is null;
select * from employees where commission_pct = null;  --X
select * from employees where commission_pct is not null;

--AND,OR -AND 가OR보다 연산순위가 빠르다
select * from employees where job_id = 'IT_PROG' or salary >= 5000; --둘중 하나만 만족해도 나옴
select * from employees where job_id = 'IT_PROG' and salary >= 5000;  --둘다 만족하는
select * from employees where job_id = 'IT_PROG' or job_id ='FI_MGR' and salary >= 5000; --and가 먼저 동작
select * from employees where (job_id = 'IT_PROG' or job_id ='FI_MGR') and salary >= 5000;

--NOT 부정의 의미
select * from employees where department_id in(50,60,70);
select * from employees where job_id like '%IT%';

--------------------------------------------------------------------------
-- ORDER BY 구문
select * from employees order by salary; --ASC가 default
select * from employees order by salary desc;
select * from employees order by department_id,salary desc; --먼저 부서아이디로 정렬, 동순위에 대해서 salary 내림차순 정렬

select first_name, salary * 12 as 연봉 from employees order by 연봉 desc; --엘리어스를 정렬에서 사용할 수 있음
select first_name, salary * 12 as 연봉 from employees where 연봉 >= 10000; --where에서 사용x

select first_name, salary, department_id from employees where department_id = 50 order by first_name;
