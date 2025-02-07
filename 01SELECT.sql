-- ctrl + / 빠른 주석 
select * from employees;
select * from departments;
select * from locations;
select * from jobs;
-- 특정 컬럼만 조회 하려면, 나열
select EMPLOYEE_ID, FIRST_NAME, PHONE_NUMBER from employees;
-- 문자,날짜는 왼쪽으로 표시, 숫자는 오른쪽에 나타납니다.
select FIRST_NAME,HIRE_DATE, SALARY, COMMISSION_PCT from employees;
--숫자컬럼은 * / + - 가 됩니다.
select FIRST_NAME,SALARY,SALARY+SALARY*0.1 from employees;
--컬럼 별칭 ALIAS
select first_name as 이름 , salary 급여 , salary + salary * 0.1 as 최종급여 from employees; 
--문자열 붙이기 ||
select first_name || '''님의 급여는' || salary || '$ 입니다' as salary from employees;
--DISCTINT - 중복제거
select distinct department_id from employees;
select distinct first_name, department_id from employees;  -- 조회된 데이터 기준으로 중복을 제거
--ROWID(데이터 주소), ROWNUM(데이터 조회된 순서)
select employee_id,first_name,rowid,rownum from employees;